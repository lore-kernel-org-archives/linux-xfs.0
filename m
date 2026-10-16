Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD4E1EB1AA
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179285; cv=none; b=rLadjtrdTdZ0TznXKL0IezqYNzAL2tHV584ycs77Ng2t7iOwyGpCN2ZEsMIc5VewrKI49ztUVtNZvF3pAQ/IF0bG3uLw+fwlRbt99J4WgTGSVfB4J/aO9/e8s8vvUCzqCAlCPqzchrC/OsWGJ+DAjGEUYsdMTDQd6Vl4N9nIiVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179285; c=relaxed/simple;
	bh=JD4Hfken5JJrzmPnRHTdA5n6xHA/4Jjb6toeCnwl9ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPGm4WkHc8/vO/6LN29QcD/h+oMGoinT7iOUaNN2P4pxyxSjPhLf6rUIw52JrUzy9TZ3j40dk9ABk56KjAZK+dYnZSliWYaQC0bZp9ZhdBpcZiPMhf2L31WuI0+kc+T6iimumGxoE+/SsjiCv+1lhUwU52XpRGQEbVur4PBlRyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SvBS8Ddv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=N4G90g9q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SvBS8Ddv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="N4G90g9q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792179281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hOpNm+yIyD9ownCnQ7E4FdiVFLCqMPnFM/CfhE4iG6E=;
	b=SvBS8Ddv6Yz1FGtbpaWf/fynv/ePrv5M8h/UQqN/DLbp6CQn2SJZytShykzWBawmfQGO8a
	ELECrBTh8uZ/RgQW5c9CyYOKm+aFbQVVOLhVIUXtOw+fGIaPDFB7BRte083a6Cls1sRVwC
	5J+hl29AkW6wVME2/lECX6D53aXSvjg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463--By0NZkFNFibwaUwgPR8zA-1; Fri, 16 Oct 2026 19:34:38 +0000
X-MC-Unique: -By0NZkFNFibwaUwgPR8zA-1
X-Mimecast-MFC-AGG-ID: -By0NZkFNFibwaUwgPR8zA_1792179278
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93ae8e7e546so64267485a.1
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 12:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792179278; x=1792784078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hOpNm+yIyD9ownCnQ7E4FdiVFLCqMPnFM/CfhE4iG6E=;
        b=N4G90g9q52PhWOllChEbbfijkccNx8aOFjYJKqMV+aPv02vJDepTLkSH8zzJvx852l
         PajIu8Y+agrwMtxTNaV/c9PfffK3BNZfkhpqDtAHXiSjiJ5dfRdevoJwrvdQG5ei7xxq
         Vwudd8o9dYB2d4U9BtiqxWrImAe59oTuRtEUntb8mjllRX2fYxE1vx1BvjjGJgFctRtV
         VRei6m1JeBSgUnKvOdFUG31BMqWg7BBNqIuVwFUhTQPq5lgZrPEYVtZJ4PWXtq0Cz33g
         RC1pU9fiAV53PzkpORAlkgrWaqIA1jFRn12K1lQx9lyKkuRBUAZwWtlNMV4UsOnhjXzM
         SppA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792179278; x=1792784078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hOpNm+yIyD9ownCnQ7E4FdiVFLCqMPnFM/CfhE4iG6E=;
        b=nNI/JWiuWpYus57Uo1If8rbiK/xOeByTcHqbSWBMtLykYlWtH6C+1t+/JKMsaBAiMm
         W35BkjuB623ziCEPwYYEexXyollcg1GttSHZGJ59GXoFeoQczcMowVKNFaReTdtHTmq2
         amAVpNIF/Q4dm6Xo5lcs4IVfutz9fbmaIjUVco3jJ5boLINLC4X1ODxIhfVsL8QGXsp0
         KsUVvkNnBIEuvee9I/PqfI/1DhOEM2mR8QTDB+95r5vB4JYBaH2++h3OWuKnDYmGOjpl
         0IC5iRi/ql2ha5GSa+SqgWnPwEYy4EVh6S0IAoLSkUe1YvTtMwwGGWZY9euozDCNIQlb
         xJLw==
X-Gm-Message-State: AFq9FYJr0VJoBA3x1gjxA4MS+hc8gYT7Wfet8e0WIMBvmXJAMw/uTQ2u
	8Bt9nZKG64iK/iRpQQU1phwTPb0A+/cR85l8RIxQhWYNaf4ro9Hdm1JmFHCt7oTycdo676VYQsG
	pll3EVdEPuyxG49027i2bts6oxQfyrA8iruwHIIL5ylL4soLODDAtLrK4eoLoNqWL7GmEbIPBu7
	clWNHLKUWdqk6/72nOBpBJLw4bjo4/0qtXHbX4P7TPEUFs
