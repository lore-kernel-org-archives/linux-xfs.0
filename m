Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBQJtAB7013099 for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 13:55:11 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EEE01BF6936
	for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 11:55:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id C0mtBvRMEc3yN125 for
	<xfs@oss.sgi.com>; Fri, 26 Dec 2008 11:55:09 -0800 (PST)
Date: Fri, 26 Dec 2008 14:55:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: new acl tarball release?
Message-ID: <20081226195506.GA4173@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Andreas Gruenbacher <agruen@suse.de>, Nathan Scott <nathans@debian.org>, xfs@oss.sgi.com

The current acl 2.2.47 release has a quite nasty bug about following
symlinks, which is already fixes in the current ptools/cvs/git tree:

	http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=499076
	http://oss.sgi.com/bugzilla/show_bug.cgi?id=790

Any chance we can put out a 2.2.48 release with that fix so that the
broken version doesn't end up in distros?

The oss bugzilla also has another patch that needs reviewing.

AFAICS the same problems symlink walking code is also used in attr,
so it could use an update, too.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
