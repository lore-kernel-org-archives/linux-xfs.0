Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135405;
	b=INLyZTZBgEWOfEc6wVbkZa7Pe31MomfDGl0zc1y/PsP4IxoSq7S5h88TBuNMePPhigRb
	 mwdD2qOq8vsik1U/5DxT2ZmpY7Dr5+r2aMjUwuzKXf8Z+eLu0/trtk2ttGIzrDvA2fAVB
	 raQklxsb6RsxdNTHbyKbOm/BemdU3ht/BI4myS1buu8QZnNJRqHRYwmbSxzcTwIxBNpTO
	 hFbuUCgvtwlxYqmjstsAK9KRN/9PGEFsjlJM4FuSHu7gB8rh3Wt9cCv/EnsUmLyeEw7WN
	 6GBMdsDeeCmf4i5DqTNJatCW3Sv4pAV44WNg0Ec8IV5vZuPWR1TUP6esyl2oddXJHHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135405;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=hylVN4pLJ/oWpRgIPCsClj4OvOXmuIl9PskjQZcFHUw=;
	b=260FGJYQR7J5wWR0UaMgaujbd+lgYLcai+dSMHCKHHYZlwnvqAcqMHN19qPc7Rt7xoSs
	 8hG0jmnykMP7A3uTNJHZ7TdCB2BU1Ee7bhu+/9kk+2dUU5cmcyZwMzQx8zxObRrGY8j/s
	 hOTBjjUyfQ5NhanZPBQ8pm/8CexxeDLpMg7VLyHmIH9vZmoa57ds4z69MOmRne9nmcVCQ
	 HFJwst3/eWMhaFd4R4JRRT7FchJRIw8OWHCibeEhJi66jt9BhBthrubNG2O83o+RMwQvZ
	 a5EeJjWNeZCwjQxRp/xbumvcVtisdSjndjFnUtr4bs47jM/T3QhcEm7RpxmTfZBR6Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=PcYmnVWp;
	arc=none smtp.remote-ip=209.85.160.173
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D782360A2619
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D782360A2619
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=PcYmnVWp
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5363c8de563so4816991cf.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135395; x=1793740195; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hylVN4pLJ/oWpRgIPCsClj4OvOXmuIl9PskjQZcFHUw=;
        b=PcYmnVWpIJ5mRB58NQMpE5mtmvrIjkFJfuvX83tHAZ1CLRHHbicyM3u6h8FJcnIFgM
         J5eugBKZk83ApO4bvKBaG03hyGfj/SReJVHl6iNberoZgsPHT7W1hGBnldbZdxpcpgNL
         aAQs/H7L+JpEfTYN1SCnCdj2xQMaLhjfaASoqrBh+1gm69q+401VD1HX+S+42fgfqzT9
         8I3hHMHxcEc558Dl5uKuqjZE5PkSB+YFz7DFEfIY4u/TQ5loAy+B+uLkNQFpB91/FNXV
         6UUFhT/0oS5lY/L6UBhKSztShSN3EyYYIstmckxZlhoo4E6C/zRft0fAiS1dIA49FDVp
         9nPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135395; x=1793740195;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hylVN4pLJ/oWpRgIPCsClj4OvOXmuIl9PskjQZcFHUw=;
        b=I4kzUeZAaZHEGGtWZO88FDarYJAQmOew7BIe3MOnzPocsHece5Md2J1v03TTFcILGH
         ZWghPvOvNXbEfhi6oeKqAHffwBGKIC8L5FVI24xIH3pjBjFwUHCWw5Z8x1aNBKhn5rMN
         tJBHSKq6q6q8hna01uPZt16qAZBX9/ns80riejsRKuEERweI1Qh/bnRRiZ1kMpTeegd+
         UK2uDUJZnvf28vbdnHPE4TzO9wSEG0FcQClYLy/RJdh+E3NW9eL2dzOAMszV4whZt5Hj
         ZNa10jVlpct8rH52uGdrkPQHmUUwA954jFYNqY/pWZ0TrhdEQsnHZvtpSBj0vbSc6XBC
         SlRA==
X-Forwarded-Encrypted: i=1; AKwUvBwLJV/wOdU7Bt3PdmBlV6Q7wNgKTv2wKvbxEWK1qhz/T1ZbcT1DF0c7KA6B3oWosVhh7YR3trl1/Jc=@vger.kernel.org
X-Gm-Message-State: AFq9FYKWzG/4jeiFFZ+59Cp5se39pxGz1W3TYusp/gcDYz8Lg+EYaspM
	HfzAXgz50mPoEuVLUczVtlQ3d4b3Z+wAV0iOiRHtkj4kTYiK1iyXq2rRwy7SC0873ao=
