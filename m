Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BF83EB11C
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419153; cv=none; b=iu02W+uV/p+8BhgxRumoQ1OVoL710HzxexYBwR8QzMAPTHyscGAjORkX4OT92pKtvzEAN2eYC1Qx/TYP9gnQ+OYnTNyDQ2A4D+5NDQlWRRcyXNsK8BsUgJIn3Xdz9mLpK3JXX0JGp4Uj8FxFuOtwxyE/9Qe4u+8ly5snP/znVFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419153; c=relaxed/simple;
	bh=D33mb6FaQocvqhteTZQGShc/l/XfqtOIyarg8zYssCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uor5uFIa+h8VIDxhUNOH1jHcaeMMJq9QHohYyltB1gGpvds4CX9K4jpSYEnykNxxHCXR6jG3C+1+yEeCvQmv0VwA4Ok8fNMglsarLR9tfI7+3Xv93XEr1QMRhGFWm8jPlpUOPKXUfYV2cdrpV5xav3K60i0rsBR3TMZ/anPAou8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VW2oXQIU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fw80GpiV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VW2oXQIU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fw80GpiV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789419151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n4zIHmWTKm6c5TPKEhzssEaBdK0A5jD/ioRqA7lhyE0=;
	b=VW2oXQIUWh2H0RETUAgFW4GOVHkmEh3MAUcOs/YxKhVOBmscJFMRQawFu0b7dcEchNN12t
	riZ2ivpK7dsyYUxo086F9iSS//tq3WomPGXRxiXW30AaQWHGsSf96FT8xXOupQxd2YfnnV
	dO50TyifnJ4aKq+4Nhc3nSl27COW8Cg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-OHIuzLX2MHeb1UBxJrTmiA-1; Mon, 14 Sep 2026 16:52:30 -0400
X-MC-Unique: OHIuzLX2MHeb1UBxJrTmiA-1
X-Mimecast-MFC-AGG-ID: OHIuzLX2MHeb1UBxJrTmiA_1789419150
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93a0050a554so649545785a.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789419150; x=1790023950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n4zIHmWTKm6c5TPKEhzssEaBdK0A5jD/ioRqA7lhyE0=;
        b=Fw80GpiVcyLEEWQbbVIsu0r4GXmRFRIPPUxV9QH3gX4j18ygPFB9gWgdRCSxgvV9xj
         Au5jD/4fXiWuLbOZadYbvVyZvSe3A7q2ip3sHRM3CL5wIEiyqc9QxWiCRUs5Z35v0gaL
         6wzFTOHKG4hhuA3dK4v+ZDqOiWYPhex1WHZRPEqgBLyaU466grYuRMMGaS9V/0oRysON
         gxILwUt9Q+lOozBY1tHDnz427W5RIMtDr3Q1sscXesLpaXFJKrTWmFf8m7ywjxWTmGPI
         enak+oA/4OnryHHFicwPCgT8CRJPfABl0KanDLKTBiMTxqot0lfSmO61fXoFx9fY7vOl
         +Upw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419150; x=1790023950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n4zIHmWTKm6c5TPKEhzssEaBdK0A5jD/ioRqA7lhyE0=;
        b=pLFhXgvuMEm1gIvpcEGADfkdNeHBrIV9gLWpEeC7JMRiGCa00DxiN/JGqzaSTWLoTW
         Mgze0eDKK1Q2cCfZokjSR67DIVDH8x2wGe5HBkQue/j1AGKedm+zOATSrpL1YRX5+WHQ
         qE1RW/bCXEyfmYdc8OUj6GajrFiOEw1uBBxq+DTX6vt3fQ8ZhwLNH6Dq4wOzd9epk51i
         VWKCs8ixDpjxxfeL0/x3KyaPzbMeLLEV2bs8jh0R6Q5qMHpXxXRLi0WTvYBIvqMhca4T
         Sux9GGxFhoTNE1SxBlwxNf2S/Z9YA0dRdAqA9AG73/Hz0TSBwlcM6QNRsXAk6qYPKkEh
         T1Eg==
X-Gm-Message-State: AFuF++m/MTGMEnCmA0H/K3F7UKr4D2oSXBNxTbVZM7/+9NiBNhAonZkN
	Dkvee7qcuQGHhQvir0ubhJDLfa+cAuccFk7sljKa94Rj38vK2k6PheSZOnXTUdlqN+Z9jgoVuMN
	rC+ynZX78xCbGDaehIm5AKekmEMbPNSLlWbRGqoeGgvXi71CIFALLaFLegrgb7tQU9fxuXTjxSi
	pv7oudB5E/8FEp2AQv4qHPxpyrDuE30lR/OEgKNrJUgA1mU/k=
X-Gm-Gg: AYBFou3WykB5/d5MGxIEfX2qo2kQxDwFfedV9oNFDPEANmVbvQjubv5i8BWc4dmZmE9
	IDaak6G8T+hP7WKgKI82q9dNLhayJgwXE4Mb/U9l6mHBk/2V+8eU0ypgrP+fkT0Ds1F2DFGPtwM
	YSLEeM6vFrpNT5IMbVEZk5neIWg8MRQ5Uh0koky+QGGFRhMk80AkammXkx+ou7Xh2l0m/xM50uc
	DHeTQelIEMoA6wNM30Mzl0VzbgEF15SVnYEJJ8OY0dDY+tA4AA4TkM+ANaOZ3+31WNqsaHGmBNA
	xzb/tEEwjTUK4tsTKtfqWB4dftVQ42zsHEMR9sbVblw8I+FDoXN35wRvKpvbPNYPumk7t/6RRnr
	0/uNQX/9cpWZILGFAlZ/m05uhO4h0b3UVqVVNYw==
