Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D47172767
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479600; cv=none; b=TjNP+uzU065XyRpqk95xHzTCzGgnubXpiSS+WEStVoXRq9G2maJ412WLsyVqeLfZmZtEgLYBPR+x7Rw5ng966POUORmbPfEQTSOB6u+i59J9R+NFezH3ZUe4sLaq5mmOUtgBoFRph5O8nEtBb6EeAYG2ZPQX5Lv2gg8L7Bapdlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479600; c=relaxed/simple;
	bh=FeLYIbIkz4YILs161qworv+9BnUXObjeWtlI0dmF8DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXSPtf2sGjh3ETkhEgLc4w3mxW4Uh8dEp6QPi1tvOCppuJ1u0FEQRwIqOVBX8kD2z8VOTkPQ+3T08SptyIBiIT1xHJxLUQVZHh+sf1O+uajB2olf57688TZggZN10A/0fQmrDVvSSe4a59pZJUpmxVINy9lRNjYMSwNxXl0n5XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eWEiPklo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eWEiPklo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aAApPEx/wtD0xZR72NMuqW3jhzv1pbBasWUws4OC64M=;
	b=eWEiPkloQwvvCmnITwXAXquAhjpSquDNztN8TCJyO3zLp41ntpopwIbvrKCsYnrRLlh+Dm
	bRh+4BVudqzpNoGsTnfcwn1gf/IR6vV4GPgygHiVkmdGTWOD9IGjc+cNN/I7gpf9m72gwC
	s4m2lBfx1gXa5y/YZq+luUWIctd3tJs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-rFsb2oFTNYqKaNey8ZgO8g-1; Sun, 29 Dec 2024 08:39:56 -0500
X-MC-Unique: rFsb2oFTNYqKaNey8ZgO8g-1
X-Mimecast-MFC-AGG-ID: rFsb2oFTNYqKaNey8ZgO8g
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aa6a831f93cso914410066b.1
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479595; x=1736084395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aAApPEx/wtD0xZR72NMuqW3jhzv1pbBasWUws4OC64M=;
        b=XyOmf/LMRHG1NGJCT2vsQUBYTp/hNLqBtZQw967qAw39xkGc/FQPhzmRhLUk0enkol
         OQe35j6p9A6nmDGNeSBhp/YXF72zqv6OAxzfOoTlMfsyhHZX9oaGlx34fm6/XUbwCIpg
         S1mbzUXBMVAy1ZaON93t8tPRdv6vDgd4kByoW0b6r+DsXBR46v3MCl3Ldv0QbqOZt9sG
         Lk2AlRJPJBnUJbPhwo4+ptLamztrhlB3VyTXCEVyHWVoxcvmct2WSH8sDZ8SsSDrKLLY
         HbHnSRMQcacldK08u6aUX5AqpaDPUJS6oHC1zANyjTte+AOma1Dqew3jy4h/jErNhxvr
         7Zhg==
X-Gm-Message-State: AOJu0YxcK4e5dQukwUVai66pgAbETz8nEbSNaU2PtDDcCVnQzv7J5YP0
	FmuxyIA0+lzP3GnvzfaUrRdX97+TpDACiprwo5Up9FMZE+zXKmpv8O9jLJYoGbKCKLUIYG30Jd4
	CHkvKZ95VdtLrqq1QnicjQ1UEnPRU8VDcde/8eE4fWhU3LdE7YJu/JBgSu7iEzp9zTCbZvKldYT
	8BjbZVT+rDh7LOsBrvnNtj4cDeHHM1HRaw1kEhZMpS
X-Gm-Gg: ASbGnctFbEiDJ7SGrfD6InFL0RidMwPKz3fc+q/LoZJF5Wu1wqbSMOepwO8uPBBdmed
	nBCt2tkJO0OXq5AayLcXroOSrPtAjzOeDgOzLBB5qAa8GMS6FY1fJTbCEiqrzybK95FVRx6qQNK
	EHzVOFVHec8c50VjpqnbR4vq7N6bRapUquURZFikUBDUCOodQnY3SMDWiJx9w+g/ZKhl1nJC6PN
	U+SH9NCOBLXW5rCSCPZpYE9IQoWjUrgcPlM7sx04+fCiuvQoh0cUkGQMqHejPCl0uHqHyBI77Su
	ehrbur8Cnwr4kyg=
