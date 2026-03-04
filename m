Received: from smtpbg154.qq.com (smtpbg154.qq.com [15.184.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C7717BCA;
	Wed,  4 Mar 2026 11:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772623856; cv=none; b=co/It8Pa7hVXCDt7PIc/nc+/KCKrDe3TiaYAdxvh1aJ+7Kyzq4CZuYz5qEhEXdmqSsVcJpqp0gvzkOU8UmuFW/KPCX91PTXV5LvOM04vdjbiZKtqBzCFcNfZrOw4NqFkFt7hUgtJnBo1kfypUY5KEaEo+JbMKBZ5Bm49TyY4nG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772623856; c=relaxed/simple;
	bh=/DAPR9YQ7YDAW8oZA7Qwt3fLuAbtVrpSy8jC6ChRBIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCHMzKhF/oxGK2it/dc1tG6MwWePYdScpqQm1OTUKIi6UVysDZj+LiHai/e9gLm/3jfpIKB0q/uyWu6dlRwKQfj8uMSz7xg/dorPtQvCW7Oev5buUP9ZvaN06Ndn2peY02nvzGPD+830egJcQueYcn9mC3rvl90Dn8alIgaDdso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=G/8DkeIE; arc=none smtp.client-ip=15.184.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="G/8DkeIE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1772623780;
	bh=MpENa8mWUxuwjKdTOrasJ08UWYdELB3KH0mJp4yoAzA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=G/8DkeIE/Jr3QRH9X69qKEBGyKOZkMnqdKNFbnX/mdoa6R4b9VZ9kzow9R03gAZ4d
	 lnEejDzfHBcgWFmkfkunowNcwDkUSwUDlhNceqbPx75Y7KYrte0ZvksEtEtu2EpUZ0
	 1c8RYT0MK1fxzpIAoIxRadqu4m/H6kJKP/C2NoYQ=
X-QQ-mid: zesmtpip3t1772623764t823d88a5
X-QQ-Originating-IP: Qj2980G7g8byIFySsnUrKZuXHUTt8e0jQmCCZP8U0n8=
Received: from hongao-PC ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 04 Mar 2026 19:29:17 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4117823029604281760
EX-QQ-RecipientCnt: 7
From: hongao <hongao@uniontech.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	sandeen@redhat.com,
	hch@infradead.org,
	linux-kernel@vger.kernel.org,
	hongao <hongao@uniontech.com>
Subject: [PATCH v2] xfs: Remove redundant NULL check after __GFP_NOFAIL
Date: Wed,  4 Mar 2026 19:29:14 +0800
Message-ID: <505A5848AA49D10A+20260304112914.599369-1-hongao@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <B6935AE39B8FFBF2+20260303033332.277641-1-hongao@uniontech.com>
References: <B6935AE39B8FFBF2+20260303033332.277641-1-hongao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: MSyoPQEuxKCuFQgrWzu7mfvoLsb3J5wq/+XtbluHfjQtWT414f9pDuGF
	xGo7E3zEVGk7qm6XQ9OcDRNYupTA4e8uP3HK7wd4vmeBLPyUV7+wIbgbIS0zeXdcMUlonSL
	/LSVduwz+LH9hhZ6P2kMwrUusjtKXXKDniGJMfgaGcpSrzSXNHG2Hp/bU6KvCghcG6ZzPG3
	M7HPdIMTOrorxWJ98UekBKlSrZrYEJAXLBr10PnVkOuCJdsUNCzaZVgzf9hpEOt5xgMHV89
	4fTGLTiP2OVRIelY3w53kMWYzW3sbhbsqflOo8bJVxkpM36LS0oCKYnmvVOKywlra2rIo9W
	VA28UZ2FjFR92O9OGFkYAVq5qj+sMNeG2vKydwAFTWhmUYMhwElh/Y1b4c0hqkC+PWFLiaz
	d6CyvMyS0dXJQDyTgb3yDjKjL3rzeTyEsGDNqECZna1tJPlXx7b4TCUKTsZ4hfjw1yrOnrb
	M2QGKACc0o3/sxQXQ5SgMPDxL4L0xaBZKy6PeYdtcWvE0T+Q7m8aULCqV/zgmEvaeyr8YJB
	D4elVISnKDKH7uNVd8PusBkAyZyprd7CGREqEmmTTzOo7IdAcSK6drSDTQAx/rO7mqtbhO0
	vq/2s/RI19yN8oKqJVsN5cZSUHSreruXbL6kma529zPkgyl4dm/S9jgz3BSQLP0eC4lIPmE
	Ppx1ZK6SQMBMYP1F2gBN+5Xm0Kb1TjzfepIYmAZD2W+K7QucogKrhSYE/dw5vdYXxRmDxPJ
	mnSwU9EuHXsoae2vMoSd/zQNfR0VZ2LU5POIBeAS2Y5ZM/4cOBO9jKOQtkPe28mQknHrhs3
	e4jIXJjSDNeV2DUHijB5TEFbr3TLJoUKgGVO5eTkUAXwh3330e2J05BOuDbayFqg8yTPsOO
	tm+IUN89dO7uNt6S+uHFj1uSNTY44ZXs8Ud3mkXzaTYJFxVqo7tWdR+vtKFzip8AJN12Rg6
	dHh7wKBMqxd/o1Y1+SiCjShXQVguM3smXhc16rSxIkhXjEhdNon5Erg6oGrty0v2srdesbv
	IpxKzU9g==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

kzalloc() is called with __GFP_NOFAIL, so a NULL return is not expected.
Drop the redundant !map check in xfs_dabuf_map().
Also switch the nirecs-sized allocation to kcalloc().

Signed-off-by: hongao <hongao@uniontech.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 766631f0562e..09d4c17b3e7b 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2716,12 +2716,8 @@ xfs_dabuf_map(
 	 * larger one that needs to be free by the caller.
 	 */
 	if (nirecs > 1) {
-		map = kzalloc(nirecs * sizeof(struct xfs_buf_map),
-				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
-		if (!map) {
-			error = -ENOMEM;
-			goto out_free_irecs;
-		}
+		map = kcalloc(nirecs, sizeof(struct xfs_buf_map),
+			      GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 		*mapp = map;
 	}
 
-- 
2.51.0

