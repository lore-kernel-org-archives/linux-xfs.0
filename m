Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E418C392C21
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 21:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787607666; cv=none; b=L5QBZyn4K8bgZ+H8aSjAaFVopM/b2EWP86JLarVmhcMWkZnBhbUI3jbk6dMZZcAAYSFmCfruyoSG6iIicdu/aobZ0awXw/RE5dsNv5DaFOa0Qrv3jS+DC4Wohfmag87oiv92nf5YAGtj0ax170p52cuR594OZdOcvy7E2HyEur0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787607666; c=relaxed/simple;
	bh=rApFJBflxc3o9GI6Y3TIyBajpjKgs59zVkWM/ayKiUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGwbFKjL8D/P9Tpk8HARDQu0RMfxzmPPr5EjWaAY6slJ+tmkg6AIe+0CgvSnSuEHVEniT05aNaGPSrtdV8g6lRu0oal4rVcpIqw2tSTRawlJT5urDcZVXyeK9jtCVGLufnsz22m2FJjPaikV6LGAa7LOjcRbCzGgUmVnKK0EdKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GQe/I9H9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jXfh2EdC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GQe/I9H9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jXfh2EdC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787607663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OeamaJAWmLp31a+QeZZ/+p3tY83HjPFxvOQH2hF75Y8=;
	b=GQe/I9H9vAbYy0PAhxb2IKmHtLKSu5CwJG00ulYTESLYt1Wu2pMMOvbYVhtwjMdHtRtp44
	Aq+PH6LKtgLTgyfIT6RA0qERw0jTK71GjdCOZdQWt1I2mxfdqZD+Uj5E87Afhop/OWu2dL
	CSkSzd6OGV83D5RYmrFtskouZ2p9Yjo=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-wTAJW4EcNEGoz-PY_mY0-g-1; Mon, 24 Aug 2026 17:41:02 -0400
X-MC-Unique: wTAJW4EcNEGoz-PY_mY0-g-1
X-Mimecast-MFC-AGG-ID: wTAJW4EcNEGoz-PY_mY0-g_1787607662
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b2f2b8d88fso7820061b6e.2
        for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 14:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787607662; x=1788212462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OeamaJAWmLp31a+QeZZ/+p3tY83HjPFxvOQH2hF75Y8=;
        b=jXfh2EdCx+jqfMPnxmsHBZjYF35Bpy8TQQjQE6mstsfyrdWQXzYsh+Qg+S0GomIBDL
         fdkM2HCbt+8NiQ/kHqbMPP+J2Eu82wm4Deh/4s6qlJocj2oS3Djp4HD1rUEIMGiuJzih
         t8lU43QS7Mn42Fr3zbhFv3vbbbLhYAXiaUoCHG8YyyDCCdiFnCawj+P9ATrh2VpsQNLz
         uz5UvWzntXHnf5Jh1bQkk99tTV6uFNJSHKu5ueCth+BuLeAYogljrgLoxSZxk+U7hnqT
         glQ2grutKAzdUqQaz99hanjQ37D7xiK9hOOekeAah7c+tYEk3Hgj/+562P/VzihHeW1p
         R8Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787607662; x=1788212462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OeamaJAWmLp31a+QeZZ/+p3tY83HjPFxvOQH2hF75Y8=;
        b=Atu1rpmAecXqi3lI14SO2G3l0e4mHMoBRZ1k0gLvHwETfmKciVxe1S82LcR/e/G/V1
         AIYNabPH6skWUwPo0NrszknS21jGShNjBUVPTGPdmhWcnS77Qk35hVC7bY4NGELe12RJ
         MZRBv8MK9vd6/zkdudFVG8aERQtEjZunBy0gz0wFmzLtEOJnJGQhsmaI6f3Y0bBscuuO
         sy/pewu55iFDdP+xJIyvwNImb8Wse8n3bVfWyDmlguB7O+nirqPqXHZ0xp/qvw8OrTTu
         yOorZ1VAOtdAegQHebGcvuqZ4BPPqiXhpqnvPhzOmgOlrbqtGtN/eXKfpnk33iI33Q4/
         AJVA==
X-Gm-Message-State: AFuF++lN25xqV69fWKI9OESRvFumaj71wX7HcsGW9i4T4CfXjxJOKUQw
	UZvR7pnjlebJ1p8n4ywCTXJRO8Z2O33gxmyPRQS++bmbmFOz/lNMtZhJ/hs9AtNApMpY18sbqdr
	3IX4JkrMw13r4pLc3JYOJZnWrOaUBIWIr2KDgJ85ojRHfu0Gs3/g818Vx0kCgh/ELglokBeNfjz
	kwAjTZpYZ1igxkYmLFQLGvZ2V3/zffv3HvSfhZjYBP4/lThqc=
