Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66993F9F20;
	Tue, 26 May 2026 12:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779798802; cv=none; b=jl+njtFI0hCZRcyeJQvjzbO10nXALm1ZVRgpcX3SPRts5OvNaaWxZtzu+m44JdqN1QqPRsLixQ4KdFZXodIRf0bNq+Px6D4/HCRe6ElECbJrbQOOK7ICwWUzamK8JfkxBbr5/wE3L1G4OwWgGuCuqQjHqeoDUKkjWBunYEuD050=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779798802; c=relaxed/simple;
	bh=AMtJttOvlD+gIPcPblslUbJK29b/IZh0VeF2aWb5xIg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rPQ0od6zsCE3V+VnLnfO0cbehmAh40bjP0+QTsvmQNIninq3hFLKtwwqAya3laL5ssKb+YQoewTidaAOVY+3Dh4UFCnIvGkgNem8XJ0tZxQYjntuceygFIQysddrjsPE/Gd4cznQVi3BgOAya1RBZiO+Ib+T2cqhHIBtlXpk+ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=ObqPSM1R; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="ObqPSM1R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779798777;
	bh=HnXnYYfJIh8r/AeHcKb5dZ88fCwf5GpkD4QQ0bkrv1I=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ObqPSM1RQgWyjNH8gXTY8RgTBPcBwHIBAIOWx/XLdH8UfacwNj0/c9EyAkRWlq0+O
	 sOhC+7hoZb7FzG6d7BI/jtQETL7rut7Mz49qSAPbJ67bYX8I+KWGwwJr1+J/0GvWNO
	 g22+YdsdjrV5JM+kEmoACrKWX/+6PI7ffaLjFdJs=
X-QQ-mid: esmtpsz20t1779798772t338ea2d9
X-QQ-Originating-IP: BbDABHiK42ls+9M8IONtC+hkA4O5rPBWod3d7MAMfL0=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 26 May 2026 20:32:51 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17762609845750498593
EX-QQ-RecipientCnt: 5
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>
Subject: [PATCH 1/2] xfs: fix error returns in CoW fork repair
Date: Tue, 26 May 2026 20:32:42 +0800
Message-Id: <20260526123243.1078867-2-gaoyingjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260526123243.1078867-1-gaoyingjie@uniontech.com>
References: <20260526123243.1078867-1-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: MP8czXAw5bCi78MP0FzgvGucDLfW2E8fme+0kakIslmdEmgoSSd7tjbn
	T2OMhfMGVIX+aQEKnBmtOR5ch2KJU8ipO3qN00EL8dH4j8441FV2imPCv3Iz1KVr6xU9kjn
	eokjczKOB/UZQ8UI3Uv8Po6TpA16Q5MvqBrYi31ninJm7Za5rohZgw3Ur48MCo55mfjZx/I
	uERfhiqYehQm5TnWj4uu7NX6NHhlv++ebUFFomSkT6Sc3vBjd4rLFgHQhDLrHB6qdH/Gq5x
	HLZlBqYdhM/j7s9zs6LPSpwrxl6Blm74hwPccfbqtOCJcuo6MO04FAg/lr0ln6w2zLp13nS
	SdnEPlclfpfKnUdM/jRSanXH/uxIs5U4RfxNF+40otBvaOL9UpSpXy5TOUYQkGudP2ypk8Z
	GcxrbRagvMm/2EQJb7XmgMH/hHtUL954VPdhbDG/cSX7UWArJd065vb7KDrpwqeGcxVXGNk
	rnj/Qqw5jiBF+xPT463KU/XVBVs/w0FNog0xd5dieKSRyBCmN0S+/OqCIeji9t0f68tYgNd
	QaE470JNF7RY95cxaaarcUTsdbsUIDCUbahBSonhYgAB0x2wNxUmjuV0lOPjsXuQit75X8d
	5pvTfhfSV0hp+VyAuVqSWxISDV9AKIPEcDdGo9Udna67qs+J8N0rdI1YbPtUcuEm6QbWika
	p4bN+6UMEw6zoEicwBlfeqzA5VMXaAFCnjjXkeOfgCo4nrRLruNZwHSSyNL69VADpuyl6F3
	3IYVtuDQCkNoz8SO8rKTUZJNyOEJ3+8neZ0fXQ7ickotfwCQeO8pEyc7cP8G0CciNA8iG4J
	HZjiRbpFO9oRvuAiBIg6yJZT7EBZKM8EFI97frT5/NhAU26cxqBa8X7ytt1mCv6R+qf3jcw
	Gl14udVzh2/PB2QQQZLbyxX30rBSgy/KxuRB1WDzUsI0CvksBfvAJsUd4JjsFJZQatKM2TL
	bVT6uIyxvy7IqRbcaJ3qKt2D0YyHBEIBl7cC1YSrHhCmwbdFwWS0j4gIY6twull3jHXCswn
	03YS+85Dq7LuI9WsUtzl5coH59z4/LzxqLXBmbvgEmbDjjlAu50PryzRxbvINE4WExh4mry
	fP7wghaTM5wtDzEjoeZpP9b8/99CkZ0qA==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

The non-realtime CoW fork repair scan returns success after the
common cleanup labels, even if the AG setup, btree queries, or bitmap
updates failed.  This can make online repair continue with an
incomplete bad-file-offset bitmap instead of stopping at the original
error.

The force-rebuild path has the opposite cleanup problem: if marking
the entire mapping fails, it returns directly and skips the scrub AG
context and perag reference cleanup.

Send force-rebuild failures through the existing cleanup label and
return the saved error from the function.  Successful scans still
return zero.

Fixes: dbbdbd008632 ("xfs: repair problems in CoW forks")
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
---
 fs/xfs/scrub/cow_repair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index bffc4666ce60..bc3838bac71a 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -304,14 +304,14 @@ xrep_cow_find_bad(
 		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
 				xc->irec.br_blockcount);
 		if (error)
-			return error;
+			goto out_sa;
 	}
 
 out_sa:
 	xchk_ag_free(sc, &sc->sa);
 out_pag:
 	xfs_perag_put(pag);
-	return 0;
+	return error;
 }
 
 /*
-- 
2.20.1

