Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED0137CD5C
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 10:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775815872; cv=none; b=nD9gjpeDY6+8/K0LCg24lO6GoJJVIUOxrhP9WWaxGc3wZ1cuWsKfn4KLQcZqlFeW5bd3n412Q9bNB33bp/YxJpwFC+nhRB3iL6N7ZMcxocv74Le3OwQ5O5uSlkGn1ieqi2ecVQ7ZAqhHWZIbxqcX8vASAa8onmBYkzP74Q6RC9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775815872; c=relaxed/simple;
	bh=ZLFmeNnpXMQY5Idoo7GGvp09WItgOs4lD5yrN956unU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uLxu66DK6l60GFDMUvHqAwgplUto/Fh6dKPfjzWTQj63UKydM7OrAez098em2YNGMYlDrADhZ6LV9HsWhSX5giutF1/NX+7/qvKM3PS5HhSRyYv7cndik+AtE3ZznnGnJDVxAa94MHmWHdi5oud+zHtR0PM1EivauqbfpzVstPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dv4bG0k4; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dv4bG0k4"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2cf1646bd11so3230508eec.1
        for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 03:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775815870; x=1776420670; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gs2VW1Gl3mTkG3F5QoajrDkspcE3G+ncg4CJsvRt2CM=;
        b=dv4bG0k4X1seAhES+7kggOVqW5UIIzap0VMD/MjHTW/IyjOTAu31Dhc9tGqoOCE7u2
         k4l7szgbDDC7Q0Ep205O8e3QdzARgI1yzvLNbTC3XrYbHGRAfjhHxz08/EX+4WF0AjAT
         Y9eyJ80GsSKCFqlquiC9PzCfRYJhIloU2y+xsP7cEcaJuJx8z6YO8efBpa2q2VWWkWSP
         agYac+QIWs4TnXajO4vBg0TjLgEQ3KRngRNq5oojfdQ/M45RCQAT3XeqhAOG2bDXXQgg
         jYQ3z4JRg/0HJ0JII6ytM5uDx5dHC1FM10UAsvjN33w+Dwy4old6rp0avJ/Xvrh09lZ2
         s+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775815870; x=1776420670;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gs2VW1Gl3mTkG3F5QoajrDkspcE3G+ncg4CJsvRt2CM=;
        b=GaBBg+yesOex05ytUxmb/+ei/NSwp7Uz0PP84okBFQeckazDIg9FOuKUsG+isiq7RP
         3bLRTD+60vLqWqgY8ZJLlsZarl8+J7IWrMwaQ6yzU7vP6Np5NvHopNLPuWkeeXUpfPrc
         YVFwsnfP+W9Y7XHUCfdkS73D1ozMZZqfmZ14DXea4QDILixqZqVRA+OcXq0vRqKLUx4y
         2w33bWGvSukVuMWN5W/mPQ+QivRbffTTzbbNN6006RMD40y3KR15OErHNa53hDSMBaIh
         T0Gq/9TvLkMBYOOCf2bsLxVw48qYM2V+qKz5+oXfX8sVUVHHqxjzP/sEWaszrU9+8sIP
         kqrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJDhOCqOQkmWlkaE5L8xlHlyXwp0maB4gLO+4SJsZlxsW5wBaVb6zvfcCUVmJ/kMKulva/+rff1S4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbKYm42FytRkT+2j1H2FN6XwXdc5OnQtYZ4Wh56BpYLqasrrDV
	1c5Wei9PtgS9m+Xq1Y2y9Zs67RgtG3nflLMtJCAIN7zXJtmH2DO0YiBU
X-Gm-Gg: AeBDievVMuHCrS81Yalg4Y3sPZqfFP+wozuVDnRebqapdONzbmU2UT5/rFtVdIbXol/
	LckgBN0tUXKoQzeNbDOFUvsUcVP7ysYiwsXHkaiB1hJqRPSMsf5DyULmt9LOFGmcNfgxj2p+Enz
	pqdksmG+pG6ham3qbHCtUKxloKvDddXkH5dtuLj/M8Ovqllklek10gZRVacgpjsxq/CmEZtfQU3
	f2udAaUUOQCnu2EtiRbT1B9q5niyjvL9VNlVhRx0kEP53PPSixo/3mbzYrAITV+8HUhGj4u40Em
	POoNbQ/+O72FJuyxC9HYYSGP3AiubmsBNTS7xlRR1bl/v+/lYb4NBa94r9iT20Hfn5JXLUz0UF5
	6r5JhXRyMD7BtRXIZVJubh7Yb3mdBeNKB+BDv8Og8+2w2H1kiL0Rd2mK1R2RLQjw+GHcjcYiAU/
	W0z1hyVNm9Vqe81O8Te5vcIS3aO1vEXdwHulmW+Q4ogstHIg==
X-Received: by 2002:a05:7301:1f10:b0:2d1:d434:d005 with SMTP id 5a478bee46e88-2d5899a3b93mr1647202eec.20.1775815870421;
        Fri, 10 Apr 2026 03:11:10 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d55faa42dasm3508726eec.7.2026.04.10.03.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 03:11:09 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: cem@kernel.org,
	djwong@kernel.org,
	kees@kernel.org
Cc: alexjlzheng@tencent.com,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: remove the meaningless XFS_ALLOC_FLAG_FREEING
Date: Fri, 10 Apr 2026 18:11:06 +0800
Message-ID: <20260410101106.2523665-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

In xfs_refcount_finish_one(), there's no need to pass
XFS_ALLOC_FLAG_FREEING to xfs_alloc_read_agf().

So remove it.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/xfs/libxfs/xfs_refcount.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 40c7f0ff6cf3..0ec6ccd8b4dc 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1414,8 +1414,7 @@ xfs_refcount_finish_one(
 	if (rcur == NULL) {
 		struct xfs_perag	*pag = to_perag(ri->ri_group);
 
-		error = xfs_alloc_read_agf(pag, tp,
-				XFS_ALLOC_FLAG_FREEING, &agbp);
+		error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
 		if (error)
 			return error;
 
-- 
2.49.0