X-Received: by 2002:a05:620a:4492:b0:937:80a9:94b4 with SMTP id af79cd13be357-93a297cbe46mr628926685a.2.1789419149745;
        Mon, 14 Sep 2026 13:52:29 -0700 (PDT)
X-Received: by 2002:a05:620a:4492:b0:937:80a9:94b4 with SMTP id af79cd13be357-93a297cbe46mr628921185a.2.1789419149217;
        Mon, 14 Sep 2026 13:52:29 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f1da12sm1099236785a.9.2026.09.14.13.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:52:28 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 06/14] xfs: remove unused mp argument from xfs_parent_finish()
Date: Mon, 14 Sep 2026 15:46:11 -0500
Message-ID: <20260914205221.1516254-7-sandeen@redhat.com>
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
 fs/xfs/libxfs/xfs_metadir.c |  2 +-
 fs/xfs/libxfs/xfs_parent.h  |  1 -
 fs/xfs/xfs_inode.c          | 18 +++++++++---------
 fs/xfs/xfs_symlink.c        |  4 ++--
 4 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_metadir.c b/fs/xfs/libxfs/xfs_metadir.c
index 7c6b086b73db..cc45a8a5aed9 100644
--- a/fs/xfs/libxfs/xfs_metadir.c
+++ b/fs/xfs/libxfs/xfs_metadir.c
@@ -163,7 +163,7 @@ xfs_metadir_teardown(
 	trace_xfs_metadir_teardown(upd, error);
 
 	if (upd->ppargs) {
-		xfs_parent_finish(upd->dp->i_mount, upd->ppargs);
+		xfs_parent_finish(upd->ppargs);
 		upd->ppargs = NULL;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 8eb4de9c5f1a..1dd3968a78b1 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -72,7 +72,6 @@ xfs_parent_start(
 /* Finish a parent pointer update by freeing the context object. */
 static inline void
 xfs_parent_finish(
-	struct xfs_mount	*mp,
 	struct xfs_parent_args	*ppargs)
 {
 	if (ppargs)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 030a7c8f2c12..64643fb8b591 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -755,7 +755,7 @@ xfs_create(
 	*ipp = du.ip;
 	xfs_iunlock(du.ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	xfs_parent_finish(mp, du.ppargs);
+	xfs_parent_finish(du.ppargs);
 	return 0;
 
  out_trans_cancel:
@@ -772,7 +772,7 @@ xfs_create(
 		xfs_irele(du.ip);
 	}
  out_parent:
-	xfs_parent_finish(mp, du.ppargs);
+	xfs_parent_finish(du.ppargs);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
@@ -972,7 +972,7 @@ xfs_link(
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
-	xfs_parent_finish(mp, du.ppargs);
+	xfs_parent_finish(du.ppargs);
 	return error;
 
  error_return:
@@ -980,7 +980,7 @@ xfs_link(
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
  out_parent:
-	xfs_parent_finish(mp, du.ppargs);
+	xfs_parent_finish(du.ppargs);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
@@ -1985,7 +1985,7 @@ xfs_remove(
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	xfs_parent_finish(mp, du.ppargs);
+	xfs_parent_finish(du.ppargs);
 	return 0;
 
  out_trans_cancel:
@@ -1994,7 +1994,7 @@ xfs_remove(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
  out_parent:
-	xfs_parent_finish(mp, du.ppargs);
+	xfs_parent_finish(du.ppargs);
  std_return:
 	return error;
 }
@@ -2357,11 +2357,11 @@ xfs_rename(
 out_unlock:
 	xfs_iunlock_rename(inodes, num_inodes);
 out_tgt_ppargs:
-	xfs_parent_finish(mp, du_tgt.ppargs);
+	xfs_parent_finish(du_tgt.ppargs);
 out_wip_ppargs:
-	xfs_parent_finish(mp, du_wip.ppargs);
+	xfs_parent_finish(du_wip.ppargs);
 out_src_ppargs:
-	xfs_parent_finish(mp, du_src.ppargs);
+	xfs_parent_finish(du_src.ppargs);
 out_release_wip:
 	if (du_wip.ip)
 		xfs_irele(du_wip.ip);
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 5585ac7f4d16..cc13819df6f2 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -219,7 +219,7 @@ xfs_symlink(
 	*ipp = du.ip;
 	xfs_iunlock(du.ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	xfs_parent_finish(mp, du.ppargs);
+	xfs_parent_finish(du.ppargs);
 	return 0;
 
 out_trans_cancel:
@@ -236,7 +236,7 @@ xfs_symlink(
 		xfs_irele(du.ip);
 	}
 out_parent:
-	xfs_parent_finish(mp, du.ppargs);
+	xfs_parent_finish(du.ppargs);
 out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
-- 
2.55.0

