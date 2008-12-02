Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB29qmfp006811 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 03:52:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71D1B164310C
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 01:52:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FezW8uuyOF1JiHrS for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 01:52:47 -0800 (PST)
Date: Tue, 2 Dec 2008 04:52:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ia32 userland and XFS
Message-ID: <20081202095244.GA18292@infradead.org>
References: <4934914C.7050707@cox.net>
	<20081202093350.GC20730@debianrules.debiancolombia.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081202093350.GC20730@debianrules.debiancolombia.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: An?bal Monsalve Salazar <anibal@debian.org>
Cc: Ron Johnson <ron.l.johnson@cox.net>, debian-amd64@lists.debian.org, xfs@oss.sgi.com

On Tue, Dec 02, 2008 at 08:33:50PM +1100, An?bal Monsalve Salazar wrote:
> On Mon, Dec 01, 2008 at 07:37:16PM -0600, Ron Johnson wrote:
> >According to this (seemingly 2+ year old) web page, the XFS file system
> >chokes on the combination of 32 bit userland and 64 bit kernel.
> >
> >Is this still true, and why should a low-level driver hidden under a
> >virtual fs care what user apps access it via the vfs?

XFS as in the plain posix filesystem works perfectly fine with a 64 bit
kernel and 32 bit userspace.

But various advance capabilities or administration interfaces which are
used by tools from xfsprogs are implemented as ioctls, and unfortunately
most of them have been designed very badly and aren't wordsize clean.

There have been handlers for a few of them for a while, but only as of
today a full set of compat handlers has been commited.  That code will be
release with 2.6.29, but could also be backported.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
