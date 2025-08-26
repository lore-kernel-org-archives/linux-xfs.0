Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2335A36CC7D
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222908; cv=none; b=k0HWPww6AexC0g57Adqk68II0PkiQuXHxeQbxYfj/IuE+uej6gRWag3VroJLE/4zkBa2Amf8/5kgzuxTKjpZdNkLn8hJZ2cxrPefIbbNOU1j2AeGPhnS4/t3lvXjQ+AMCsTXYhhJhcBV1RivHXI9AoHbBL8Wfa0GOpDLdTTR7+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222908; c=relaxed/simple;
	bh=GaKmvGab+0a2RrIuxhv8XqHzko9SenWylGMpW6UIOW4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yr/VPuPDCJMKohGDIntppHEvUchwtVx6wqEAI/bPoIVik/EH/sAFAk8TWB2M7RquqoqIcb9aFCl9TO7g7+vOpzLWKd74AdpH5DdQvPRplbFOOXhGbRFbDLhn9RDUPbDK0uX9OYQzlVHXXSFu5P8buuA171QOD8sy0EFPrkCZZAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=uGC5UlYj; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="uGC5UlYj"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e931c858dbbso4584483276.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222906; x=1756827706; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WTOjoTpV6m7hLv/F0NHjQx0Ply5AcqoXgmnK8+LDP5A=;
        b=uGC5UlYjbB6rOseH9rP9MBsmDrcW30L2b2JfgIYz8Eyj3xR/rQwJmfyyU66fGoMvZd
         YIn1TRYIdFSV0VIFkfvJv0Y5xYinUBAW72kL9idKUi+wb0zTYCBo08c3pOGQrl3SHnH9
         vxnF5uYsccZbcvX9GNwpv0/djWeDtHVRSa5Rz3Uu5EFHcpmCsexCUXNdQWgH+hTiw2kj
         VGL2vVIQfEfXhMWUQAVfWEBK1kyEfBiNFS6a4c1WOmK2x/Zw3eXkvzoZrOe8uhHAs5td
         Hh0qDI46iRuFdj4JGFQTJ4/oAy2+e21u+KIat1IEqO+Z6mbnDl7hhYAeweAmG3iwJoz1
         Qv/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222906; x=1756827706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WTOjoTpV6m7hLv/F0NHjQx0Ply5AcqoXgmnK8+LDP5A=;
        b=CG6VBKYrgN7Haoyw6/X3rXl0uG28eAsr0EuJnqIAVH6Lyltq2Ha48Nf/lWyf6OIVLX
         RJtEnS58jgCPvKZl5AOLoYExJ1zdzgBEjvHPmXYQVeI9o2Md4MWXyrIu+yB/9HQ0ksSM
         /5tkqvi+SEbpnZrrJwFp2sswoK3ff84ay57kGuBaB5VJxkoyBwmzwq4hkWFZswzUhXMa
         HDHA2fV5ShxaPb7jABa4EFSX8UuxIgkHo8gQ7RxwmeyrKmhogEcHsEkKTzMuJBT+NJdH
         atdQ9euefGIRuzavwV7rLfmMI/cy0kh6B2SDUrP935FnXfH5VMANLwZgCZq7xMzOsjtB
         oB6w==
X-Forwarded-Encrypted: i=1; AJvYcCUqelR6lc51A/xgdY484r+28GQExtggP5giDdARtnb0OYzwrJOQ/6TRFPz/nLwHzCYlVQD+vc8i6Cg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPQquJ9+LZrC8sDqLMMHhLS4504XB/Oz0m1mvUXnZILMi0VO7l
	mscjJqAM6eqwIcvYxN1L6M1oSo1leJgOAYE8RkotSKCBgzk0KTEYlcbY4OKKe5To5aArpOa/+LD
	4jyha
X-Gm-Gg: ASbGncsLFpqAk/KlcYLHq/J7RG6qqwpZJGxNsSqQmeSivjsJbpg5ucEGlXIMnHuy5mq
	0A1OiOvIqBfmkqvuyjUBjd26yG3nNe9YVYvLqF91nwXJ0/lLXsNgvAmN+53a8jfBey2hXvMeyxE
	JibwS3f6F/7TE/iqQp75yVhzL4ONf//ZlXH6rfVa2hdG1qTieIO8PB3TgcuSJjJvzStFGTzUt7v
	gnlS21aZWFm5ret890PT/H/PcXzQ55fpBFwguo2H9FOZ3OcxjGNe9e3qz2HgqtV01+k3+W1WrtE
	aAJB7h+P2bGRV6YU+BwajNAPPbF20jfMNoyfr8yiTlL+wRFTa4mYNqOyuQF37SBLidBmcSS5cY1
	XwIrE6LJBLuTaONj7FtUNCQeafC79c3VXcArCw+xcWMQSqoHEieFbgn4YrhXwm6Mu+lV3Kw==
X-Google-Smtp-Source: AGHT+IFjze0r20/WCdIbB5fda9LnJE1jWaThHGsQzBCPZUwgD9yRzYM9e2CgIgaMhoLiVnPc0UCoRA==
X-Received: by 2002:a05:6902:150a:b0:e95:3e67:90de with SMTP id 3f1490d57ef6-e953e6797fdmr9650941276.27.1756222905943;
        Tue, 26 Aug 2025 08:41:45 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e96eb3c35cdsm121586276.11.2025.08.26.08.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:45 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 39/54] fs: remove I_WILL_FREE|I_FREEING check from dquot.c
Date: Tue, 26 Aug 2025 11:39:39 -0400
Message-ID: <e2c8fe9fa28fb6e52d0e47e38d2ef93c9527b84f.1756222465.git.josef@toxicpanda.com>
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

We can use the reference count to see if the inode is live.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/quota/dquot.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index df4a9b348769..90e69653c261 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1030,14 +1030,16 @@ static int add_dquot_ref(struct super_block *sb, int type)
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
-		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+		if ((inode->i_state & I_NEW) ||
 		    !atomic_read(&inode->i_writecount) ||
 		    !dqinit_needed(inode, type)) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		__iget(inode);
 		spin_unlock(&inode->i_lock);
+
+		if (!igrab(inode))
+			continue;
 		spin_unlock(&sb->s_inode_list_lock);
 
 #ifdef CONFIG_QUOTA_DEBUG
-- 
2.49.0

