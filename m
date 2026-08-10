Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D57D215161
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 23:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786403182; cv=none; b=PjWllOKsC+lC0xky+k09xRTvm4zhoiUDEhGPKfbp+K8VUxBjgeKbh5b/2SMyeTh3Cqt/P0j1zTjUjRG8+XV4uDtJs82asByF6QVr5HcQLoMDG+u/6tDyEx+YB5DcgwwN336XpfOQwty8+FmZ00XgK/h+uwskuBQPsyqgclhzHMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786403182; c=relaxed/simple;
	bh=cN3dntYSRKkBZpxQVRebrXb/QZ7i856/vDVWzWsugXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUyx0/ZNzvJ+NWESIRH5XvY1xDvCOfwT21rullltbTrH+JX7zMKZWmkEzS5mhevth2pl1fLLuj/ts6lP0g16v2ZDqq923g6sBmzr8HAALqEo2ib/or6si9hzyP5g2uca2dGCEPmacwd0mkbSQ1a3HAt1nGwFoJ8RgNLKhgVcrMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=zgTLPEIy; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="zgTLPEIy"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5bf9635a8c1so97267e0c.3
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 16:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786403180; x=1787007980; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qEP94udPMsH7DZzh3NprgOqukKgliAk1nMK36vluOns=;
        b=zgTLPEIyDyNu03GghCP+oVAaanG4lX4gWWNonwSreaw6IUbyXQ/6jAj/0VruyPuFuQ
         mN9YNSxlSBSd1aG30b8B744F3hfbjwDyrECr5br5dQys+vScw5/+KuOzLola9tewQuBy
         gFux9/mfLs3rUshN4vcpceBDR1j45kirwBTnlXWmJUfgZEpUAh1n8TdXHmLYYDyaSsj9
         grQU1S6quBNtuqQYizjYSItidQXnCZbRx1vamqVR/QsObnL5CTSixUG+PwSgH2OTtden
         rKtHVaTGTWT8BXvDi4SBQE0Aqyg9qAWohOT01mcOKd+3iIzkP6j+ulG95EY/1LPVy9XF
         +vKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786403180; x=1787007980;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qEP94udPMsH7DZzh3NprgOqukKgliAk1nMK36vluOns=;
        b=URxBhJ1aquKdCd0dKd754KGknq1j9JlYc3EYyTO7V/l4KW/rc8Cfzdl8YN9fETFrYZ
         TbGF4glFF/G6WIzo4RsKI+nP+E7gymOXxcwmb/dXFuWfP32GpD1vjcqRjwdg+Cw4pJzv
         E/UbEFAPAhZPlBK87W5CWA8J7j12Bjy+FBbC8IpkEiYd2m4VgL1nDSJrEV3zCeLiy9Vl
         uY2GM242Ak8ALxhBcxfQhppw+QJjda5uPtbqUz5TVQjXaIztZIXUzmcX4dm5QqdgngN6
         1amsoULLTAceLdnVsaKaf5cfzgBLIcWMNVvTOa2/K+CkY7HkjM2WfibDPrYm0Z88Xl91
         bq5w==
X-Forwarded-Encrypted: i=1; AHgh+Rp0NSvfzbQG2q4lLOL6Mktp+qp2d2YXB9UzywG0pldJIIss1TfqJIsK/aPocKstk6w5jxDh1GNzA0o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoJj3Y2PV9BvcIMO4BEZjdJUQHwjHWB1BMlLwUMlIErL3pEJHA
	LjSmcHBV1JUfzhobstCDUvA7zgsl1AoSFUXXefK7AgH/nMFIVmpQ3EIGA0R14g0keGg=
X-Gm-Gg: AR+sD10O/cxt77Wr1gcSZ2eHzAmzUYo5j0EZtAYiGGbU3s7xD1+aaV23hOxdXZMk3An
	ECVu1nbOJMwOXLMVvXT68lnrAbMCurG0+zKbct4vesx7NPfra8LfO6T+cjvGq1OhxpB5h0hwDsq
	1zW7y/F4A939Z8mVO1iUSY7oNGfIgvp6I/vMWJpMCAH8Pa0bIqTzTwc5BbHqjeM4r4dR7zIvYLa
	AkJ6Ko/ZSds+yVWx3BthQEHgKdgzcPgxbEktu62S4K9RbeG3Nr/ZCOGI1kOye8xrFOawdHeLFTU
	flwxqbPQmbJbXPB2zO/Wvdy3Iv5DogdUQ9YKkMmAwjaZVN2SFKQIBaSFjhLP0+kP3O4Kvj7zlE5
	my3DutDm+c0drp0iU/26pTyBv0ZVtF7ElZgekK9CBlafFjYLpsoT+9yKnAzQSyoju8gJ7nqjHm7
	y1/mZuQGVzljIhx+U+1KPIlOtD0YaV6axMxA5sBOeHNSKhSL/HeT64gKxHHPs3pT2V8z4VHRPBJ
	UlE7nInLjOuy7o=
X-Received: by 2002:a05:6122:6b8d:10b0:5c3:6e8a:4a22 with SMTP id 71dfb90a1353d-5c3d940b089mr3357590e0c.3.1786403179879;
        Mon, 10 Aug 2026 16:06:19 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c420a2d1d8sm3340875e0c.6.2026.08.10.16.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 16:06:19 -0700 (PDT)
Sender: Javier Tia <j.tia@peridio.com>
From: Javier Tia <javier@peridio.com>
X-Google-Original-From: Javier Tia <floss@jetm.me>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <achender@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/6] xfs: give the deferred barrier op type a name
Date: Mon, 10 Aug 2026 17:06:14 -0600
Message-ID: <20260810230611.2859909-10-floss@jetm.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260810230611.2859909-8-floss@jetm.me>
References: <20260810230611.2859909-8-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1371; i=floss@jetm.me; h=from:subject; bh=cN3dntYSRKkBZpxQVRebrXb/QZ7i856/vDVWzWsugXQ=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqelljZqnJOJa7RnkDd+smQ6u6sTV39cbOgg3pl R42h1J2EW+JAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCanpZYwAKCRC17sMLqGd3 HwjgC/9W+RZggkTvAas8vSgCzWt+sCY/+LWSwn8Zb63ECol+aJvCAiPZRr2cOROR+wuB+Oc6Hq+ fX7Ku1B4/T9TIPW4ClO5az8YG31sz23EgwCDSEt5DCagmasNmF9N0OWRZA0BJz+RFfxFtuAU+Ln 7gNV54+UuYYCbSrYBZPlUawEJzZxIqctSqKZvAU06FfJ0sNQs9Qz8Fgj5bAJf+vOFocrgkTlGMR CXBpTXLLvzR/xp0PlzyriXzO0AMcmf4i7CRM0nxFoZ5DTzQ93+/pSTu2lfcOB07p3bN99s556b4 /pWImMOIck8AYgKa10wxkRe9ZhiZSHt8KD8k1RsoFu969z6PONSTSwIpOLMBJVMeBqj4iRnt+V7 czDk5j4n5ld4UWZqYs51fSEYShsMtoimfnKUsl89mYWWB/QZ7fH1VgzX/F13Xg4eNhVz1elL7e3 7kr7G9JC7sVywFxWmCmyMM91RzR/q6P4jT7Vhv1jkUB/muX5Y2Q08b4mfrgdiaohHLvSs=
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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

