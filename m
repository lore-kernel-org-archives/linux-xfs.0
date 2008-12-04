Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4DmKZt002598 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 07:48:20 -0600
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A83271BEF4BA
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 05:48:18 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com
	with ESMTP id KZGayJeTZVdOP8Y0 for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2008 05:48:18 -0800 (PST)
Date: Thu, 4 Dec 2008 14:23:27 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: XFS breakage on m68k (was: Re: linux-next: Tree for December 3)
Message-ID: <20081204132327.GA12971@lst.de>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0812040956370.10635@anakin>
	<20081204121330.GA18815@infradead.org>
	<20081204234603.b5a28cd6.sfr@canb.auug.org.au>
	<20081204125006.GA13411@infradead.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081204125006.GA13411@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Christoph Hellwig <hch@lst.de>

On Thu, Dec 04, 2008 at 07:50:06AM -0500, Christoph Hellwig wrote:
> Yeah, but Niv fixed it up and the correct version is not in the xfs git
> tree.

Hah, he noticed the bug but the wrong version got checked in anyway.

Here's the fix (for todays xfs tree):

-- 

[XFS] Fix compile with CONFIG_COMPAT enabled


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_ioctl.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.h	2008-12-04 14:19:32.000000000 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl.h	2008-12-04 14:19:38.000000000 +0100
@@ -74,7 +74,7 @@ xfs_file_compat_ioctl(
 	unsigned long		arg);
 
 extern long
-xfs_file_compat_ioctl_invis(
+xfs_file_compat_invis_ioctl(
 	struct file		*file,
 	unsigned int		cmd,
 	unsigned long		arg);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
