Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9BEIh6l005973 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 09:18:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE0CF145F42F
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 07:25:57 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	j6k2qxhbeQ0TxAB4 for <xfs@oss.sgi.com>;
	Tue, 11 Oct 2011 07:25:57 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RDdAG-0003qR-PL
	for xfs@oss.sgi.com; Tue, 11 Oct 2011 14:18:40 +0000
Date: Tue, 11 Oct 2011 10:18:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3 v2] xfstests: allow 091 for non-xfs filesystems
Message-ID: <20111011141840.GA14750@infradead.org>
References: <20111010182156.GA1323@infradead.org>
	<20111010182216.GA1335@infradead.org>
	<20111010182233.GB1335@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111010182233.GB1335@infradead.org>
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

Also use _supported_os properly instead of erroring out manually on
IRIX.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/091
===================================================================
--- xfstests-dev.orig/091	2011-10-10 18:09:20.000000000 +0000
+++ xfstests-dev/091	2011-10-11 14:12:00.000000000 +0000
@@ -37,10 +37,8 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
-_supported_os Linux IRIX
-
-[ $HOSTOS == IRIX ] && _notrun "Not working on IRIX yet"
+_supported_fs generic
+_supported_os Linux
 
 rm -f $seq.full
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
