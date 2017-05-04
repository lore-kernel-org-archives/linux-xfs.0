Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35868 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbdEDN0W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 09:26:22 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 3/8] xfs: dismiss xfs_uu_t
Date: Thu,  4 May 2017 16:26:18 +0300
Message-Id: <1493904383-2187-4-git-send-email-amir73il@gmail.com>
In-Reply-To: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
References: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

uuid_t (a.k.a struct uuid_v1) already provides the fields
needed by uuid_getnodeuniq(), so use them directly.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/uuid.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
index b83f76b..7bb4fb8 100644
--- a/fs/xfs/uuid.c
+++ b/fs/xfs/uuid.c
@@ -17,15 +17,6 @@
  */
 #include <xfs.h>
 
-/* IRIX interpretation of an uuid_t */
-typedef struct {
-	__be32	uu_timelow;
-	__be16	uu_timemid;
-	__be16	uu_timehi;
-	__be16	uu_clockseq;
-	__be16	uu_node[3];
-} xfs_uu_t;
-
 /*
  * uuid_getnodeuniq - obtain the node unique fields of a UUID.
  *
@@ -35,11 +26,10 @@ typedef struct {
 void
 uuid_getnodeuniq(uuid_t *uuid, int fsid [2])
 {
-	xfs_uu_t *uup = (xfs_uu_t *)uuid;
-
-	fsid[0] = (be16_to_cpu(uup->uu_clockseq) << 16) |
-		   be16_to_cpu(uup->uu_timemid);
-	fsid[1] = be32_to_cpu(uup->uu_timelow);
+	fsid[0] = (uuid->clock_seq_hi_and_reserved << 24) |
+		  (uuid->clock_seq_low << 16) |
+		  be16_to_cpu(uuid->time_mid);
+	fsid[1] = be32_to_cpu(uuid->time_low);
 }
 
 int
-- 
2.7.4

