Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F25C1E9767
	for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2024 20:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725481784; cv=none; b=f3HpQdT3gA4CMszj6u8tPF49l0LmkSTJwyHWl2aSg6OEKADo09W2BUXTaiSwyEt/VFd2n6qINqCMccMqkmSGtGsSSbh5tf3nqeqU/XoeUwx3tiIwS1pOdaFtD9NSImb2974pgWIvY06ff88kzAlq0Z0f/3vQfwUpFLWkGR39h48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725481784; c=relaxed/simple;
	bh=mlpkxER5ZXbhWxBFWH/+nNlNrq7abJQvDN93xPwV0N0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQVbrF5T2aNTdMWS5luOtJiip17KaGtcl2Cuuyrv8sK7lda/iy84rbBWW1Mdicp3g8qzqlxBb5l4TsgaaqtjTy+cqBDkPh6i87UCdcOMXliVvzQHr9TXkJ9lLOD6nyFYu/psPdTdwBoQOeazqr5A/Ad292dQQoFg3qQ+g21Jc+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=Kxe1sZSB; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="Kxe1sZSB"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6c35427935eso30216d6.3
        for <linux-xfs@vger.kernel.org>; Wed, 04 Sep 2024 13:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1725481782; x=1726086582; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k2g5nWsdtLhh4I3qKZ9kVR48Zxv3ldXz3E9kfB37E8o=;
        b=Kxe1sZSBe9bkdYZJnRALn/HAAAEZMTeKx5eO5AvTJ1D3YwSVfn+q5BILaNQW8ER2gI
         mRsqj+KUHJ9z66im7l1ciGFzt9X9oXD3q4FjbbQeStUTGAd6/HYPBSW8vY3KM3CkbRJG
         Hqfe5P+PTSnrLsdQJr1+s9qkv/NAD7V7PMQtg3S94IcnTfuviqT7TkqwJTke7gTzi0K9
         ggVWsakCpTAaB6upon39dRx8Qqe245H8JgVEmnUuvRcNqde+hkeUQXMJUvWslK2tB1UV
         SnFSr76ju62cmfyRuo5JBgN0ZxMAN/PxBuPJeqtog6yIzIehwqBwFtxPE+Z4TEVlM9op
         3pRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725481782; x=1726086582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k2g5nWsdtLhh4I3qKZ9kVR48Zxv3ldXz3E9kfB37E8o=;
        b=R/oCuXme95+2IfYzUhHmcvUqtRW9+y0AHgP/7jn0Bzb3fpoR2vYZDVBcCt+rH9OxD3
         +Mt3YRtRB8RMvVOnajnJSSbbVLj8L2MHEplduxJqWloKRhYEJdpaLxMWFhXNCZ2oYzh8
         tIc7cH3dd64EHAijoUkO6Sa1aGxoLwQO67D9mi+Bt6815pahv0g7Dii6ChMEM9qcTr4y
         3bfLcA7cs11FYiBIAoba1l35PkMqUbPcZAOm/kmZMLeDX5AnQrzx6NGW9Tm1qd0ytJfz
         UMo+xfxtIg0HTuA2tQj7EP2YzqkcbzlE79EwqwHWv5PgEYpBStvmUzcUJHC7O13Qsgm3
         goQg==
X-Forwarded-Encrypted: i=1; AJvYcCVV6yPovmQ/MTcFc+mvtVMb2yhHYf/dCKE5wDc8p+xGFmduhICo9hWa1YetOH0KWCtVcTXtT27KHVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAx03lMckXdW2v3vWvxuRWDIrw4yDaclFyTwegrG+q2kjR2xyl
	JpRqZXWxdUHZ9nQcEzB8Z4dr2ogWcK/kzxy/cQ794THSDHHPGpr/2hYOuL0VsAY=
X-Google-Smtp-Source: AGHT+IGcGqc27V/yp+/MPiFXZlq6o8dH/S56y18i5ffiw87nR/uugOanZlUMV6j8hRmZXaYyxJ0xkA==
X-Received: by 2002:a05:6214:4a09:b0:6c3:5ebb:9524 with SMTP id 6a1803df08f44-6c35ebb9733mr193501086d6.48.1725481782473;
        Wed, 04 Sep 2024 13:29:42 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c520419ecfsm1552666d6.126.2024.09.04.13.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 13:29:42 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 17/18] btrfs: disable defrag on pre-content watched files
Date: Wed,  4 Sep 2024 16:28:07 -0400
Message-ID: <367fe83ae53839b1e88dc00b5b420035496d28ff.1725481503.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1725481503.git.josef@toxicpanda.com>
References: <cover.1725481503.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We queue up inodes to be defrag'ed asynchronously, which means we do not
have their original file for readahead.  This means that the code to
skip readahead on pre-content watched files will not run, and we could
potentially read in empty pages.

Handle this corner case by disabling defrag on files that are currently
being watched for pre-content events.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ioctl.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e0a664b8a46a..529f7416814f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2640,6 +2640,15 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 			goto out;
 		}
 
+		/*
+		 * Don't allow defrag on pre-content watched files, as it could
+		 * populate the page cache with 0's via readahead.
+		 */
+		if (fsnotify_file_has_pre_content_watches(file)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		if (argp) {
 			if (copy_from_user(&range, argp, sizeof(range))) {
 				ret = -EFAULT;
-- 
2.43.0

