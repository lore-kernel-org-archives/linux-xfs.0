Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3A91C9B71
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 20:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731356378; cv=none; b=iBENMAN4W4wNbbyzmcMT7ZmtODpbTXGE2TeNC09ehMwY/uwnt9TfOblgidOzjl5YXZGAuwLvcUuoT9PS6VKqFMPOVUCLb/F9K0rG4g+M6xijRQKbKeLiDiCTmdb2s+4hJNmHQnXTTaaEsJ0nMZxei/OVQYTVEXQ7C6ovWAdF6l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731356378; c=relaxed/simple;
	bh=ebiNpZYnvVnRivNXQB+8i4kmhiMBzkGPNaNaMTrbD18=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcS8+xzzDA+f28/4A6YYu40CnRQ2k6MVSeXGxb2KhzGCXv+FTVD9nomhIwqEAbYZFtInbsz2cm14Y+lpJeXYwmZHROfl67+vE2/4WGyI065R03HMhggIGg70Hz31mgHCyD1hs7ygpaQEonQbe9muXcD/+4j2EZyoYwdTCPhOXBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=KsDTylkz; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="KsDTylkz"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6cbe3ea8e3fso36678526d6.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 12:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731356375; x=1731961175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K354FbH7N36y1HXaBsHf/k0mJrRSZmAsPpq48Ppw2zw=;
        b=KsDTylkzOgGiWbe4xY9fDmY/F7+0m5JC1Y4l7qPBaZeAv0ydV8vhzH+V9fHZ3NwPZf
         veb1C7wPnCqaG1gdsoVAkVG1FNVyhNSzDr9MO63p1F+rB/2jMR9b45XGdS4ANqDShUgS
         6EWwoOPpd4CiqUei5swGsFI1oYllzegAIbuaHT2JmArM8BAYM0ZX7RPsMDbwUj0Js6TM
         G1AT9ygGUe0T1yODjStHH+6+0V/waG7Y56iLa4d325OsIoS2SSFuf+9pUTjZrNUi4+ur
         nMHDjuGo5dxvE3I5i/hJMEXjWaKjhOPp/J+hMjtAMP/JDvyjtWlJVVa9M3Do10WfdbAl
         fqOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731356375; x=1731961175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K354FbH7N36y1HXaBsHf/k0mJrRSZmAsPpq48Ppw2zw=;
        b=FOs99FcidZcl0hFCK/S+fuFSrPeEcyUD4yVcqgUk90AoLnvNrCDQdzxjEx4a+azfzp
         BmcxQUszakFYscVI0syVph4+zM/Zv1zFLuWGHmgj6S+hEiiWpGwi1dCcn7WW2SpVsdN1
         fqpb0OVmB8+MHQ9wi4wWJKq8WTcBO8YdPs4XrwhPUncOpt6P9cK8cXEvfwsVO+r71NXw
         WzmwJVznVwymsf2tX4fMfKMhM5Wt8GbWNjSygfLV84Or6tltnELLO9MtpFaXROlzuMd/
         mFZU8t9Z4i/AF6kHZwojndk22pcxnvomRSPFAZZ4kkKci8LluhaZiVaVrHcDfYomog8/
         ZQxg==
X-Forwarded-Encrypted: i=1; AJvYcCUYs39ntIFZbZbnPzBapVcBzF0ltONCzBNFcSOa9yiguX/eqGVjLB/4kKp5EbeET0PZkNyXY8bft18=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjWtlx9kGyl5WXLL7iNl2GNO+PPFUPrNtmxBwymJAJ0CVyQOTN
	w/LLjnu0y9GlTPW06/onMC0l2AYUjGRig7o3VuVKX54z323n+0t5Hu1B8hExH8+ccwaKtswTzCF
	k
X-Google-Smtp-Source: AGHT+IHFQZuz+k/JoyCiK5HhS+saKZlDM8Ru8ImET04ZPdGlwroC1m2336uogkksO+jSLPZVucywhA==
X-Received: by 2002:a05:6214:4518:b0:6cb:5273:7265 with SMTP id 6a1803df08f44-6d39e1800c0mr180760506d6.20.1731356375457;
        Mon, 11 Nov 2024 12:19:35 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d3961df2d2sm63665716d6.25.2024.11.11.12.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 12:19:34 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	torvalds@linux-foundation.org,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH v6 15/17] xfs: add pre-content fsnotify hook for write faults
Date: Mon, 11 Nov 2024 15:18:04 -0500
Message-ID: <339a520d48acf1c8dc736460d09fd240201d6e00.1731355931.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1731355931.git.josef@toxicpanda.com>
References: <cover.1731355931.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs has it's own handling for write faults, so we need to add the
pre-content fsnotify hook for this case.  Reads go through filemap_fault
so they're handled properly there.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/xfs/xfs_file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b19916b11fd5..d1966f996c77 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1442,6 +1442,10 @@ xfs_write_fault(
 	unsigned int		lock_mode = XFS_MMAPLOCK_SHARED;
 	vm_fault_t		ret;
 
+	ret = filemap_fsnotify_fault(vmf);
+	if (unlikely(ret))
+		return ret;
+
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vmf->vma->vm_file);
 
-- 
2.43.0

