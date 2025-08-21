Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC42391934
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807682; cv=none; b=UfvZlizbTBXHMDh//nJOKMToe2osZ4SKcspke9Q+0Kvr+vumNk9JK1QbTV51kkNJdSiWEYGHHcKjemS2hj3c5ndemC/zsRokqk0GwTsCBt3gu38rQwTl7AgTxuOwxngy0vj+FY8y8cnkVDJwacIgd/RfLR72r6sA+OL16fY5H1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807682; c=relaxed/simple;
	bh=BVFzQz5MM2vwh8WuHoPp+aDwxtfF8jTQaeq36xEpnFM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Szs7VMZ2qQ8Cm3SKvF48YKUqZRJips3yOuwh+Ni20NhyBdykrRPNp+87NUjmPB/6iHgage2pJf0rty3jivREhYYkNeWoZiaixQucCNANBeTKURvZtwfpx+qjGp5dtsEgz0NUWaNVsu7gWnOB2ytlU2tKhjbf1uOeA/yQyDq9df8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=0EALgZJc; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="0EALgZJc"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-71d60150590so12051307b3.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807679; x=1756412479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OJwH/2/AGfycifeN3K6mTcfvLjDiixS7hIcYHA0w3vE=;
        b=0EALgZJcGmEUK0G5O4pBhDWjcwtTiKu+ML1PFtFlnWJLRWnwJbMhtD7NKzAGLKSRyI
         2i2/21mj1G9SYs9Z52Gl/A03sJnpqd2vBA454oH5a0eECCXsjdVFRaveguTqQPLgXAIU
         As14Ad4hYniOV7Q/TitFvLF3BntzNRuAPcAjvWFHPffde6td9E82QvN/Z/F+LBuMDnz8
         KFq6dLUDp0aHPE1Qn1w2K0Gb12INRu2JLYIwaYgTYR0173ITncGGhgZefOjLFgsDoiT5
         pbnfUwmw7IN4vbBg4GJ6hd1qYtTfHIVcrnPRCqFGccfNWl9yM/741WuqSNMz3/IexkdE
         hcQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807679; x=1756412479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OJwH/2/AGfycifeN3K6mTcfvLjDiixS7hIcYHA0w3vE=;
        b=GdhjH4wbzwqNny0WxtjOgip2C6cUvnk68HdoADYW3sDZ8xQ9MUEdB/lDQkizv0kYkb
         +gWsDQl5v18X016i0mBH/dDe3qhyvsruqnTLLxaSdPE7BRg1QCMsx416dSBzDkZcOJxb
         OgnBwwTfZEaoJzJSQ1vuInXDJlrDrKdtKuOP8EKBU9V9ZhaK3mLbrmPuIA6T0aAA3fTH
         /Ad18b6NmpIZts1QZkJm6TVhypgASfxMH+a1sZrouyCl7mFsQrECx8ZUnLrQYChxKose
         mKvhxXXtV2l15hUtgxw+yFQBW0b5Jd/xjvkB5Jr+Zkl1rBrHBUOKIAP9X5DB6fAsrn7o
         zXqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYszu4V5FskcnzONuRDJQumUDsepOYtHgmw4pht25WJWGLnHMHtmTIHPy4uhsrnPLc5L774nHJe7g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz1nQ2vFUhflaSv+ONJuFF2QY/kJ3+AOH4syhRmBARAIyoR3Uh
	EalLnGWRGjOnYXrMCjFsj3Pni+455NQxk/ZUZQr3YQ0wB+rPwJAuY+WoUZOLJVmWmZE=
X-Gm-Gg: ASbGncuHpWzlZE9r/RmO1841akFVJIszckC5pqMMUP8o8gnXSaerIefI4MmYu1Qu15R
	S21ZRk62uZxjNXKwpk6pfeIvpi+55Yt+LaqbLSlTo87t08IUJa3WDhrTiv94Bmhe7G2E2DmZei4
	fP9sGt33tmaOTz/Qrxs4MHBgw2mDcbqn2cBs9j69dx7MI6PpvFIQ4rM31rf4VrFYQgRzT5BigBb
	w/ryJhXkXgFBaWLmNE/sZZ0wbIpqaKdc7LQJQJ+Ij4cy7YtGqJlH+OdfxeZLrhwFM6jGLYjki57
	PV9UitUh+9kkoilU7JUzP8xlbvTNsh/J/zveyunnnaTVPGSsNDVvJLvZFbooowz/ps2BpoQbpL1
	z50xW55u8+6+DwGFFNAXxNTwpVwyQ29OuFxVoHV2bxkIKAzxT1joJpnrUS1dSE/lyrrJJuw==
X-Google-Smtp-Source: AGHT+IFLh1NRGdke0rPvIun6BwDM+j5CUgCx0MIDgv4txaYGE9873VFVFQQgPIyDR56MDTrNJvGMzQ==
X-Received: by 2002:a05:690c:305:b0:719:3e4f:60f7 with SMTP id 00721157ae682-71fdc3e8edamr6284457b3.26.1755807678549;
        Thu, 21 Aug 2025 13:21:18 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71fb82b39ebsm13478727b3.42.2025.08.21.13.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:21:17 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 41/50] fs: change inode_is_dirtytime_only to use refcount
Date: Thu, 21 Aug 2025 16:18:52 -0400
Message-ID: <b4913e1e9613eea90c47c2ec2d8de244e1478668.1755806649.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755806649.git.josef@toxicpanda.com>
References: <cover.1755806649.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We don't need the I_WILL_FREE|I_FREEING check, we can use the refcount
to see if the inode is valid.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 include/linux/fs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b731224708be..9d9acbea6433 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2644,8 +2644,8 @@ static inline void mark_inode_dirty_sync(struct inode *inode)
  */
 static inline bool inode_is_dirtytime_only(struct inode *inode)
 {
-	return (inode->i_state & (I_DIRTY_TIME | I_NEW |
-				  I_FREEING | I_WILL_FREE)) == I_DIRTY_TIME;
+	return (inode->i_state & (I_DIRTY_TIME | I_NEW)) == I_DIRTY_TIME &&
+	       refcount_read(&inode->i_count);
 }
 
 extern void inc_nlink(struct inode *inode);
-- 
2.49.0