X-Gm-Gg: AYBFou3NmH0Ddmw7XrIYq/DVW6MsFByfmZJNNtoTpUH3QiYisQZpvsveY8SAnQLD2qw
	hhTYDmVTWTpXivyFNGO4jGm6uLAwvdHdWiYKMVNKNpQLOkBaeZukkV5ACpcSHv3N0D+w3HGnwOY
	2lPZXLcy6dP1RQYvgi9NIh4pyC29+llLugJxV+yK3YtzTrOgmc2jRW6FLNGylsOZIQTiQD8BD35
	NgtqegPCENdF9WbP8r7gsMuHxMv45BopGhFAgHfvOB7Zc12w5ijzRoM/CrasEttMVbkLwV0vNji
	K8GbXutylqmTohk/Wtwe/pVp6SUuEdKSj+x3s/bnO3cXyM7u8yb75QNPj57NGbX2at1I6hphB2G
	DuyvMs5RNGHLBAwuZtSij6uIT6OM2fsaKE4wsBg==
X-Received: by 2002:a05:620a:439b:b0:93f:d27:c89e with SMTP id af79cd13be357-93f29dd63b5mr142871185a.75.1792179277902;
        Fri, 16 Oct 2026 12:34:37 -0700 (PDT)
X-Received: by 2002:a05:620a:439b:b0:93f:d27:c89e with SMTP id af79cd13be357-93f29dd63b5mr142864185a.75.1792179277218;
        Fri, 16 Oct 2026 12:34:37 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a990fsm284359185a.35.2026.10.16.12.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 12:34:36 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@lst.de,
	dgc@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 7/8] xfs: remove redundant stat checks after xfs_refcount_delete()
Date: Fri, 16 Oct 2026 14:29:07 -0500
Message-ID: <20261016193422.1630907-8-sandeen@redhat.com>
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

xfs_refcount_delete() simply returns the error and status from
xfs_btree_delete, which now validates the delete or returns an error.

This makes every instance of the 2nd test in this idiom:

	error = xfs_refcount_delete(cur, &found_rec);
	if (error)
		goto out_error;
	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
		xfs_btree_mark_sick(cur);
		error = -EFSCORRUPTED;
		goto out_error;
	}

unnecessary/unreachable code. Remove them.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index bf7526621681..924f839b35a0 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -500,21 +500,11 @@ xfs_refcount_merge_center_extents(
 	error = xfs_refcount_delete(cur, &found_rec);
 	if (error)
 		goto out_error;
-	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
-		xfs_btree_mark_sick(cur);
-		error = -EFSCORRUPTED;
-		goto out_error;
-	}
 
 	if (center->rc_refcount > 1) {
 		error = xfs_refcount_delete(cur, &found_rec);
 		if (error)
 			goto out_error;
-		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto out_error;
-		}
 	}
 
 	/* Enlarge the left extent. */
@@ -574,11 +564,6 @@ xfs_refcount_merge_left_extent(
 		error = xfs_refcount_delete(cur, &found_rec);
 		if (error)
 			goto out_error;
-		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto out_error;
-		}
 	}
 
 	/* Enlarge the left extent. */
@@ -641,11 +626,6 @@ xfs_refcount_merge_right_extent(
 		error = xfs_refcount_delete(cur, &found_rec);
 		if (error)
 			goto out_error;
-		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto out_error;
-		}
 	}
 
 	/* Enlarge the right extent. */
@@ -1232,11 +1212,6 @@ xfs_refcount_adjust_extents(
 			error = xfs_refcount_delete(cur, &found_rec);
 			if (error)
 				goto out_error;
-			if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
-				xfs_btree_mark_sick(cur);
-				error = -EFSCORRUPTED;
-				goto out_error;
-			}
 			goto advloop;
 		} else {
 			error = xrefc_free_extent(cur, &ext);
@@ -1847,11 +1822,6 @@ xfs_refcount_adjust_cow_extents(
 		error = xfs_refcount_delete(cur, &found_rec);
 		if (error)
 			goto out_error;
-		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto out_error;
-		}
 		break;
 	default:
 		ASSERT(0);
-- 
2.55.0

