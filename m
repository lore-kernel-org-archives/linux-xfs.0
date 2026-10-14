Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2364230F803
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 03:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791949870; cv=none; b=jpED7tWl+2VZnNNJH9zkssPTJyv4lcVCJavhhq0Y7pRSxJf1+qh3k2CxZGygDvUmjFpGJXJ0a7BQY5aYJbCcAkzeJPJ26w3WDul8gvhkqrCQt3DoONacHRMy4YE/O+3mB7G2BQ1/dRizl1Vcltzx1lHw7r+IQ3AbMsuLyEE7Jpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791949870; c=relaxed/simple;
	bh=lbpZsQcZlLNr/bSL1DPP5UABSmeZHtfRCJPlwhKd1I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYJKn/rnn0vp+x5L8UIVFyeAyoeTYKmZxeVgKy51N8cnOo2YSnWJEb+CvRcvHNXP+wDfUqYrDYgggOnx8VbjaX7pAscIhDEqOKlQIpi8aiXy9npEuA5K3ViVg8Q5nsjLoy1JG+74UddfmLOgM33IpY9Mc5oJXomZ5u8WvG/A+4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UvdNP2ep; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OOwXf4/G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UvdNP2ep";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OOwXf4/G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791949868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SU+uTtz+TGuRLImguyvJXWLrIjxVyfW+xxu6/L/o/Yg=;
	b=UvdNP2eps8xMRw1yLygKTiwZl/oGJF38DiIlE8+oEEjE43VnTVWcFeyqkB1IawVxHRnyDZ
	2OvUJPXE+m3CbRmja8JPTs1IPoKW1TFG5eQ0omkzwytyjCO2xFbm0u7W29sUtFgCsOLowB
	k52hgk1q31IupD9eiGgPELiV/6CXyGI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-4jEYfbzANtSuYZ9jSJmptw-1; Wed, 14 Oct 2026 03:51:01 +0000
X-MC-Unique: 4jEYfbzANtSuYZ9jSJmptw-1
X-Mimecast-MFC-AGG-ID: 4jEYfbzANtSuYZ9jSJmptw_1791949861
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93a3f673221so1129395785a.0
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 20:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791949860; x=1792554660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SU+uTtz+TGuRLImguyvJXWLrIjxVyfW+xxu6/L/o/Yg=;
        b=OOwXf4/G0lrM9LroTMmjihqy6UQVS2VKf4fErI51E/loM2lk4+KRBMkGhAaUuNiZOY
         X88hFHA/UhSuYoIntRhmCo7kCw5yh7QqMVPW1FtptGaHe18/uNo6IDRLiWjfQFb/rnXX
         4wlYVAgrY87RkkChgl8jWuW/PEASwdt/pGa3mcTVgfnHr4eUjrp+cG2m/cmbvUcG9oLS
         b4WKjz5YWh03p1TOKCkYtqDmnTkfyGvevGAhsylNqRkWW+V28AHizdBOyy1oH5/0FVpb
         XUXiY91Ks1YtoRlRJHON4X/2Y+EaZ/FBQoh3oXpQq67uaakVpuOD9HsIsP0Xp4CYjcGh
         5law==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791949860; x=1792554660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SU+uTtz+TGuRLImguyvJXWLrIjxVyfW+xxu6/L/o/Yg=;
        b=U33Wp1uqJBDW3kror2UV3pgunQEVxNkV6ogdHrdKC9iaHibTi5sqHmJMIiU1ZgDRgd
         wAopp5CBY+CuQVKHjvwmZUECVaHjgQ42KoPN4Agk1t0GMUB1Ky7hrOaQoIhwGD/jX93l
         HvdCqRDFl5JFZPKSE8yvxLvI2u1l6RuZnPfPxlh/6gUTZ5CsYnZCzoqMR/drJllJqNFp
         jFDxX1VQr2gBZztVIuwDlLb8yIus5zSawz9sFckixMuHFJjxiqv3cmAATeVdSVXgU2kA
         RdtLI2I1ibuzSSRsiav/lQDWZWRk8z14bF/Ba1LKaXBqLTvr7W+l/F1MFXBSBh67tpio
         D/9g==
