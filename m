Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4693CC9E4
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179281; cv=none; b=aD/jBSHt5lIQDT6SYSTcqIWufp3ph955YuWkO8/8mhXZcg6ElRvPwNu6wvC+UQPIlS+hrdK+2nVXbz8BkvGMb+JdugWP1I34yhGMGDpqF1KGPllacSINdMWut/ZBkTf6ffXC00W2YgwBSFubN+Lh8cYn0CdWpwMQ9PKeALXDeVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179281; c=relaxed/simple;
	bh=INQ4OTexVp2FwrUYaPYNyMXYYuVPCGjxyY1fxZM5JGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rx08YSQNjGV2YVJKIFL/tb1WFN2W1xFM1zYq81k+M23h045K4kHUyPNoNb5bQ+qOFXyrjo17lGKdfrzqDkBCVGICTaF9TFkCtf9UCWiIfxvgKCTnoHPOhKfUjqpIY3W9FWqTMeAfQgRIJ2pCNrDedrj4nPSB9G7FMJ0U4HRWLFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eEpkONcE; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TL0haXrZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eEpkONcE";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TL0haXrZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792179273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=usxsKZX2k/KhYN46rCztoi3qXeUrvVOgV1Hv0NNJ+CM=;
	b=eEpkONcEHpkZROZ5A1eJrjI0Qy4SmvdG0Kkr8PlX4TMdHiD7E/1Kgek7/IgAnwWJq+gcYo
	E/dujZG8WRJnHzaf1Z0MVYMJ2keZoKHFwSI05VvLUp9yqAc4QDldok3kZHqhZILNOliFyH
	tf8ZTWDALywabqcd9CX5VqZtrfvb0GI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-CkIfhECINcaQaMlrdu0X4g-1; Fri, 16 Oct 2026 19:34:32 +0000
X-MC-Unique: CkIfhECINcaQaMlrdu0X4g-1
X-Mimecast-MFC-AGG-ID: CkIfhECINcaQaMlrdu0X4g_1792179271
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93a3f673221so89871585a.0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 12:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792179271; x=1792784071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=usxsKZX2k/KhYN46rCztoi3qXeUrvVOgV1Hv0NNJ+CM=;
        b=TL0haXrZ1NrYzvEBg78XDStBotXODnuULS16Rq61Fhx8VaPttUA3tfFJHhcaoCiE0T
         jtmJFeh8RdjmfYKoI/g7qttUVg953wKoh7uqPZNgn/iOfBWBYXdk3tqjY1MCLcxIjkJG
         uhLspxayuuMawvkcHoiTWZIbhg0PdgSL58piJ5y7htwi5LblkP49dFVKPlg9NRvA2NCp
         grp3niFnsY6xcTxyq4zo4uWw1COUMs95YbPjZSP1m3VseA65fk/K7dNuz6K/xo3wR3qm
         xpDyEgd06i1dWZpgUKa1PYyOPnX5Ar3FaFYChdQdVsndS9djvw3MYu0NiI2+hAJwoiD0
         Qk1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792179271; x=1792784071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=usxsKZX2k/KhYN46rCztoi3qXeUrvVOgV1Hv0NNJ+CM=;
        b=hLkpqHzlSNCWOGi19w+AkdolsxAV0e4J2RxCWIgnZDu2MhbrUXEUdUWyOif2tX8R2E
         G5b7MQbZQj78w9F2FDCA58HVYEgzPX0eHQttdJ99foKPGTqxRAHmJ4S6QZDWmyxNwnKW
         RCMXzjZ9BZQmdxc9Gi2x9ypsHtH85QPIqdu8TZJ2TF1w9Evlk13EDuIv5Pj96jrtpr6a
         bEklHhFk2FWm1xsRO9k92YIt7whLlg7X35dcdaabnG3npiF9n7rO+4wsRafap3D+wPBq
         2xD1IhIAjPFbH9EJiBte9sd66m724M7XtSxsHz/ib5Agj1oN36TfM/VowJMjjjjVkpmH
         O3Cg==
X-Gm-Message-State: AFq9FYLfE+6kCpq8E78OPtZWabveNDWquHJrEMNMX31BXGN6sTc2xirw
	LNsOCdB0KyOCb7fguSBw07cCvD881NZtoKHzXrlBgep80lNuH62mMFNUi5JjQXcIEVLJRCfNlDN
	VHkDjQO8EUHMv4AORc2sGCReyAmXxqlAyrhC8I1B4jaQvfUICFkp0DA9Yn0fzMz2o6OVBhpNT5x
	Gh4v42fYiPJB8fonKDtR7a6BywXCdWsRIbf73WwR1Ttjqt
X-Gm-Gg: AYBFou2315T1go/tm9KPMt03AYHDtL+1Dy9vLY0IfxG9vOg+g/d6YNsW+rTc/khMCjB
	de3wOzHi98AMvDs4xtE6gIPl8D7mjZLktYNaSlZKl8QYEOCaZgHNqc1mB6TzxnRdyvSIVgycNwf
	6CRQjZZuBwhYsNXL9oOpEaP6Z0rYz1MoIgBKG6+U2Fj9Auyygy8WMi9c2BuueyvqU5dr7ni7IAo
	rBZ9a4Y0UXlolUk+2uDY02rHJiQvuKas0KnTKZWHCepkfmDHXjrwXvISNXHEqNSvlyRmASG74A3
	l+4okASvVZEcx9miOb5RQrx2stQtZWBPX7zSo+o8au3ft+XC6oBnk1VFm4eYeKPdfqyr/sD3xq+
	2iTCzOwqZJldYrQ8kK89vA7GqR+fsg8JRTIL1Nw==
X-Received: by 2002:a05:620a:2889:b0:93e:c12c:fbba with SMTP id af79cd13be357-93f29db9245mr162130085a.71.1792179271288;
        Fri, 16 Oct 2026 12:34:31 -0700 (PDT)
X-Received: by 2002:a05:620a:2889:b0:93e:c12c:fbba with SMTP id af79cd13be357-93f29db9245mr162122785a.71.1792179270628;
        Fri, 16 Oct 2026 12:34:30 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a990fsm284359185a.35.2026.10.16.12.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 12:34:30 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@lst.de,
	dgc@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/8] xfs: remove redundant stat checks after xfs_refcount_insert()
Date: Fri, 16 Oct 2026 14:29:02 -0500
Message-ID: <20261016193422.1630907-3-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261016193422.1630907-1-sandeen@redhat.com>
References: <20261016193422.1630907-1-sandeen@redhat.com>
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

unnecessary/unreachable code. Remove them.

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

