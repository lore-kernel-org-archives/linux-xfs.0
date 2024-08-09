Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1305E16A931
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 18:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723229113; cv=none; b=dySiwEZcBGl/sEvcRgBwKjm7fAsMxdPMQQFyMQiXQLSMCO9E37XpGQpxxWJnn6iOY5Mgbs5hbWL2xrDvByF2bKby6fvayTIP1XNTQA162q84m41OV1ITaOgmR0ALvXZ2N+jFpBh0fBtZu8QU0xROx/22Qfpe1NO++QIqf8h11ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723229113; c=relaxed/simple;
	bh=/ZdKHR4pHjntJYSoUdVRDKcFzv/LrElzLuY8Xsnn2js=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=je0h9pDzKuL9UJpY2p/KrmXBT1T/d5uaHou04FztSK88LXE68jGcqKCKSNH3ujNw2vK+Jy/MCCq73Kia8xzKoM/x7OF6rZxe8+ptLMd9KnkktA2x0su9sYqDt8DQrjDQSvJdrupU6CiLzKWyIsFOG+QqMc3kKwPjgsB2dzVb2N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=k182i0B1; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="k182i0B1"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7a1d3874c1eso135838385a.2
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 11:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723229110; x=1723833910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AN6bShe37d+I+GAe4SQfQZex9z+pcNLPbf8dU2iG5Y0=;
        b=k182i0B1lft3a2VbsmTWma9o5Iy/fcPHWhwmw6eZL0+I0AdZcvRfBOSW7Aofc4ba57
         TvhC83SsWoa5JGEa1CCe3pkGvY3Dm22ZKGiM9W23ECcAgdRibn5ACq3kgK/M6PqHcb1Z
         qBrpaSiGeK+glwZhLjJly5dj41GawvA5crtp/ck6LVV1IP9E169BJIuWIqZTaSs/q+c3
         FM9UpF5O/nJQVcftKuFPOVhwXeCYdiUQ4rNvo87gqIZyWvkMjzQ9pVMV5LAvvj3liymK
         RiSAdSYmetyZhHDspKFOaSolG6aV3qzppyqAoUun79jmRpMAV+xGubJxILFlM9TWBEAc
         1ujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723229110; x=1723833910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AN6bShe37d+I+GAe4SQfQZex9z+pcNLPbf8dU2iG5Y0=;
        b=MVMuTFEbdxrlsL1vx7LGjEA1OdKQoK6BJE6ZHex2i5O4eilg4ZV7zCYdcDU7HF0aBq
         aSy922Mi7sF0lTI80Cn4qgRLTHdyo4/MfqHs0wo9fDZvKayo+4HG8samUnsGb1qXPnc6
         gNuBM7JOTPVQ9Ofuosm+InezTgw/YyF0FMXCwR1zBeAvs8CwyN01sHoaCkSPgS+HFhLb
         U8arhhzj/bQeAgzgpAseC6hxsIEPBHo+dSMdisx0xIclFQHHJ80cNEFOqMI2UZFTFX0q
         d7Qai0RPR5LRF4hreX6NA+OW16dfKsuUWhWu4DPcgPj/+rpcF96RBr7n5qDqZNDZIYFs
         pCYQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/yhwRkoGy7QtVm3UYoTinU41LrXpY0SQxNJyK8jWkGFc2F3qhpCrBVLUpoSLORREhMHBfIZfLf3OzEp/XecFMZyJdNb61S5W6
X-Gm-Message-State: AOJu0YwQfxxqqCQ1NO4TaWQRhzgzd5qYKypWfjCWoWTOImfL+ZOTDF85
	5uq6lV0hDmfp6Q35g/GpBQBnzjvODjxE0GUBIzferfC103mcpdVl0lSkZNtoMwM=
X-Google-Smtp-Source: AGHT+IGkk+5fyo6NCGpzPleO9dzoJzviklkx5ZKaFGvNslWQvN9ZFJWRDyezozrA8VyzG3HLheVY+A==
X-Received: by 2002:a05:620a:29d0:b0:79f:dc6:e611 with SMTP id af79cd13be357-7a4c182c4bdmr273891485a.53.1723229110136;
        Fri, 09 Aug 2024 11:45:10 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4c7d8b0fasm4267685a.64.2024.08.09.11.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:45:09 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 14/16] bcachefs: add pre-content fsnotify hook to fault
Date: Fri,  9 Aug 2024 14:44:22 -0400
Message-ID: <b3fc6d63e23626033ff2764a82d3e20a059ac8a4.1723228772.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723228772.git.josef@toxicpanda.com>
References: <cover.1723228772.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bcachefs has its own locking around filemap_fault, so we have to make
sure we do the fsnotify hook before the locking.  Add the check to emit
the event before the locking and return VM_FAULT_RETRY to retrigger the
fault once the event has been emitted.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/bcachefs/fs-io-pagecache.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/bcachefs/fs-io-pagecache.c b/fs/bcachefs/fs-io-pagecache.c
index a9cc5cad9cc9..1fa1f1ac48c8 100644
--- a/fs/bcachefs/fs-io-pagecache.c
+++ b/fs/bcachefs/fs-io-pagecache.c
@@ -570,6 +570,10 @@ vm_fault_t bch2_page_fault(struct vm_fault *vmf)
 	if (fdm == mapping)
 		return VM_FAULT_SIGBUS;
 
+	ret = filemap_maybe_emit_fsnotify_event(vmf);
+	if (unlikely(ret))
+		return ret;
+
 	/* Lock ordering: */
 	if (fdm > mapping) {
 		struct bch_inode_info *fdm_host = to_bch_ei(fdm->host);
-- 
2.43.0

