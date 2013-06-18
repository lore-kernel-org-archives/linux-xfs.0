Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D8CED29DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 19:19:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A8C868F8037
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 17:19:33 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	4cUCjHEUsQotrfYA for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 17:19:29 -0700 (PDT)
Date: Tue, 18 Jun 2013 10:19:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: possible null pointer in xlog_iodone
Message-ID: <20130618001920.GM29376@dastard>
References: <CA+aXbB5ohJkDde8qJSE0AU6B0dh59YjNPVfxVjXCOg73k7ihXQ@mail.gmail.com>
	<20130615010313.GA29338@dastard>
	<CA+aXbB5b0Vqp9mTPUiV4x_bGkVfbnCTErW-QoX=SMjv0mADf-w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+aXbB5b0Vqp9mTPUiV4x_bGkVfbnCTErW-QoX=SMjv0mADf-w@mail.gmail.com>
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

On Mon, Jun 17, 2013 at 06:38:56PM +0400, Vlad Bespalov wrote:
> CentOS 6.4 kernel 2.6.32-358.2.1.el6.x86_64
> i`ll try to make a script that can be used out-of-house.
> 
> several requests may have failed (un)conveniently, so we have passed
> through setting XLOG_IO_ERROR in xfs_log_force_unmount() and
> eventually skipped xlog_wait altogether:
> -----------------
> <1>XFS (<device>): metadata I/O error: block 0xa03e1d ("xlog_iodone")
> error 5 buf count 1024
> <5>XFS (<device>): xfs_do_force_shutdown(0x2) called from line 1052 of
> file fs/xfs/xfs_log.c.  Return address = 0xffffffffa0559e51
> <1>XFS (<device>): Log I/O Error Detected.  Shutting down filesystem
> <1>XFS (<device>): Please umount the filesystem and rectify the problem(s)
> <4>XFS (<device>): xfs_log_force: error 5 returned.
> <5>XFS (<device>): xfs_do_force_shutdown(0x1) called from line 1063 of
> file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xffffffffa0575
> <4>XFS (<device>): xfs_log_force: error 5 returned.
> <4>XFS (<device>): xfs_log_force: error 5 returned.
> ...
> <1>XFS (mtab~): metadata I/O error: block 0xa03e1b ("xlog_iodone")
> error 5 buf count 1024

And the rest of dmesg showing the stack trace of the oops?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
