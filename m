Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC80922A80D
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425023; cv=none; b=ZU+ANzH7SsocrFcNKAp2SHvC4oMPP2+LDYWIWNfflx/bSaHzbh45WlXEnQZbZIa5tufg1o4Y/3D3v/KR9qWKmkEy8r/HouGA/Uv6NdJrFAoJmfXraAWliXu7yxnl+TpNwAMWHaYi10HCQGT5Z4UFzoxlUmiDySXjNH/Jd9wZLUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425023; c=relaxed/simple;
	bh=D33mb6FaQocvqhteTZQGShc/l/XfqtOIyarg8zYssCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxXecr2BmakkAxyCsg7kgEW5bLJf9Puob6qNbk8pxzMn8rNmpe6fNMXteM86zN/8/nYk9uLWCMj5KHOqCs6ubLvscbgxFcc9kIJLO8nWl+9jqoBh5C5rpTiEJCh3ZYEkFgSUdf2keCNnuCMZXeUIyCC8vkHwJj88rRHBUCFC5+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QPvbHDNs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=D5E0Y6fh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QPvbHDNs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="D5E0Y6fh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789425019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n4zIHmWTKm6c5TPKEhzssEaBdK0A5jD/ioRqA7lhyE0=;
	b=QPvbHDNs+1apXI6FM8pCPz8v11dlrsAhihwKmGaAblfeaN1dFL4d+mLfxY0Oyfe0avwfCN
	iJfZTv1Jf70vpBIZKVz90Wn2wYSqwn+XzMjpsoN0yDCbwLzfHfINjaDGh7/z1A+TPGR37s
	Ni+GIrPkQ4/OtQTMmUYMxX+Fxtav/H8=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-2ClcX3r3Mo-LDWEwk3ghQg-1; Mon, 14 Sep 2026 18:30:17 -0400
X-MC-Unique: 2ClcX3r3Mo-LDWEwk3ghQg-1
X-Mimecast-MFC-AGG-ID: 2ClcX3r3Mo-LDWEwk3ghQg_1789425016
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-530f962fa9dso59718291cf.0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789425016; x=1790029816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n4zIHmWTKm6c5TPKEhzssEaBdK0A5jD/ioRqA7lhyE0=;
        b=D5E0Y6fh778t9We+/aoabCDMj9NWA7+eikOiU+o2V0IoMgqSHia/0dVPzCrSe7K3Tu
         pg+61vjpdoJ0jYTrqTKCK/EHX3FKayBhxD7//uVwEdGOv+ttiCFFQt5NE9zh5a9PJPnA
         qGWQb8GHbQB3ep6ful5wt18Zyx6YNdPbGXEyNbXbS59WFe66T9amDL4SZEcb0anPrGFz
         WdmaKbRsHmAezl2QafV5Af5cvS4ckFMnWGnKbVlQaduixHG+XMqxQ84YHpKk8lP3DBsc
         hnMPA3IGVIyMCzRK20jeI9QPC1DwcH43oXk868SF9O9soOjPUhNFdoZVHEYt9lf9/y21
         05DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425016; x=1790029816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n4zIHmWTKm6c5TPKEhzssEaBdK0A5jD/ioRqA7lhyE0=;
        b=NQtyAAD/la/XUeaBJB5HKUmk97Y600auzahbKgmZwulv1EGYlxmV0VeyyBuPguXWAF
         aqdoCAooI1EWErrGQN/+/+mMMX13Bn3c/5aH1bBPVwmsOJHT3GZ/K00/6TJrlnPKKd35
         CIqBn0vh3IpbDbPLEqO3G9fmsLDIMrlZbLpp/H8lDCP4R+lroblpRSCY8S/tfE0p8PlB
         T2ka14VNmcjM0PArMh7k9Iq1Eu1iQQ1G3+l3lzCGVLpjWRhRB1YABDZ8PsMOEzcls8WQ
         /sbTM73LM8u/JI6hkP70isA2sR7Xj4AegCFx4Rls1aW82GSXcCgKT5+1/3SiYQGbEh7G
         +xzw==
X-Gm-Message-State: AFuF++meBGEm78DQwYm1A8k3v/YGYuyK075dTEBMx33QfZOXhhdclnyp
	LH+8BTY3D8onaZR0Q4SXK8jVDRZSNnW8pxjimGsMQJ05KrP9j4SaYRXeE3YQWDOCEEXJ99hLPEX
	SEnRyDEKqZGlWWoIAYq32KvqUNqui0ZjQ6rgqVQZf+2ogf8zLSQ5UFxt7KcUIy7pWo/Xe/X4DN7
	vha6XcN7Z0ILL+ADMkVDipyN8Op0Ab98WuZPBXGWmoFqJRWNs=
X-Gm-Gg: AYBFou26iDRs/1HyKyN9liyC0HBg/GrdztfBrZ0f0YScsMGoFqNuf6rF1y31Il68hC9
	mngQG+YdvYMHh2/eSLCjJxTIgdN3t9ENOvkwqk43xoTOsNSzBLAMNT+F63l5IiMDACtjt4bn0QD
	GEJUXJ6qDK5XvfRUpDD5oDaRufpbEFmP1GmAvPufmiwPFOZUuAVQtlvxNgLAFOVqdTRF02cd9Vx
	3C3E6Tev0e1+8fPmSdh3+JF0n8RBqqrg1TBeA72FWNJCYINmgFzfVrYtcetbTGHlEDJ524G5CUF
	aus6Qg5hlSmw2bFfO6Lo3W5HV+60Q0/WJWUsHhAZrNheZSpn4C5x4NHOo0XflrKUogPvQ790XL+
	e0ruLEF416r5TKW2TVs2Ij34=
X-Received: by 2002:a05:622a:5d1:b0:530:f7aa:d424 with SMTP id d75a77b69052e-5310cf619d6mr68859351cf.20.1789425016131;
        Mon, 14 Sep 2026 15:30:16 -0700 (PDT)
X-Received: by 2002:a05:622a:5d1:b0:530:f7aa:d424 with SMTP id d75a77b69052e-5310cf619d6mr68858661cf.20.1789425015581;
        Mon, 14 Sep 2026 15:30:15 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530fa03dc30sm56084041cf.15.2026.09.14.15.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:30:14 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2 06/14] xfs: remove unused mp argument from xfs_parent_finish()
Date: Mon, 14 Sep 2026 17:28:52 -0500
Message-ID: <20260914223007.1587017-7-sandeen@redhat.com>
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

