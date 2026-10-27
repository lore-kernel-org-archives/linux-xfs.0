Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135398;
	b=ut2GkfQD/t5PFzVfId/TM0BqCmm46NxtYn5gzKPthn5RD266eccVGV+Tq7bTaFPcfojH
	 OZjzsJg5s0gl54YPJpkvGk5oe8PcRfxwT+y8XYBb2X//JKVug9p7wGcj5/YjYD6iecLBI
	 OPeUCfdOdVi9D+0d112eyFKqrWTYcm2pS0UpQfAVRQfWdE8JyUlbmVG2NyCTRW0Dan7ah
	 H/DWYmTMaX0MBuv8sO/1c7NdAWqsnFde43p0Rov7yWmjbHwdy5RJ9Jm68jgN5GJWjIR/B
	 w6yktdI+hjS1ET+Lox/X18OmGJ8gwafVoPb6XMD1YpwOKdxE1HyyCwNdBuxskjIWOPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135398;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=Ck/ful92N6NXzDNP60KvQsR2JiXRucsXYdV/7/B7+xM=;
	b=AZwNlhNFH6cJy2a0ryROlA7D3XoQASvev6/5ofC2JvLol23YO49qoxDCNxmZ1aIV6P4r
	 WVqy1glnVMd8DF+EY8HL9PYeWeBPxSgMH4pOUm2fpqgZeZ5smtlbW6lNkvCsh/vuJO7rt
	 K3U8H8Bml9Q0KxLEe/TFPD3pyDY2B1jvCMXvpDej32kWNNWT2GtFaDa5IN/u+YmyovNFb
	 nDue4BCiZbchOnmJyLEcrqhsM1vanNT7/kfBWPNeJ6gUXD26FLB+bycwmsyMyq9AFsvQk
	 MPK6apHayCCRcd7o6m73ecW4SNYmac+aZ3oMIzl/2Zcp+r+YYK2mNqYp0xy7xcxZnNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=cZlRNmIR;
	arc=none smtp.remote-ip=209.85.160.171
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E1060A381B
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5E1060A381B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=cZlRNmIR
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5365b48238dso3571061cf.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135397; x=1793740197; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ck/ful92N6NXzDNP60KvQsR2JiXRucsXYdV/7/B7+xM=;
        b=cZlRNmIR6NxiLuSTk5H7t58NmoHxtt8buwWzXHDQYgXzaYZBtGWYF8BILLNiN/vitj
         /Ay8gEMGGZF6pPT2aogmsL7+z4PKstycGKkTnuGcrE0QimQ0AMJpggcLcKxYCnYxnuw+
         BxBGaleMVQgyAYjeUtXZ5m4kAzoGneBFExCLdLMNph842KUix7YhAfqG1ct7aeU1DwMh
         CwFY9FOoeTpRD9iYQqX7c+upezqtLqr0Ui5ht8qe3sGeB1ob4izFucUduE2QF2DaDp94
         2qZQqDUamnv0uaY/sqsTcm9CxRP6HeQWIkO4FZTI8TEsbgPmIMpVQR6cMXb4unK0U+OI
         Hi8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135397; x=1793740197;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ck/ful92N6NXzDNP60KvQsR2JiXRucsXYdV/7/B7+xM=;
        b=J2Cl/rrIp9c+r9M2h2Y3Z2GpMEfmbUm4YQi0PlxSsBASIw39lI83CwO8GSKiY/fg5K
         MFikuMXrXGjd99TtyIpB16AxX5Vs8Zi0eOxcYuGFjoeo43Ju1gQUq942WpqjDR6mfNEv
         kVT22iMSd1VI9GY45d2yPItl2jPyrrnTy+o/PGQcQ3xx+HRWyfzHc/kiPzBnOjEC6/t2
         wBhSmv35454YsDqFsME5EhuedxtAcIT1IVgfFqCZpyKsa7P9nvIcK17JCcjQvQHuTMNR
         qPaxXeEEPZ1KYnEuzHBhy690dxqZ1hMx6na21PKMjTE0NpBXngkrYAKKLy8vVFm5oPkc
         4krw==
X-Forwarded-Encrypted: i=1; AKwUvBw+r5054mPZTuhSErwtj919mEGCZYyLhobi2qZ5AML6e2ChSnG7B3elkParDsgHembkUKIimfbJecU=@vger.kernel.org
X-Gm-Message-State: AFq9FYLnoLJn01EUdSuNFx6S0gvFf7ZZYQHR7a29AkpuLgNzA5P2fNP1
	rND4k5SV80UhBtvKPn9T+KfeQdqe/Go+h93fDu3VDyWkbONvO025/8vmhS4hj+1PExQ=
