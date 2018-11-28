Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37132 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729093AbeK2D7Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Nov 2018 22:59:24 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D2A0C04B2F6
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 16:57:07 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 3/4] common/types.h: Wrap #define UUID_STR_LEN 36 in #ifndef
Date: Wed, 28 Nov 2018 17:56:48 +0100
Message-Id: <20181128165649.56853-4-jtulak@redhat.com>
In-Reply-To: <20181128165649.56853-1-jtulak@redhat.com>
References: <20181128165649.56853-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com, Jan Tulak <jtulak@redhat.com>

Current Fedora 28 has the constant it in uuid/uuid.h where it belongs (per
comment next to the define), so we should treat the define as a
backward-compatibility workaround, rather than enforcing it for all.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 common/types.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/common/types.h b/common/types.h
index 50c841e..096c5b7 100644
--- a/common/types.h
+++ b/common/types.h
@@ -35,7 +35,9 @@
 /*
  * Should be, but isn't, defined in uuid/uuid.h
  */
+#ifndef UUID_STR_LEN
 #define UUID_STR_LEN	36
+#endif
 
 /* fundamental page size - probably should not be hardwired, but
  * for now we will
-- 
2.19.1
