Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34934 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750937AbdLHENw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Dec 2017 23:13:52 -0500
Subject: [PATCH 2/5] mkfs: remove unused m_uuid in sb_feat_args
References: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <591ad270-b882-f3ad-ca8a-ce15b3e75035@sandeen.net>
Date: Thu, 7 Dec 2017 22:13:51 -0600
MIME-Version: 1.0
In-Reply-To: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 mkfs/xfs_mkfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0f7dd92..d30f73d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -773,7 +773,6 @@ struct sb_feat_args {
 	bool	parent_pointers;
 	bool	nodalign;
 	bool	nortalign;
-	uuid_t	m_uuid;
 };
 
 struct cli_params {
-- 
1.8.3.1


