Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB6AOlDD004893 for <xfs@oss.sgi.com>; Sat, 6 Dec 2008 04:24:48 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77D79C0D3C2
	for <xfs@oss.sgi.com>; Sat,  6 Dec 2008 02:24:46 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id L0TOgKjePpLOzbsA for
	<xfs@oss.sgi.com>; Sat, 06 Dec 2008 02:24:46 -0800 (PST)
Date: Sat, 6 Dec 2008 05:24:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix up xfs-cmds build after the parallel-fest
Message-ID: <20081206102415.GA28776@infradead.org>
References: <49396528.1090700@sandeen.net>
	<20081205173716.GA8216@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081205173716.GA8216@infradead.org>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Fri, Dec 05, 2008 at 12:37:16PM -0500, Christoph Hellwig wrote:
> Thanks, this fixes the dpkg build for me.

But it misses one hunk to fix the attr build, too:

Index: xfs-cmds-git/attr/Makefile
===================================================================
--- xfs-cmds-git.orig/attr/Makefile	2008-12-06 11:20:21.000000000 +0100
+++ xfs-cmds-git/attr/Makefile	2008-12-06 11:20:34.000000000 +0100
@@ -39,7 +39,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
