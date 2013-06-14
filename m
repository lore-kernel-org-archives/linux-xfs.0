Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E16027F37
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 14:42:00 -0500 (CDT)
Message-ID: <51BB7209.6040301@sgi.com>
Date: Fri, 14 Jun 2013 14:42:01 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: possible null pointer in xlog_iodone
References: <CA+aXbB5ohJkDde8qJSE0AU6B0dh59YjNPVfxVjXCOg73k7ihXQ@mail.gmail.com>
In-Reply-To: <CA+aXbB5ohJkDde8qJSE0AU6B0dh59YjNPVfxVjXCOg73k7ihXQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Vlad Bespalov <vlad.botanic@gmail.com>
Cc: xfs@oss.sgi.com

On 06/14/13 12:15, Vlad Bespalov wrote:
> i`m running an xfs filesystem over device going offline/online and
> sometimes offline may be done in parallel with unmounting
>
> at some point i got several crashes with null pointer panic in
> xlog_iodone: xlog_t structure taken from input buffer is null
>
> i wonder if the following call path combined with disk online/offline
> handling could have led to this crash:
>
> --------------
> xfs_unmountfs()
>      xfs_log_unmount_write(mp)
>          xlog_state_release_iclog(log)
>              xlog_sync(log, iclog = log->l_iclog)
>              (bp=iclog->ic_bp)
>                  xlog_bdstrat(bp)
>                  (iclog->ic_state != XLOG_STATE_ERROR ? )
>                      xfs_buf_iorequest(bp)
>                          xfs_buf_ioend (called with scheduling (*) )
>                          (queues  : bp->b_iodone_work,
>                           callback: xlog_iodone)
>      xfs_log_unmount(mp)
>          xfs_trans_ail_destroy(mp);
>          xlog_dealloc_log(mp->m_log); /*frees and nullifies all iclog->ic_log*/
> -----------
>
> (after we`ve cleaned up log structures we switch processes*)
>      xlog_iodone(bp)
>      {
>          iclog = bp->private
>          l = iclog->ic_log
>          if (XFS_TEST_ERROR((XFS_BUF_GETERROR(bp)), l->l_mp,
>                          XFS_ERRTAG_IODONE_IOERR, XFS_RANDOM_IODONE_IOERR))
>          {
>
>                      xfs_buf_ioerror_alert(bp, __func__);
>                      XFS_BUF_STALE(bp);
> /*l ?= NULL*/ xfs_force_shutdown(l->l_mp, SHUTDOWN_LOG_IO_ERROR);
>          }
>      }
>
>
> Thanks for your time.
> Best regards,
> Vlad Bespalov.
>

Hi,

Looks like the log unmount record can't get written because of the disk 
being offline.

When the write times out, the log structures are long gone.

I bet if you used memory poisoning, the iclog->ic_log would not work either.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
