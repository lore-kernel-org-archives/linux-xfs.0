Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398E23EB11C
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419160; cv=none; b=rPi7uKs4uhr4uOlYWv2oUL9LvQbLQHVp2nIrdIhjdM7L2ltpvejkHpEAuH0pSrW3VLIw/oz6ufBBPkOfniDDSjRR12kyvJiRn9dqgUaikBO+LBnnQHTDPzKYrwKtbPqlq03/X/S/Ql7B0wSXxMeushuEx78sdRlCp49aoXDzUYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419160; c=relaxed/simple;
	bh=TuGKg26UtP/JJl0Z9gbPMelVg2xrm0g5o0bta1zFk+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jP8ou+JGURc0U3H0FhoMXijbSNLr1hBb5j6a1azd1Gub1pKEKasoojoeSITu7Liy8nKd1wUAsA9X5exX5lZKMiTGIAUqah8Sg3OUFBBWRG+TUUQ3zd3SZi53v4yKeAE96RDYjF7JVRZCjT87qWiJz1MzEDqXeoDH9BKU2GkExQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=emnXgBby; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bMm3B1r1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="emnXgBby";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bMm3B1r1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789419158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jVjgGcybRKFF7qqM4DYEjnlfnf6mR8WUlWjyF8AmnFg=;
	b=emnXgBbyZJ2QX2EHYFkQnckFslFkH3/NX86tmYLnYhlB0gbFK264npBg0W29SCbnXh/k3l
	Q2ZPsoXBCVGqCw3/iOKlk8z8Yd9QkZD5V5rADVpQQ3RiKmt4UKWhPqkJvj4OZPeIlvL/xS
	Wdj7rgCEpojJRIZMWj2GOpLS3zRY5Y4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-nEyMMfo7Ot-sXPUrUMFyLQ-1; Mon, 14 Sep 2026 16:52:37 -0400
X-MC-Unique: nEyMMfo7Ot-sXPUrUMFyLQ-1
X-Mimecast-MFC-AGG-ID: nEyMMfo7Ot-sXPUrUMFyLQ_1789419156
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-934956beec8so696410885a.0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789419156; x=1790023956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jVjgGcybRKFF7qqM4DYEjnlfnf6mR8WUlWjyF8AmnFg=;
        b=bMm3B1r15hfgb+7tXuLdq7oNfOIf8wMzMXgO5nLNMgfrN7BmTH7QlAvNI9JyGUvYwi
         JqRvuZ17UNfKGo2UPec+7KYbOzG81gJtxhBof/+0br79SZQqh8tEub1UH2pg0rNhIkcA
         cF2lz6slyigPCTFGvCy8IP1bQkyq5+qHU5cZaDbWXWmlRUb2AD7tEAKi0S4MBwq/GTOy
         +XB6OqzecETO4d2YnaU+erqZQzS0ReTohMRY2xMsQBPC5r7VbKtgufteEpI4mRBElDge
         g5+lP3n8jAmWyZ0apj9QLkkPGfe294sNbf9KB1asDAY/ZUsps5JwMPWkjjX/QlkXU6PC
         vATQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419156; x=1790023956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jVjgGcybRKFF7qqM4DYEjnlfnf6mR8WUlWjyF8AmnFg=;
        b=HQ+zZd+dP8ArUdT3bEeKrSIMkZTIYdzFbw0EvRIM9eb0Iu6AL/e4U0z3EuPEt4E0/8
         quSEtSelk2OX0x0KEK70YyFhFdWqA3vMlP7e7D04FRS/edAKsN2KcObZa9rDN186DERk
         fkVtPUle0UgAWIq/kbEN8TBnnU3kaOXKk9crm1+k9mnnk0gkbJnl3sZjaRCL3Pze4jx5
         ZzqhStwcwte43rhb77BQwqn6QCM5vopuj9uVqKKoqqwpMoD+vpyNFyJ64eh6twin3lyR
         AKYhl7gSkcsHnvWoiGSqdxZinAS5bfxd+pAE/H5RthgoB95bief3ugY2MChv5keaa0O5
         ykgw==
X-Gm-Message-State: AFuF++nKzsipXZnR5cxpLKvFTts67TUcOXWiV6ncf7dk4O/U2QhT/D7L
	FhVtef+q34By4hf9oew0HtbMCMVFDNpQ32WBKOTgAQjRLuTa6l4pAOSAwRrkne2Erw5PuyeaN5n
	9pCzBb5mLEWQaaaChMb/2AkGbnZxgW3MzbkxqhwKnVZOZjTqpD1uqNKQ3+iT55Q5ecLGDvYfq60
	jISKFA7/qxXEMSsp4+T6HxWRzmbWRaZKfOli/LJVRserexJzE=
X-Gm-Gg: AYBFou0fVyGCKawe/vM/ihvRj+WpSFLUODj7IP+WyYhS9ZJhvMmFAw0KRnxSYMncsla
	11bsVN8nP5KxDGQ8O2inv09c2X2h+++63v8ReDfInWZhxCh1yGQKWtUTB9LIaWeG1+5XI2IdwG5
	fkgGmXUId0JQDmlHnkwDdfb27MNQwIBrx7DvQ5WtaaQSyZ4k219NFILybpS+8PYkP0jlQrkdXyH
	4EwFUrV/pC0IA3oXWCheXXtrHHn3q7qlQqnaXjdCb4z215fQGly9L+qBmyrZ01UXqSWLt8xhz4L
	a/uClfkH8pXtAAD3rc+t9Cuhg5j6qE6KbpwIL4XTi3iVTP3kgs+k1tlJc9rNDO9aAuYfcY9zzkj
	eHnNMXwM/YP0e5Dt4VflcjNG4rgtPNedyB+dQNg==
X-Received: by 2002:a05:620a:8081:b0:932:ddff:123d with SMTP id af79cd13be357-93a29945ca8mr634244585a.29.1789419156242;
        Mon, 14 Sep 2026 13:52:36 -0700 (PDT)
X-Received: by 2002:a05:620a:8081:b0:932:ddff:123d with SMTP id af79cd13be357-93a29945ca8mr634238185a.29.1789419155634;
        Mon, 14 Sep 2026 13:52:35 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f1da12sm1099236785a.9.2026.09.14.13.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:52:35 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 13/14] xfs: remove unused mp argument from xfs_verify_fileoff()
Date: Mon, 14 Sep 2026 15:46:18 -0500
Message-ID: <20260914205221.1516254-14-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914205221.1516254-1-sandeen@redhat.com>
References: <20260914205221.1516254-1-sandeen@redhat.com>
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
index 487bd4f68ebb..9a163c1c6240 100644
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

