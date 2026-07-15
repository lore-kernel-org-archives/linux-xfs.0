Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAE842BC49;
	Wed, 15 Jul 2026 10:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784111496; cv=none; b=AaHq2m6j6clkNOi6RRHcrKLp2aUXbquX+Fn89gnouBDyCuMGwZp6ryOeusPoG7/roORUhPftDdAsq8lW8eeNkBasYTYBQ+Co06JGx4J+YvR9rweSFxrNKryedIqUpvzTulPaqogAkE2F0o2yml0yboLi4MkP5ZAOAJkyKoPwVYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784111496; c=relaxed/simple;
	bh=e4Wl/dzPK7FW1shNf6Ar6eY6ax6OFIdfpHTZ93Ru4Hw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BzfXS8tV5Kw18p5JB34S6WXFmbYBPyOPgQtVAPd/X17ITGg//Wx0SaeD4PY6IwKV8ga4Vvm1oicTRGBm5Ur9ddCnvAeEQhLGzuPJ4wgvRqhlO6eeTPHhnaydQHCyupsxbC/SR/jx2FQn/ASoq60PQqeGJ72yi1a6N3iJ1tqWJrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=hE41mSxu; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="hE41mSxu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784111462;
	bh=2cVz65bfqpxyMl4P2L/ME8u+LPsl792Q8rTSngHzZgg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=hE41mSxuwau3SBxhYIrltGz+Kb69C3FkUoyn1KcTYHuZPh8SwWgcWOEnO6WMzkckB
	 Q+XUKKOtAxwXBcvmKIBvi2WsQogZFusxWgl2qmeSuItAoeR75RCG5GBkVjgwJGCzL4
	 iJnRl18+47HuZndNUOOf0SQDvvukX9BKkFk6XUOY=
X-QQ-mid: zesmtpgz1t1784111445t1c4ca814
X-QQ-Originating-IP: hZmF3kZC/bQYxcnGfNESN4MAGP1slbQKbSpzr5L31AQ=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 15 Jul 2026 18:30:43 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8601385554246524199
EX-QQ-RecipientCnt: 5
From: Qiang Ma <maqianga@uniontech.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiang Ma <maqianga@uniontech.com>
Subject: [PATCH] xfs: clear zapped attr fork state when bmap repair finds no attr fork
Date: Wed, 15 Jul 2026 18:30:26 +0800
Message-Id: <20260715103026.1701559-1-maqianga@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz3b-0
X-QQ-XMAILINFO: NuFCnacf6wViwKE3tPh3pkN8zZzjPcatq6qX0riLs58uVU7iryQ28qtG
	D4rzmMVzsSAotndiy4TNXx00rOoKbd0PCJtU6q/CZItuhsWcaXbjetRQ2O9Nd6A9+325O6U
	dUkbwLz5a5DT64mGPL4o98HhPfpBHe2ArNspiExtI9nCGIB9nXleoBk5/M05fr1QPNZBZxu
	NSlj4XZdEqjRcN8idDBnBML3afUNjAhzj/XrGUQX0nxPCCKJ9jSXz0tc1V6qMvwblOJNWVo
	iAPWfSg5UX6MQFNLj7PvfF6bkcqX5NF799UZO3htwmz3F2Ox5j8HQwiySVDgFUki6jVwjz2
	5w0R74LxwrRQdZ40K3fGp7OYE+ucfk8BXXaMZ1zcMBQtwD491+AH6emVISh/y3+2qzawxgq
	WeVz9nXQDmjmePM2yAfXYsRzUTKMMq0kzlFGL/rXvhiWDFLnEXxs8x4Jbao1QW8+UP/9NVZ
	SKOYyIezpAotHRGfhZq0lJZSDqOQUXzAfA79ZseOi8E8l/VE6kdn1+fqSuhtZI4lzQ/uYSv
	oBaQg+D4R3EsWZxhM9er8tgqFmU5qnAow9wo8lRb7Tuk788Usiy7e+kfNKwG5MWUp7PTR44
	EEiu3SFkzHtzy10Ig5iUwu679y64IWpI+6w+O+4Dvp73EdmMxVatMaV9umFBAGWcKDkaZmx
	1O30ADExSNb+/feV5LHeDnw5u34MuB0aedwGgEht5r+JR+BlLkqpyvMxfExExvJNBEG/qaX
	0oXADI0i7QEkkmz1nY6w/CqT1qu8tQGlGtsx7neDgYd3e8aBqABH1I/rDsFwQV6/s3kfLbp
	AU+MrGkp/XZlvKr4FY7ODPxVvOLQcXm2KM5PuSIQ5Vmoc+UZSP6tUaCNrcOFWJ0aXPAbr7z
	v5IDGbcvAbWGMXng1rqytx3Wh5yjFGixJjOiIdznZ3U9FBJl60DI/Kgd7oXZAePHkR8s3Fi
	tPLOjDxW7grPcY/5ORMTFWuPC8xiUab7nuy6f69daUwBt77hR1VQuBubTXp5by6i5cR2Phw
	UxuyxLSuBfEGSJCLjmyIf+rNPMuoY=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

xfstests xfs/377 can make xfs_scrub repeatedly check and repair the
attr block map after inode repair zaps an attr fork.

When inode repair zaps an attr fork, it records
XFS_SICK_INO_BMBTA_ZAPPED so that scrub/repair can revisit the attr fork
block map.  If the fork has been reset to an empty state and removed,
BMBTA repair has no attr fork mappings to rebuild and can return success.

The post-repair scrub then runs with XREP_ALREADY_FIXED set, which means
xchk_file_looks_zapped() deliberately ignores the stale zapped health bit
and asks xchk_bmap() to check the current attr fork.  For an absent attr
fork, xchk_bmap() returns -ENOENT.  Returning that error prevents
xchk_bmap_attr() from marking XFS_SICK_INO_BMBTA_ZAPPED healthy, leaving
the zapped health state behind even though there are no attr fork mappings
left to check.

Treat -ENOENT during post-repair BMBTA revalidation as a clean result for
the zapped attr fork: clear XFS_SICK_INO_BMBTA_ZAPPED and return success.
Keep the existing -ENOENT behavior for ordinary scrubs of absent attr
forks.

Fixes: d9041681dd2f ("xfs: set inode sick state flags when we zap either ondisk fork")
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
---
 fs/xfs/scrub/bmap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 70028da1aacc7..0cee51d4338e4 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -1170,6 +1170,11 @@ xchk_bmap_attr(
 	}
 
 	error = xchk_bmap(sc, XFS_ATTR_FORK);
+	if (error == -ENOENT && (sc->flags & XREP_ALREADY_FIXED)) {
+		/* A repaired, empty attr fork no longer has mappings to check. */
+		xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_BMBTA_ZAPPED);
+		return 0;
+	}
 	if (error)
 		return error;
 
-- 
2.20.1


