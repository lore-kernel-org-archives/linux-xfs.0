Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075E8382F15
	for <linux-xfs@vger.kernel.org>; Sat,  8 Aug 2026 23:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786232428; cv=none; b=tClHpt9eRZETZnwoHJDf/azxQ3wPvvpXYVxUMrhq4pniM1bIJiB8LvDpETt/1BLFLES8lyZoAVdSAPEaAHOVmFVpBaiU1ZCLUIN74HhM6FKKzwJ1GkI3KmDYuSZsIGPprdZ0rdv4ArWBreARhXQp85bVP1nxJLGXUFS19w6etwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786232428; c=relaxed/simple;
	bh=ywgQQybimAbetQ1b5A6qf3bB8zSZlHCCG8IDtXjEdvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SghkrMyCbnwmKhUw5sj5X0m9agdJh7v3Rh33LDNcWjZ1JazF2KGNqwKN6hCgzxUYvosGEW2GASQs/FrvMvcPjLp5y71rY6mx864N/U0Pt0Y3fR+C2/5Ct+KC3nLddg6/jHBhua/U4HliNMceC9dHjHiKav7YlE2sT2rdDPDTU3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=wDkLS/uM; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="wDkLS/uM"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-74c05517c09so17762137.3
        for <linux-xfs@vger.kernel.org>; Sat, 08 Aug 2026 16:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786232426; x=1786837226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LW37IMt7/aNr6Ztw5VvHFxxJ0NK7pezHWunpaqvkaIs=;
        b=wDkLS/uM9luPF2w1zNMs4ay56CjiLJjnmWFyscupdx9ovG+0ZQwNfwPTqDCvDWiWYZ
         6Ap0dWfFHagk+BTujC11DBES606j7ABciMaZOW5g3cHhUdx4ZixeJh6miWsog49REZX2
         YeNmApM3zQlkZNqRf4UrixRknV3ZLi7mfQF5BvBF3UWMTmErAaWSbVyvnCHtw27Okvul
         Foept6ZtOnkA33SDVKejilEVPRgv+Yf9ixrpm1JbNmnAymZicVaDYJzTLdB/0QtIMHb7
         LcqZJ7pPF66qWJD5FS3x4bBqMtYE5Q5avtbkTDhKGJ/e9O4I7vf+qOOA2s40j0PHNo47
         MhOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786232426; x=1786837226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LW37IMt7/aNr6Ztw5VvHFxxJ0NK7pezHWunpaqvkaIs=;
        b=SgoRzqwf4w96ZoO7ipTjnpw9XBlZDAuI6BKbIwXN++DvSKbsHkPjbYOs4kaWHdu/56
         6f61A9V1NJjoqamSE/+rmyERjesPkIeK+OVin3vcSY2ZxQINB5dlivwW9l8JUgpgOO/K
         qWKzPErua4klCkYVmE71rCrrEWNLjBhayLoMfEO4tvT6aqBQaq238YViSAtRf2/SKy+X
         tiSh5pdnw4VrDHsFae8b1twsUisWOiN3/SPPWJzqJKgohN1MYbWE4J2aicKNE/ubKdu1
         wK6jpCktwnfiXl8p/J0oyXZ5fLPTAYHobDW0UzcLIZvRDDpQJnJTMmWC3QslpZH8wjcR
         Gw6Q==
X-Forwarded-Encrypted: i=1; AHgh+RpitDbyzuHgbuma5rRa3tt6gblTH0no2pyu6qaHXmatl7RgpFmI6iwSpIb7zQ74oJ/FBnBiCXqeXdc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1L/OOayGDeKqToQq7m/jc6d7nDOHhTXd4JogZpXCKCyAwt4Tb
	EWRbdz2iPLxDtMyc+DXwQnxzNlpjfvPh8pd/3hKk7rQ8y2aDmP779TSnVW0dgNGvvVE=
