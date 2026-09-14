Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EFC37187E
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425030; cv=none; b=oktN/LL910BEWIS3i3CZLnQ1j6jFx8rhRRngbAi17orDE/J8qcOYRLir8bUrPC1SOfpinv80apBwQHi/u7guBO28Uts7eSHaBvzC519bao1hBzWmO9ROLzknjEUW0Mb/rSRs9RfmM6LsVIZ7aO53a5qD8fDId/TSsvsq0Q2iySQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425030; c=relaxed/simple;
	bh=m7TLGBmV671OLagG+MTvGZPJz59AmHxDDGwIvbSKiNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaHvxbBHuDby3CoOhiCXgHFRDSo6YS9iFOynMEH1X4wIw2/faL70OzENcoAbDoWFeJsIhWxTnphM+Bx5TR44eDBe5qes95wEp0Ozyt10QKlYIcHyLscszYs4KyBrq1MzUDyHhMllrDKB1+bERTSRbMf9HdfVBNmhI3hkKGY1NJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BsZnD+My; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TmiABH5j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BsZnD+My";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TmiABH5j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789425027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wQ41Ui+KrY/JTWi6MvSZzgPeexByJ5Nkwu/BiQnGhSc=;
	b=BsZnD+MyIVNCdzBVrBsC2oXSzb1ChqJWu3APTemFPEtTuTWOhrVH3o0gynWYFWn9KD/Wq3
	WkyeSoImRIKi7sHtK4u7v4KQ3j7gP+oOKB1uBtV4fhcDxDzp5zM9nEXVZJmTBut82dwUcn
	AMkc57oy7AqslY5VkGVhbip3/lg4vTc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-m-CoIIZAMDS4BeR__xKYdw-1; Mon, 14 Sep 2026 18:30:24 -0400
X-MC-Unique: m-CoIIZAMDS4BeR__xKYdw-1
X-Mimecast-MFC-AGG-ID: m-CoIIZAMDS4BeR__xKYdw_1789425024
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52fc16ac179so6373491cf.0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789425024; x=1790029824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wQ41Ui+KrY/JTWi6MvSZzgPeexByJ5Nkwu/BiQnGhSc=;
        b=TmiABH5jK3UZGTVpQMerm8yPUIRAI5O3qKkOH1RY3MGhXmoMonpaNw5WCcV/HcKE0+
         MKPmmyPV0/wKPvLm7rYlonUaMf7h7uKSObMQF6I6xu/Q2H8QU+yUClMGmIsW+DsvgG0k
         bMGUWy0aQT4rwbM/VHLKhspAVageh+wUX4AxICjQh7HiWkwm4/05w0lNu5HJlwTOY67p
         ANBDRWQVS8EOYpYxJ66WVmldo//4M7ZQcAk/DIwLVV80f/mGk4BKkgQheQpsTUm0iVWI
         TjxiDsLI0l9Nohe6CeMmcnEGKd95DvLzTEWwdy790/7nWOUIyul1AXk0WxKEYA3+GOma
         hLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425024; x=1790029824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wQ41Ui+KrY/JTWi6MvSZzgPeexByJ5Nkwu/BiQnGhSc=;
        b=et2peOCYKRpLYuvHxVY6XtFo/zisiAKGvmIA+pt1i/oKxXRT4JR6JzSW4D6mVBhZPJ
         jTj7IUtRvkXdpA3VLNKmLSPZPZ1wOG55oLDbD6/FNRxF/HL/DYMn/dYJqAk0cz87fEkr
         ofOvmZZ8ZDxmBdHXOh6tQhXiavDrrurBcZKzwlwP8MDTow5Vju9Y+AM6eZo+nMA2KvFh
         GGBRQts7llplvQlirNv/bWE9VxBIiZQHe9/e1o1piMFHJHkdgRRTzK3WCDtpWHjoMCSI
         lecIT9aybDDRlJXFZpDNIALYcmSt+2axByni3xT5Pdrjq8LB95nZwokM+XyFoS1CwOn+
         PNEQ==
X-Gm-Message-State: AFuF++lXOIWDaZcRBi+Bv8wsv/nIdXXl9hizTeRbSPzIN+N45aEBrsJ3
	xF+GdhxvFVpHELm3Jm+hLPa1kTBONenzUU/o9wp/xTX1Bdvb7MhTOgbzFWZ4vlD9U6xPOlzF6aE
	ve502D13VFXORrZPLMmSteDXS7+9VhjB1CBvwjMu8j2NiYyovfRq07gPXevFPBUPUflob9oW1aJ
	rzHX3a3j7wLSzOzSeh4Me0QE8086joQuztzTo2rvdR9abjSqc=
X-Gm-Gg: AYBFou0Js+1qQHj/9t67z+HYgsKDImNqWBQrz+LDY0wkNyezyPS5pG2rT+cptlbXH/u
	5puuyotpV5dq/tSTCpQA/psg2IGIeSc1PclVvh+G/2Njj51eBKHodNwD53AkXk9JLWUUosENk6r
	Kwmw7fWkLAmskSnN4vFMgWn32BfQVunldCnzpZhw+bYjqMf/3mtsvwuImDZREIB2Td7I8nWR95i
	gWmeCTwmjZchad98N8ejBo0+dOYCaTyuH32kx654glvGXy60DHWlRs+At9LE3vFf4bj3ucIUfxN
	nXorUwi6Jz1whanYW43qCKSIYR7155Q3QcUCcOz8nErVWuAIqpWBJX6firf3wywFIHRsrZjYXgJ
	2beuAwtS1fdl7h42+VXBgvTTr0vGbXsFrehklGw==
