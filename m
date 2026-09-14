Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28E322A80D
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425018; cv=none; b=Ky0fbL7dwNvXhji4HOR9ufPyyIEiL5LPPdosjus5y/HeMiTi9AJGoxSbizs6V0wNXNXyxwNB11BLkc+0cqUzp63arYKwB8kHAOq8XnihyXFcEcx2AxYnoWtpVJvChOe9eKEB7Y1sfIabgY+GKxnVbLztyOrkUqgh46b/UP98BhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425018; c=relaxed/simple;
	bh=SYAQAOhttOGnhtexWwb5jeSIyUKBYRkNeHtFCaxkVm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PghzBA8f2Ys6Y8n/DqPH5sCc4oZgqjHhAXgBVGgjI/TwraeyKrf6GQYi2WkDIwVHqXcAcJWyrbMeKP/R6hg+UP/7AbUYmOGOhl1nHUCwbrgeG1gS1jsxlZtqT6fWp08RD6u1bwtOQ/6/gSTiemooVVnuq02eN7KUIlnKpNMGNNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q4ZiuyH4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xer51Cc+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q4ZiuyH4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xer51Cc+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789425015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xx6Sxu5/l+5vNgsCoXuwQFKU3pRXBIQK9Rv07dPlb/4=;
	b=Q4ZiuyH4CpccjG+76t8QoDcvW4M7h+AdPCQYLw/g4/iIkc8ATDItA5kRvTWiQC0QXCfgbq
	ye7T2WNXqQ0r7eCdCI4ZAuNRANE6Q2QcX0N27Db19Gl4RV1484arQbjhlUTWZLlFhbMqxN
	QNd2M/krhZbjozFqhm0y6owqgy4tkXg=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-nvKxpEHmNr2VOchl2d5T6g-1; Mon, 14 Sep 2026 18:30:14 -0400
X-MC-Unique: nvKxpEHmNr2VOchl2d5T6g-1
X-Mimecast-MFC-AGG-ID: nvKxpEHmNr2VOchl2d5T6g_1789425014
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-53018848232so44498801cf.0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789425014; x=1790029814; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xx6Sxu5/l+5vNgsCoXuwQFKU3pRXBIQK9Rv07dPlb/4=;
        b=Xer51Cc+nMs3zHpW+h10/K87sHGPrIkroXfcEtudhXeuGy1Ny+jrVGDVEeHBzWFF0n
         xFEhwCGbwHxp4uC6I3hTbftjUsQce+opp+mlCOMrdvmWTB+Fcjk/YJvOVBOo7wFZkHfs
         F0XY0lMXcg/sUJmr79e503AhZizQgINRidnBnPBT/odZiG8B8WwDgLU0nnp6bgtBqIMa
         3TGaN1QdfFFWnqQg2WHeteow/KTZiuHbHyP8IKMaqNQB4kiHIxvL+9kiBGgkNJ1HZtPv
         w5+HIScLZAFHjzvqoX3OpbnV/fv1Iepiw+rcso3GHY7KotNY30VbJrDBz3oGrdAKiO7j
         VV+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425014; x=1790029814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xx6Sxu5/l+5vNgsCoXuwQFKU3pRXBIQK9Rv07dPlb/4=;
        b=KejQTOu3hMWFskkxUDJmSPll5xKY3iTl9buPqRwhLnkm15dKc/3anB+NdepR842s7Q
         iWCf12noOuJWHco/hMamnS3zbkDsIiApc9a+Xcm6BPlumZDjnIujFmfqdE1EGC5tRzQb
         vRPuCuRcpzNROlTjovlt2tcqafeENcT2f4N8CdmXkMJpgN2xkxMGiOzZUxwYPbZBIjPr
         N9KfmA08vAmB99eLF8XesWQF0I28mRwKCvL7FVjRjpweQAjr0tuELRBMK6z3VxvGSF9+
         w39KAnWXwQy6r1uB7Bc6zdfJ9GEoJnM3eNtE3mZ4AnRPxj20ymaO7NGWb3aestw/catY
         TnLw==
