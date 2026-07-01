Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625173FD15E
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 15:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782920331; cv=none; b=LHwLdgB7uAW9Kncf72Co8xlsoSU6UbeV6qaQbNF8Zy7oyM7LVClP2P9H8HgWdrtCPsED1xpMkcjvNfOtV28tRSmS78cXxJxoHr1BdUMOnhOGNoBK4pu/y5bd9QOQXhlFMXo/zixQ8+l57aGyLu9eLwX3IlJo9lMkJlvSRRKgGws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782920331; c=relaxed/simple;
	bh=125Vm7x7eg3cFt+IVHx04F+gmJXcIVanyYQQuXUvvQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VjdLMx9ByJ4j7timD7ur2jMzm05Z0eBZO2U7/SMx84KYI0ywiXD3CdsC+3Of82uCFOag3oNUI5JO867dXff/+Gpx6jBqZnyluF5V3g+uvT3kBGMnEa2H7/HBGgWpmQmBZ7At0a4RUZ34OPIxCpNu3d2+9bNQkBC2Piy7KJidoJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mIlhj1Co; arc=none smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mIlhj1Co"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-137335bc3caso1545197c88.0
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2026 08:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782920329; x=1783525129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p72O5yNYZZkPWPAj+7VKrFUx6xhc+wR7+xTM0sauMzA=;
        b=mIlhj1Co3NAjWm7nl7JP0RlFK4aSNKfT83T8VUACOpP2z011sJ0s2mJKOrIPg1hZdO
         U7htpH/Lds73WFmziVx/jByC8o1cBBShateQ8sGmOuiQ5dt4SK4eGm04G1mV9Qj+dwWg
         JTxNc9nte4UbhgogMnIqdL0Pj/lUodyox3ShvS/MM5ezFmhueCjrjsATTccS1ugZJUnr
         FfTa8WQt6BEKtRF4doygALJBVH+DxwzyYg2g4/nH11mztqxC+e60E9sQ3cFqcge9ACKS
         VTSuBr1j5ylIm7qAONNcvElYUU22hdw3wXyzHtkdmFq5VRTSKbdM03A3XTXCVxm0I5WS
         ninQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782920329; x=1783525129;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p72O5yNYZZkPWPAj+7VKrFUx6xhc+wR7+xTM0sauMzA=;
        b=BNVQwbuyuHSAZfk0nFaWEVRis3+LXD8KxpoXTnfkT/BkJoABGExL6mKOBi0ycrFc8n
         nZ4R9AjAOXEThjs6doBg/RYJfg+Pby05rG3GNgEaMRubVOPnbXYTeajWLl5Y6zv6Tu4e
         MczR625yrK9ZMVB8voewkpK29koM+PZwPKC5CKCpEQyDdlOdsqtzRu0AUQqfNBQFCp5M
         k5AbksfqdLKfATW8nJKQlQv8RdpKI7aoUEnRA8zL3ILgimhgepVlbqhXQzbP5qi+O/Dh
         xKUIQmA+tAdlVKrujH/IqnMCUpTqtYaHd4C5tXgUEZb8hhmqEce5a3WUPFBNV8rbEuFW
         mVhA==
X-Gm-Message-State: AOJu0YyeskZrRYhkYT6JlbncpH6V+Y0f3QIvCbqDXbt5/tadqod9hQii
	gvY8gY/1d49DhpkL+r1nM94EFcxT0NhMIRE2h0U4YU4ZQ1rEn2cfVvx6czJDwAoJ
X-Gm-Gg: AfdE7ckbQkWRJYVWabW4dQNoiwbnwe9ImsIfUShUSQZA1AbU6vVPcF7giqwSRrZ6t88
	Qi4ZYAx4otNJiqha5vgta74NE89xv+KSm8xxI+SpXU4BAnQ9KIiIUCLJYzMv5bKZSOQh2B/ba1M
	5jq4oGi1ivAiKmEdDcmLXXRD3KCjMbS9lt9a/nnVP+RcxpzYS65eDoxYh3qOMna2CEDx30N8Ixv
	0AcFS8Kgu6tTLiAVTjW4pAC0ZZc2qiEa0x2BRg8khXqd8gDxPVo9wFrz21L4zOpNyfK3GxYESU0
	uJyaH+1zqjLRIFsd03j/vtboHpBv/XypGpqLr7ZzQU6hFB3L+Wewpf7k+ml07wIHjnTTNt4PMNE
	FMF+jAZicYwRYJA0Rgv57qxvDbapgfBYSZ8zfnQOjM3Sx4AW8kNZyuFfFwu0FRSsKeZuU2u3LfP
	5k8XfSrpB5PavOeQeVDxOJGsxJzjOp9Nl4iwcbbF6+QDoabSIC0yElX3TBSA==
X-Received: by 2002:a05:7022:68a0:b0:139:85c2:d7b7 with SMTP id a92af1059eb24-13b3915e2famr1089960c88.32.1782920329082;
        Wed, 01 Jul 2026 08:38:49 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b2cd1be7bsm15761678c88.1.2026.07.01.08.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 08:38:48 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH v2 0/3] xfs: fix NULL deref in log recovery reorder
Date: Wed,  1 Jul 2026 08:38:30 -0700
Message-ID: <20260701153833.3155514-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A crafted XFS image can commit a transaction whose only item is a bare
transaction header (ri_cnt == 0, ri_buf == NULL).
xlog_recover_reorder_trans() then runs ITEM_TYPE() on it and dereferences
the NULL ri_buf, faulting the kernel at mount time.

v1 was a single patch that added the check but kept an ASSERT(0) on the
path and duplicated the sort_list splice.  Per Christoph's review, v2
splits it:

  1: drop the existing ASSERT(0) on an unrecognized item type
  2: move the sort_list splice out of the loop (no functional change)
  3: add the check that rejects a committed item with no regions

Patch 3 also notes that, since the log is CRC-checked, this is a crafted
image rather than media corruption.

Tested on xfs-7.2-fixes with KASAN: the unpatched kernel oopses in
xlog_recover_reorder_trans; the patched kernel fails the mount with
-EFSCORRUPTED and no splat.

Weiming Shi (3):
  xfs: drop ASSERT(0) on unrecognized log item type
  xfs: splice unsorted log items back to the transaction after the loop
  xfs: fail recovery on a committed log item with no regions

 fs/xfs/xfs_log_recover.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

-- 
2.43.0

