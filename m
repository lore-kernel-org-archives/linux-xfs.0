Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D501AB6E7
	for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 22:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727217714; cv=none; b=uzCxKC80zGGArt+KyLL836TkepcSoF3nBxR+in5yPrkPPqDnfTcgbP+olWzbnZLwFmDvfXenUS8P5S4bwkMc2ivUba6zbjzcjf1y3VwLfM5SUV+scNO4Ny29T4fUATHmap8J8qioxKhDwS6aIecNOZDL7yhfcZ74CzM6oHnRXXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727217714; c=relaxed/simple;
	bh=Rdr8TSS4Iwh4qeHM/cdtAjEt19818xzhxC0cUa9WajM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=klqCJe85N+dgqERjLX5T34pnyufD5tyhZw5mLz/jBxQQ88XDGr8LoLbltlz/H690gaTY/xdazvtfkjOW+fkRUNbbIxN++bQ1nccq54nS63njLSsF2bHg3XT33KvATwJ/dMeErCBITmkDkzmLst1omDUb7XlJ0yJDeur6tyopdYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=A2XnA0FG; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="A2XnA0FG"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7a99e8d5df1so607331685a.2
        for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 15:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1727217712; x=1727822512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/a9bPAvhWH1p+W4Rny/nJHlIlCLE5pbW2+6lAK0+Ac=;
        b=A2XnA0FGluxqnTk1jg9eAjMDDk8Czcq47vc6ET1Dr4OAokDAqyjLDX24KV22XKxlZQ
         mfkGlSCOUO9odQOAru7xTLyoRAsdRvUqDJ7lKfVPNJABqU757Rjgg4dD9TtbVtMP8tEq
         SGYeunoU0uo7nG0KUG7fvMG2D5t9f2dqWdCMc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727217712; x=1727822512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u/a9bPAvhWH1p+W4Rny/nJHlIlCLE5pbW2+6lAK0+Ac=;
        b=VvvxEnboMfT9aIPwVZY1ldjY0Dd7VZwpuCv32mQTPAUfPZh4UlhWRRaqB0fi3Dnf1/
         AZrZXEWLJKOTZM4CjTi6PSppSLHFKWjIKW7lcueWjFpUVscMtySpkuFQ6uxIaepx/tC5
         7ecGnEWf/gXZ14etXIe+JqdA1gCNLcn9UHEtbSFYXctCUI8AEy9SzfT6ebQGZQoBH8nP
         42B2X1fN/Eh+zmGABp9/AA4ymq+kmPQDQFK97QtHR4cheCKNug8OKz5Hic3RvnHEWZ7r
         Oey50kysWgzN02f47uDuM3a0OMZyPiEp9T9X3YUss5lnRdJ/M3kM8/8/VzdyyVreP4Gs
         SJFA==
X-Forwarded-Encrypted: i=1; AJvYcCVHHBf5hmvuMLCy6/ZuT7XvtYdZEYh8o+vCzanfMVFCUGpG6XvogzVAhbr6mH+22VU2kVq/mbch0gU=@vger.kernel.org
X-Gm-Message-State: AOJu0YycYPScdmisRsDpkGUd+f0GKsHPLd3D+Drgq/C+R9SxiCk/EqYZ
	NUr2r/BLeW3itVhqBod6DwtHuLBzw3e8Ip3Ip/BB1t/EynotmlNT+A2ySuRxOA==
X-Google-Smtp-Source: AGHT+IHtrHM9uSFNGuTueIdUjBDfNePVRPHZDWy5NLhLxjIwwHImFGO4nwimLqt9qoFoZHpVX/ayOQ==
X-Received: by 2002:a05:620a:190f:b0:7a9:aba6:d012 with SMTP id af79cd13be357-7ace73ff065mr116593685a.22.1727217711792;
        Tue, 24 Sep 2024 15:41:51 -0700 (PDT)
Received: from ubuntu-vm.dhcp.broadcom.net ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7acde53d6d3sm114843285a.42.2024.09.24.15.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 15:41:50 -0700 (PDT)
From: Kuntal Nayak <kuntal.nayak@broadcom.com>
To: leah.rumancik@gmail.com,
	jwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vasavi.sirnapalli@broadcom.com,
	lei lu <llfamsec@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Kuntal Nayak <kuntal.nayak@broadcom.com>
