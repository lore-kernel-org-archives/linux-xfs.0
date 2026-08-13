Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2474322E9
	for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2026 20:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786654179; cv=none; b=uCt/66XtbaibdP5snE1TXoHErGPmm3E0d9dph4wZlRsIjTcLR6XxX3SkcYga7inIEdYmvBQCQkPZzzT7JbX7Q8OqW8Evgn0DWTbircyyntr65AVcTxUED8mqxEBiGl8pZp4V0EnGFtLjF2bKUS5YdSrwqnmbZn9/zSa6UXtEaFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786654179; c=relaxed/simple;
	bh=Fj8moMODMEqzllKrIEDP/Z9Mkh3gHutrd24ct7M16Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQEB9AE2tAigRUG0ldbDtRU8NPjClVOCgoMqcWn8dLHagp0OeIfZ2he/mPvyXsoyoRiT3y6AKmcsyNCzcO4teHAslbE0drVCn269ygH0b5W8iHpCyoWDbv1w8RdUlpR9xxKY4CpCozpqVNLqvGECYFdkXY7azr60dz/NxZjDkg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cr2015NG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iFb/rCVA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cr2015NG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iFb/rCVA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786654176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lh90MVA4+voKr9C9sDWPwRAnKrknP7iqLE77doOFWds=;
	b=Cr2015NGf1ulJg3Uxk1lOaxXgNA1bGtrfvsiiHVsryKTasKTBAlq4vzWL2K+64ASITcRWo
	mua/e6NO+nqomc2t7uBkLeVkl3dJ6MoD0Jo5v/kuS2SfbDewT8txJ90ix3rqdNR1fPPpQg
	c8dmDicyZTbPCS0yZtL8jKu8KSF/gac=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-eeZXDWZ6NNu1xREBbWkAQg-1; Thu, 13 Aug 2026 16:49:35 -0400
X-MC-Unique: eeZXDWZ6NNu1xREBbWkAQg-1
X-Mimecast-MFC-AGG-ID: eeZXDWZ6NNu1xREBbWkAQg_1786654175
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4ad778bacbeso231371b6e.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2026 13:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786654175; x=1787258975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lh90MVA4+voKr9C9sDWPwRAnKrknP7iqLE77doOFWds=;
        b=iFb/rCVAZt9Zd5tp/U42AfqST7EmUjFqAeq1F3yLjR+TACXON4BJYX5ljhYX7EStt5
         zn91xhF/+S7FrDpq3LFjYQJlMwSw3+S7FNOl0WpCSlEZ6qK20O4EiFy+gLFYf38HMnFq
         DRwclw9Z9WZCYziYH8PcAtabxcW9EjAOcsnAib20i4EE2i4cZSJJx6+AyCft3SMr5HDZ
         dJEo9H8kexIkg2upxpJ61rWnpMogYzn/OtVcOf3zNQUhqk72xH6cfdJwc2e7KCjNTNqk
         +xqdZj2+muQ4EUqF5qWq2+CsxCc71P3ZrworSgcY9AhEn4EmV5h6hORtxMSZA4VNoD8f
         5a9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786654175; x=1787258975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lh90MVA4+voKr9C9sDWPwRAnKrknP7iqLE77doOFWds=;
        b=EqruWjsB0E//JUNPIbwE98E/J/FF51CAzZEYyL4cDlhzS3t4Shekmdriwgm2oxW2zT
         wuvhHeKhDG7+mRJuXmCwWMFYSJ8IVTUEnYU33KcPMGXGSj5eDGwtPiRWsCc+887XVRmg
         fQ/bGcUsrxNwkhCHbpnel3D/GQMhKfeJSk1jNzpEr5A8Gu4NViRCdGuX+fqzjJbvqiR3
         f0/SF4cqGd4tjhNPu9WumqIXgjdhDRBef4hJX66usdI2rHyDxBLXm89qeL5fwYrclMWt
         QNV0mP3PJ0dMihd5oiNDEaXieBQIQag8mVcK+coYiPppBfaNlrFg+1ED432exZlsPaVg
         jvaw==
X-Gm-Message-State: AOJu0YzjxYsSv+lTMEDADWTkUMmcbHpznvug4TdOEq7ZQCwr/7550jX4
	nLqkbrL5gVH1LtahxsqJ3HnNf5u21YJjHXJ4yqRqZ1xIggZMIJj6Czm4g80m6USSc0JczzqzWV5
	iUZPcL9AyQkaJYIhFRum8Ss7goPIM1WHM9AsQPPo5qGT37gKROMw/EAZ9ykK97ZqloLqa+tHIcr
	rCR4E534xgFCewpsqU/uHblwSzSh1IIiTwTqmLwM6oPkyPor3e/g==
