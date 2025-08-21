Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5902C350837
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807622; cv=none; b=hEwV8oVCNL+sjp3o8UvZas5YNUg4JZmvjGLDAXsYJvqBJJHmngf2WfoxJ3iwngsK7a/eqTjYAikaGHul6f9T2DuX4kX8rgnJkVxC+Yg9CyP7eKeMYvAUNQ2iNJ5bspfkz1HJS7ivT7k4vSHxEKTQiK5cHSXOVOjnkZxXj8EblUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807622; c=relaxed/simple;
	bh=DNs/TQNxWbDoZNMHMrgStYIsY8w3J4G2A2bPU67Gm8g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0M6lw/rbSDWAAO4+BCokbwLMJEPe8soLCjP7GZPmw9xrWzMjHAmL9oxAWHC+KappWbYDif0yegKd9V+Podo46AByB/URJXosZVW5veG+AANsbMubmPovmk9PfOIyxCj4nh5qU4+7r+r6XZNAq0PEWTrKxIV4mvKJjXubEU3RC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=3NLXyK0H; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="3NLXyK0H"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e94fc1e693fso1481987276.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807617; x=1756412417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PJtEKoNF9dskDWzZWtIeIVazPwYY+yFnFA15zXPxXm8=;
        b=3NLXyK0Hq7K7Xwb35em1fKK0/NIasNdoAasVFINs9VkpEjPFbYMXEe3FHhhrW8WAq5
         H/Acep5yoiydyITVPHy2Y2LF4v8yTlKLWqs9rSmn3AZju5ibdtaXiO65X6cxXZtevm2l
         k7IsdpNBzmu0DvPBH7+pYwyYikFaJErrRYooPjEHe2265H+GBkouLTNnbRDNrWbrb83t
         XZ0DAn8ZzuzfHMBhU44IMj3fhUZYyCckUWtPd/S3CLn7xR38U6SXBBdCJQBEzOXwNp3x
         GJrTW2TERerfIJ/DgGwX+PH9/CsiOAZm5piqclRhmYwbRe/vcPVnYBBc4rvTyNIiA6Mi
         SiVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807617; x=1756412417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PJtEKoNF9dskDWzZWtIeIVazPwYY+yFnFA15zXPxXm8=;
        b=Lzu8YzAqGTv7BH5Ofd5TLwjOtWbpzAFuRWOwaCAcZ0pugAKDSjbUzx5VhCnQM4wJ1Z
         yayhv+RJGt79tx3/k6uqku7jx9uvIDPn8hdok4x7zRHW7Kmam6cNYrr8X/RUheuAeHu4
         sn1tINNGy6JHnD4qQqz00Ak8e+iY2ClEkYFdJKAAHFLKXJ5V1+qizvhDwzGjvxZ0W/gf
         EwzfX8IaiZcBISg5pyjBTOWFpQIB8M1MPzhd7wvgEljPMXOAgid1pX3uwzknpIOWrfVj
         3uXWqDZOfHJqPDmJzDmphq1RZh4vi8oIvU2ykcyav0yUAsORB/XJCqHvrj/V/U30V0AG
         h51w==
X-Forwarded-Encrypted: i=1; AJvYcCUzsWW1ut/JfhXP2LtRU9MSsW+XITyu1IcjCx3jO0gukR6FTHgWXBo8RlyNzkm+Z2v8Y35ygxVAr30=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCrQeLStKZ88dCzck6Hp4IJt4zIdDM1LSR9LQLEkoLoYMMgGU0
	45W+PM1CnG0Ypl1cywe3wjLXqR12nkjC9+Rd07nLPUw7RKRjvUOd4GNG0ltE/yx05UI=
X-Gm-Gg: ASbGncsC2yxV7QJ1A2804rOTM1CzUL6fCmGPB2MNkybddNZNkjZEPbLs8Rmszwzxldy
	koqnknDdWezZi79QtZadq2yJ3CEmgxAFdoK7sX9vpUxpn30wee7o3Q21ggzIc4kdT1HDVucaXCu
	CKy+WSsI9447I0rd7RYgNcN9c88kIEzcePfPiGkz1iPbx8IIizs3u2q2eFfe+bzs77f92WLF2Tm
	wompmrSF9HiS23Xc2/2R2nQ/2dl1pRNuH2Sk23HkOAA83zs9CF52bLC9RdCJ2a/M7jqsPTLsWk6
	jyH9oD2BtpjMByd94MUng26q4AUnAy0vs4KmSg+H1VUGL4bEqxhOUb9d/JjqBkG3fqiWibksng1
	Vfm1m/QqaYl9AGVocP6JXbm6h/3ghX1Dw0LNwZcUzhYa1swXhItt5bsq+AJ5Uphe8BRpMlrQoQW
	hKdoyE
