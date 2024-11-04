Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA64166310;
	Mon,  4 Nov 2024 01:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730684730; cv=none; b=bN5atV5gpb6/1Lam6BAttRmYILlIomv+dQaCky/elSKhT5QmcjnXBDmUTgp9CuPlRCCm90g2UuDOyudXwXbdiyIYMjZ2LwUYQu0TZOAJwHxXAZ77oo8Vze2tfRv+7Mz8gB0LFvACiXefnNQu02H0iCsuXONsgCqOqjGS5WN9XPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730684730; c=relaxed/simple;
	bh=v7M4rAfw0syNlkg6nlA1/MAlQXSJDeKSY6G4D/mkxRE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LO7XDZBnPMUCNHujbiggltLPNiAH/dnz3TDjmH+zeq4Elqz+IvktHc7fp+olrE6Ombdox+mSumP4vdEqjmf7Yt20sXvmpLMbgZJf9fH5yIz4Vivn9Lim03Db0aU0q5ihDX0segWM4nT9FiUjlUeSQe0oshPH1751A1EcPpV5Exs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hUK+RsC4; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hUK+RsC4"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-720d5ada03cso2339292b3a.1;
        Sun, 03 Nov 2024 17:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730684727; x=1731289527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+fYSOcf5BwbqG/V0bjEjjkcwk/JSzZFYqZyDOf0lnd4=;
        b=hUK+RsC4kMd7ISy30tkozr4L+yEnwrCsu2Ab1mqghLjAkQ5202w8ArJBWKSPtNtXW2
         16ojpIu7l9zHVBh7weqlSjyuKoudB9mvSQCuVO89mDVPAo/D+buPxb0snHY4x1JSdqKQ
         cWkSWjNaqxsPh0QyeDp18RiKJZPkV/PB0NUCEQVHnCRiFpAPUa+5UcqPEKFeGTo76xlT
         iizAgtZY6/zvbV6xKIOSeKmI4AFFTrvvcyPSeEwfI3luEV7EAoJSuxss9FLpldjAyFen
         5r+p5R7QCa3aIGy6czqowh+Wjn7YPgNpvCAUsJDZJai4ug5eKqlvkA2ruX97P4IaYuRz
         ZDYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730684727; x=1731289527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+fYSOcf5BwbqG/V0bjEjjkcwk/JSzZFYqZyDOf0lnd4=;
        b=kRap482dzNuMyxZx6Q0dMsmVBQKg/JH4yL3pPjJVzT1XPH+s2/LVvorsxI67KrF4iN
         mkkswamvOqA25YPAPW2GJWJXpgwG3rk4UQ+fyZw5LNW3pA9e/MbiUMGoUrcSJvWjanTi
         WvFTX5lICIVHfBWG3i3CBaJUoArgRbX5JuPqi0QH2JFQM9HO5+d43zsXi2pqWs5A4D6P
         SQY7R8pbNp54GOfTuQMC7MC5JxnFWGYnlqfrpoh6SMYf/Djejslh/BMm9mQe4930xyjG
         ZtxD46aAdzt4e573aEo7UAVdaFXHORjMcbqOEJCa0phzK0xhl1lDQGLK/pEH79g9EE90
         +k6w==
X-Forwarded-Encrypted: i=1; AJvYcCWcskjFFAYDlqVfFZz17W3xw/4w9FbBxiAXAQKZr2YPMn7SOwhLsFREqy6iXR9tD9XpsEnpjC3t5C5FDt8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmkhHEyb5W4HTTMqQTMBA3DCWhtqY7Rr1SGEZ+VrXpaw0bVBh9
	xYYRjxH5ZoGuFPK0XXzwptorgLCRmQBa5NsvFbdSAVYqO21P/sIo
X-Google-Smtp-Source: AGHT+IFqqG3AVIwR2dvdYVWcOll8SFyzb+cFp7t3eJHk6OOIVzIApobg17OnJsaXXd1cvm1AaGX/Sw==
X-Received: by 2002:a05:6a21:2d8b:b0:1d9:28f8:f27d with SMTP id adf61e73a8af0-1db91e533camr21757137637.38.1730684726824;
        Sun, 03 Nov 2024 17:45:26 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:105:216:3cff:fef7:9bc7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1eb3a7sm6360030b3a.81.2024.11.03.17.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 17:45:26 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: djwong@kernel.org,
	dchinner@redhat.com,
	leo.lilong@huawei.com,
	wozizhi@huawei.com,
	osandov@fb.com,
	xiang@kernel.org,
	zhangjiachen.jaycee@bytedance.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH 5/5] xfs: modify the logic to comply with AF rules
