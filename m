Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 41F6029E14
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 15:17:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 37B0D8F8084
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 13:17:01 -0700 (PDT)
Received: from mail-ig0-f177.google.com (mail-ig0-f177.google.com
	[209.85.213.177]) by cuda.sgi.com with ESMTP id
	kqxYO84hq2HGRHXm (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 13:17:00 -0700 (PDT)
Received: by iget9 with SMTP id t9so85664183ige.1
	for <xfs@oss.sgi.com>; Tue, 05 May 2015 13:16:59 -0700 (PDT)
From: Nicholas Krause <xerofoify@gmail.com>
Subject: [PATCH 08/12] xfs:Make the function,xfs_alloc_update_counters static
Date: Tue,  5 May 2015 16:16:35 -0400
Message-Id: <1430856999-31952-8-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1430856999-31952-1-git-send-email-xerofoify@gmail.com>
References: <1430856999-31952-1-git-send-email-xerofoify@gmail.com>
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
To: david@fromorbit.com
Cc: jack@suse.cz, bfoster@redhat.com, sandeen@sandeen.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@lst.de

This makes the function,xfs_alloc_update_counters static now
due to no external callers to this function for other files.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 53ed3f3..2f94b53 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -548,7 +548,7 @@ xfs_alloc_read_agfl(
 	return 0;
 }
 
-STATIC int
+static int
 xfs_alloc_update_counters(
 	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
