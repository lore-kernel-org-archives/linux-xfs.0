Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2854A35E4F7
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222883; cv=none; b=aHc/MrJsPVx8S0E7D+pyy6IbUucvUKvtnX0dBxx9q4KyvbKrdWroku58lpxQrfx/9QSiaUqRA4ag7qPrN/kLG4CKx3rms2/eCkrKslrGwPs9FAM9Ko7P3LjYoHWVz6+aYnuN/MP+Ib+3ez71AwFA42m8ISCvhbrSx66DKQ6XWTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222883; c=relaxed/simple;
	bh=6dnduwz2qT/zsskC7epU9otttNGxq+N4PxJFoWXJBUw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnX9DiDBW2LT7w0NWW/5Iy4Kf9bnxQM5VF52aHGkOLnez+5NO1kj9UiUE4BuYR3KKQmv8rPqIi7HhlQkrHci0QTyI29kgtBfEAOGC5KILRnxjYUCoKBmUMJaqUk0XYG6d/6dmAFuireJ/TwJ+EzwtZ2vkuCNMTWGsCtgsQoHYZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=xhEuwrqL; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="xhEuwrqL"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e96b9022f51so2645508276.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222878; x=1756827678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FOjvmn46ZQoy8RoAMfUo3jX2UJkpyHzSOm/HJR2z+vw=;
        b=xhEuwrqLkcNIW0HGzHalnj46MA5cS47Ou4R7wQlDNWBfhipWLvRF2jPJBejbqbQ3Oz
         6GrT9LqjTnDJ/A5+jNuWkXj5j9A0rcg1NvR51yKNeytDpBi5MpthpbeU1AUWaiKZ49DP
         ITvGBFHTX13o7KjaYSJ+hBdYFrbs8RYfkbinHkLlIwFIzEypF1bnaqHXurmWXsRMNYlX
         npeFXFVF/tBbmTdlBss+FCDqJEEY1vFVA7OAECSP7YsVxINy916zF68pZ4Gj0C2ZpjC7
         6xPDtdsxytRiM6ex0ZUaU9vj8anwiGqG0NlT4oJHD73mKn7XnHCrXF/mMlsOF46CJGyN
         HsPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222878; x=1756827678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FOjvmn46ZQoy8RoAMfUo3jX2UJkpyHzSOm/HJR2z+vw=;
        b=i2xjtkA6GDZFSoHOf7nS60Gdyn6wfQ8aSzttI9jcWWL6/IkICa18KHz3PyYua2EK6e
         amiuMW/h2IauOUB/vzVyQgKidkCmilW66CawVXF7g6zRhQ3eVa1kdnftSHvJS8yMS5me
         UmziGxwr35Rf+YanSFDhqarcbFMwbHtRDuSCJ/1FmjxgMGHhJRF65o636y87DDH3/g6g
         S2XAJgrdYWIHxidaehvxnW282ni9EG9PpPIGaToklDRmATk81tOF9DU2KI2A9OtDoDFM
         fXZXlyOFDQSFAc5aREB99flvcwF3Eu+WbcXOs6hS8lNfLJStyLI5nBXsgaFdkOaGk+RU
         ERMg==
X-Forwarded-Encrypted: i=1; AJvYcCX84tqbMBpictOx2F2RAD7Zlq+UH8F5F8WJnarouSn36e99ldrCH4ad7Z1p+JFq5f1jbd4PFNPQPnk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz507YmElU5jIfa8H5EqZhqpLHq+r/vKmFfNZghrH81s+u+WdlB
	fzumGYnk1fyLd9s3/Qm4fgdUT33noo1e246mBvr5brIW+LUw3hYxl9pBExOzm7CliwQ=
X-Gm-Gg: ASbGncv0CJOhHf6r/+FdhQRj11VBQyzKqW7QBmwdVpCnl+lX+UJ1Dms6C0ZiyD+5DG6
	lQtxKxjLcJA793mpQU7UPG3ru+CVwNgqctcD4zL4l8JzdUzmPSN9zwZI/Duv+8RRcDxa5lkk9nA
	i3aRFfrSikXb7tH/UtZSo5sGPt3ReFKcHkqBxAwDOVO5XUFL6jpS8YAmcOV3SHOH/5BeMqwL6C9
	IH9NgbWWe2lHzzzoqLbLnGPWK65ZSbhFKZMiRT5WdGdPk0JW4dYqr9lRmXCmiXIyf0Jd3PZdbuU
	K9ry1hkJ1Em11jVULFUUAirr4y+zVllR1h6Kw8SOrdn2VVcrsbN3qYPDDc7nOafG4Y5+7RpyJFv
	Y8S0kmSw9CuSe6/jW9eGnCctvtrVQtn8cnCwmmPNY0ug1ctZlHaDsvaaCF0pLp1aD1XCtiQ==
