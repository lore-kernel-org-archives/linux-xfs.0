Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4GKeGXM140979 for <xfs@oss.sgi.com>; Sat, 16 May 2009 15:40:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC7C828ECBC
	for <xfs@oss.sgi.com>; Sat, 16 May 2009 13:40:25 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id SEI8VY8mSOs23Crb for
	<xfs@oss.sgi.com>; Sat, 16 May 2009 13:40:25 -0700 (PDT)
Date: Sat, 16 May 2009 16:40:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs:  add fallocate command to xfs_io
Message-ID: <20090516204025.GC28186@infradead.org>
References: <4A077195.3070708@sandeen.net>
	<20090515171324.GA14804@infradead.org>
	<20090515172711.GA23630@infradead.org>
	<4A0DB97F.4020201@sandeen.net> <4A0DE88C.2040401@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A0DE88C.2040401@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, May 15, 2009 at 05:11:24PM -0500, Eric Sandeen wrote:
> Instead of above does this work better?
> 
> (just change AC_TRY_COMPILE to AC_TRY_LINK)

Yes, that correctly detects fallocate as not present for me and
thus gives a working fallocate.

> 
> AC_DEFUN([AC_HAVE_FALLOCATE],
>   [ AC_MSG_CHECKING([for fallocate])
>     AC_TRY_LINK([
> #include <linux/falloc.h>
>     ], [
>          fallocate(0, 0, 0, 0);

Why do you nee to include <linux/falloc.h> here anyway?  You don't use
any of the constants, and the fallocate libc call must be in another
headers, so it obviously compiles even without a defintion for it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
