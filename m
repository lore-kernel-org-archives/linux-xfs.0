Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5831AD9C9;
	Tue, 24 Sep 2024 18:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203161; cv=none; b=PAo92J4s1gMeozsudnlzQl1mjH5/fy0fapH+fH2ByiXZ1hIFBCBaJOdsXpCXdhPpmtExntdrl2NjsCbM+HwHbZokWvjw2JFThUjXrUauFlT+D5C8JCKaGl9R/MAC71I0Xbjol+PZvLFuo0ZA7lamHmP55rSvY5ATN62tZHD9d+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203161; c=relaxed/simple;
	bh=+zlQsXTCVYOj1wvZVYOxcabsbl6Tg4oTY01p1ZCtiys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NA6uN1fJzJ1pLgt4qo2W/ao0a/Aeu1GrGylAo1iaheqbR3LvYw9ThXH0Lt2oC5IzmdyZ06gvfLs1LUjC+qVS0zUnOBcdh+IQ01/pHLpkEUyd+WJ2wG6l8i4mvkSzu2WitblmKWx/93HIeOIqo5YCRT9GK3mczznZ20wpj2xO4vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a9jwg5Iw; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a9jwg5Iw"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2db89fb53f9so3849659a91.3;
        Tue, 24 Sep 2024 11:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203159; x=1727807959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QXMidJQ1AYXovK5QnNrVPj6wmS+iZCPj6KfD3MCeBIw=;
        b=a9jwg5Iw3OtR8K/qNaxciouXqRLT4hgBVL5A67lWysSuY3nLfVkyxu9iXmqfwzat0k
         hCJ9bC8Rk8gBfAvj2qqdVCaUsPWqzkIQPmI/3+CGjWxn2Q03D2C66ftbiMacUTzhOekN
         TmicckSZgaSizFsQCX74tfVzFdH5zBTeoj3G74kuMW4UdM2bkqeuMNk/Qor9T7KoPVRc
         90UzGZMf6elXvXDP9ridNEBDj5Hi9eQqGonB0UHN3tikY4F+sWGLEgiWnt4eGSHuKBjB
         fWorLFc52STw7m/lg0pIkPVsdUR+jqUOxpRaivgfRb5CGBQUGohOBlpwexQpiI9wY8UF
         JbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203159; x=1727807959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QXMidJQ1AYXovK5QnNrVPj6wmS+iZCPj6KfD3MCeBIw=;
        b=MK0FkODR+yrqZtJt2ld6nVmurhycrNkThzlBmS7wtAhmivOKWqkTxnQ3e5cIEzjIqF
         7iJfn0hK2mfKu3+G/48hAbMtlYgdlc4eoTVjCpl2+RmT6XGCrPw9FYN7w7KACHyU1mSL
         FrnZXvFrcgKbc26rzvmAUDUN/yJEO3yH1l2GhPvdnhKQDpk2ovT32027+rHUhPe0nflJ
         2Hg50H/3DYJjlN/zNNe81oZ7fuJwiDs+qQAJI4zvY5TIX6bu3tMXtLmiG6nFxl4q7t6C
         kR5tkGNelwidcIw3Et5wNvkKBQcHEigllXYNiLhqRjzL4mRYueXbHI6JZBvl5pnNRpz9
         ZbPw==
X-Gm-Message-State: AOJu0YxRqtthFuiysX4i0/Lk6wfJTdL9rl8OX0oyXUt71nhFHLLekyGp
	vDe58Uf4Ik+GFgn/Hb7TUHTmhl0AjBsBUFrFV1IWDoc7a+J3UBYkboHnopWq
X-Google-Smtp-Source: AGHT+IG0agEHkPzG4NeGNcKYOf6Wo8vQm/YgPbfVbPqIvQnht6QVnTkRqKAJbrxLbNluUIiMf3wdiQ==
X-Received: by 2002:a17:90a:3883:b0:2bd:7e38:798e with SMTP id 98e67ed59e1d1-2e06afbddd6mr81616a91.28.1727203159018;
        Tue, 24 Sep 2024 11:39:19 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:18 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	syzbot+6ae213503fb12e87934f@syzkaller.appspotmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 16/26] xfs: remove WARN when dquot cache insertion fails
Date: Tue, 24 Sep 2024 11:38:41 -0700
Message-ID: <20240924183851.1901667-17-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 4b827b3f305d1fcf837265f1e12acc22ee84327c ]

It just creates unnecessary bot noise these days.

Reported-by: syzbot+6ae213503fb12e87934f@syzkaller.appspotmail.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_dquot.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8fb90da89787..7f071757f278 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -798,7 +798,6 @@ xfs_qm_dqget_cache_insert(
 	error = radix_tree_insert(tree, id, dqp);
 	if (unlikely(error)) {
 		/* Duplicate found!  Caller must try again. */
-		WARN_ON(error != -EEXIST);
 		mutex_unlock(&qi->qi_tree_lock);
 		trace_xfs_dqget_dup(dqp);
 		return error;
-- 
2.46.0.792.g87dc391469-goog

