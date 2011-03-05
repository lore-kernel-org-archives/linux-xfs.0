Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p250M3WF198589 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 18:22:05 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A5F215819BB
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 16:24:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id t9LcJzGn8WLaaoao for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2011 16:24:54 -0800 (PST)
Message-Id: <20110305002222.395571492@bombadil.infradead.org>
Date: Fri, 04 Mar 2011 19:22:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] Josefs xfs_io patches
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: josef@redhat.com

I promised to look into adding alias support to libxcmd to allow both
fallocate -p and fpunch to work.  Turns out that isn't quite as easy as I
though.  But given how trivial the hole punching code is I think we can just
put in both version of Josef's patch.  That's what this patchset does - first
one is his fiemap patch, which is unmodified except for the commit message,
and the next two are the fallocate -p and fpunch support, with trivial
changes to provide the FALLOC_FL_PUNCH_HOLE define if the kernel headers
don't provide it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