X-Received: by 2002:a05:622a:aa8e:20b0:531:10c:a525 with SMTP id d75a77b69052e-5311994f696mr14290221cf.0.1789425023831;
        Mon, 14 Sep 2026 15:30:23 -0700 (PDT)
X-Received: by 2002:a05:622a:aa8e:20b0:531:10c:a525 with SMTP id d75a77b69052e-5311994f696mr14289781cf.0.1789425023180;
        Mon, 14 Sep 2026 15:30:23 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530fa03dc30sm56084041cf.15.2026.09.14.15.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:30:22 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2 13/14] xfs: remove unused mp argument from xfs_verify_fileoff()
Date: Mon, 14 Sep 2026 17:28:59 -0500
Message-ID: <20260914223007.1587017-14-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914223007.1587017-1-sandeen@redhat.com>
References: <20260914223007.1587017-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_types.c   | 5 ++---
 fs/xfs/libxfs/xfs_types.h   | 2 +-
 fs/xfs/scrub/inode_repair.c | 2 +-
 fs/xfs/scrub/quota.c        | 2 +-
 fs/xfs/scrub/quota_repair.c | 4 ++--
 fs/xfs/xfs_inode.c          | 2 +-
 fs/xfs/xfs_super.c          | 2 +-
 7 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index b5b0b6334d11..32e6c0aaf467 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -232,7 +232,6 @@ xfs_verify_dablk(
 /* Check that a file block offset does not exceed the maximum. */
 bool
 xfs_verify_fileoff(
-	struct xfs_mount	*mp,
 	xfs_fileoff_t		off)
 {
 	return off <= XFS_MAX_FILEOFF;
@@ -248,8 +247,8 @@ xfs_verify_fileext(
 	if (off + len <= off)
 		return false;
 
-	if (!xfs_verify_fileoff(mp, off))
+	if (!xfs_verify_fileoff(off))
 		return false;
 
-	return xfs_verify_fileoff(mp, off + len - 1);
+	return xfs_verify_fileoff(off + len - 1);
 }
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index d217220d2054..adae81149680 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -280,7 +280,7 @@ bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
 bool xfs_verify_dablk(xfs_fileoff_t off);
 void xfs_icount_range(struct xfs_mount *mp, unsigned long long *min,
 		unsigned long long *max);
-bool xfs_verify_fileoff(struct xfs_mount *mp, xfs_fileoff_t off);
+bool xfs_verify_fileoff(xfs_fileoff_t off);
 bool xfs_verify_fileext(struct xfs_mount *mp, xfs_fileoff_t off,
 		xfs_fileoff_t len);
 
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index cdfde3cea5fb..e12525838e6c 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -933,7 +933,7 @@ xrep_dinode_bad_bmbt_fork(
 
 		fkp = xfs_bmdr_key_addr(dfp, i);
 		fileoff = be64_to_cpu(fkp->br_startoff);
-		if (!xfs_verify_fileoff(sc->mp, fileoff))
+		if (!xfs_verify_fileoff(fileoff))
 			return true;
 
 		fpp = xfs_bmdr_ptr_addr(dfp, i, dmxr);
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 222812fe202c..8c6ba1240fd5 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -89,7 +89,7 @@ xchk_quota_item_bmap(
 	int			nmaps = 1;
 	int			error;
 
-	if (!xfs_verify_fileoff(mp, offset)) {
+	if (!xfs_verify_fileoff(offset)) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 		return 0;
 	}
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 59302e8afc7e..9ab373c1994c 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -116,8 +116,8 @@ xrep_quota_item_bmap(
 	int			error;
 
 	/* The computed file offset should always be valid. */
-	if (!xfs_verify_fileoff(mp, offset)) {
-		ASSERT(xfs_verify_fileoff(mp, offset));
+	if (!xfs_verify_fileoff(offset)) {
+		ASSERT(xfs_verify_fileoff(offset));
 		return -EFSCORRUPTED;
 	}
 	dq->q_fileoffset = offset;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 64643fb8b591..842627af4061 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1064,7 +1064,7 @@ xfs_itruncate_extents_flags(
 	 * the page cache can't scale that far.
 	 */
 	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
-	if (!xfs_verify_fileoff(mp, first_unmap_block)) {
+	if (!xfs_verify_fileoff(first_unmap_block)) {
 		WARN_ON_ONCE(first_unmap_block > XFS_MAX_FILEOFF);
 		return 0;
 	}
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b24db75eaedc..2edc2a497883 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1889,7 +1889,7 @@ xfs_fs_fill_super(
 	 * Avoid integer overflow by comparing the maximum bmbt offset to the
 	 * maximum pagecache offset in units of fs blocks.
 	 */
-	if (!xfs_verify_fileoff(mp, XFS_B_TO_FSBT(mp, MAX_LFS_FILESIZE))) {
+	if (!xfs_verify_fileoff(XFS_B_TO_FSBT(mp, MAX_LFS_FILESIZE))) {
 		xfs_warn(mp,
 "MAX_LFS_FILESIZE block offset (%llu) exceeds extent map maximum (%llu)!",
 			 XFS_B_TO_FSBT(mp, MAX_LFS_FILESIZE),
-- 
2.55.0

