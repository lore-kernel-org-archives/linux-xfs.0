Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AIMZGn195176 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 13:22:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 013BC1C7B01F
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:22:34 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	2G1t7fYtFPf3Z3q3 for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 11:22:34 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RDKUj-0000Ll-AW
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 18:22:33 +0000
Date: Mon, 10 Oct 2011 14:22:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfstests: allow 091 for non-xfs filesystems
Message-ID: <20111010182233.GB1335@infradead.org>
References: <20111010182156.GA1323@infradead.org>
	<20111010182216.GA1335@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111010182216.GA1335@infradead.org>
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
To: xfs@oss.sgi.com

The tests in 091 are entirely generic and pass e.g. on ext4 and jfs.
btrfs fails it, but that looks a like a btrfs-specific issue to me.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/091
===================================================================
--- xfstests-dev.orig/091	2011-10-10 18:09:20.000000000 +0000
+++ xfstests-dev/091	2011-10-10 18:09:41.000000000 +0000
@@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux IRIX
 
 [ $HOSTOS == IRIX ] && _notrun "Not working on IRIX yet"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
