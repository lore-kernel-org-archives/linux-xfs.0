Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EBD137F3F
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 05:45:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C236E304059
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 03:45:12 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id FJyhkIb9hxuxuVYQ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 04 May 2014 03:45:10 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1Wgtuw-0003WU-Gd
	for xfs@oss.sgi.com; Sun, 04 May 2014 10:45:10 +0000
Date: Sun, 4 May 2014 03:45:10 -0700
From: Christoph Hellwig <hch@infradead.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH] common: use a relative path to fsstress
Message-ID: <20140504104510.GA9510@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

All commands run as $qa_user should use a relative path so that
missing access permissions on $HOME for root don't prevent running
it.  This fixes common/233 for me.

Signed-off-by: Christoph Hellwig <hch@lst.de>

--- a/common/config
+++ b/common/config
@@ -134,7 +134,7 @@ export MOUNT_PROG="`set_prog_path mount`"
 export UMOUNT_PROG="`set_prog_path umount`"
 [ "$UMOUNT_PROG" = "" ] && _fatal "umount not found"
 
-export FSSTRESS_PROG="`set_prog_path fsstress $PWD/ltp/fsstress`"
+export FSSTRESS_PROG="./ltp/fsstress"
 [ "$FSSTRESS_PROG" = "" ] && _fatal "fsstress not found"
 
 export PERL_PROG="`set_prog_path perl`"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
