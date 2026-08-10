Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D823B52E6
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 23:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786403180; cv=none; b=DBz6yz9I31eVPlFLePqdLUmkjK9w+th9DH701FJGQ6dl+L0rrnrhjdTYsItmii+G1452xhKy2Y2GGmdecU02rjagPFvaQ8xbhLxTrMQDIMYgGE5yM1TXAKrZWd4ZE5xYF3rQFFhAUzQTLsqm2rwvkKgEsLzh4ESe9CYbwrtMwpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786403180; c=relaxed/simple;
	bh=O7lAK9Itxu3BtFZebuGm+soxk8EufQFIVRqNLSr9Y0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYCOHTtTklA2OPJIFGtpUX2mgTAUaAgp/0gOlNUzhtNazBJc1ZhJfSnaiYj2FrLCgUFqEtXoC6LTDnarK6PYT0eUQ3w2YLk9yCcK5FZs6qcOT9TPoNrCPRPidjECKmQVxah4fAlklr3jEKOPBZJHbvf3HsAVkJygQ0o6TQw/zmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=dcfmmgL/; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="dcfmmgL/"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5c3a84d3739so90718e0c.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 16:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786403178; x=1787007978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sND6wzkbiGyKvdiG9Z9kRm+epdaTPvk4GyaXe9tvODk=;
        b=dcfmmgL/UcF4bmjkp9fEgXkxf7S9WCRAv+4lyIa6RfeGT/7FbY8X9Her51KN1GZS0o
         PW3c551S6yu9FfxpEzKDf2xEgM8cWHqHXK4wQhl0UGkY9ACczYyTSbAgS+FKYCinRdU6
         45nfGmo9umsCx9kgDBR3f1PBs1iIJoAxU97kuQggBj75p9mnBSuQ+Jc3TSv2YYoX6yra
         TK3FO6pVkCwLMMC9PBQmINTmqWPyfwjpRALxx1fHbLKNLTbFiWuMBvy678ZRhPxIxjGP
         R+MO6fSm8jSkojijm8vo5/yWulLUGpwKVZaPX/VPwRLcCO8RyBSkR5Dm0bsjust0+gWQ
         1KkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786403178; x=1787007978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sND6wzkbiGyKvdiG9Z9kRm+epdaTPvk4GyaXe9tvODk=;
        b=Zym4O0hGzdBl15IcGo7f1UmBOnXsQsVEpHUNHb+QLTubh+GxDT+pRNRS/v2Rssv5QR
         Mdt+q3Uewms2hx/ZxY1aQbcRuS4XLMo1pX33RpSA2AQJI5+rOaOj2dY7/+HGPFibrLTv
         cB95qmFhltCBDqArT/612iHGFS5ucZRtmy8tMEpHbitmybBiiJSoHjcaXGYa4WBTz1AS
         BzGJ1vBMGZHj5Puw65lbFyFYdHzkIQykI9Rz4IWsW/UX2vdcCXZjl3VaPLA7K9uX9gC5
         Wt1lH+zH4TP3bFfoA8SNlkb+bBppMEozWlj9+jNJDtJ+BQlgv5EqJvOnx7mQ/9oDBHCw
         RKhg==
X-Forwarded-Encrypted: i=1; AHgh+Rof+lBhPQqfMcDM1XrJEIVFcVmWjY9/NwIMjNGApAgScd2CP7djkMe6b0JCfJyHkajhBoiDWFw7qNc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaMK4fUGlLzkYr86vItbDI4vr0vbMCWzYEjI+WoqQ1CgOUzha4
	xQKjbBSW8hZM3bUav5+ZVt9K9WLbT6WGjA5x/mYQJwmIzo8qdt3vzpD1xOwtS3zwoWc=
X-Gm-Gg: AR+sD10uKFzXIEEnBl0Sgplpn+qW7OH3kzkTk07J7BOKHNcx8ii/oFRkAKJBEpRjN/u
	9G66XRBCX+yqEmhSfIiGv7ia8tMOaYjUeEkXzdVCjPdOHf7aZCHjIqOtgQAmlXcjqhk/ED6Z4zw
	bulod7QWSr3A0tzC3z9ko+IjmjMUKS5zGuYeTp7bbCLlJZnsDjXQoSccGccLAcsz4XscwTcroV0
	PNrJxcUDCrHgn7+YCsFnqmQyCuogFcMlZhrVxTjTc1dWVfeFZLO0hePv9LOSU7pCIP+y3S0PhxL
	lTpYV3vIYt3DMb1Esp2gZAUS9kn4Vu+J7XYUL7YneSAGGBK8AbM43RXNXQH7SIGRZ/kWZSqU9d5
	abjXaCzkZFqEVXv5iLJTQO/nvMuo9tN/2yC9hV5YnAeMUlX+Ydvmgs6AZzqWCzJ3/GDH4P5pIyj
	YGWyUDWbbJt+nTjxkk3htlycsVjcy3txK/c2vmH/61RMViBLyLhDDkoGJmE/lCidAcnw==
