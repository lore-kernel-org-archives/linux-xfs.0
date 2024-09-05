Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6263D183CB7
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560516; cv=none; b=nn48voW9z5qAgk2wc4b5QCXbUO1CHQO7pN95QnPz+cn9GHUT3G9K8a5d/kj8QwwqEjwbQeXC6+ljQRMQvPjstedQp8+LRrpeuj38zyv8+WAFZ4c+P7yhyDmyE/AC+b6bDy8W2/1QvK40PlYWKSys5n91fNkMqO5wkwqep/85A6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560516; c=relaxed/simple;
	bh=/OEoQKnY8a779EBHUO+LTZlIDn2RAlwt/EuLDdx8vc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myTd5n0AEpYLiGw9AlRIY78UTxZ9W/RCsJTdpBLyDAGxQ/7VgOLGq6ZgTUxBWbv7JrXnF2x2NifQ6kM/USZkD5JTd/fdkpjtDe9VxzIg+YxnhPwvqtimQSHOGpxmia67IjUr5KGO/0v3WlWgxh2MkI0cqtQ9bKMtx6O92rnCvyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q7avDGET; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q7avDGET"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2021c08b95cso18555665ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560514; x=1726165314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zBWrptBan1hieddm9lbe0C8LOI4hE6j+bk2iO/lGwWw=;
        b=Q7avDGETxGTgCRE5VQzLFWb98IXLkeWHAArwau4kc3HvpzFy86VfTaY7FCb9ph3kDD
         DfP1YF5Hr0he9Qh8HmtRCFxJbwi5OXBbSJWO75bhZ2gUFuGicKaYxEtOgMSoWYjvPe35
         7LzUmzAf7MInSsbRKLU9Jqy67771qFlt7E4TwljSJp7R6DnpCRe5NEvjlszR4b31OkMQ
         OZypFwQzeXOvkWz2c0jv9KbxrstDgEVQoNHV69LwgU9euUQz2kxxT051dApg+CVXZgO4
         VyDPul0Jhh8wfNTBVdiOAahlF5PnOBQ8ZG24YQI3DVdUk5PeefrXU2yCMYMzkYkJh4B+
         P+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560514; x=1726165314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zBWrptBan1hieddm9lbe0C8LOI4hE6j+bk2iO/lGwWw=;
        b=G3xd0dB7FcOVqkQRztN2hvWm92OY9CqNvR3ivdiCYcciN8DN221HgX7MYO4xwOAkWY
         tmdz8FcO1i2jScW3ZNPICSTqFMSWvxwD+bfMydOlCopOkeF+POiFIfGzNs52OCCeHub0
         5c+7dxVFFtiByr6rEaUwlE1FREKlYdfv8FR0SpYAmSY9xaZNznLWVJhYi/70vXm+CZBQ
         a5xvEP9A9qtfTrpl/1F4A0KG6X496pdo9PrZfp650uxc3K/jOqg7LE+ThKamKU7H8x0h
         Cu+DUwUbWr/A+Y8utmCuHRQApBmM37M7dK3yaKHm7zSj+5O7E+qUslIYJ1/WDc54jYXd
         Gt6w==
X-Gm-Message-State: AOJu0YyWro8xhNfGdg5XT8IyGEXd4/8HWQPSs/poQbLu51bjo8GMwb2/
	i+e2y3D6dI0NOm6iSx1RQJua5eK48KpuquVc3MPfUkPfqicrHs6X/ykTEbXG
X-Google-Smtp-Source: AGHT+IHZWR46vidcvvlQ7Xx7gpswcBdtWFLIe5JP0IHfiw64epilmlJ1KqkuGxC1EplN0sannYoCKg==
X-Received: by 2002:a17:902:e885:b0:1fd:96c7:24f5 with SMTP id d9443c01a7336-206b7ce7a6cmr111612575ad.5.1725560514520;
        Thu, 05 Sep 2024 11:21:54 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:21:54 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Wengang Wang <wen.gang.wang@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 03/26] xfs: fix extent busy updating
Date: Thu,  5 Sep 2024 11:21:20 -0700
Message-ID: <20240905182144.2691920-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wengang Wang <wen.gang.wang@oracle.com>

[ Upstream commit 601a27ea09a317d0fe2895df7d875381fb393041 ]

In xfs_extent_busy_update_extent() case 6 and 7, whenever bno is modified on
extent busy, the relavent length has to be modified accordingly.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_extent_busy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index ad22a003f959..f3d328e4a440 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -236,6 +236,7 @@ xfs_extent_busy_update_extent(
 		 *
 		 */
 		busyp->bno = fend;
+		busyp->length = bend - fend;
 	} else if (bbno < fbno) {
 		/*
 		 * Case 8:
-- 
2.46.0.598.g6f2099f65c-goog