X-Google-Smtp-Source: AGHT+IEGnHWDf8yEIkP/y4xLOXnB+qyW4bNlEA/MgMrDBawziV+qfA30EUGQvOnBiEpnJXh38D+Gww==
X-Received: by 2002:a05:6902:c0d:b0:e8f:caae:d581 with SMTP id 3f1490d57ef6-e951c2e0348mr1021208276.13.1755807617210;
        Thu, 21 Aug 2025 13:20:17 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e951bb562acsm225609276.9.2025.08.21.13.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:16 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 01/50] fs: add an i_obj_count refcount to the inode
Date: Thu, 21 Aug 2025 16:18:12 -0400
Message-ID: <b7ae58e099d05601fe16d310e06eea3085c23c70.1755806649.git.josef@toxicpanda.com>
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

Currently the inode's lifetime is controlled by it's main refcount,
i_count.  We overload the eviction of the inode (the final unlink) with
the deletion of the in-memory object, which leads to some hilarity when
we iput() in unfortunate places.

In order to make this less of a footgun, we want to separate the notion
of "is this inode in use by a user" and "is this inode object currently
in use", since deleting an inode is a much heavier operation that
deleting the object and cleaning up its memory.

To that end, introduce ->i_obj_count to the inode. This will be used to
control the lifetime of the inode object itself. We will continue to use
the ->i_count refcount as normal to reduce the churn of adding a new
refcount to inode. Subsequent patches will expand the usage of
->i_obj_count for internal uses, and then I will separate out the
tear down operations of the inode, and then finally adjust the refount
rules for ->i_count to be more consistent with all other refcounts.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c         | 20 ++++++++++++++++++++
 include/linux/fs.h |  7 +++++++
 2 files changed, 27 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index cc0f717a140d..454770393fef 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -235,6 +235,7 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 	inode->i_flags = 0;
 	inode->i_state = 0;
 	atomic64_set(&inode->i_sequence, 0);
+	refcount_set(&inode->i_obj_count, 1);
 	atomic_set(&inode->i_count, 1);
 	inode->i_op = &empty_iops;
 	inode->i_fop = &no_open_fops;
@@ -831,6 +832,11 @@ static void evict(struct inode *inode)
 	inode_wake_up_bit(inode, __I_NEW);
 	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
 
+	/*
+	 * refcount_dec_and_test must be used here to avoid the underflow
+	 * warning.
+	 */
+	WARN_ON(!refcount_dec_and_test(&inode->i_obj_count));
 	destroy_inode(inode);
 }
 
@@ -1925,6 +1931,20 @@ void iput(struct inode *inode)
 }
 EXPORT_SYMBOL(iput);
 
+/**
+ *	iobj_put	- put a object reference on an inode
+ *	@inode: inode to put
+ *
+ *	Puts a object reference on an inode.
+ */
+void iobj_put(struct inode *inode)
+{
+	if (!inode)
+		return;
+	refcount_dec(&inode->i_obj_count);
+}
+EXPORT_SYMBOL(iobj_put);
+
 #ifdef CONFIG_BLOCK
 /**
  *	bmap	- find a block number in a file
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a346422f5066..9a1ce67eed33 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -755,6 +755,7 @@ struct inode {
 #if defined(CONFIG_IMA) || defined(CONFIG_FILE_LOCKING)
 	atomic_t		i_readcount; /* struct files open RO */
 #endif
+	refcount_t		i_obj_count;
 	union {
 		const struct file_operations	*i_fop;	/* former ->i_op->default_file_ops */
 		void (*free_inode)(struct inode *);
@@ -2804,6 +2805,7 @@ extern int current_umask(void);
 
 extern void ihold(struct inode * inode);
 extern void iput(struct inode *);
+extern void iobj_put(struct inode *inode);
 int inode_update_timestamps(struct inode *inode, int flags);
 int generic_update_time(struct inode *, int);
 
@@ -3359,6 +3361,11 @@ static inline bool is_zero_ino(ino_t ino)
 	return (u32)ino == 0;
 }
 
+static inline void iobj_get(struct inode *inode)
+{
+	refcount_inc(&inode->i_obj_count);
+}
+
 /*
  * inode->i_lock must be held
  */
-- 
2.49.0

