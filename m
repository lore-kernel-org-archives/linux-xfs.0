Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36836 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751950AbdEDN0U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 09:26:20 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/8] xfs: re-define uuid_t as common struct uuid_v1
Date: Thu,  4 May 2017 16:26:17 +0300
Message-Id: <1493904383-2187-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
References: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

xfs was defining a non namespaced type named uuid_t and for no good
reason. xfs code doesn't care about the internals of uuid_t struct -
it only cares about its size.

Re-define uuid_t as the common struct uuid_v1 in include/linux/uuid.h
and get rid of the xfs private definition.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/uuid.h        | 4 +---
 include/linux/uuid.h | 4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/uuid.h b/fs/xfs/uuid.h
index 104db0f..0e3ecd0 100644
--- a/fs/xfs/uuid.h
+++ b/fs/xfs/uuid.h
@@ -18,9 +18,7 @@
 #ifndef __XFS_SUPPORT_UUID_H__
 #define __XFS_SUPPORT_UUID_H__
 
-typedef struct {
-	unsigned char	__u_bits[16];
-} uuid_t;
+#include <linux/uuid.h>
 
 extern int uuid_is_nil(uuid_t *uuid);
 extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 4dff73a..02253f0 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -26,7 +26,7 @@
  *     time
  * - the clock sequence is a 14-bit counter to avoid duplicate times
  */
-struct uuid_v1 {
+typedef struct uuid_v1 {
 	__be32		time_low;			/* low part of timestamp */
 	__be16		time_mid;			/* mid part of timestamp */
 	__be16		time_hi_and_version;		/* high part of timestamp and version  */
@@ -40,7 +40,7 @@ struct uuid_v1 {
 #define UUID_VARIANT_STD	0x80
 	u8		clock_seq_low;			/* clock seq low */
 	u8		node[6];			/* spatially unique node ID (MAC addr) */
-};
+} uuid_t;
 
 /*
  * The length of a UUID string ("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee")
-- 
2.7.4

