Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54738 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751670AbdHAQjU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Aug 2017 12:39:20 -0400
Subject: [PATCH V2] xfs_metadump: properly handle obfuscation of all remote
 attribute blocks
References: <7862201b-e387-8037-ca99-b6ab3212f4a7@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1e034d9f-0e21-637d-c0e6-09d1b7e95027@sandeen.net>
Date: Tue, 1 Aug 2017 11:39:19 -0500
MIME-Version: 1.0
In-Reply-To: <7862201b-e387-8037-ca99-b6ab3212f4a7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

add_remote_vals assumes that it can subtract blocksize
from each block that it processes, but with CRCs, there
is a header on each block, so the assumption that each
block consumes $BLOCKSIZE of the value length is incorrect.

This causes us to stop adding remote blocks too soon, and
the missed blocks do not get obfuscated.

Fix this by accounting for the header size as appropriate,
depending on whether or not we have a CRC filesystem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Use helper macro, don't send mp as arg (it's a global (!))

diff --git a/db/metadump.c b/db/metadump.c
index 96641e0..f60bd32 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1609,7 +1609,7 @@ add_remote_vals(
 		attr_data.remote_vals[attr_data.remote_val_count] = blockidx;
 		attr_data.remote_val_count++;
 		blockidx++;
-		length -= mp->m_sb.sb_blocksize;
+		length -= XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
 	}
 
 	if (attr_data.remote_val_count >= MAX_REMOTE_VALS) {

