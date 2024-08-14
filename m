Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513A21CB336
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670783; cv=none; b=pl3CnT0OEObCOp+rgBg3sy7G0vAPeW86IbfxPFpWVVX1jOAfjeAwJ/Fo8WF7yMme8zfIr7vvH0i9BQ7B2cEGquMSwumd0iecqcGee8fup24xlvkE+utBvQ6gcbpP4XtAL5TB3uRxbKy8noeYGIkT7kSJJibIcg7F8iV1IFhZSLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670783; c=relaxed/simple;
	bh=/ZdKHR4pHjntJYSoUdVRDKcFzv/LrElzLuY8Xsnn2js=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNRInlY3DsHf0bpT8h2OVeOC/yDpM/R7AiaCH12k3cnOT3nVMXnigtmQ4F1P/+CqqDM00KJq2sAEiYEReT0E06YRZnanb5F8Ll5sYQhc99ZKCL+wldv/pQv0GWoN1ClWRn4GnAaiXH/sX+dXvAv6vKMZMSQA8ixpDakfiAhWJ7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=XJsENMnb; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="XJsENMnb"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7a1d42da3e9so17763585a.1
        for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670779; x=1724275579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AN6bShe37d+I+GAe4SQfQZex9z+pcNLPbf8dU2iG5Y0=;
        b=XJsENMnbwhH3Pwzq9pD/aXXais5rsjHl9cQJ781xKJ/Va8J//Sv9tEerVBsx3Eud4y
         8jO4iJRTVS8qigq9ZBhNoT1x0RXtuYEJTcYoINjeGnZVSyLu88MugguCPXVd+q/xLizN
         cSM8+nIXlbK4rb3zXbtjSieepmtd2q18kUV/Kl2x71j4PvwDTTVtuFiS4MEQz3E+as8p
         2aNCxCLWADe3IkNtmPhAtiXbuR49yWxKHLVSKmzGhlsVW72qh3K3UFQre8Ck8PDmgbZN
         jr4OaZ5qjNqiZbmcLLTWA8uhTs1WEqhraa/X/128IQSgz7ZoNVAGrvRE/P6h0C4588fF
         a3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670779; x=1724275579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AN6bShe37d+I+GAe4SQfQZex9z+pcNLPbf8dU2iG5Y0=;
        b=bLkFJWyB86fszAqi5AsyxknmHAKAbpwNCig9HBe2MFV4P2ZjVmRNmQw9fLf/pwXmDi
         z2I/l68iLqEOLPD4XFs/8WCtR8E5+ScKSZP0Ec9L/b3xcIQpAf6bHqUSNdJAUjJYo/sO
         la+v43WmTXgTOm7J2b79iPr0c0uG481kSpHl0RFwR8VecSuLBg3tq734xYskgpLdkp6j
         QIxsqfjI5NbeGhSdOUH2tua2bgXW6m9SCxO0E0CDoWJpqX8V7izIksx82ljW5QrYQ7YB
         JZxTAA67pQpBA/7eCpTnj2fopmNJaw3wtiDSissGa+d+qPSkkx3QlMq5hzg0FXCa3aIo
         23wQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6meH+cLhWTVqT1lGdKz1Jke8gvUBo/gvtGOUL0y4mJ3ygKqpq4Xz+qZ7yOBzPRD2yEfrAMhdy4+RiJ9jCFBIMrRGTACNmmJ2x
X-Gm-Message-State: AOJu0YxvFT+gb0mgo2GdAjnbGiLD5d/xywqElHyvu0DIh4/wAdVS4cXX
	g5ywWMda2J0CYq1N0lvZCgm2yMOQPEuJGcBOp/vK+WTd+IuK8v3deaiKJXsaS7g=
X-Google-Smtp-Source: AGHT+IFQOOdc7hk322ZC4VYavDskQmkGcpA4gUJL30TWlxeg1xLDQtxnIo9ze+bETsdddSmDQjnk1g==
X-Received: by 2002:a05:620a:c47:b0:79f:1cf:551e with SMTP id af79cd13be357-7a4ee323d9emr460557185a.5.1723670779329;
        Wed, 14 Aug 2024 14:26:19 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4ff120085sm7708485a.131.2024.08.14.14.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:19 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 14/16] bcachefs: add pre-content fsnotify hook to fault
Date: Wed, 14 Aug 2024 17:25:32 -0400
Message-ID: <9627e80117638745c2f4341eb8ac94f63ea9acee.1723670362.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723670362.git.josef@toxicpanda.com>
References: <cover.1723670362.git.josef@toxicpanda.com>
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