X-Gm-Gg: AR+sD12qmGXlnx1XJMcr8bhCHJdw+7WflTlsIcUryhEIis/gQG4un/QSt0olgtOkjr5
	k8P0wg+0fw6jbcB8VYj7lkuXFrIUwRXtpuYCOIDyZBp3cSJeSyukWf3kNU0Www7bPXCXiEHnrDz
	AJceu4kKEFKeC8gnLzyGMo7yEAHloSR8lsg6UyYb/cexhlITbMWnScuiNA7ylP8gHkpfpUAOGhe
	hlGBjlkHUqAIS09V0e1YkZAAXsIMHND4fv6bVKFWOdqitJulI7CRV/ZE2yFogwvkU6GLB8j05z8
	MXH6BJ4EBRT+zljsmbBkhJr88BfLCx4WoK5sE9q5ibB+fjkk8Gk24tzG1x1nhOi+UEDDqKx8dLs
	GR2BR3JZyOx4YC43FONOuyzAjCQp8WqcLbju1qEmpZkc=
X-Received: by 2002:a05:6808:87d4:b0:497:c1f1:1511 with SMTP id 5614622812f47-4b2ef46b1b4mr28060830b6e.16.1787607661645;
        Mon, 24 Aug 2026 14:41:01 -0700 (PDT)
X-Received: by 2002:a05:6808:87d4:b0:497:c1f1:1511 with SMTP id 5614622812f47-4b2ef46b1b4mr28060791b6e.16.1787607661077;
        Mon, 24 Aug 2026 14:41:01 -0700 (PDT)
Received: from big24.xxmyappdomainxx.com (97-127-68-83.mpls.qwest.net. [97.127.68.83])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b32c8355e4sm4174860b6e.11.2026.08.24.14.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 14:41:00 -0700 (PDT)
From: "user.mail" <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: "user.mail" <sandeen@redhat.com>
Subject: [PATCH 2/2] xfs_repair: distinguish true ENOMEM from "not found" in cache_node_get
Date: Mon, 24 Aug 2026 14:59:00 -0500
Message-ID: <20260824214056.400740-3-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260824214056.400740-1-sandeen@redhat.com>
References: <20260824214056.400740-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the cache_node_get() callchain, we may fail in cache_node_allocate
for two distinct reasons:
 - The cache may be at its current size limit, and must be expanded
 - An underlying allocation may have actually failed with ENOMEM

Today, we do not distinguish these 2 failure modes and will try to
expand the cache size even in the face of an ENOMEM, which won't help.
We can distinguish these two failures, because:

If cache_node_allocate fails because all slots are full, c_count is
untouched, and it is >= c_maxcount (all slots full.)

If cache_node_allocate fails due to an underlying ENOMEM, c_count is
decremented before return and c_count will remain < c_maxcount.

So, if the cache has been fully shaken, cache_node_allocate stil
fails, and c_count < c_maxcount, this is a true ENOMEM situation, and
we should give up and tell the caller.

This adds yet another return value to cache_node_get (-1) for ENOMEM
failures, and corrects the comment about the existing 0-vs-1 returns
- though nobody looks at that return value today.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: user.mail <sandeen@redhat.com>
---
 libxfs/cache.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/libxfs/cache.c b/libxfs/cache.c
index f8be9b89..63224e58 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -373,8 +373,8 @@ __cache_node_purge(
  * hit, in which case this will all be over quickly and painlessly.
  * Otherwise, we allocate a new node, taking care not to expand the
  * cache beyond the requested maximum size (shrink it if it would).
- * Returns one if hit in cache, otherwise zero.  A node is _always_
- * returned, however.
+ * Returns zero if hit in cache, otherwise return 1 for new node;
+ * allocation failures return -1 and a null nodep.
  */
 int
 cache_node_get(
@@ -474,6 +474,18 @@ next_object:
 		 * If we exceed CACHE_MAX_PRIORITY all slots are full; grow it.
 		 */
 		if (priority > CACHE_MAX_PRIORITY) {
+			/*
+			 * Shaking failed to make room. If the cache is not
+			 * full, expanding the limit won't help - this is a
+			 * genuine ENOMEM. Tell the caller.
+			 */
+			pthread_mutex_lock(&cache->c_mutex);
+			if (cache->c_count < cache->c_maxcount) {
+				pthread_mutex_unlock(&cache->c_mutex);
+				*nodep = NULL;
+				return -1;
+			}
+			pthread_mutex_unlock(&cache->c_mutex);
 			priority = 0;
 			if (!cache_expand(cache))
 				goto fail;
-- 
2.55.0

