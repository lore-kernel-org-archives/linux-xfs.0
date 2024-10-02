Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A00A2581
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727833225; cv=none; b=oSq/sw9l9UoyRXnvfysJhjvOpHuaaiHA3Er4cCdKNyY4VxGD8cZ0Fb60MOBFSf8W9yb+sMTxFEKpGwX7dB8bMVEyjSfLJEUuaIkaCQEfmsUp6GH3jTKeDMkF7ijxLRvp5daVY5SCV/bOWrWO6+fz/s5vqZW1wEG5qy2hT95d+jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727833225; c=relaxed/simple;
	bh=QzJZcYuJqvu4t2qF3uS7a40qvoBvPZsRghW4Ip08npo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=he+nLz4lNzVOF1n9Ln/gmuSHEYGsTRpBeE9WyGGMokUpGoFcNU6TiIe9+YOUQllpGP9Xq3nWC9ypwnNFrkWfXbrJZEN7MOvLKz607+yBUgu+QRD/GR3LAz8znVVp+n4c0UST0A0EP4vfwYTtefljTTY3jXAxUD6O7p9IYFsXhqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=mqYWq7x1; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="mqYWq7x1"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7db90a28cf6so260440a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 01 Oct 2024 18:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727833223; x=1728438023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t1rJUH/mWxXjOpXgbWGlZQXMWgJmvd7aMaDMpndP2yo=;
        b=mqYWq7x1xbf1Ifrw7l1y2hhb9uvYjvNPSTW1iORI8rCU2XEsl+XY/vOeenwwhuh/gY
         ajpJIWehMuzEXqo8GoU0SwcE6EjcUK+/obMFHEa5HIBTDnN44tZMziodmtPWVDDg44oS
         liGh0o9dM1n4SBN5ZanO4+Atj/FQLwPgu+9nPP0tO/wB658yECd2nYb1eK4tpCJrIIyu
         Umi/Ogw0B1sjExbsJdPofoexikFkJ9xIhVPNFzXe7zyJe1GTGvRq532XyL3D4IFnQX76
         ixifH88l8GT6DzppfqRVwkDy1lgnwuPn76+vleoRSMchGFMuoaqFJkSKob3fscTt9W3d
         sTwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727833223; x=1728438023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t1rJUH/mWxXjOpXgbWGlZQXMWgJmvd7aMaDMpndP2yo=;
        b=bGXEIhgkt4DAHAE+aDx5P52xHoas+nUohkakGZb8L2+wx6eeXcJuq9GVxQqwf3JSly
         Rp6IrK2TSM8Hd0zOL7mz36AuycFmRK3wKV3e8B17slYFVO0BElYoWOkrdSTEL45mrI0E
         mcrn8Api3F2Y7X3QhNYf+SMtlYFIPPVkotaspTmwU1HoKpaXNw3gS/WrTvduOORxkYNh
         N8KNRizx+PuvOhkJXsPVtVrem+aX1IK5dCe01Z5RSAP0Y9ZPULKnHBeYU0EENE4i67hq
         LjP58U3aMbhlH4/aIMUHyO/oC49v29+7L4Xjv4wlB/vUVJobQNf1HutctrLsNi9tr2ux
         XPSQ==
X-Gm-Message-State: AOJu0YyBAUGcMd+uYEuNL7EoLruOjyplkBANbVd68uRqFRIn8OOci8Yl
	n1AzKPXc2GZNXoepYxs42MYzgJFtQay4CITQdgSHknMrG3KAhqAMUMa8bWeSfUsOXIyJI7eL70D
	E
X-Google-Smtp-Source: AGHT+IER4Kb2iLiz3Cn70aHvpLUJtA0lkyIz83+tDTqx83rbjBv6L7OqRmyXU9lvlCTDvJmi8BZfWg==
X-Received: by 2002:a17:90a:dc0d:b0:2d8:85fc:464c with SMTP id 98e67ed59e1d1-2e15a253ae9mr8067492a91.11.1727833223299;
        Tue, 01 Oct 2024 18:40:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e18fa54fe3sm317590a91.54.2024.10.01.18.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2024 18:40:22 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1svoLj-00Ck8r-0v;
	Wed, 02 Oct 2024 11:40:19 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1svoLj-0000000FxGf-2yhr;
	Wed, 02 Oct 2024 11:40:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	kent.overstreet@linux.dev,
	torvalds@linux-foundation.org
Subject: [PATCH 7/7] bcachefs: implement sb->iter_vfs_inodes
Date: Wed,  2 Oct 2024 11:33:24 +1000
Message-ID: <20241002014017.3801899-8-david@fromorbit.com>
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

Untested, probably doesn't work, just a quick hack to indicate
how this could be done with the new bcachefs inode cache.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/bcachefs/fs.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 4a1bb07a2574..7708ec2b68c1 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1814,6 +1814,46 @@ void bch2_evict_subvolume_inodes(struct bch_fs *c, snapshot_id_list *s)
 	darray_exit(&grabbed);
 }
 
+static int
+bch2_iter_vfs_inodes(
+        struct super_block      *sb,
+        ino_iter_fn             iter_fn,
+        void                    *private_data,
+        int                     flags)
+{
+	struct bch_inode_info *inode, *old_inode = NULL;
+	int ret = 0;
+
+	mutex_lock(&c->vfs_inodes_lock);
+	list_for_each_entry(inode, &c->vfs_inodes_list, ei_vfs_inode_list) {
+		if (!super_iter_iget(&inode->v, flags))
+			continue;
+
+		if (!(flags & INO_ITER_UNSAFE))
+			mutex_unlock(&c->vfs_inodes_lock);
+
+		ret = iter_fn(VFS_I(ip), private_data);
+		cond_resched();
+
+		if (!(flags & INO_ITER_UNSAFE)) {
+			if (old_inode)
+				iput(&old_inode->v);
+			old_inode = inode;
+			mutex_lock(&c->vfs_inodes_lock);
+		}
+
+		if (ret == INO_ITER_ABORT) {
+			ret = 0;
+			break;
+		}
+		if (ret < 0)
+			break;
+	}
+	if (old_inode)
+		iput(&old_inode->v);
+	return ret;
+}
+
 static int bch2_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
@@ -1995,6 +2035,7 @@ static const struct super_operations bch_super_operations = {
 	.put_super	= bch2_put_super,
 	.freeze_fs	= bch2_freeze,
 	.unfreeze_fs	= bch2_unfreeze,
+	.iter_vfs_inodes = bch2_iter_vfs_inodes
 };
 
 static int bch2_set_super(struct super_block *s, void *data)
-- 
2.45.2

