Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2RG2s9Q251551 for <xfs@oss.sgi.com>; Fri, 27 Mar 2009 11:03:10 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B64841C76775
	for <xfs@oss.sgi.com>; Fri, 27 Mar 2009 09:02:09 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id SNQpHR0VgEvYNpz1 for
	<xfs@oss.sgi.com>; Fri, 27 Mar 2009 09:02:09 -0700 (PDT)
Date: Fri, 27 Mar 2009 12:02:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Message-ID: <20090327160204.GA9306@infradead.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, Mike Frysinger <vapier@gentoo.org>, nathans@debian.org, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

I did some make dist and build the tarball tests with
acl,attr,xfsprogs & co.

We still run libtoolize, aclocal and autoconf when building a clean
tree.  I wonder if we should just get rid of the whole configure target
and require a manual ./configure like most tools?

Nathan, any comments on that from the Debian perspective?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
