Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B862C3756
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222868; cv=none; b=e/DzDGUpUlzz/X3zl5/InqMHc/JxANw3c2IFUimN7HbinXFoYHOtLslZC4LHI8g6RhWyS+KcS+H4r8SHY32nJSssCg5KjZvq0FiKAsoUFM7ZnQ/74aUt2giuOAqdc17eZs3+VlEH9uEIS/9sKbRUPfYslJKsyUjxm8J8Ucs2Iv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222868; c=relaxed/simple;
	bh=PneIhJNQkgVThEAsNHxm41aQCPMVns311gwXpZ3Sh8g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unf/mKQEK3XrvDs0flwH1Naqq9ofdrcAmeuY6d0gqslJkmWtwGrD+rgMEz1IO6/vU7rlnYymtpnKKsORTJUHuwcA9Zxdt4CGM/SpsdsxhEAT3hAv+QjiW79xZkXC5ImKcd/cWhO34WIHSn4rWW8sxcMC2mwfrmLWu2njbOoY8K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=kZyAqmex; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="kZyAqmex"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e96c77b8dc1so1614568276.1
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222863; x=1756827663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HD2qcaH/sr5LIXFLqeTARJ6AgNvAdAMXICDQLGRWnH4=;
        b=kZyAqmex/cesg6aAtrS67EW10x7YCxR5jJlgBDqwL2F0rktufaCU8DGALs8yUl/MI9
         J9lDkatWm13yBDt/sJScvpwuW/HKNpzrTpOXnnDzydajWsT+MZZUnB1XqOOfIAoDFQgt
         MH5nAgyxSmEcEXO29puZMz8zaPURZnUh4Lc7nXcP2n6UFYhRa5fOTx2xNJ/8Zg7i1cmO
         OHfBUbOuYVWJsFHGnU87Izcco6sC5n0qetnC0DuNH+M1d0QXLLlRcrcNpyJlqwBwGcrJ
         VjC/UyA4pjPy6/83KkdVe5Am14/6h7GAhXOudB+8adNl5tmGtv+nl7K34xR8LEZt/+XF
         BrLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222863; x=1756827663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HD2qcaH/sr5LIXFLqeTARJ6AgNvAdAMXICDQLGRWnH4=;
        b=Rc97gvdAXcn3sR3D8+IPJ+ngtEnehfd2fl4TMF/cIx1V2cVdg2/DLWBEmlAN3i4rPX
         wt3P7LzppYCqUWLxTdvKGt8ac0GrPu0eHCg8AtRj9BfSIzqh1C20oJAUDQY0iTEjodKr
         02jw80sbWNfQzUZ/r62HKX/LNd6Lxa6Rk9HgJKjni7Xw7/pYkNyXdQeRhHny7PlXTe3j
         p4tD5VasWCVGNHyzBl6Z1/UO8Z8YHmf6uNCPmQXg8gOIjU+jUn9gxtcwjWJz/cpYjh6/
         w6S6nt7arGwgjkW+y/Z0HAFx2aSc+wWNQlvkI61fR6URb2fciPTjPKfxLcrehyvYtf90
         klEg==
X-Forwarded-Encrypted: i=1; AJvYcCXn+L+twPVsKsg16STeRHPf8tys9Rt5GMyj097x5RuuT9ttpXMfRddCuR3gMoBbr1HFVPg8WzRE/B8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTh8prJ8mPTa8cTWEEEZQksPbQsDZbHoZvf3TlId7gz0Pf/qaK
	Hd0p6tQ2lb1J0AnAmuzimpVuRYDamKCdZdAzORVdJrbpJox7Y8Wi0agNyQPr9bYdWgM=