X-Gm-Message-State: AFuF++ljiBVds/V8uEOJ1Y5vLhN/Wy1HPaAfGd+1u7FJC2PZeE05Uquu
	59XmmaImVa4/W1x4Jngnk4yqh4uXeKqLNJT/DNSTjCGHdcKSlNqy6FbR4EXHXpNWRvRPBUIRSF2
	FJ8sJ3wl3XBGr3nWIyiWfntfROdZYmOlG09PyCYxzAku5iDxum9F3SWb5Xe0zwe9P/2zAclTZP4
	O3HphGedFPOJGdDP7DMuRmkzW/t2DC4EednsMnfZgVy/cwsDg=
X-Gm-Gg: AYBFou18KFB5S9ZjF0jKbdtfwaBPmbzdXxgLKL8saecq14P3XX+HJgRw+YqQlg4KbG2
	+Q0OfkvZhSa6xG1wjcTpYmREfcEwenfpY/L/0VEeZYppOqhM2V62qrMbAexft/KyGNQv5kSNq6u
	YLe5U0eUXEZShSnAQINBRf5DmzDW7Y9JnSgf5yWUBvVW1X+69z5kJEgiPGrJkSNWIchYnsUFogT
	2XGo2Y9BpmfG4C73P9OigHdg4f0oyvqY/1Oh6wBe6Rj+Q26A8oO1FsgyBQ2IFrS7HxZxHMil/Ha
	4euZGFt2XlCM+K6PZSUlxDh7BGnEyBVDYz9nH00bFeiVK451MgMEvfSE6r61tDD4xm85vKldc01
	IFYZoHrc8P1GoccHmhU7WQon8a/A/d3dx1E/lfA==
X-Received: by 2002:a05:622a:120e:b0:530:6f9f:d4b9 with SMTP id d75a77b69052e-5310cf2f63bmr68140221cf.20.1789425013790;
        Mon, 14 Sep 2026 15:30:13 -0700 (PDT)
X-Received: by 2002:a05:622a:120e:b0:530:6f9f:d4b9 with SMTP id d75a77b69052e-5310cf2f63bmr68139201cf.20.1789425013143;
        Mon, 14 Sep 2026 15:30:13 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530fa03dc30sm56084041cf.15.2026.09.14.15.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:30:12 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2 04/14] xfs: remove unused mp argument from xfs_exchmaps_check_forks()
Date: Mon, 14 Sep 2026 17:28:50 -0500
Message-ID: <20260914223007.1587017-5-sandeen@redhat.com>
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
 fs/xfs/libxfs/xfs_exchmaps.c | 1 -
 fs/xfs/libxfs/xfs_exchmaps.h | 3 +--
 fs/xfs/xfs_exchrange.c       | 2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 49eda8d0994d..05c2ec5478df 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -135,7 +135,6 @@ xmi_has_postop_work(const struct xfs_exchmaps_intent *xmi)
 /* Check all mappings to make sure we can actually exchange them. */
 int
 xfs_exchmaps_check_forks(
-	struct xfs_mount		*mp,
 	const struct xfs_exchmaps_req	*req)
 {
 	struct xfs_ifork		*ifp1, *ifp2;
diff --git a/fs/xfs/libxfs/xfs_exchmaps.h b/fs/xfs/libxfs/xfs_exchmaps.h
index fa822dff202a..055b8dbabd5b 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.h
+++ b/fs/xfs/libxfs/xfs_exchmaps.h
@@ -115,8 +115,7 @@ void xfs_exchmaps_upgrade_extent_counts(struct xfs_trans *tp,
 int xfs_exchmaps_finish_one(struct xfs_trans *tp,
 		struct xfs_exchmaps_intent *xmi);
 
-int xfs_exchmaps_check_forks(struct xfs_mount *mp,
-		const struct xfs_exchmaps_req *req);
+int xfs_exchmaps_check_forks(const struct xfs_exchmaps_req *req);
 
 void xfs_exchange_mappings(struct xfs_trans *tp,
 		const struct xfs_exchmaps_req *req);
diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index c69ecd6a19de..2aa6a4687e67 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -238,7 +238,7 @@ xfs_exchrange_mappings(
 	trace_xfs_exchrange_before(ip2, 2);
 	trace_xfs_exchrange_before(ip1, 1);
 
-	error = xfs_exchmaps_check_forks(mp, &req);
+	error = xfs_exchmaps_check_forks(&req);
 	if (error)
 		goto out_trans_cancel;
 
-- 
2.55.0

