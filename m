Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82FC23BB
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727833225; cv=none; b=UOWgQ8b4v+Bb0jr8kVPhr4xkbjmDXAWkzzrkBQqx7RVWh4+lsunZf77PfYKenXIstL8KSX1EdFE/m5OiC5MIAie9xRH0eKVfDAqG19DLGzBzL0ylP7l72U9xJoiA5qO9YUkkMZ8bqLubwE4KSdAuTExAdlYd3tWYp8/zL5+1ekM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727833225; c=relaxed/simple;
	bh=wERFCZi4NhTiU1dRVVGYgy3VJ2JsE6+E60RIrOoOa6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGqHI20Aw/pfHUB2f30yxU9Oquus8n0pIxf/ycIqeUICAdUkG/PGbIUNqpoWrk44TwNCoj+q7aO+8M0qYHfC50376fyg3o7z0PQrHjMT6vMiRgs5FOxtL2sr1NOk3QOuYAnGpXr4cGpHcLG1SFAGa6YxSBB241rgJCmiPQBngrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=1VgdHl3S; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="1VgdHl3S"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-718d6ad6050so5164603b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 01 Oct 2024 18:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727833223; x=1728438023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MqUz/n8MwDanhwIPscfHBkgek04h3sMszpax/ZNM448=;
        b=1VgdHl3SVjFiorXNao6kQKzzafwDHifkqX3eD8ytJjN+PbrW1t0ibxiFBoJ48TuV0A
         JyrPqhAe0GlVf1BCpAL7oVBCXizAAAG/PghQhTabKzJm3MCznkBKCy4YXFJijEdBNbYI
         MG7pV82d/oNXX0eEl+L/+2Hlr7cBsrKqwbKC9AYlbkNqAqectmvYiqMraOSShNofUf0w
         iAv6pvWTLOJQ0+N+DV/5R69tGNbTfdAYYeEyi9/q1uDZPX0/SvX/3eYNl8XfoZLy/1pR
         RtnuG1RjyFLdOIUxwbjGLA4j/KkZr5ubf3nlLdy4SMHNgdZnYXup1hTJHFqCMN3s5QWC
         omTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727833223; x=1728438023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MqUz/n8MwDanhwIPscfHBkgek04h3sMszpax/ZNM448=;
        b=Bj601XkVGbWOW7wCitAXrJf2Cu4BzV4rO8vLRAGb6DrPSVh8naRrbvSSEO57PbxSFz
         qcRplBcbCJm7Lm01s22dWeBmTM1Ay+rmU29Xc035G6zQkH2vedheosVgE7pfQAwWQNUm
         M/nd1kId6wZoJ8Q8PsJHgSURUwx0jueVELL8Igyf/r3xqhuQUtjrN9u8mB8Ecv+Z/Zk4
         Eu0dWvKHSI6jmkr+wdpTe0NAaycEy2xSsOj4Gjk8ZUvKuJvK6/a7xn7G/45bZbYMDOaU
         yBcILK67Xfcqh5FUjk0ZI9JWBiwiiblC5RRqSFuO2EyhukC6SUufXoxvqWspap0E1iij
         wcVA==
X-Gm-Message-State: AOJu0YzPxvU5mu6Hx8vhAWPIOj+JvpfNRgKUmOY6MbSiD/+13W2Yoen+
	+OevsXpHcwCApctAo0fQokJfFoupTJinx6oSevaVXSqUxqqafAM/3hqX2EhBZOs=
X-Google-Smtp-Source: AGHT+IFI/J5a2+oGSxaIyhJos9JM1DKr2gAaXKr5CeqDLkHEJBj3amuR8ocZQfdzLPPtz0sAZagbSA==
X-Received: by 2002:a05:6a20:c6cd:b0:1d5:1604:65e5 with SMTP id adf61e73a8af0-1d5e2d2f303mr2078892637.40.1727833222985;
        Tue, 01 Oct 2024 18:40:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b2653717esm8730866b3a.204.2024.10.01.18.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2024 18:40:22 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1svoLj-00Ck8e-0h;
	Wed, 02 Oct 2024 11:40:19 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1svoLj-0000000FxGV-2eHR;
	Wed, 02 Oct 2024 11:40:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	kent.overstreet@linux.dev,
	torvalds@linux-foundation.org
