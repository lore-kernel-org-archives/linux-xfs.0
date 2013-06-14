Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 073C77F37
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 12:15:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 768C3AC008
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 10:15:07 -0700 (PDT)
Received: from mail-ee0-f44.google.com (mail-ee0-f44.google.com
	[74.125.83.44]) by cuda.sgi.com with ESMTP id Fy9HCMsfJwrrUB6c
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 14 Jun 2013 10:15:06 -0700 (PDT)
Received: by mail-ee0-f44.google.com with SMTP id c13so502405eek.31
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 10:15:04 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 14 Jun 2013 21:15:04 +0400
Message-ID: <CA+aXbB5ohJkDde8qJSE0AU6B0dh59YjNPVfxVjXCOg73k7ihXQ@mail.gmail.com>
Subject: possible null pointer in xlog_iodone
From: Vlad Bespalov <vlad.botanic@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

i`m running an xfs filesystem over device going offline/online and
sometimes offline may be done in parallel with unmounting

at some point i got several crashes with null pointer panic in
xlog_iodone: xlog_t structure taken from input buffer is null

i wonder if the following call path combined with disk online/offline
handling could have led to this crash:

--------------
xfs_unmountfs()
    xfs_log_unmount_write(mp)
        xlog_state_release_iclog(log)
            xlog_sync(log, iclog = log->l_iclog)
            (bp=iclog->ic_bp)
                xlog_bdstrat(bp)
                (iclog->ic_state != XLOG_STATE_ERROR ? )
                    xfs_buf_iorequest(bp)
                        xfs_buf_ioend (called with scheduling (*) )
                        (queues  : bp->b_iodone_work,
                         callback: xlog_iodone)
    xfs_log_unmount(mp)
        xfs_trans_ail_destroy(mp);
        xlog_dealloc_log(mp->m_log); /*frees and nullifies all iclog->ic_log*/
-----------

(after we`ve cleaned up log structures we switch processes*)
    xlog_iodone(bp)
    {
        iclog = bp->private
        l = iclog->ic_log
        if (XFS_TEST_ERROR((XFS_BUF_GETERROR(bp)), l->l_mp,
                        XFS_ERRTAG_IODONE_IOERR, XFS_RANDOM_IODONE_IOERR))
        {

                    xfs_buf_ioerror_alert(bp, __func__);
                    XFS_BUF_STALE(bp);
/*l ?= NULL*/ xfs_force_shutdown(l->l_mp, SHUTDOWN_LOG_IO_ERROR);
        }
    }


Thanks for your time.
Best regards,
Vlad Bespalov.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
