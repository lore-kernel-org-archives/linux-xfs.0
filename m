Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC5E36CC94
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222909; cv=none; b=OuptqsAqjZ6EfWN2Ty5pItdeVZy8+061A4dkCYTDacZH7EkH3dRUPhb5i/U0qBJJv3C/yE+9vOEA7kFnAq6pdjx2ngvtkDCberO3tbO5nD/RPw0rNY0ARt8mZXIbtA5IX7CoTTiLPWx1ohtqChp+Wrsye/IgWmd4asKKRik1A4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222909; c=relaxed/simple;
	bh=m+sUlUspLqIWAgATvlSwBwWt4KCBlddh6LFbQXfkBEM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F41kg3DVXsOnHrcxZUos/l3fQWyUSyH970fFmK3oJpPgdsxuQOUgDjo+5oJ6ZUncxGdzd/zPkUwty6tXaOOPjCy+CHAwn4RXFvSuIBHWQX5eWIqCCEXvOgdYpnj7gRXGleEJtmLq0KOqEpHDXKc5ZCWktvN3jczit0E6X0rnyas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=A5otpevE; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="A5otpevE"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-71d60504788so47008327b3.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222907; x=1756827707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=alkILxWqr/LmCgOsh2PuAUd8yboXHrvMnPHss+yxiwA=;
        b=A5otpevEudPAs2Kt9rfSBPzBPiuKCs+hcdFzHIZEMFDr1jJwHa8At7JaBTOxPGWb7l
         v1kQmy5SiVNZl1bbfjo2pzkMkzWV2dwJIYb/bzQbs8u2KncqvyNeBR9NfrC3YF4NX0xH
         j+l/FRJvAzTa8zz77CZLmsunLOGJWALjzm/ykm21a2+bG+U4e3uIQ0uh8oAQSk1nZhBG
         7ilc5GnvNR88mBjDCc7Rso17LapQx/KfqTobIwQ+V7GXSCNK3muZ9YPvBTcSVQMgf0Jk
         bJp8gbWdBuKgm80egAPoot3L8ezkAw7lKXN195FwxZP90Noa62N0NOxbxXwH/l62alv7
         23Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222907; x=1756827707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=alkILxWqr/LmCgOsh2PuAUd8yboXHrvMnPHss+yxiwA=;
        b=UbNxiV+IeZvYqkUMzmsdniVwdDv6f/rrS+GdAiyEc+SAL4f0w+p6kGO5AyiB7RmwSv
         rqmY4W1EvrXrovG7P0MPtuuyN47hZzfkpZD1fVbHOh0H9EQ/r9Ahz8MA5Gc/4cpywK1o
         pA7wiqpTDTzU60ihGdx8sg+xkz3QpYnNkuxOIOi3e4mIn2/dRboQUN5NIRASa/+NVOcZ
         HL5xogjK6aS0BKSI0fB1G/XH7uHCkPVJbpMImVCOPC8uD/VgN75wlC1XQnsWHpd6tRAN
         GuGEKHj4efLZ90vtSJmknHb7DTDmCTDtmvnLIrbrdSUrVTxVzm+d6e0/j6H06QGt8sfn
         2IjA==
X-Forwarded-Encrypted: i=1; AJvYcCX/BVyH+fheDl4DVH7K2b34vWm2dRvwTn9UHXfNjUO6eyAA9iDP3T9yVj5rordvgNCGBDhaT4G+AjE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMBsVBbgYuNZr1iAraJQEHjJp/KuqanR32XbGdf3RD86cLoipW
	OTOyDz4ccXajl+PEK1dcRmxHATXSGc1bZUPtP2tyTwGkhIM9uTi2+zAqZxwgEAnVWj6i9Z6zo0K
	9jzvV
X-Gm-Gg: ASbGnctSb6k1bLnxzxlteNMCc/6+aNF4u9fKuoRKNgV9HDMxZrgxbOQCZgPLraKAo+B
	YRPyUBCZQDL8uWx9Q4COAMpqTrtUJnJ+ax6FeDo/gRpGM5gGJ77DxSWCcPTEgLQ3HKZ5gPB4ZjD
	ic229O94NnYO3giKJhu9Kad0XWUvHU9DjWF67NykgZJmdSncYV4g69PYdWaNdHzCtB9dMNyWxxF
	SxyDP6RgzCJ0+oQxFrXzvZUSErMo14/ijmX7aZvbC7zBnEwN2p2L4R2oW0Ny/uQX9hYZC6I6vXz
	P/lvvtzfVuYOc9x77RHJJGv+ShtevuCutR9YuOfCPKcTTrYgIOvCOeTRytDFKjd/P/sQQGupY4r
	gOAmMG93Qxib5fTUpVzbVFb4sRxWfT8ocJKr9E+gG8lzNYDXx5qvJM6oNP8wOmt8kUnJjDQ==
X-Google-Smtp-Source: AGHT+IHEY7UiuwZsDzTPmXSQVgcvtXTUxA/hqZfermlmHJkxzpNIVBJ6NmVxvNzn0Yu9TKer1jXgcw==
X-Received: by 2002:a05:690c:5:b0:71a:42a3:7b47 with SMTP id 00721157ae682-71fdc10b936mr194714767b3.0.1756222907406;
        Tue, 26 Aug 2025 08:41:47 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff18b4198sm25314047b3.66.2025.08.26.08.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:46 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 40/54] notify: remove I_WILL_FREE|I_FREEING checks in fsnotify_unmount_inodes
Date: Tue, 26 Aug 2025 11:39:40 -0400
Message-ID: <2d97e6a9ac8347779762684ddd720fa8ec53a7c7.1756222465.git.josef@toxicpanda.com>
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

We can now just use igrab() to make sure we've got a live inode and
remove the I_WILL_FREE|I_FREEING checks.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/notify/fsnotify.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 46bfc543f946..25996ad2a130 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -46,33 +46,15 @@ static void fsnotify_unmount_inodes(struct super_block *sb)
 
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		/*
-		 * We cannot __iget() an inode in state I_FREEING,
-		 * I_WILL_FREE, or I_NEW which is fine because by that point
-		 * the inode cannot have any associated watches.
-		 */
 		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
+		if (inode->i_state & I_NEW) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-
-		/*
-		 * If i_count is zero, the inode cannot have any watches and
-		 * doing an __iget/iput with SB_ACTIVE clear would actually
-		 * evict all inodes with zero i_count from icache which is
-		 * unnecessarily violent and may in fact be illegal to do.
-		 * However, we should have been called /after/ evict_inodes
-		 * removed all zero refcount inodes, in any case.  Test to
-		 * be sure.
-		 */
-		if (!icount_read(inode)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-
-		__iget(inode);
 		spin_unlock(&inode->i_lock);
+
+		if (!igrab(inode))
+			continue;
 		spin_unlock(&sb->s_inode_list_lock);
 
 		iput(iput_inode);
-- 
2.49.0

