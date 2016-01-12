Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D0C9D7F37
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 14:02:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B764C304059
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 12:02:40 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id PYmL08KlFLA6Vla1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 12:02:38 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id AFC4B208B1
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 21:02:36 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3pg2rD45m2z5vN0
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 21:02:36 +0100 (CET)
Date: Tue, 12 Jan 2016 21:00:01 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH 4/6] linux.h: Use off64_t instead of loff_t
Message-ID: <20160112200001.GE568@nyan>
References: <cover.1452627740.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1452627740.git.felix.janda@posteo.de>
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

These are equivalent on glibc, while musl does not know loff_t.

In the long run, it would be preferable to enable transparent LFS so
that off64_t could be replaced by off_t.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/linux.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux.h b/include/linux.h
index 827dbe1..4872a1e 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -141,7 +141,7 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 #define EFSCORRUPTED	EUCLEAN	/* Filesystem is corrupted */
 #define EFSBADCRC	EBADMSG	/* Bad CRC detected */
 
-typedef loff_t		xfs_off_t;
+typedef off64_t	xfs_off_t;
 typedef uint64_t	xfs_ino_t;
 typedef uint32_t	xfs_dev_t;
 typedef int64_t	xfs_daddr_t;
-- 
2.4.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