X-Gm-Gg: ASbGnct2HuNLLJ5489v2TmjrN7RSc6wOy/mnoQWxC3K0REqaU9B0FuqhUTeF1csY9mU
	iN7TQLs5nhG0wIDhB5ZRUcAChR5qsBrX/6V05y4lv+I4Qy2gjx/fDJoHim6H1niqsCVDOAYmoJ9
	TnphsIRtYqBiCGOsPBifJrbAU77Ndv+N5W5/VcCvIB8cUezhEbt1mORNxDZ4yXUkRDqxo3Qpsqg
	0DdYD0Yj/U8nDQwTwIB0npdd4iSbaVDLj8zBFFq2iur4X8ySJZ/0lm6Uy/dJgG+sFmdPV0XBlNZ
	9j7LJLKs6G4ZRMbzCTHPqFBAL0yao/qUMaat3aBfCQxkiVv/iKGnTICELpSVwDSNmUTi93kwqc1
	1lXyHzx1zChEojx/yaa8I2/PPNYXqqKPf7QisxII2yhE5MjKeWy8fhqFLciE=
X-Google-Smtp-Source: AGHT+IFOwyxSw1QzDSHocgttZXA5ZJZK9OYg63GGlqCgEipVYEviCk6vMqE7SYxZSIRJlAFL4ZG7+Q==
X-Received: by 2002:a05:6902:100d:b0:e95:2c21:2b23 with SMTP id 3f1490d57ef6-e952c212e8dmr13585755276.19.1756222863102;
        Tue, 26 Aug 2025 08:41:03 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e96e5530a72sm368624276.2.2025.08.26.08.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:02 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 10/54] fs: hold an i_obj_count reference while on the LRU list
Date: Tue, 26 Aug 2025 11:39:10 -0400
Message-ID: <f4cf75a75d4100f0a7a9d9a411fd28869dd41595.1756222465.git.josef@toxicpanda.com>
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

While on the LRU list we need to make sure the object itself does not
disappear, so hold an i_obj_count reference.

This is a little wonky currently as we're dropping the reference before
we call evict(), because currently we drop the last reference right
before we free the inode.  This will be fixed in a future patch when the
freeing of the inode is moved under the control of the i_obj_count
reference.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 0c063227d355..0ca0a1725b3c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -542,10 +542,12 @@ static void __inode_add_lru(struct inode *inode, bool rotate)
 	if (!mapping_shrinkable(&inode->i_data))
 		return;
 
-	if (list_lru_add_obj(&inode->i_sb->s_inode_lru, &inode->i_lru))
+	if (list_lru_add_obj(&inode->i_sb->s_inode_lru, &inode->i_lru)) {
+		iobj_get(inode);
 		this_cpu_inc(nr_unused);
-	else if (rotate)
+	} else if (rotate) {
 		inode->i_state |= I_REFERENCED;
+	}
 }
 
 struct wait_queue_head *inode_bit_waitqueue(struct wait_bit_queue_entry *wqe,
@@ -571,8 +573,10 @@ void inode_add_lru(struct inode *inode)
 
 static void inode_lru_list_del(struct inode *inode)
 {
-	if (list_lru_del_obj(&inode->i_sb->s_inode_lru, &inode->i_lru))
+	if (list_lru_del_obj(&inode->i_sb->s_inode_lru, &inode->i_lru)) {
+		iobj_put(inode);
 		this_cpu_dec(nr_unused);
+	}
 }
 
 static void inode_pin_lru_isolating(struct inode *inode)
@@ -861,6 +865,15 @@ static void dispose_list(struct list_head *head)
 		inode = list_first_entry(head, struct inode, i_lru);
 		list_del_init(&inode->i_lru);
 
+		/*
+		 * This is going right here for now only because we are
+		 * currently not using the i_obj_count reference for anything,
+		 * and it needs to hit 0 when we call evict().
+		 *
+		 * This will be moved when we change the lifetime rules in a
+		 * future patch.
+		 */
+		iobj_put(inode);
 		evict(inode);
 		cond_resched();
 	}
@@ -897,6 +910,7 @@ void evict_inodes(struct super_block *sb)
 		}
 
 		inode->i_state |= I_FREEING;
+		iobj_get(inode);
 		inode_lru_list_del(inode);
 		spin_unlock(&inode->i_lock);
 		list_add(&inode->i_lru, &dispose);
-- 
2.49.0

