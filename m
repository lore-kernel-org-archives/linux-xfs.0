Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A7E14F125
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560530; cv=none; b=g+Bd3lpzBPSeeN4PTVHt9eK7cgAQUKpbKc4SYmPIYf/LnYBv+L4cqxIzuJ74C6WcIIc2X8o6PIMekuDZjrBCmY57aFvhxpp3SqFtoq4tHyrS08kw9c6WvhjpU1E3XIvmWsXvJk5MZPbq0jMr9fC0qujciVeu+QQojGWdqw8l5bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560530; c=relaxed/simple;
	bh=TPY+vj0/sdNOV2JkVbbDkmRU7H9VqyVffPRcrPrRo04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjtaF854R7Yk/yqXj+MeI9BHXndLQM14lrJC7z9JLwRnCMIRhJR8VZ8SOT03CaVujffw4suj3UDEWy9kd/q8YE9dMLStF6xYCxkqIl+EJZprYRObXORHfW7ym+FEcBE+9PEY8JaKGZyYTJiV64RB5vTiEmd7uHnUjVyXMWLUs40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P5cvfO3O; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P5cvfO3O"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2059204f448so10328445ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560528; x=1726165328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SEHVUfEZxglyCvDS+ChOrn7L1eN3AwmIAAdmlinPo8Y=;
        b=P5cvfO3O9cJteoeYtJJknRb9psy3FyDAq9+8sezQpzUCNuLKmw/pDsUfGoqglHSTlW
         cP/L/9bhH0/zJjQ6DUK+uWuoQb+m6HdpdhU96MiUma5xh6mIqVog0QPtTV6bUNc8tFPT
         8oYkhqwhFtRntMtD8IAHIFte4jZubZO9GufGQoWrypOnLhqFdNX3NkAaROPe8QrVHNi0
         4bWoC5I9Ha03OOXKy+HydaMJJSOXSQ7OkvKI0y6R9CXhnKsnPLGB07FUg7DgSGHvQ73n
         1axh9S3ZRYmnriNI+3Y1y7mQWOOHYUmUXesxKB2yHe7O+ViJF1jn5uSyV2QLvXPHlvd5
         8SFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560528; x=1726165328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SEHVUfEZxglyCvDS+ChOrn7L1eN3AwmIAAdmlinPo8Y=;
        b=oHErLoQ65TZeZq1TDbDemrnuVi1eMsp8QrF2sakA19LL3FbwiH63gXyss8aJ1epijy
         YyP5rMPX6Oel6j2UzrezlpR+Fu8rk4e+rqlCeCTB/Y1DNUbOdCYpL5Zn4WeXgBKlUuP/
         4IhCAdoAXQkFBImzmTxaj/zBTElKHnLNl76F0p+Ql5u1ox8JJHwbnuxhyq7/RdWypwaN
         tXHOmOiD201bF8r+tJmplFYKPohuNRmaAGwi3ECMiYrp2tLUMbZX4NcmQ08B9Jkq5RfG
         f4oQ9ImoD/O2iTr0eQ5g/sOO9fUY04CH/MHvIQwrGJzpevL/0/NRAiEzqMQmrUUdVawL
         J71Q==
X-Gm-Message-State: AOJu0Yyif+uv37N8XxBbEasI4DNZXx+E/0W118GbMWtct0gsoBLpNg5y
	yWgsFpb4+2yIrowvXNzGd6Uw92C5iO3e0SAm8PKka5Dx2K8zYZN79LhdYwWM
X-Google-Smtp-Source: AGHT+IEcek0PekIVBRcMU58WUYY0pS9sWSDMv02y2RkzU/Jyd5+1uA1lR8Fx/1PV1ki9g0bF7In4NQ==
X-Received: by 2002:a17:902:f686:b0:205:7574:3b87 with SMTP id d9443c01a7336-20575743c5fmr154821475ad.15.1725560528223;
        Thu, 05 Sep 2024 11:22:08 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:22:07 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	syzbot+6ae213503fb12e87934f@syzkaller.appspotmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 16/26] xfs: remove WARN when dquot cache insertion fails
Date: Thu,  5 Sep 2024 11:21:33 -0700
Message-ID: <20240905182144.2691920-17-leah.rumancik@gmail.com>
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

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 4b827b3f305d1fcf837265f1e12acc22ee84327c ]

It just creates unnecessary bot noise these days.

Reported-by: syzbot+6ae213503fb12e87934f@syzkaller.appspotmail.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
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
2.46.0.598.g6f2099f65c-goog

