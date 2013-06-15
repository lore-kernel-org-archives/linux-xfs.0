Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E8B447F3F
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 20:03:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C81A18F8037
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 18:03:16 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	bqoFclwswzvMU9OG for <xfs@oss.sgi.com>;
	Fri, 14 Jun 2013 18:03:15 -0700 (PDT)
Date: Sat, 15 Jun 2013 11:03:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: possible null pointer in xlog_iodone
Message-ID: <20130615010313.GA29338@dastard>
References: <CA+aXbB5ohJkDde8qJSE0AU6B0dh59YjNPVfxVjXCOg73k7ihXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+aXbB5ohJkDde8qJSE0AU6B0dh59YjNPVfxVjXCOg73k7ihXQ@mail.gmail.com>
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
To: Vlad Bespalov <vlad.botanic@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 14, 2013 at 09:15:04PM +0400, Vlad Bespalov wrote:
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
>     xfs_log_unmount_write(mp)
>         xlog_state_release_iclog(log)
>             xlog_sync(log, iclog = log->l_iclog)
>             (bp=iclog->ic_bp)
>                 xlog_bdstrat(bp)
>                 (iclog->ic_state != XLOG_STATE_ERROR ? )
>                     xfs_buf_iorequest(bp)
>                         xfs_buf_ioend (called with scheduling (*) )
>                         (queues  : bp->b_iodone_work,
>                          callback: xlog_iodone)

Which is followed by:

                if (!(iclog->ic_state == XLOG_STATE_ACTIVE ||
                      iclog->ic_state == XLOG_STATE_DIRTY)) {
                        if (!XLOG_FORCED_SHUTDOWN(log)) {
                                xlog_wait(&iclog->ic_force_wait,
                                                        &log->l_icloglock)

Which is supposed to wait for the log IO to complete and hence
xlog_iodone() is supposed to have been run by the time this code
completes.

What kernel are you tesing on? Do you have a script that reproduces
it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