X-Gm-Gg: AYBFou31WmPN0U/U7YTig0yFhZfsGGMmnlrFa9ozDfp4Te9r20Tu/LBPQ4MEXBbCCMW
	cPPOTtY5J01q7Dz0zEz2Qst8AsZ030NzYji6GFKM76qrrjxqsqunLd2v50Rcakv7SyST8pjJltj
	jmrO/WhHf11hihc/MG49b9rnExLVWaG1iG3fpyg55F9ZKHfYYrB/ep6Cty5AqufHIvcop3o3aok
	ddnP3ELOUSDkhQE+arJF8GsUadtQZKDwBJ4bdo8aEkiusmw8uVRtqzdwFGGGdhOKcfVvlxGb7XY
	0ODZn2nTrR3RDtFwSWrsXedY4HdbAbFKsuRPTh4ofjofi/zsny5mxZ+cqZ8CgLeJw5TISEXLn5p
	ZuaMdbaQORerQQod9I2NMDoqRxVmBGD8fFPlFDlczyEhu3jnGhL6Sp8yIZILwZtWlCTXqEINg+B
	DDTDA0cnNORS5PEizCWXcwls8q9QEUMGY4ftxkRTl7np9v1Ww4kp2G4Wf5TaCMXjYMfSFomTDlO
	5RfLYSO15paB4BEcKHHk9LWiwy5VkbuQGFxwXRE+1sLFzxhA0U5TcNkhb3cZ5vu+oNC3lYsMEPm
	l52R32aIUeA5YXmUbRUvRHAcXVMQILrb62WdLSS7E+MCSg==
X-Received: by 2002:a05:620a:1729:b0:93c:2726:77ec with SMTP id af79cd13be357-94408930698mr32136185a.5.1793135394896;
        Tue, 27 Oct 2026 14:09:54 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.253])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0787fe4sm1097066885a.27.2026.10.27.14.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:54 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:32 +0000
Subject: [PATCH 06/10] ovl: mark the overlay inode dirty on modification
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-b4-ovl-containerized-sync-v1-6-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=6734;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=IkGUnIO/d185CPUCJ4d/igDpeRoCY5CFDEBzS+HwtoU=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QOVK+4kd6b7Xr7kl9CkNEWeg+Stag9HORTgmo14n0P0eHvRSoG2YkVBQ2kqpUc+xVB+0z6G4wjg
 I8xii9QxxYQY=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

To sync only what was written through one overlay we have to know which
upper inodes that is.  Mark the overlay inode dirty whenever the upper
inode is changed through it, which puts it on the dirty list of the
overlay's own bdi.

This is about data and timestamps.  Other metadata is left to ->sync_fs()
of the upper filesystem, and nothing is marked unless that has
SB_I_OVL_USE_SYNC_FS.

Nearly every change already ends in ovl_copyattr(), to pick up the new
size and times, so do it there.  The one caller which hasn't changed
anything is ovl_inode_init(), give it __ovl_copyattr().  That leaves:

 - copy up, which writes to the upper inode before the overlay inode knows
   about it: ovl_inode_update()
 - copy up of the data of a metacopy inode, which has its upper inode
   already: ovl_copy_up_meta_inode_data()
 - a new atime: ovl_update_time()
 - a shared writable mapping, through which stores go straight to the upper
   inode: ovl_mmap().  The next patch keeps such an inode dirty for as long
   as the mapping can be written to.

The state of the upper inode isn't looked at.  Its dirty flags are cleared
when its writeback starts, so a syncfs() during that writeback would miss
the inode.

Nothing is marked on a volatile overlay, which never syncs.

An earlier version marked every overlay inode with an upper inode dirty,
for good.  That is simple, but the flusher then walks all of them every
time: 1.3 seconds for a million inodes, and with metacopy a container
which chowns its image has that many.

Based on work by Chengguang Xu.

Link: https://lore.kernel.org/r/20211122030038.1938875-1-cgxu519@mykernel.net
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/copy_up.c   |  2 ++
 fs/overlayfs/file.c      |  8 +++++++-
 fs/overlayfs/inode.c     |  4 +++-
 fs/overlayfs/overlayfs.h | 14 ++++++++++++++
 fs/overlayfs/util.c      | 14 +++++++++++++-
 5 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index e963701b4c87..12ad3ada5517 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -1122,6 +1122,8 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 	ovl_clear_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
 	ovl_clear_flag(OVL_VERIFIED_DIGEST, d_inode(c->dentry));
 	ovl_set_upperdata(d_inode(c->dentry));