X-Gm-Gg: AYBFou1i788idvFzmQTUOuUUDA874C1970IE0c1gbIj5goZPHnuHWCqIwEbAimJ4BYV
	y+NddY5znJk4ySfKKteAAcllOLFjTdGhk8mHnB2V7mSacXSXdTCiroPPxMD21UDvViDTco726vy
	YiBFN45B/JEoNSw/DewZTWQAmHy5+AyTIiiIhdUji51iKYWENaMKPBlH2NOdDWHMe7qKzmMG7PZ
	1sGfIrdNLv110ysEoBu92aE/cdKdZta5LrYhFFjGq7p/ZZNb0p5NsUPzY9TSKePjrvYaKrCth+9
	6Z8q70+S9tMY2K9+gz/4h9bFDpAw2VR4P18Z1PDEtPuwQqiicPvccxpA3zBtQjcYNRgZ6EHI9lg
	x62jyjF8aruiV0dlZi3DEAknVsUPpqxnACifz7KYhbSIeXSZXcZZZLejhwK06QUkpbOCRE9rfQD
	ASG6+eq9aLu7rgnUxriTtx1G8bPhIvdoQSo9MtXKyM2En/NztJ7KFAmDI1ONyKWAowaxKAAVS3I
	WcKdQWba0RNGigEUsr08fZhLcl8KNW/XAre98kjSFoULo8Qfk/K095oCtZ1+82jR2Q5Gieh
X-Received: by 2002:a05:622a:5917:b0:536:3950:5d7d with SMTP id d75a77b69052e-53fcb20d4a0mr9425991cf.16.1793135396673;
        Tue, 27 Oct 2026 14:09:56 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.254])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c0ffd4sm113733436d6.16.2026.10.27.14.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:56 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:33 +0000
Subject: [PATCH 07/10] ovl: implement overlayfs' own ->write_inode
 operation
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
Message-Id: <20261027-b4-ovl-containerized-sync-v1-7-802e512379a6@toxicpanda.com>
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
 linux-kernel@vger.kernel.org, Chengguang Xu <charliecgxu@tencent.com>, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=3603;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=TzW1SCvICZ369myzzdV8AX2bLJ7uerYZSh8+JshacQA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QB+NR25IEkE2f0VZhWtwP5u6sLCjWEHN7x6AAsproO/3gSZZmPXZynAwUIROur1wPkzEoIAqopA
 LpfqCsruvyQg=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Chengguang Xu <charliecgxu@tencent.com>

Sync dirty data and meta of upper inode in overlayfs' ->write_inode().

The overlay inode stays dirty for as long as there may be more to do:
while the upper inode is open for writing, because stores through a shared
mapping go unnoticed and the mapping holds the file open, and while the
upper inode has pages which are dirty or under writeback, because a pass
which doesn't wait has only started them.  So by the time the overlay
inode is clean, the data which was written through it is on disk, and a
syncfs() which only looks at the dirty ones misses nothing.

Signed-off-by: Chengguang Xu <charliecgxu@tencent.com>
[josef: redirty only while the upper inode is unfinished instead of always,
 no check for volatile, nothing is marked dirty there]
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/super.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d21e7cbb70c2..0aec7059e9da 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -15,6 +15,8 @@
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/exportfs.h>
+#include <linux/pagemap.h>
+#include <linux/writeback.h>
 #include <linux/file.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
@@ -313,12 +315,62 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return err;
 }
 
+/*
+ * Could there be anything left to write or to wait for on @upper?
+ *
+ * Whoever has it open for writing may have it mapped, and stores through a
+ * mapping go unnoticed.  The mapping holds the file open.
+ *
+ * Writeback which was only started, by us or by the flusher of the upper
+ * filesystem, shows in the page cache tags until it is done.  The dirty flags
+ * of the inode do not, they are cleared at the start.
+ *
+ * Metadata is not looked at.  The upper filesystem logs it, see
+ * ovl_tracks_dirty(), and ovl_sync_fs() has the log committed.
+ *
+ * Nothing orders these reads.  The one order which matters is to not see
+ * i_writecount at zero and miss the tag of a page which was dirtied through
+ * the mapping.  The tag is set when the mapping goes away at the latest, the
+ * count drops when the file is released after that, with the locks of
+ * unmapping and of the final fput in between.
+ */
+static bool ovl_upper_unfinished(struct inode *upper)
+{
+	struct address_space *mapping = upper->i_mapping;
+
+	return inode_is_open_for_write(upper) ||
+	       mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) ||
+	       mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
+	       (inode_state_read_once(upper) & I_SYNC);
+}
+
+static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	struct inode *upper = ovl_inode_upper(inode);
+	int ret;
+
+	if (!upper)
+		return 0;
+
+	/*
+	 * Go through writeback_single_inode(), I_SYNC is what serializes us
+	 * with the writeback of the upper filesystem.
+	 */
+	ret = write_inode_now(upper, wbc->sync_mode == WB_SYNC_ALL);
+
+	if (ovl_upper_unfinished(upper))
+		ovl_mark_inode_dirty(inode);
+
+	return ret;
+}
+
 static const struct super_operations ovl_super_operations = {
 	.alloc_inode	= ovl_alloc_inode,
 	.free_inode	= ovl_free_inode,
 	.destroy_inode	= ovl_destroy_inode,
 	.drop_inode	= inode_just_drop,
 	.put_super	= ovl_put_super,
+	.write_inode	= ovl_write_inode,
 	.sync_fs	= ovl_sync_fs,
 	.statfs		= ovl_statfs,
 	.show_options	= ovl_show_options,

-- 
2.55.0