X-Received: by 2002:a17:906:dc8e:b0:aa6:9e0f:d985 with SMTP id a640c23a62f3a-aac2d470b87mr3240546666b.35.1735479594759;
        Sun, 29 Dec 2024 05:39:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHwh2KYCj4TZ9+xld3MiBRps8At9LDLG9PzeBHyaeHlj4svGiaGOgb8oZNWGKFX85Gzp6Ys5Q==
X-Received: by 2002:a17:906:dc8e:b0:aa6:9e0f:d985 with SMTP id a640c23a62f3a-aac2d470b87mr3240543966b.35.1735479594351;
        Sun, 29 Dec 2024 05:39:54 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:52 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de
Subject: [PATCH 04/24] fsverity: pass the new tree size and block size to ->begin_enable_verity
Date: Sun, 29 Dec 2024 14:39:07 +0100
Message-ID: <20241229133927.1194609-5-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

When starting up the process of enabling fsverity on a file, pass the
new size of the merkle tree and the merkle tree block size to the fs
implementation.  XFS will want this information later to try to clean
out a failed previous enablement attempt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/btrfs/verity.c        | 3 ++-
 fs/ext4/verity.c         | 3 ++-
 fs/f2fs/verity.c         | 3 ++-
 fs/verity/enable.c       | 3 ++-
 include/linux/fsverity.h | 5 ++++-
 5 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index dc142c4b24dc..d7fa7274b4b0 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -578,7 +578,8 @@ static int finish_verity(struct btrfs_inode *inode, const void *desc,
  *
  * Returns 0 on success, negative error code on failure.
  */
-static int btrfs_begin_enable_verity(struct file *filp)
+static int btrfs_begin_enable_verity(struct file *filp, u64 merkle_tree_size,
+				     unsigned int tree_blocksize)
 {
 	struct btrfs_inode *inode = BTRFS_I(file_inode(filp));
 	struct btrfs_root *root = inode->root;
diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 839ebf7d42ca..b95f31f7debb 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -99,7 +99,8 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 	return 0;
 }
 
-static int ext4_begin_enable_verity(struct file *filp)
+static int ext4_begin_enable_verity(struct file *filp, u64 merkle_tree_size,
+				    unsigned int tree_blocksize)
 {
 	struct inode *inode = file_inode(filp);
 	const int credits = 2; /* superblock and inode for ext4_orphan_add() */
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index ff9308ca04aa..cef3baa13b80 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -115,7 +115,8 @@ struct fsverity_descriptor_location {
 	__le64 pos;
 };
 
-static int f2fs_begin_enable_verity(struct file *filp)
+static int f2fs_begin_enable_verity(struct file *filp, u64 merkle_tree_size,
+				    unsigned int tree_blocksize)
 {
 	struct inode *inode = file_inode(filp);
 	int err;
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 9f743f916010..1d4a6de96014 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -237,7 +237,8 @@ static int enable_verity(struct file *filp,
 	if (IS_VERITY(inode))
 		err = -EEXIST;
 	else
-		err = vops->begin_enable_verity(filp);
+		err = vops->begin_enable_verity(filp, params.tree_size,
+				      params.block_size);
 	inode_unlock(inode);
 	if (err)
 		goto out;
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index ac58b19f23d3..81b07909d783 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -33,6 +33,8 @@ struct fsverity_operations {
 	 * Begin enabling verity on the given file.
 	 *
 	 * @filp: a readonly file descriptor for the file
+	 * @merkle_tree_size: total bytes the Merkle tree will take up
+	 * @tree_blocksize: the Merkle tree block size
 	 *
 	 * The filesystem must do any needed filesystem-specific preparations
 	 * for enabling verity, e.g. evicting inline data.  It also must return
@@ -42,7 +44,8 @@ struct fsverity_operations {
 	 *
 	 * Return: 0 on success, -errno on failure
 	 */
-	int (*begin_enable_verity)(struct file *filp);
+	int (*begin_enable_verity)(struct file *filp, u64 merkle_tree_size,
+				   unsigned int tree_blocksize);
 
 	/**
 	 * End enabling verity on the given file.
-- 
2.47.0

