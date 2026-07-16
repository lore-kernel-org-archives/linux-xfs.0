Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1D42EDD78;
	Thu, 16 Jul 2026 09:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784193853; cv=none; b=hyA/z/L76ZMHywfQeWG+a7AkzKZoLNiQhrW/OBBlf99uzGd1KnvA6atwAISg2MZ/2lDBz1lba5gsX9F3f0wYln/xygGAfNC+Ws7/KYao3thuFlQkBW8nMde6vWngi9tXObnfvLuoM108HTOiVWzBYN5jjfIGZ2Z/8fLTkxyutb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784193853; c=relaxed/simple;
	bh=Nu+RxB/Gh5omp7YkDzMU16A77EzDLq3kPeJMzgFDgr0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=i5tFuXt2toHIH11g1d5Npr5TzMjn/cEp88ejGSiBrOYqGhH72GcLd6lAl6JxEJTOesqKLd7RhfHQLvfYgueSWoSbB7eAzt1L6ajasHKGrOxupGMqp6d2YBt3an3tSnKVhgw9sq0tUXBwzrW7kF4xh6nPf2+G/ZubHRkuRJ7e9vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=lfysFO66; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="lfysFO66"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784193798;
	bh=dQm/xOoQxhmd7Z4KU4LlwNNATvc2uZD+sB/1VJ4glWY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=lfysFO66IzyVU0y+7fOWSjEung+jxcVFvPo3JW/ONR2gwsm6h05bgD8y34EAYNpEa
	 BHjxX6440Glx1eEgDAn+BmCEHWTxWnkVNmulz+4cnyxwb7pHKG2K/EZTzAwUzt3yc1
	 kDmRbOESE5G1vq6zihEzdsMKUcBK6c7VqffVEarU=
X-QQ-mid: zesmtpgz1t1784193781t8a31d514
X-QQ-Originating-IP: QM7MTl46LltyGzAVW2FTPGPkSYUidmi0vYLUVxqLgnw=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 16 Jul 2026 17:22:59 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17191938862874866410
EX-QQ-RecipientCnt: 7
From: Qiang Ma <maqianga@uniontech.com>
To: cem@kernel.org,
	djwong@kernel.org,
	hch@infradead.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiang Ma <maqianga@uniontech.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] xfs: clear zapped attr fork state when bmap repair finds no attr fork
Date: Thu, 16 Jul 2026 17:22:45 +0800
Message-Id: <20260716092245.1847930-1-maqianga@uniontech.com>
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
X-QQ-XMAILINFO: M6NtOza7l4PFlQmfMSdWdJPa8tE4UIi3fVnF/BFD+6AtKEB3ILUI22bu
	hO5EcaZiEFy/4BCWVHyWo1o7/AcNEAFE2E7VTDvc78OFj/oUWeqQRJlB60tnN+ukxBkgBMp
	dmW7QZiwO7sRASO9NGSpqQoWU75dxxlf40yM3mOsSZRnAx3I3VSCNXJ4C2I0LDu+Gir+ByL
	vFOhMUXIEcPbYEmQYIwK8EUOgEeXnnw/4bnQ+VWzZJWRsqs2J47wLdD1TPAbIMWd3EPk9o0
	XkfIbwL/yrd0wiSZ1523+Xs1H9Cjs2jnUlbo/gXPlGLOdqEWf6DqMeC+CIFFj5CNFMSD19f
	0PnsdXk2EBjElxz85jzKiuPnfL4eu5d+S5wKRyEsbbPEKmFAgpB2Qtt/lcDxdUfnLMJdm9P
	9J9otjhCaUF8bij5lJHK07va/2eXo+gN4IgwYCuRi/5SFJXmiiziUyS6NjvCPc+bl9Y8iZj
	4ZE74lNTpENWbnJ5w+u5xQaSZIl2dB0pxfkDiTAjTC7JvIPqB9qP/2tOPB0xW1Bj5WGuSWH
	fGFeya7AiAs5rbeJRXkJxqHeLGpL/jMjMWi1OX83eH+JpTVD22DEDzOt1tQZr66TimCJGW6
	bLuYDj7TV2qnjSSoFHRRyuau7RCkvqsymoTtrykmB5DNhabVUgolRpdv2WAyo+o+NednOkf
	LjICggfs/MvbsFzCI9Qd8aO//oSxivTeXGh4KpOQVabDsQ8QqgLtDuMK1UFvQsl3ekdNVmR
	1aNRW7J0Bcv4zSgyOqcdD1aeNdTXfZPgUwDH8aJFv2138lPfMKj5WONnzZChz1VmNz1BCAZ
	cj8yWi8io+rElisjedXAXCLuHGLrrbhMIhJdo6+Ez2ch7i0im881Mx2UlN7/2D2/ZRrkVds
	KFZQ76pnsGc82THZrncRkNJE+ClsYOgLtdWOyruNqtYV0GmN5w7/GN6gnC+uCWfhVfQEB0o
	wFa/mY5Bm96FWUNCJESu7a2eMDLbE/DWj2S18FJpnqaylE74hyIbnRl4rGBFuGoZn7Jfh/t
	O/KJYK7MWCmOjd6q2aRqjZKchUzllQAUEvg3pDKUvzei03ipp8
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
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
Cc: <stable@vger.kernel.org> # v6.8
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
---
Changes since v1:
- Move the overly long repaired empty attr fork comment above the if.
- Add Cc stable and Reviewed-by tags.

 fs/xfs/scrub/bmap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 70028da1aacc7..401c278725d21 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -1170,6 +1170,11 @@ xchk_bmap_attr(
 	}
 
 	error = xchk_bmap(sc, XFS_ATTR_FORK);
+	/* A repaired, empty attr fork no longer has mappings to check. */
+	if (error == -ENOENT && (sc->flags & XREP_ALREADY_FIXED)) {
+		xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_BMBTA_ZAPPED);
+		return 0;
+	}
 	if (error)
 		return error;
 
-- 
2.20.1

