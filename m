Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA432D77FF
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 07:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759996799; cv=none; b=foFWcnYscFXBkoWwMeHKZKc+T3c8IKF6k+jpP/ffcvbQx9+aI1tK+I93z04v7X+6Lz27/yx+DIGFiiUeZJ6uFNslkKHdWWRN864k/kgRyordDUTRX8XVIK/galbkihZuP8vY7iyYCxsPFcPJg7W4HV5Qp5NLLgQTH9keAMJKDfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759996799; c=relaxed/simple;
	bh=CjghRbVJnrrRxsFC/uqUg1E0WT10jkJULO+lABGoVkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiPuW2DCkfM/IKwFNgZXsd+snXO2gFNuc9bxI073pyjTkzwHzoPy9LG8ndXfucs3sm8SoJyDqrp1yC6XSQ7Wgsl/BmBB7QfcT/GhDzLx9E+a9uUSlXZjOl5vI6XcP1ZeuaM8NTJjh+DPeglqEh145tdFpgtRLzlMLORQY+crAJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XagQkyNV; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XagQkyNV"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6394938e0ecso999932a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 00:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759996793; x=1760601593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8qUy8w4oQhAgPl6fOZI4wnlmjsFcl6OG6QfU8CrT8Pk=;
        b=XagQkyNVxo10BmQPyZD+yu//5tUJ2oRbuqYr1gAYVHfL+oBGf2DHyKr5NUSSOpszo9
         XNVfIA7L2ILl3KlexyL25l2DusOVsoonl03HpxhblrhT/dSehwjKS4WCbhIuWCkU1sZz
         +yql5aQB76ryOHiSeI12l1yC8ghJFwdrGCCcfYtPTy91qDr3ksDgSx19jQIBI6I0Qrmb
         6jVvsF6aacudvR7O4N7kmfCLBUsV2jdX+n+evXIeoLGKN1p241aiIXIjDZp/h2cyiiuQ
         uWHjDw9pGWbQjxRdbbUchADmgaYabJOE075a81KPgOTaVMvpTKKn1pw+dy1b0nkFz57T
         rHOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759996793; x=1760601593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8qUy8w4oQhAgPl6fOZI4wnlmjsFcl6OG6QfU8CrT8Pk=;
        b=NbTTSuOadm2bYrkwGdBZocnRecMnt0ayPRv5PeVRZDW6h3nMAP9bh75cph/moCli3/
         itF4SYT+jaW1w+w4pyLe8gjXgPvpBgsNu43BUXZc/qiDe3tNoXmBIo0KohqOmHzZ13yh
         qS71trv00Tbrsj5r7h3gAIoy0HCkVSEI7AXNyuzoajSBn9s0KVIULF6mllhonde+Von0
         57UGtwTFvZq+azMRH3uqPGpadOrcwoSAnFV9QptAv0pzfq5qJyFZW0GwbqCcdC+Oa+HN
         d14ipUkOyc/x++1ntgQvBJ+w1ssuyY3vI6C1LcSPux4Cus2ff8tKccRwVTPuOeLseZ4v
         chLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIx274cxrA7aAcFaZQwXEIXy0HVa65/OQoKigAIrBJaNgGMGbqbfEShz3vXC3kGPr397aQFvug71U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0dxdCrdk+MIpOGIPl+jdPfU1VBlBIGXyT/IxMZe/wQh3cDeJx
	1HcyPldpHfw3B09ce5mX+owu07d97WYVnwWyvgrnSZRONy19l8YDrpGI
X-Gm-Gg: ASbGncs9YCu8XJEg1AeLBAWXBSlys0GEE0zKA+goKYUgFs1sWwJ8s6KdOJbs6gNWCGc
	n+PCJR8Ne2+D8RHNliK3Jm3Stlb/vlJPJmCW8QacGqhc/3uETejeNc0eifWzGFyYHtcj9ByeBap
	SYPHm7+ji3CaEkguYwUUeBi083VoiYzxESQ9NhUwObbahN4wojn7wi0AcmUmT3GCxAtmT3xcM52
	pxF0KKV6DzetFCn67H7T5afGFGeNjbl45Hl/cPFJnBGUeXtH2ox3Sl8KanS9ASy93FL0A2ER8q5
	6kYZBDHMl3Vq/1FNm/fv+mag6s42+9xbET5Vz//0Tct1czF7gURw160kb397qvSArr7vHfCpSQq
	hMbJEnAK+WkUmlzQikFyYwghYOOv+uDnWbQAVgBhZvmByVio9zu7BoNT3QYbo6UXRCtFl0B7QRg
	FIXzJXoWyF1o/BrZL0dSnbpw==
