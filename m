Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B59DE29E0B
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 04:24:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A8B18F8037
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 02:24:17 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Pt198hUaJtaWFlVy (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 02:24:16 -0700 (PDT)
Received: from smtpout2.drei.com ([109.126.64.2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z6bU7-0001ze-OB
	for xfs@oss.sgi.com; Sun, 21 Jun 2015 09:24:16 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/8] xfsprogs: remove the unused inst_t typedef
Date: Sun, 21 Jun 2015 11:21:59 +0200
Message-Id: <1434878524-18176-4-git-send-email-hch@lst.de>
In-Reply-To: <1434878524-18176-1-git-send-email-hch@lst.de>
References: <1434878524-18176-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 72fc4b3..37a86aa 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -96,7 +96,6 @@ extern char    *progname;
 #define ASSERT(ex) assert(ex)
 
 typedef __uint32_t		uint_t;
-typedef __uint32_t		inst_t;		/* an instruction */
 
 #ifndef EWRONGFS
 #define EWRONGFS	EINVAL
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
