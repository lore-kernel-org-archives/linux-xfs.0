Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUCQRBu010881 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 06:26:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29A291796BF3
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 04:26:27 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YDPWora2tc8FInax for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 04:26:27 -0800 (PST)
Date: Tue, 30 Dec 2008 07:26:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: library placement
Message-ID: <20081230122626.GA14350@infradead.org>
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
To: xfs@oss.sgi.com
Cc: Mike Frysinger <vapier@gentoo.org>, Nathan Scott <nscott@aconex.com>


There's a three year old patch from Mike in bugzilla that stops
symlimking the libaries into two different directories if they
are in fact not actually different:

	http://oss.sgi.com/bugzilla/show_bug.cgi?id=430

After reviewing it again I don't see the point of having two copies
names for them.

The .so libraries should go into PKG_LIB_DIR (aka /lib in Debian) because
need them at runtime, potentially from tools outside of /usr.  The .a
and .la libraries are purely development ones and should go into
PKG_DEVLIB_DIR (aka /usr/lib in Debian) as we won't ever need them
while running programs.

Given that we're currently working on the xfsprogs 3.0.0 major release
this might be the time to make this change.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