X-Google-Smtp-Source: AGHT+IGbrd08TTcAFiqwbpW9BDTUl/1zMbIp8ia/BbOIaKggRHixcVaV3Fgadc1Z9T3iA/deAE80rw==
X-Received: by 2002:a17:907:9702:b0:b3c:6093:679b with SMTP id a640c23a62f3a-b50ac2d58b3mr707002766b.36.1759996793003;
        Thu, 09 Oct 2025 00:59:53 -0700 (PDT)
Received: from f.. (cst-prg-66-155.cust.vodafone.cz. [46.135.66.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5007639379sm553509366b.48.2025.10.09.00.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 00:59:52 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v7 08/14] smb: use the new ->i_state accessors
Date: Thu,  9 Oct 2025 09:59:22 +0200
Message-ID: <20251009075929.1203950-9-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009075929.1203950-1-mjguzik@gmail.com>
References: <20251009075929.1203950-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change generated with coccinelle and fixed up by hand as appropriate.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---

cheat sheet:

If ->i_lock is held, then:

state = inode->i_state          => state = inode_state_read(inode)
inode->i_state |= (I_A | I_B)   => inode_state_set(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_clear(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_assign(inode, I_A | I_B)

If ->i_lock is not held or only held conditionally:

state = inode->i_state          => state = inode_state_read_once(inode)
inode->i_state |= (I_A | I_B)   => inode_state_set_raw(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_clear_raw(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_assign_raw(inode, I_A | I_B)

 fs/smb/client/cifsfs.c |  2 +-
 fs/smb/client/inode.c  | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 1775c2b7528f..103289451bd7 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -484,7 +484,7 @@ cifs_evict_inode(struct inode *inode)
 {
 	netfs_wait_for_outstanding_io(inode);
 	truncate_inode_pages_final(&inode->i_data);
-	if (inode->i_state & I_PINNING_NETFS_WB)
+	if (inode_state_read_once(inode) & I_PINNING_NETFS_WB)
 		cifs_fscache_unuse_inode_cookie(inode, true);
 	cifs_fscache_release_inode_cookie(inode);
 	clear_inode(inode);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 8bb544be401e..32d9054a77fc 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -101,7 +101,7 @@ cifs_revalidate_cache(struct inode *inode, struct cifs_fattr *fattr)
 	cifs_dbg(FYI, "%s: revalidating inode %llu\n",
 		 __func__, cifs_i->uniqueid);
 
-	if (inode->i_state & I_NEW) {
+	if (inode_state_read_once(inode) & I_NEW) {
 		cifs_dbg(FYI, "%s: inode %llu is new\n",
 			 __func__, cifs_i->uniqueid);
 		return;
@@ -146,7 +146,7 @@ cifs_nlink_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 	 */
 	if (fattr->cf_flags & CIFS_FATTR_UNKNOWN_NLINK) {
 		/* only provide fake values on a new inode */
-		if (inode->i_state & I_NEW) {
+		if (inode_state_read_once(inode) & I_NEW) {
 			if (fattr->cf_cifsattrs & ATTR_DIRECTORY)
 				set_nlink(inode, 2);
 			else
@@ -167,12 +167,12 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 
-	if (!(inode->i_state & I_NEW) &&
+	if (!(inode_state_read_once(inode) & I_NEW) &&
 	    unlikely(inode_wrong_type(inode, fattr->cf_mode))) {
 		CIFS_I(inode)->time = 0; /* force reval */
 		return -ESTALE;
 	}
-	if (inode->i_state & I_NEW)
+	if (inode_state_read_once(inode) & I_NEW)
 		CIFS_I(inode)->netfs.zero_point = fattr->cf_eof;
 
 	cifs_revalidate_cache(inode, fattr);
@@ -194,7 +194,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 	inode->i_gid = fattr->cf_gid;
 
 	/* if dynperm is set, don't clobber existing mode */
-	if (inode->i_state & I_NEW ||
+	if (inode_state_read(inode) & I_NEW ||
 	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM))
 		inode->i_mode = fattr->cf_mode;
 
@@ -236,7 +236,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 
 	if (fattr->cf_flags & CIFS_FATTR_JUNCTION)
 		inode->i_flags |= S_AUTOMOUNT;
-	if (inode->i_state & I_NEW) {
+	if (inode_state_read_once(inode) & I_NEW) {
 		cifs_set_netfs_context(inode);
 		cifs_set_ops(inode);
 	}
@@ -1638,7 +1638,7 @@ cifs_iget(struct super_block *sb, struct cifs_fattr *fattr)
 		cifs_fattr_to_inode(inode, fattr, false);
 		if (sb->s_flags & SB_NOATIME)
 			inode->i_flags |= S_NOATIME | S_NOCMTIME;
-		if (inode->i_state & I_NEW) {
+		if (inode_state_read_once(inode) & I_NEW) {
 			inode->i_ino = hash;
 			cifs_fscache_get_inode_cookie(inode);
 			unlock_new_inode(inode);
-- 
2.34.1

