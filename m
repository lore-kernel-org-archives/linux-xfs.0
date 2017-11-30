Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750849AbdK3WMd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Nov 2017 17:12:33 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9B1D8267D8
        for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2017 22:12:33 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 700F6620AC
        for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2017 22:12:33 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_io: add buf_lru_ref tag to inject table
Message-ID: <79e391ff-fbb5-baf9-bb36-776d956ccecf@redhat.com>
Date: Thu, 30 Nov 2017 16:12:32 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

it might be nice to also allow specification by number, but
for now just fix this up to match the currently-defined tags.

diff --git a/io/inject.c b/io/inject.c
index 9d0cf62..2f15854 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -62,6 +62,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_DROP_WRITES,		"drop_writes" },
 		{ XFS_ERRTAG_LOG_BAD_CRC,		"log_bad_crc" },
 		{ XFS_ERRTAG_LOG_ITEM_PIN,		"log_item_pin" },
+		{ XFS_ERRTAG_BUF_LRU_REF,		"buf_lru_ref" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;

