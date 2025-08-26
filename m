Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987B33629B5
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222892; cv=none; b=AyR5U76brnDfdHOwqmx+73zKZPtRc3qGnI4MAcYM/8tG6kvYydKebvzOVM5fUgQ6bWp/xsa4GTCoQOM6Ejt10C3T+AYGmJneeORtZAjlyIAZ1aH3ky7zX6EX1D1soyu10exLUmG1tjV7WCY3I8La596M56UWUwC8tNo2V5HQwEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222892; c=relaxed/simple;
	bh=da2l454EY3RDXmu4EckOSRuB1DAXzvcsmcg7FnzAFBA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idMIrEAWwN9syz2b1/IIc0k8FFe8uK0iTeTvrsNTUQLttXUkgY2AjnMZh2/HB9V5XGkDJ0v8idChW+y/Ygwf+nuVnUHXFCuc6LJV/LgrqfoH6ojNwK5+j3jWkRYhsEwmNyu6zdCS4IrNm0EYg/7ZtJBseiU5OFbBI+v0WEJ/uYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=NpSH2p4T; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="NpSH2p4T"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-71d608e34b4so45875997b3.3
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222889; x=1756827689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1J8X3O3fTDW+jaZZ9ZUDLQSX9BKwP490GcePdQCSTYU=;
        b=NpSH2p4TwrhYqyS+JNvyj2RFxnRO8GderDQpdNwrEtTwAl6etuRWZC0DxEfavawTwr
         JN9oG6Fj5sQf3hsTt8bUNwA98mZ+FjJrmIMs57VdAJ0u//t1x+6G+AatgmBBqgtQeOcL
         EjdHR6EeE5IGJyXx4wQJzJaVYcJDocwsiMlsSsqRdqNazntvaGkEUaZeeGQLXt4j3BwJ
         NG5CKPhg10u9fMotJh80BBGfrfOzbZy54EdJGY//l//ru3UIugRLrwenwxpIFDqw8k44
         yI+RPEaXO7z1pGffmoHJ0gznWoXgnw0mgjuam2HhRefh9VqOfn7OmIp8lw1ijMGQT5A2
         bbJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222889; x=1756827689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1J8X3O3fTDW+jaZZ9ZUDLQSX9BKwP490GcePdQCSTYU=;
        b=n0rOE4+JrL5IhwfUNo5jUaVMCWjFq3vL0Yep+nXlj8ZxaStBFjn2UKnvmwJiNtULWv
         8rin3A162c6DRBfaw+Y+ac/9O15fqyl25xD3uQ9WxhkLFxtgSqvGw+/xhYnYc/LLahRl
         Q/qpfgMy+dgrKPONpi/JARmE677WEZz70SySTaN/wDNI8zvWbfpW9xZWEcOPVbslzRN3
         44ufz/8qY0+Py17HuJpqc1Ym2e0D4Cxcy7mEFyR2B7hFLCm4G5l65myXcSiDjsQeVCg3
         bDO3o6dusKTlg1u7EMgtDogzW0grmf+7laQHmYzZahfYDkBHipfhJ6YGhCzTTl9klu63
         N22A==
X-Forwarded-Encrypted: i=1; AJvYcCVpwQBNbRfK+VnQDnhefQgnac4pmpnUIQU4mD6W7zL5XwmVtFYU2+622FqfnOA8fqfr2csKAcKG8MM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8z3htued4tnvC/JdqywMH0Lbv0EpCF71wy7FZSH+QyaTQKqMd
	icZLZVO/+OkAA4Z7ASCW3YUi0A38KcuA3SBvr5HaV3iSMfn36XqcO0vapPNPWC6lOTA=
X-Gm-Gg: ASbGncsuPyMxGzKadHZ8WiIQxqdk1UMQ6cqqQ2N6HgK0l3IYeQ2C2rtFV/D69rTXfrv
	YmzPwhrRrZGY85YIe4ENNIoqHWCoo6HJbWTunqdGfDO3Gb/HgRXv6Xr8Gj7ubUBsDxLX7riAmby
	7hcFkyO2xVpLCsZZPFI1JR3hWG7LvCoRo8UvxEbIfqixoOBuvm6ijogp9FZPPDIfnpXGA3cIcne
	Do6+PCtohjI9pTV1cGSpo6rW6thUS5fp8nBw5G/HCOz7XX/G2Q3UeLhBPPBqH+WZeIUFfN3pOrE
	PLim629q9KjoylgsAhaQIn+Y2Ens9g2EVhibbGryjV+eJba/62lFjsuwqoze055QKOQMHaKv9uF
	y+X7otzPqxE2Ol9WKsxj+l3K+Dxln+pZQg0yWu22AAU6AQ1T8AxnDBH0dxu0=
X-Google-Smtp-Source: AGHT+IGeqctPLqrW8y8Jmm08bG1yVz3laGgupDgU9tlxtVYuPYypXQM+Rifx08nHERJsv8bMHECX7Q==
X-Received: by 2002:a05:690c:3507:b0:71d:5782:9d58 with SMTP id 00721157ae682-71fdc2b731fmr152872667b3.8.1756222889415;
        Tue, 26 Aug 2025 08:41:29 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff18ee79esm25043387b3.73.2025.08.26.08.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:28 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 28/54] fs: remove I_WILL_FREE|I_FREEING check in inode_pin_lru_isolating
Date: Tue, 26 Aug 2025 11:39:28 -0400
Message-ID: <aae290b95e0a84f47145256295841c2d5c533d9d.1756222465.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756222464.git.josef@toxicpanda.com>
References: <cover.1756222464.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the inode is on the LRU list then it has a valid reference and we do
not need to check for these flags.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index 082addba546c..2ceceb30be4d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -666,7 +666,7 @@ void inode_lru_list_del(struct inode *inode)
 static void inode_pin_lru_isolating(struct inode *inode)
 {
 	lockdep_assert_held(&inode->i_lock);
-	WARN_ON(inode->i_state & (I_LRU_ISOLATING | I_FREEING | I_WILL_FREE));
+	WARN_ON(inode->i_state & I_LRU_ISOLATING);
 	inode->i_state |= I_LRU_ISOLATING;
 }
 
-- 
2.49.0

