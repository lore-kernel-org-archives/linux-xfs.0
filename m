Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AB53793CF
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 15:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770047104; cv=none; b=ZC4UjsoL/jwhYtaJK6NaO9nInX1C0YVVVmhPPeHBNuMuFeSV2atxP3GEks6c25DAgOFdMtBXOx9krdNmSapsNMOO3R55BFHs/CxZcbdF8won1mAk4FEawe8PoDz+E8u/7wdQ8lw2FSWDSZf8P9KQW8bK35n0eMDqG3W3fz3UXn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770047104; c=relaxed/simple;
	bh=apmosNlmlGXu84xxAwbeHewfRKLaSp4Y/cXTo8RIVDg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EP2JBnLsPDN7FbkAbdB1ivEpZ7EKNd+fxcauY0OhaBzcNmY0M1k7qCOXEU3kxtarH4IwmBrikV1hFyNB70KCFQfdC4xKbajFJuMwIYtwS6zkaL4Qz/IYcGQWIZLvHmjfFkaGVcSMiJHLEPXHJ7WQellv2zjzMJ6aK9gq1rFtBPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YbnDctMW; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YbnDctMW"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-81e8b1bdf0cso2847895b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 02 Feb 2026 07:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770047103; x=1770651903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bK/86Nyk/EKSMMzdzRby3gSajMQfUiZyejcUNvrlmaI=;
        b=YbnDctMWIILWQWskhbR+4tTXyETdbS6st6Enj2mJO0kWkeGloerpg1yF+9v+X1t5W8
         Sj9syCkLZJn7KjVVY3gbLNxPDq9Hd2DRzwg/Eez5uviN+mnPbti+LhqQGLY5CM+BmmhH
         NvgoZlr5M31rSlr8XSAp1aDKEAah2MeZc+rQ/bAd5lFlh52C78qfufmRt/Mh3pWDhmrp
         EKiwyMcpXOpBcxowwNql9IE1Nv5a8VjFV8l9EbfQYuZP+xDqx+K7ih8/UL8DcCalXwOn
         oFmPQp1GU7Ub4r3dr0icNp6qTESH1RSLXM9RSHnDWGnqK/pratDDzyBr3gPXxmfq4Iv1
         j6bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770047103; x=1770651903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bK/86Nyk/EKSMMzdzRby3gSajMQfUiZyejcUNvrlmaI=;
        b=rwmnEoaDCCsh16E04k3Swp/s4jv5AoN7kYH5nljzajqC32bLTzZJQYjySO6L2ikxdp
         STHd8+hcBnVsoc760daeUXXoBodtxsbnWcQ8bstPEJGfzF7po1rS+dA8wOxzwX8bwM7t
         oovdRC62xiBIkFxdpZWalUpB5w2VVeaV77T2RkqJE+Jpf0KkF5nMsOGuWxLKT1IZk0yQ
         TvSWRGeNLiZFvjn5jQ38W9T7Kgd5IeLXDwYi9nwjwN3FW8If2l4tSxlVE6G+opTGB6m0
         FSLliElhYEvJvbAvnEZVeVFl9OgDR886paZNNU4cVRkuXMw6fPs8he38xnKuWG6Amqy8
         FaUA==
X-Forwarded-Encrypted: i=1; AJvYcCVeLF1RTn6lWft0IV7EhS5c1mFyI82BcyetDhq+elvcDHsY6vhw04T31fPETkMtRY4R4bf668InlS0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+3ebHpMkKQTvIZUcpbU+F6GiYX0P1IcQ0q6eNmKeYUurx86yD
	dLiEHHRBj8U8Y533BoJxlvc6bZJc3qsA6c8Qm97W7wQ2T/wjSPuD6NRd
X-Gm-Gg: AZuq6aJDp2pbcEISxX4IG65OVobz2Avy4J4jd4TYUnEhSzJlgPDHt77CgEjEnb4igNG
	JQ6H0k7U7H2/UNBJVO4EcB1gzS4isX9jMOJ5Gre0qFSTs/yY3+7geG8hYNxo2tRB32G3FGu5apF
	J0+04uJJvXYr91SSmbhqp9z+Khe/D1rxtFb6rx8sJbHxJiW1WPbHelwnGynZupvKzaeVWlrIpOF
	sfRcgv/lPr10v2C/+4Ulndfudcg68e7D3w2mhAPeORNaLhaZ2yR4++hpt6RlEvxopw2Ennc7+jW
	bbsTakXCK+eICONwkvNe6EFdZ84qn45rPAO0Kh47r+54Sh7H+D9uAbhV2ojWeY6lLsgj+hKf1hL
	MViuZTsMImSUgdFkXGplsxoDRMV350fSf7+311U0MP71oCvHBXeiu4AWOuTPQU4slFWX0hQIgoh
	yRivaqFwxI2HHXkP4J7fZHJ6LC6EJqROhjF93KQAa4t3+IWLoDAn7HDeAVHd3ehNsjTb2u9ey/s
	8VGb6+B6VnLxp5dbXfOswaP4SAhyuuEsOXGhIqE0igty3lpx951forb
X-Received: by 2002:a05:6a00:9185:b0:823:5f7:ecb6 with SMTP id d2e1a72fcca58-823aa43a1camr10597514b3a.17.1770047102767;
        Mon, 02 Feb 2026 07:45:02 -0800 (PST)
Received: from lorddaniel-VivoBook-ASUSLaptop-K3502ZA-S3502ZA.www.tendawifi.com ([14.139.108.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b4ea8bsm20074206b3a.22.2026.02.02.07.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 07:45:02 -0800 (PST)
From: Piyush Patle <piyushpatle228@gmail.com>
To: brauner@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+bd5ca596a01d01bfa083@syzkaller.appspotmail.com
Subject: [PATCH] iomap: handle iterator position advancing beyond current mapping
Date: Mon,  2 Feb 2026 21:14:53 +0530
Message-Id: <20260202154453.650471-1-piyushpatle228@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260202130044.567989-1-piyushpatle228@gmail.com>
References: <20260202130044.567989-1-piyushpatle228@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iomap_iter_done() expects that the iterator position always lies within
the current iomap range.  However, during buffered writes combined with
truncate or overwrite operations, the iterator position can advance past
the end of the current iomap without the mapping being invalidated.

When this happens, iomap_iter_done() triggers a warning because
iomap.offset + iomap.length no longer covers iter->pos, even though this
state can legitimately occur due to extent invalidation or write completion
advancing the iterator position.

Detect this condition immediately after iomap_begin(), mark the mapping
as stale, reset the iterator state, and retry mapping from the current
position.  This ensures that iomap_end() invariants are preserved and
prevents spurious warnings.

Fixes: a66191c590b3b58eaff05d2277971f854772bd5b ("iomap: tighten iterator state validation")
Tested-by: Piyush Patle <piyushpatle288@gmail.com>
Signed-off-by: Piyush Patle <piyushpatle228@gmail.com>
Reported-by: syzbot+bd5ca596a01d01bfa083@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bd5ca596a01d01bfa083
---
 fs/iomap/iter.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index c04796f6e57f..466a12b0c094 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -111,6 +111,13 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 			       &iter->iomap, &iter->srcmap);
 	if (ret < 0)
 		return ret;
+	if (iter->iomap.length &&
+	    iter->iomap.offset + iter->iomap.length <= iter->pos) {
+		iter->iomap.flags |= IOMAP_F_STALE;
+		iomap_iter_reset_iomap(iter);
+		return 1;
+	}
+
 	iomap_iter_done(iter);
 	return 1;
 }
-- 
2.34.1