X-Gm-Message-State: AFq9FYLUuJdX/EOelisd9JDjVhqr+GEJDJcIFrje29Zk0kg76x4BLXW0
	6fuPJC5f8+5ThvfM8Mt+dj21olhpU23ys1QAuSwITNX8liCRsdHVWb/dR8cdlNPKSlrLdvCdgla
	cFuHx6pCl8dlCSSaYn12imaPNmlXHysLxWRzbNf/7flWc9qQ3PPf3iZ3SJeV7k2BpdiRNzuLZEd
	5eLLFOytOoHjcXXTv++tk70lw5m6zUuoaTea9Lbxhg5vfq
X-Gm-Gg: AYBFou1EACbsRjnm+IXjjzfHVcUPJSzc0P8CfoY/0YOSx042k2xCJ++Qm9Y4djfUW3S
	kODKIn2aeXj4yrTQgi6UEl0H0XSXPf2DcNcwV7p4gjR6p85R3yF7tdNqTXiZcg+mY52++wolh4T
	WeqInLtv1oTn/SKe0FN1XfZ8FESnWI4E6hu2fOOEvBiPo8p5AhGUR2OjDdDqbZwQXcQ+e4wgNDu
	n8jKLBG6DlSq24xOsRP9716LksuV8/HybBRfWd04y4HD2BTotL6RR3bEVsobRaqhlQlWbr/d3Iy
	ILFDXocUonT0cQWg4Kcows+ulYPwR6U2oRcZ2rGIVM/beqDRZkoDXu7Xi4SIMN2Ah/FxQAXjOPG
	NMMT+XzWkqHp5jva294NQrpDiUp8o7J23CVlnHQ==
X-Received: by 2002:a05:620a:1d0b:b0:93e:646c:9133 with SMTP id af79cd13be357-93ebd4a1302mr2361314585a.64.1791949860621;
        Tue, 13 Oct 2026 20:51:00 -0700 (PDT)
X-Received: by 2002:a05:620a:1d0b:b0:93e:646c:9133 with SMTP id af79cd13be357-93ebd4a1302mr2361311685a.64.1791949860162;
        Tue, 13 Oct 2026 20:51:00 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef50b6c4fsm393907285a.47.2026.10.13.20.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 20:50:59 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/5] xfs: remove redundant stat checks after xfs_refcount_insert()
Date: Tue, 13 Oct 2026 20:30:00 -0500
Message-ID: <20261014013505.759089-3-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014013505.759089-1-sandeen@redhat.com>
References: <20261014013505.759089-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_refcount_insert() simply returns the error and status from
xfs_btree_insert, which has already validated the insert or returned
an error.

This makes every instance of the 2nd test in this idiom:

	if ((error = xfs_refcount_insert(cnt_cur, &i)))
		return error;
	if (XFS_IS_CORRUPT(mp, i != 1)) {
		xfs_btree_mark_sick(cnt_cur);
		return -EFSCORRUPTED;
	}

duplicate/unreachable code. Remove them.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 49e9993ce360..aec6c839220a 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -457,12 +457,8 @@ xfs_refcount_split_extent(
 	error = xfs_refcount_insert(cur, &tmp, &found_rec);
 	if (error)
 		goto out_error;
-	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
-		xfs_btree_mark_sick(cur);
-		error = -EFSCORRUPTED;
-		goto out_error;
-	}
-	return error;
+
+	return 0;
 
 out_error:
 	trace_xfs_refcount_split_extent_error(cur, error, _RET_IP_);
@@ -1191,12 +1187,6 @@ xfs_refcount_adjust_extents(
 						&found_tmp);
 				if (error)
 					goto out_error;
-				if (XFS_IS_CORRUPT(cur->bc_mp,
-						   found_tmp != 1)) {
-					xfs_btree_mark_sick(cur);
-					error = -EFSCORRUPTED;
-					goto out_error;
-				}
 			} else {
 				error = xrefc_free_extent(cur, &tmp);
 				if (error)
@@ -1841,11 +1831,6 @@ xfs_refcount_adjust_cow_extents(
 				&found_tmp);
 		if (error)
 			goto out_error;
-		if (XFS_IS_CORRUPT(cur->bc_mp, found_tmp != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto out_error;
-		}
 		break;
 	case XFS_REFCOUNT_ADJUST_COW_FREE:
 		/* Removing a CoW reservation, there should be one extent. */
-- 
2.55.0