Subject: [PATCH v5.10] xfs: don't walk off the end of a directory data block
Date: Tue, 24 Sep 2024 15:39:58 -0700
Message-Id: <20240924223958.347475-3-kuntal.nayak@broadcom.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240924223958.347475-1-kuntal.nayak@broadcom.com>
References: <20240924223958.347475-1-kuntal.nayak@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: lei lu <llfamsec@gmail.com>

[ Upstream commit 0c7fcdb6d06cdf8b19b57c17605215b06afa864a ]

This adds sanity checks for xfs_dir2_data_unused and xfs_dir2_data_entry
to make sure don't stray beyond valid memory region. Before patching, the
loop simply checks that the start offset of the dup and dep is within the
range. So in a crafted image, if last entry is xfs_dir2_data_unused, we
can change dup->length to dup->length-1 and leave 1 byte of space. In the
next traversal, this space will be considered as dup or dep. We may
encounter an out of bound read when accessing the fixed members.

In the patch, we make sure that the remaining bytes large enough to hold
an unused entry before accessing xfs_dir2_data_unused and
xfs_dir2_data_unused is XFS_DIR2_DATA_ALIGN byte aligned. We also make
sure that the remaining bytes large enough to hold a dirent with a
single-byte name before accessing xfs_dir2_data_entry.

Signed-off-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Kuntal Nayak <kuntal.nayak@broadcom.com>
---
 fs/xfs/libxfs/xfs_dir2_data.c | 31 ++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_dir2_priv.h |  7 +++++++
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index e67fa086f..72e4c3678 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -177,6 +177,14 @@ __xfs_dir3_data_check(
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+		unsigned int	reclen;
+
+		/*
+		 * Are the remaining bytes large enough to hold an
+		 * unused entry?
+		 */
+		if (offset > end - xfs_dir2_data_unusedsize(1))
+			return __this_address;
 
 		/*
 		 * If it's unused, look for the space in the bestfree table.
@@ -186,9 +194,13 @@ __xfs_dir3_data_check(
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
 			xfs_failaddr_t	fa;
 
+			reclen = xfs_dir2_data_unusedsize(
+					be16_to_cpu(dup->length));
 			if (lastfree != 0)
 				return __this_address;
-			if (offset + be16_to_cpu(dup->length) > end)
+			if (be16_to_cpu(dup->length) != reclen)
+				return __this_address;
+			if (offset + reclen > end)
 				return __this_address;
 			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
 			    offset)
@@ -206,10 +218,18 @@ __xfs_dir3_data_check(
 				    be16_to_cpu(bf[2].length))
 					return __this_address;
 			}
-			offset += be16_to_cpu(dup->length);
+			offset += reclen;
 			lastfree = 1;
 			continue;
 		}
+
+		/*
+		 * This is not an unused entry. Are the remaining bytes
+		 * large enough for a dirent with a single-byte name?
+		 */
+		if (offset > end - xfs_dir2_data_entsize(mp, 1))
+			return __this_address;
+
 		/*
 		 * It's a real entry.  Validate the fields.
 		 * If this is a block directory then make sure it's
@@ -218,9 +238,10 @@ __xfs_dir3_data_check(
 		 */
 		if (dep->namelen == 0)
 			return __this_address;
-		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
+		reclen = xfs_dir2_data_entsize(mp, dep->namelen);
+		if (offset + reclen > end)
 			return __this_address;
-		if (offset + xfs_dir2_data_entsize(mp, dep->namelen) > end)
+		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
 			return __this_address;
 		if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp, dep)) != offset)
 			return __this_address;
@@ -244,7 +265,7 @@ __xfs_dir3_data_check(
 			if (i >= be32_to_cpu(btp->count))
 				return __this_address;
 		}
-		offset += xfs_dir2_data_entsize(mp, dep->namelen);
+		offset += reclen;
 	}
 	/*
 	 * Need to have seen all the entries and all the bestfree slots.
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 44c6a77cb..e46063cde 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -186,6 +186,13 @@ void xfs_dir2_sf_put_ftype(struct xfs_mount *mp,
 extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
 		       struct dir_context *ctx, size_t bufsize);
 
+static inline unsigned int
+xfs_dir2_data_unusedsize(
+	unsigned int	len)
+{
+	return round_up(len, XFS_DIR2_DATA_ALIGN);
+}
+
 static inline unsigned int
 xfs_dir2_data_entsize(
 	struct xfs_mount	*mp,
-- 
2.39.3