X-Gm-Gg: AR+sD122QB0a8Fe5M7VsWOMw0YjR1uw6BsWqXXsWSRlA4k3QDQwiTHs8eh0xgVZ7YMj
	Wim+oZz415GRN2QbyTsJSp0MNXzC044zcs0AywljFpNJzDkRwZRv4kOHTHJae0wZK2YuFANhKr9
	ULzqBsVGm/0C8GDcJqNvHMjU1+Drtuv9++WQWNntMTU6pAZMJ/Fo7G+zyWguh75kHOt7Hu3lOdo
	q2YMS3gCfZvB0hwyDLahlc0wM1S6rVZyBF/75lX/Ro03xtrwIwU3c3uXVbEafiVOKlYXNipWagu
	5Q0F9DSDMgzzDUCkYp1GIrBjNrWQP99H0cesHktP2pkJFoKOwrvkNfYR4Y72Y24O7Z42t4KQ5Kh
	U5+HGFMuV6Q1DG6TXOJjm9Oz33cnS/d2xh3RxhWDbxaA=
X-Received: by 2002:a05:6808:120b:b0:497:d3d6:6a56 with SMTP id 5614622812f47-4b24063ca8amr773690b6e.0.1786654174974;
        Thu, 13 Aug 2026 13:49:34 -0700 (PDT)
X-Received: by 2002:a05:6808:120b:b0:497:d3d6:6a56 with SMTP id 5614622812f47-4b24063ca8amr773644b6e.0.1786654174430;
        Thu, 13 Aug 2026 13:49:34 -0700 (PDT)
Received: from big24.xxmyappdomainxx.com (97-127-68-83.mpls.qwest.net. [97.127.68.83])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b22d004c3csm2555958b6e.18.2026.08.13.13.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 13:49:33 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: linux-mm@kvack.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] xfs: count folio alloc'd xfs_buf items in NR_KERNEL_MISC_RECLAIMABLE
Date: Thu, 13 Aug 2026 15:40:53 -0500
Message-ID: <20260813204929.2253988-3-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260813204929.2253988-1-sandeen@redhat.com>
References: <20260813204929.2253988-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_buf allocations via xfs_buf_alloc_folio are actually reclaimable,
but are not accounted for as such. NR_KERNEL_MISC_RECLAIMABLE seems
made for this purpose, although AFAICT there are no users today.

To achieve this, add a new flag _XBF_PAGES to track what we have
allocated this way, increment the NR_KERNEL_MISC_RECLAIMABLE
count when we do, and then do the reverse when they are freed.

These allocations now show up under nr_kernel_misc_reclaimable in
/proc/vmstat when allocations are active, which in turn makes
MemAvailable more accurate in /proc/meminfo.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_buf.c | 16 +++++++++++++---
 fs/xfs/xfs_buf.h |  2 ++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2e00a33ebb62..0a853ec361d0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -114,8 +114,15 @@ xfs_buf_free(
 		vfree(bp->b_addr);
 	else if (bp->b_flags & _XBF_KMEM)
 		kfree(bp->b_addr);
-	else if (bp->b_addr)
-		folio_put(virt_to_folio(bp->b_addr));
+	else if (bp->b_addr) {
+		struct folio *folio = virt_to_folio(bp->b_addr);
+
+		if (bp->b_flags & _XBF_PAGES)
+			mod_node_page_state(folio_pgdat(folio),
+					NR_KERNEL_MISC_RECLAIMABLE,
+					-folio_nr_pages(folio));
+		folio_put(folio);
+	}
 
 	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
 }
@@ -132,6 +139,9 @@ xfs_buf_alloc_folio(
 	if (!folio)
 		return -ENOMEM;
 	bp->b_addr = folio_address(folio);
+	bp->b_flags |= _XBF_PAGES;
+	mod_node_page_state(folio_pgdat(folio), NR_KERNEL_MISC_RECLAIMABLE,
+			folio_nr_pages(folio));
 	trace_xfs_buf_backing_folio(bp, _RET_IP_);
 	return 0;
 }
@@ -427,7 +437,7 @@ xfs_buf_find_lock(
 			return -ENOENT;
 		}
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
-		bp->b_flags &= _XBF_KMEM;
+		bp->b_flags &= (_XBF_PAGES | _XBF_KMEM);
 		bp->b_ops = NULL;
 	}
 	return 0;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 79cc9c3f0254..ba7bfafe67b6 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -38,6 +38,7 @@ struct xfs_buf;
 #define _XBF_LOGRECOVERY (1u << 18)/* log recovery buffer */
 
 /* flags used only internally */
+#define _XBF_PAGES	 (1u << 20)/* backed by folio/page allocator */
 #define _XBF_KMEM	 (1u << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
 
@@ -62,6 +63,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_STALE,		"STALE" }, \
 	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
 	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
+	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
 	/* The following interface flags should never be set */ \
-- 
2.55.0