+	/* The data is in the upper inode now, and nobody may ever write to it */
+	ovl_mark_inode_dirty(d_inode(c->dentry));
 out_free:
 	kfree(capability);
 out:
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 7433220d4ad6..cdc552c76878 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -473,7 +473,13 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 		.accessed = ovl_file_accessed,
 	};
 
-	return backing_file_mmap(of->realfile, vma, &ctx);
+	int err;
+
+	err = backing_file_mmap(of->realfile, vma, &ctx);
+	/* Stores through the mapping go straight to the upper inode */
+	if (!err && vma_is_shared_maywrite(vma))
+		ovl_mark_inode_dirty(file_inode(file));
+	return err;
 }
 
 static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 63906b3dafcb..9a4bf7c2502b 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -587,6 +587,7 @@ int ovl_update_time(struct inode *inode, enum fs_update_time type,
 			touch_atime(&upperpath);
 			inode_set_atime_to_ts(inode,
 					      inode_get_atime(d_inode(upperpath.dentry)));
+			ovl_mark_inode_dirty(inode);
 		}
 	}
 	return 0;
@@ -898,7 +899,8 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 	oi->lowerdata_redirect = oip->lowerdata_redirect;
 
 	realinode = ovl_inode_real(inode);
-	ovl_copyattr(inode);
+	/* Nothing was changed, the inode is only being looked up */
+	__ovl_copyattr(inode);
 	ovl_copyflags(realinode, inode);
 	ovl_map_ino(inode, ino, fsid);
 }
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 218f646b82b9..f5a17bc258b6 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -676,6 +676,19 @@ static inline bool ovl_tracks_dirty(struct ovl_fs *ofs)
 	       (ovl_upper_mnt(ofs)->mnt_sb->s_iflags & SB_I_OVL_USE_SYNC_FS);
 }
 
+/*
+ * The upper inode was changed through this overlay.  Put the overlay inode on
+ * the dirty list of the overlay, for syncfs and unmount to find.
+ *
+ * Do not look at the state of the upper inode here.  Its dirty flags are
+ * cleared when its writeback starts, not when it is done.
+ */
+static inline void ovl_mark_inode_dirty(struct inode *inode)
+{
+	if (ovl_tracks_dirty(OVL_FS(inode->i_sb)))
+		mark_inode_dirty(inode);
+}
+
 static inline bool ovl_should_sync_metadata(struct ovl_fs *ofs)
 {
 	return ofs->config.fsync_mode == OVL_FSYNC_STRICT;
@@ -873,6 +886,7 @@ bool ovl_lookup_trap_inode(struct super_block *sb, struct dentry *dir);
 struct inode *ovl_get_trap_inode(struct super_block *sb, struct dentry *dir);
 struct inode *ovl_get_inode(struct super_block *sb,
 			    struct ovl_inode_params *oip);
+void __ovl_copyattr(struct inode *to);
 void ovl_copyattr(struct inode *to);
 
 /* vfs fileattr flags read from overlay.protattr xattr to ovl inode */
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 521717209b2e..e7402459548e 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -604,6 +604,8 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
 		inode->i_private = upperinode;
 		__insert_inode_hash(inode, (unsigned long) upperinode);
 	}
+	/* The copy up has written to the upper inode */
+	ovl_mark_inode_dirty(inode);
 }
 
 static void ovl_dir_version_inc(struct dentry *dentry, bool impurity)
@@ -1492,7 +1494,7 @@ int ovl_sync_status(struct ovl_fs *ofs)
  * map any lower or upper inode owned by id 1001 to id 1000. These mapping
  * helpers are nops when the relevant layer isn't idmapped.
  */
-void ovl_copyattr(struct inode *inode)
+void __ovl_copyattr(struct inode *inode)
 {
 	struct path realpath;
 	struct inode *realinode;
@@ -1516,3 +1518,13 @@ void ovl_copyattr(struct inode *inode)
 	i_size_write(inode, i_size_read(realinode));
 	spin_unlock(&inode->i_lock);
 }
+
+/*
+ * The attributes are copied because the real inode was changed through the
+ * overlay, so this is also where the overlay inode becomes dirty.
+ */
+void ovl_copyattr(struct inode *inode)
+{
+	__ovl_copyattr(inode);
+	ovl_mark_inode_dirty(inode);
+}

-- 
2.55.0