Date: Mon,  4 Nov 2024 09:44:39 +0800
Message-Id: <20241104014439.3786609-6-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241104014439.3786609-1-zhangshida@kylinos.cn>
References: <20241104014439.3786609-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

AF rules:
Lower AF will never go to higher AF for its alloction if they
have other choices.

So unlike previous iterating over the entire [0, agcount),
now iterate one AF, i.e. [curr_af, next_af), at a time.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/xfs/libxfs/xfs_alloc.c | 20 +++++++++++++++++++-
 fs/xfs/libxfs/xfs_bmap.c  | 13 +++++++++++--
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 04f64cf9777e..c3321f24a4f9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3707,12 +3707,30 @@ xfs_alloc_vextent_iterate_ags(
 	xfs_agnumber_t		restart_agno = minimum_agno;
 	xfs_agnumber_t		agno;
 	int			error = 0;
+	xfs_agnumber_t		start_af = args->curr_af;
+	xfs_agnumber_t		end_af = args->next_af - 1;
+
 
 	if (alloc_flags & XFS_ALLOC_FLAG_TRYLOCK)
 		restart_agno = 0;
 restart:
+	/* if start_agno is not in current AF range, make it be. */
+	if ((start_agno < start_af) || (start_agno > end_af))
+		start_agno = start_af;
+
+	/* Only iterate the cross region between current allocation field and
+	 * [restart_agno, start_agno].
+	 */
+	restart_agno = max(start_af, restart_agno);
+	start_agno = min(end_af, start_agno);
+
+	WARN_ON_ONCE((args->next_af <= 0) || (args->next_af > mp->m_sb.sb_agcount));
+	WARN_ON_ONCE((args->curr_af < 0) || (args->curr_af >= mp->m_sb.sb_agcount));
+	WARN_ON_ONCE(restart_agno > start_agno);
+	WARN_ON_ONCE(restart_agno < start_af);
+	WARN_ON_ONCE(start_agno > end_af);
 	for_each_perag_wrap_range(mp, start_agno, restart_agno,
-			mp->m_sb.sb_agcount, agno, args->pag) {
+			args->next_af, agno, args->pag) {
 		args->agno = agno;
 		error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
 		if (error)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b55b8670730c..799cd75cd150 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3326,6 +3326,8 @@ xfs_bmap_btalloc_select_lengths(
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno, startag;
 	int			error = 0;
+	xfs_agnumber_t		start_af = args->curr_af;
+	xfs_agnumber_t		end_af = args->next_af - 1;
 
 	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
 		args->total = ap->minlen;
@@ -3338,8 +3340,14 @@ xfs_bmap_btalloc_select_lengths(
 	if (startag == NULLAGNUMBER)
 		startag = 0;
 
+	/* if startag is not in current AF range, make it be. */
+	if ((startag < start_af) || (startag > end_af))
+		startag = start_af;
+
 	*blen = 0;
-	for_each_perag_wrap(mp, startag, agno, pag) {
+	WARN_ON_ONCE((args->next_af <= 0) || (args->next_af > mp->m_sb.sb_agcount));
+	WARN_ON_ONCE((args->curr_af < 0) || (args->curr_af >= mp->m_sb.sb_agcount));
+	for_each_perag_af_wrap(mp, startag, agno, pag, start_af, args->next_af) {
 		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
 		if (error && error != -EAGAIN)
 			break;
@@ -3807,7 +3815,8 @@ xfs_bmap_btalloc(
 			xfs_inode_is_filestream(ap->ip))
 		error = xfs_bmap_btalloc_filestreams(ap, &args, stripe_align);
 	else
-		error = xfs_bmap_btalloc_best_length(ap, &args, stripe_align);
+		error = xfs_bmap_btalloc_best_length_iterate_afs(ap, &args,
+							 stripe_align);
 	if (error)
 		return error;
 
-- 
2.33.0

