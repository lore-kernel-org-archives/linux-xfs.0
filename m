Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RBnUCH130843 for <xfs@oss.sgi.com>; Thu, 27 May 2010 06:49:30 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE99112A0B39
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 04:53:44 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id dWEeJ0WAtvysAsGA for
	<xfs@oss.sgi.com>; Thu, 27 May 2010 04:53:44 -0700 (PDT)
Date: Thu, 27 May 2010 07:51:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: puzzling error: XenServer, LVM and XFS
Message-ID: <20100527115153.GB13112@infradead.org>
References: <201005270857.39048@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201005270857.39048@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Thu, May 27, 2010 at 08:57:38AM +0200, Michael Monnerie wrote:
> May 27 08:32:11 zdb13 kernel: [  738.046895] end_request: I/O error, dev 
> xvdc, sector 0
> 
> This only happens after XFS is mounted from the LVM volume. On another 
> machine where active I/O is happening, I get tons of these errors every 
> some seconds.

This looks like the Xen block device code is buggy and doesn't handle
the I/O pattern XFS throws at it.  A sector 0 error during mount usually
is the superblock barrier test write.  To verify that assumptions
try mounting the XFS filesystems with -o nobarrier and see if it goes
away.  Note that this is only for testing, and I would _not_ recommend
it for production use.  If it makes the error go away please file
a bug with the Xen guys to fix their barrier support by either
implementing it properly or not advertizing it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