X-Google-Smtp-Source: AGHT+IFmbiTjt/bWW0MQRszMVOeUPuSn5IU4QnxuxDXuxPmyIrj4BMhw9mjI5WmiUj6YsTAUM8QvlQ==
X-Received: by 2002:a05:6902:4111:b0:e93:38c1:1fa4 with SMTP id 3f1490d57ef6-e951c2ca5b7mr16610661276.1.1756222877763;
        Tue, 26 Aug 2025 08:41:17 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e952c358904sm3307604276.24.2025.08.26.08.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:16 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 20/54] fs: disallow 0 reference count inodes
Date: Tue, 26 Aug 2025 11:39:20 -0400
Message-ID: <df5eb3f393bd0e7cbae103c204363f709c219678.1756222465.git.josef@toxicpanda.com>
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

Now that we take a full reference for inodes on the LRU, move the logic
to add the inode to the LRU to before we drop our last reference. This
allows us to ensure that if the inode has a reference count it can be
used, and we no longer hold onto inodes that have a 0 reference count.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 61 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 20 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 9001f809add0..d1668f7fb73e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -598,7 +598,7 @@ static void __inode_add_lru(struct inode *inode, bool rotate)
 
 	if (inode->i_state & (I_FREEING | I_WILL_FREE))
 		return;
-	if (icount_read(inode))
+	if (icount_read(inode) != 1)
 		return;
 	if (inode->__i_nlink == 0)
 		return;
@@ -1950,28 +1950,11 @@ EXPORT_SYMBOL(generic_delete_inode);
  * in cache if fs is alive, sync and evict if fs is
  * shutting down.
  */
-static void iput_final(struct inode *inode, bool skip_lru)
+static void iput_final(struct inode *inode, bool drop)
 {
-	struct super_block *sb = inode->i_sb;
-	const struct super_operations *op = inode->i_sb->s_op;
 	unsigned long state;
-	int drop;
 
 	WARN_ON(inode->i_state & I_NEW);
-
-	if (op->drop_inode)
-		drop = op->drop_inode(inode);
-	else
-		drop = generic_drop_inode(inode);
-
-	if (!drop && !skip_lru &&
-	    !(inode->i_state & I_DONTCACHE) &&
-	    (sb->s_flags & SB_ACTIVE)) {
-		__inode_add_lru(inode, true);
-		spin_unlock(&inode->i_lock);
-		return;
-	}
-
 	WARN_ON(!list_empty(&inode->i_lru));
 
 	state = inode->i_state;
@@ -1993,8 +1976,37 @@ static void iput_final(struct inode *inode, bool skip_lru)
 	evict(inode);
 }
 
+static bool maybe_add_lru(struct inode *inode, bool skip_lru)
+{
+	const struct super_operations *op = inode->i_sb->s_op;
+	const struct super_block *sb = inode->i_sb;
+	bool drop = false;
+
+	if (op->drop_inode)
+		drop = op->drop_inode(inode);
+	else
+		drop = generic_drop_inode(inode);
+
+	if (drop)
+		return drop;
+
+	if (skip_lru)
+		return drop;
+
+	if (inode->i_state & I_DONTCACHE)
+		return drop;
+
+	if (!(sb->s_flags & SB_ACTIVE))
+		return drop;
+
+	__inode_add_lru(inode, true);
+	return drop;
+}
+
 static void __iput(struct inode *inode, bool skip_lru)
 {
+	bool drop;
+
 	if (!inode)
 		return;
 	BUG_ON(inode->i_state & I_CLEAR);
@@ -2010,9 +2022,18 @@ static void __iput(struct inode *inode, bool skip_lru)
 	}
 
 	spin_lock(&inode->i_lock);
+
+	/*
+	 * If we want to keep the inode around on an LRU we will grab a ref to
+	 * the inode when we add it to the LRU list, so we can safely drop the
+	 * callers reference after this. If we didn't add the inode to the LRU
+	 * then the refcount will still be 1 and we can do the final iput.
+	 */
+	drop = maybe_add_lru(inode, skip_lru);
+
 	if (atomic_dec_and_test(&inode->i_count)) {
 		/* iput_final() drops i_lock */
-		iput_final(inode, skip_lru);
+		iput_final(inode, drop);
 	} else {
 		spin_unlock(&inode->i_lock);
 	}
-- 
2.49.0