Subject: [PATCH 5/7] vfs: add inode iteration superblock method
Date: Wed,  2 Oct 2024 11:33:22 +1000
Message-ID: <20241002014017.3801899-6-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241002014017.3801899-1-david@fromorbit.com>
References: <20241002014017.3801899-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

For filesytsems that provide their own inode cache that can be
traversed, add a sueprblock method that can be used instead of
iterating the sb->s_inodes list. This allows these filesystems to
avoid having to populate the sb->s_inodes list and hence avoid the
scalability limitations that this list imposes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/super.c         | 54 +++++++++++++++++++++++++++++++---------------
 include/linux/fs.h |  4 ++++
 2 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 20a9446d943a..971ad4e996e0 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -167,6 +167,31 @@ static void super_wake(struct super_block *sb, unsigned int flag)
 	wake_up_var(&sb->s_flags);
 }
 
+bool super_iter_iget(struct inode *inode, int flags)
+{
+	bool	ret = false;
+
+	spin_lock(&inode->i_lock);
+	if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE))
+		goto out_unlock;
+
+	/*
+	 * Skip over zero refcount inode if the caller only wants
+	 * referenced inodes to be iterated.
+	 */
+	if ((flags & INO_ITER_REFERENCED) &&
+	    !atomic_read(&inode->i_count))
+		goto out_unlock;
+
+	__iget(inode);
+	ret = true;
+out_unlock:
+	spin_unlock(&inode->i_lock);
+	return ret;
+
+}
+EXPORT_SYMBOL_GPL(super_iter_iget);
+
 /**
  * super_iter_inodes - iterate all the cached inodes on a superblock
  * @sb: superblock to iterate
@@ -184,26 +209,15 @@ int super_iter_inodes(struct super_block *sb, ino_iter_fn iter_fn,
 	struct inode *inode, *old_inode = NULL;
 	int ret = 0;
 
+	if (sb->s_op->iter_vfs_inodes) {
+		return sb->s_op->iter_vfs_inodes(sb, iter_fn,
+				private_data, flags);
+	}
+
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
-			spin_unlock(&inode->i_lock);
+		if (!super_iter_iget(inode, flags))
 			continue;
-		}
-
-		/*
-		 * Skip over zero refcount inode if the caller only wants
-		 * referenced inodes to be iterated.
-		 */
-		if ((flags & INO_ITER_REFERENCED) &&
-		    !atomic_read(&inode->i_count)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-
-		__iget(inode);
-		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb->s_inode_list_lock);
 		iput(old_inode);
 
@@ -261,6 +275,12 @@ void super_iter_inodes_unsafe(struct super_block *sb, ino_iter_fn iter_fn,
 	struct inode *inode;
 	int ret;
 
+	if (sb->s_op->iter_vfs_inodes) {
+		sb->s_op->iter_vfs_inodes(sb, iter_fn,
+				private_data, INO_ITER_UNSAFE);
+		return;
+	}
+
 	rcu_read_lock();
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0a6a462c45ab..8e82e3dc0618 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2224,6 +2224,7 @@ enum freeze_holder {
 typedef int (*ino_iter_fn)(struct inode *inode, void *priv);
 int super_iter_inodes(struct super_block *sb, ino_iter_fn iter_fn,
 		void *private_data, int flags);
+bool super_iter_iget(struct inode *inode, int flags);
 
 struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
@@ -2258,6 +2259,9 @@ struct super_operations {
 	long (*free_cached_objects)(struct super_block *,
 				    struct shrink_control *);
 	void (*shutdown)(struct super_block *sb);
+
+	int (*iter_vfs_inodes)(struct super_block *sb, ino_iter_fn iter_fn,
+			void *private_data, int flags);
 };
 
 /*
-- 
2.45.2