X-Received: by 2002:a05:6122:6c06:b0:5bd:a3d0:923c with SMTP id 71dfb90a1353d-5c3d8d1a62dmr4758463e0c.0.1786403177877;
        Mon, 10 Aug 2026 16:06:17 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c40b1a8f75sm4737386e0c.10.2026.08.10.16.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 16:06:17 -0700 (PDT)
Sender: Javier Tia <j.tia@peridio.com>
From: Javier Tia <javier@peridio.com>
X-Google-Original-From: Javier Tia <floss@jetm.me>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <achender@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 1/6] xfs: initialise error in xfs_defer_finish_one()
Date: Mon, 10 Aug 2026 17:06:13 -0600
Message-ID: <20260810230611.2859909-9-floss@jetm.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260810230611.2859909-8-floss@jetm.me>
References: <20260810230611.2859909-8-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1468; i=floss@jetm.me; h=from:subject; bh=O7lAK9Itxu3BtFZebuGm+soxk8EufQFIVRqNLSr9Y0g=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqelljdkIzN6Vm6qJyjzD8yEylWzJ49lYuL+7hF mhBN6Hvjd+JAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCanpZYwAKCRC17sMLqGd3 H0h2C/9q1FfvCHZUTjpMqZgcixlBy6ktrW3R+ilbZX6SIJkKPmGNb0tgsfoS482naCCHoSppic0 uTZLgE4fjZZ6d4ScY4ADsthGb/BtRLZddGfZfeKjyV4o0bbcPuJR1OsMI88X4Z8iwOwGT8RSXTc ku9S3RuuqFjXuHk2y6OZCTHgVyYvERsHRr3CXYwBfMs2lWqkrGy3B4R0AFi5gJjwKZDaBDsgp3i ZUacCCJ/plSySYNri0ysQvG/PoeJtipZtQ5j+u2A2bj/99QYh8bjM/4bIjzXxlQ4Wtbna6q+0x9 Gmjne4hson+QfKQfrtNy2unywyTyAl8XZJ4GfyXmj+8HBVD+rbRoS9OZvow8y6ChHSjG265UWgi AIQglW4YZECI6+gc662fccIAmFwtMphfJHb1yehOgXrl8bihT/OfDs0mwIVvJByQQbjjWu7KZUp eRw/RUaqOTMmP82N6K7Z7nLmFGtTubaI4Ak2SNm1aT1df+BWtx5PX1IWC842WD2bwdj8A=
X-Developer-Key: i=floss@jetm.me; a=openpgp; fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
Content-Transfer-Encoding: 8bit

xfs_defer_finish_one() declares error without an initialiser and only
assigns it inside the loop over dfp->dfp_work.  When that list is empty
the loop body never runs, control falls through to the "Done with the
dfp, free it" path, and the function returns an indeterminate value.

An item-less pending item reaches this through xfs_defer_add_barrier(),
which xfs_reap_ag_blocks() uses on any CONFIG_XFS_ONLINE_REPAIR kernel.
xfs_defer_finish_noroll() treats any non-EAGAIN return as fatal, so a
non-zero stack value turns a successful barrier into a
SHUTDOWN_CORRUPT_INCORE in the middle of a repair.  Zero is the correct
result: reaching the free path means the item loop drained without a
non-zero error.

Fixes: 3f3cec031099 ("xfs: force small EFIs for reaping btree extents")
Cc: <stable@vger.kernel.org>
Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 89501e8bd2f8..843c33304441 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -583,7 +583,7 @@ xfs_defer_finish_one(
 	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
 	struct xfs_btree_cur		*state = NULL;
 	struct list_head		*li, *n;
-	int				error;
+	int				error = 0;
 
 	trace_xfs_defer_pending_finish(tp->t_mountp, dfp);
 
-- 
Javier Tia

