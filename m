Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6FF214A7F
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 17:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739987313; cv=none; b=B93Zudr1/fNjQTJo3fcKDJ+AmLAg7s0MbeTdx+WjGs99AvSRrUGaC+sInYgFrITRLzydFYXvWabmnSfzRwUHfm26mwh0h+mpGWqdfKWJ5Rw/rI8390dT3JWkS/uuHlHX4/Lt985PruPrsctscvHugr0iBhPaxFZKTUGxNINBSWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739987313; c=relaxed/simple;
	bh=M5HeM/bcsB+jeJ4VoNq04Pn88Kt2tiIlLDcBuNOeI9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bw1PwkQK2bKDhALjvPE9g0SlRL9pM0XkgmYcEP0eu8S8qQGelNlrMm1VMrYi012hKb9til3TY8awpOYawkPO1uvSGaDgJrq680kGj4SWDVtlR4raV1VBV6qd27BnkNJtDyttUmOhn8cxP6zQj+o74ZngWvalVPpp+yRvYSnyZWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N0pfbPmM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N0pfbPmM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739987311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cBXZmx5iOmhcRhN45TDsT5IOxthhY2gP5ZbZsmfqz/4=;
	b=N0pfbPmMH+xOJ3q+MLsM2QWysTVa3YTfr5ZahT/g04zxJG36IKtuzWtD0cq9j6lzmYqciz
	lpRPI0Zllmg5CPh6C3lY0ZIM4HsFLXPrT2F1ns3cA5PES693GuZAXC9/XxDIELEShZcMTH
	HAgKOZgHt8I9D1+g1qT2y74F1Eu3jdo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-ru7BYeiAMtuqkjbQCpaMVA-1; Wed,
 19 Feb 2025 12:48:25 -0500
X-MC-Unique: ru7BYeiAMtuqkjbQCpaMVA-1
X-Mimecast-MFC-AGG-ID: ru7BYeiAMtuqkjbQCpaMVA_1739987304
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CECFA190F9E4;
	Wed, 19 Feb 2025 17:48:24 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.79])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D6AE71800359;
	Wed, 19 Feb 2025 17:48:23 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2 09/12] dax: advance the iomap_iter on pte and pmd faults
Date: Wed, 19 Feb 2025 12:50:47 -0500
Message-ID: <20250219175050.83986-10-bfoster@redhat.com>
In-Reply-To: <20250219175050.83986-1-bfoster@redhat.com>
References: <20250219175050.83986-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Advance the iomap_iter on PTE and PMD faults. Each of these
operations assign a hardcoded size to iter.processed. Replace those
with an advance and status return.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/dax.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index c8c0d81122ab..44701865ca94 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1771,8 +1771,10 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			ret |= VM_FAULT_MAJOR;
 		}
 
-		if (!(ret & VM_FAULT_ERROR))
-			iter.processed = PAGE_SIZE;
+		if (!(ret & VM_FAULT_ERROR)) {
+			u64 length = PAGE_SIZE;
+			iter.processed = iomap_iter_advance(&iter, &length);
+		}
 	}
 
 	if (iomap_errp)
@@ -1885,8 +1887,10 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			continue; /* actually breaks out of the loop */
 
 		ret = dax_fault_iter(vmf, &iter, pfnp, &xas, &entry, true);
-		if (ret != VM_FAULT_FALLBACK)
-			iter.processed = PMD_SIZE;
+		if (ret != VM_FAULT_FALLBACK) {
+			u64 length = PMD_SIZE;
+			iter.processed = iomap_iter_advance(&iter, &length);
+		}
 	}
 
 unlock_entry:
-- 
2.48.1