X-Gm-Gg: AR+sD10l45D334VYo2v787eDxUJj0tqyYTWYvPpbxTQrbEMXCr33rO0YgYZ1gmFT4RY
	5xsVpiYdU32ncJ+c2bosT+w1TiyBIUAXVt9cZ2JD2GChtn1Ab4gBLu4j0/eg6dHUMEfRGbo7JYZ
	NWhhxAnMsvRlH5AEw0xLR2Nq17JmwpJ92fZ7xgAFmnfkqh6LqfbuXEoYVQw1UvfZEBpjTtaG5+m
	gtOo1zpaixqxlcaclMPY5Tm8bnWlOgMp7c9GEs1NqbtfzCNgAYh53Aex+dY4N5q/1aYzh3Sq5gB
	o9s6czgSceVDNeYToUdLkvD0saAiD7v+IwottOUJeBQAqTxPqUYEJ7XYxSsKtpa/vQVdt4qXd69
	cYwYAxRB44OWpULlfNk2mEPSdt1P1z/Xq0ZCqZ25YpTMnw3M3oAoLqx0ommw1zNslemJFO+8Gzt
	9tq+tE66h6d97d5iEpZhvEqRY+LNlqmow5jsgyc8I4ekviOsE50oFQMyA=
X-Received: by 2002:a05:6102:f84:b0:729:5cd5:8cc4 with SMTP id ada2fe7eead31-760e8d39fbbmr4540581137.4.1786232425895;
        Sat, 08 Aug 2026 16:40:25 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-76400dfe071sm2787519137.9.2026.08.08.16.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 16:40:25 -0700 (PDT)
Sender: Javier Tia <j.tia@peridio.com>
From: Javier Tia <javier@peridio.com>
X-Google-Original-From: Javier Tia <floss@jetm.me>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] xfs: give the deferred barrier op type a name
Date: Sat,  8 Aug 2026 17:40:19 -0600
Message-ID: <20260808234016.246054-9-floss@jetm.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260808234016.246054-7-floss@jetm.me>
References: <20260808234016.246054-7-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1319; i=floss@jetm.me; h=from:subject; bh=ywgQQybimAbetQ1b5A6qf3bB8zSZlHCCG8IDtXjEdvc=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqd75hkyHuFdJdaJJvBanQA8vDJHIyzfr6C0JDF SLwZve0RxeJAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCane+YQAKCRC17sMLqGd3 H4C9C/9aSX0wUJHvMFvjKAOVvtRJww4qJJMkOB//QqPz+by++DLH//1CU1eSdMY0pHTlMwrFbKZ FJ6eltM8wcIhjYCBN11wyw1xX/itPHP5jj6tzsOF5RmuuCLGq/zcwstXKWw4u+kDQBgdQIJasZQ bhZKRZWrEN5uS1hTIRWJ8I9n6u7RXm0ACGDLE4xuYSDQeaiElag3dnVNCXwurf4wEmDbaRJvZcy 9TFFhBgIrF8VcxHHSAjsuI44hcaV26BkDy2spFrsN4eYI3ozC7tMmPyiarkeeacECA8XJ3fXZLE f1I3jY3ceh0PguIKZ/bxzTAKwiiburUrzpugLN1kjYrm/YEfuwYog9YrkOEC7Jz6lGDZzvE868x cMhySLjbniailI0P2Qv8gI6YICBfzs0VJz6wMHmZpGcp1EfZZav4x03YZh6WnGbMos5H6vT/9+Q wao0kMbzskKfUiBQXgL+Jzr67LMK1DxYPUwzhho7Pzs4bISqg5i9lVFbUFShsXsJP3uCY=
X-Developer-Key: i=floss@jetm.me; a=openpgp; fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
Content-Transfer-Encoding: 8bit

xfs_barrier_defer_type is the only xfs_defer_op_type with no .name.
Every other one carries a short string used for tracing and reporting:
attr, bmap, extent_free, agfl_free, rtextent_free, refcount,
rtrefcount, rmap, rtrmap and exchmaps.

That has been harmless because nothing dereferences the field, but it
leaves a NULL in a table where every other entry is populated, so the
first caller to print it gets "(null)" in the kernel and undefined
behaviour in the userspace libxfs build of this file, where xfs_alert
lands in fprintf.  xfs_defer_add() already treats a missing member of
this table as worth shutting the filesystem down for, so an unpopulated
one is out of step with how the file handles its own ops tables.

Signed-off-by: Javier Tia <floss@jetm.me>
---
 fs/xfs/libxfs/xfs_defer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 843c33304441..75f0d37914d5 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -229,6 +229,7 @@ xfs_defer_barrier_cancel_item(
 }
 
 static const struct xfs_defer_op_type xfs_barrier_defer_type = {
+	.name		= "barrier",
 	.max_items	= 1,
 	.create_intent	= xfs_defer_barrier_create_intent,
 	.abort_intent	= xfs_defer_barrier_abort_intent,
-- 
Javier Tia

