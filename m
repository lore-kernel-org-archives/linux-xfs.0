Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n28DBD7C081411 for <xfs@oss.sgi.com>; Sun, 8 Mar 2009 08:11:17 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71D231C26DC1
	for <xfs@oss.sgi.com>; Sun,  8 Mar 2009 06:10:49 -0700 (PDT)
Received: from mx1.suse.de (ns1.suse.de [195.135.220.2]) by cuda.sgi.com with
	ESMTP id JZC0pP7Bv2Fy91k8 for <xfs@oss.sgi.com>;
	Sun, 08 Mar 2009 06:10:49 -0700 (PDT)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Sun, 8 Mar 2009 14:09:28 +0100
References: <200902240010.25434.vapier@gentoo.org>
	<200902271835.30912.agruen@suse.de>
	<20090304172727.GA21463@infradead.org>
In-Reply-To: <20090304172727.GA21463@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903081409.28808.agruen@suse.de>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Mike Frysinger <vapier@gentoo.org>, xfs-oss <xfs@oss.sgi.com>

On Wednesday, 4 March 2009 18:27:27 Christoph Hellwig wrote:
> I've tried to port the patch you checked into xfsprogs (see below for
> the diff), but it fails to build for me.  Any idea what might have
> gone wrong?

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git is missing the following 
commit from ssh://master.kernel.org/pub/scm/linux/kernel/git/agruen/acl.git:

  commit 8de7788c29d2656f8d52d98327a80e4dfd1e3898
  Author: Barry Naujok <bnaujok@sgi.com>
  Date:   Tue Jan 23 14:51:14 2007 +0000

    Fix cross-compile issues with libtool and compiler.

    This is equivalent to commit de7b3f6 from Barry Naujok <bnaujok@sgi.com>
    in the acl package, and part of the Gentoo package, as pointed out by
    Mike Frysinger <vapier@gentoo.org>.

    Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

While looking into this, I noticed that the attr and acl packages were calling 
AC_PROG_LIBTOOL both in configure.in and m4/package_utilies.m4. I have 
removed the redundant call from m4/package_utilies.m4 now.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
