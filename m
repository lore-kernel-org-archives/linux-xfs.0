Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G6qMnf073745 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 01:52:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 158C31C452CE
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 23:52:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Gg9XD4oZeI6JA8pK for
	<xfs@oss.sgi.com>; Sun, 15 Mar 2009 23:52:01 -0700 (PDT)
Date: Mon, 16 Mar 2009 02:51:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Message-ID: <20090316065155.GA5659@infradead.org>
References: <200902240010.25434.vapier@gentoo.org>
	<200902271835.30912.agruen@suse.de>
	<20090304172727.GA21463@infradead.org>
	<200903081409.28808.agruen@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200903081409.28808.agruen@suse.de>
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
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Frysinger <vapier@gentoo.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Sun, Mar 08, 2009 at 02:09:28PM +0100, Andreas Gruenbacher wrote:
> On Wednesday, 4 March 2009 18:27:27 Christoph Hellwig wrote:
> > I've tried to port the patch you checked into xfsprogs (see below for
> > the diff), but it fails to build for me.  Any idea what might have
> > gone wrong?
> 
> git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git is missing the following 
> commit from ssh://master.kernel.org/pub/scm/linux/kernel/git/agruen/acl.git:
> 
>   commit 8de7788c29d2656f8d52d98327a80e4dfd1e3898
>   Author: Barry Naujok <bnaujok@sgi.com>
>   Date:   Tue Jan 23 14:51:14 2007 +0000
> 
>     Fix cross-compile issues with libtool and compiler.
> 
>     This is equivalent to commit de7b3f6 from Barry Naujok <bnaujok@sgi.com>
>     in the acl package, and part of the Gentoo package, as pointed out by
>     Mike Frysinger <vapier@gentoo.org>.
> 
>     Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> 
> While looking into this, I noticed that the attr and acl packages were calling 

Thank, I've pushed this patch to the xfsprogs, xfsdump and dmapi -dev
repositories.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
