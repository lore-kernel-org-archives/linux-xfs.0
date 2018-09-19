Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731782AbeITB6r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Sep 2018 21:58:47 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 97A594DD62
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 20:19:15 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 693045C886
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 20:19:15 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: define xfs_stack_trace() for debug builds
Message-ID: <d260b935-c518-1fdb-c728-84db5a1224a8@redhat.com>
Date: Wed, 19 Sep 2018 15:19:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Building with -DDEBUG fails due to lack of an xfs_stack_trace def'n.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 2f2ca06..b6746ca 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -118,6 +118,8 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define xfs_alert_tag(mp,tag,fmt,args...)	cmn_err(CE_ALERT,fmt, ## args)
 
 #define xfs_hex_dump(d,n)		((void) 0)
+#define xfs_stack_trace()		((void) 0)
+
 
 #define xfs_force_shutdown(d,n)		((void) 0)
 
