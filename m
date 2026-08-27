Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B4C30C168
	for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 03:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787802582; cv=none; b=gPGDhjXqaUB4Sxe6tDiKkHCHRCGi111HyY2sB52p5KQwYNfNPaket/9Kcq9nXC6vKCfbT/q6AiYpTRezsxxywla0yHTH5Vhnyib00setJzjBRWDKABb8zltge+syr1Fm4TBVASOPDM4KhmJuhlC6DvufXbC1qgSf0svRnYOj1tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787802582; c=relaxed/simple;
	bh=aN2/oIEqIdRgQGmd6bAJqljbhmOswDsrsCyOY6LExEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NkjEZVSbJmn8o5tXq4PvEIvzF8qb1VntAGT6t7EhdB2J0WzAyGOuG9HKH9dNK/LnY8jRkwcc696qnTNQMvvrOtX8IWTlmZSBW/+0OcC+D0QtHHoLdVtdG3qpmmblXICm1orQZ7+XRdu3e97Cf5Z/xTqsaX6iHnaXXmSEVLeH80g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=K5Bz9nvn; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Rvovbq1F; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="K5Bz9nvn";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Rvovbq1F"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 17FA0EC0263;
	Wed, 26 Aug 2026 23:49:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 26 Aug 2026 23:49:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1787802579;
	 x=1787888979; bh=XLWGOX/k542ozCwgjwvG4OlrOmVY9d+Kszzz2lazRgU=; b=
	K5Bz9nvn6ou5zeHHmkGRGBrtUekaP0THlhZbChvGVhkt6dHUvchtA+xpf0soggda
	LPQpURm+YQyGfDdrlybUL3w8BpYsvZNHTUFsGxJS9qzT5KGXLBxX1iFYoLPwkk76
	YnvPqKCZldzvZiq7Gsz5do5w4ZzxmcbBaFXBDkA46o/j2Kg2ARL1tMk2nsrAOnkY
	H7Qz65UJi2ud2d0jefB+OLg691sbt18yhgycMTRw/mv6icrZodz6vZcyP8J2CAxS
	JlfWFXKNBHd0p8nY4nLR+qvwUXwBo9Kv3/RWaxwTcb7NYvb+yoFTbbgxRqnqxE/R
	C+oo8lWr/IgaE5/U3bZJ9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1787802579; x=1787888979; bh=X
	LWGOX/k542ozCwgjwvG4OlrOmVY9d+Kszzz2lazRgU=; b=Rvovbq1FCa+8kv8Qy
	rU7eXQFvureyL/9LehhVnejgkJ3qTzFQXG5qBlVbXdnYI1mrfT2wH0aK+bOOVy6F
	K8xL4cIIJjKPHOUiHFLlBGPbJFVi4cfQMBfACOqAKLFZJIKn4KStG/r9xIycIH+2
	gsv7NeFbIstz3aU9AGxs45aDcTG5LeGP7+Fpr1zKfjELFbahYihmYa4VziwwtGT7
	Wd8FhWSovev1warQncIhwPZKXHzIzFmRyQHTSrEVta77kmpaOUQL2jVvZwWY4IZA
	qmGXJ02zeE86FxKUmR0TkID3vs6lQmjht5+Xgo6GvFoNaOE4PYvwNP5jOLYGGMPP
	u7RIQ==
X-ME-Sender: <xms:0rOPamJAU7KBGjgiIyT1y-sdN2X-XbsxhUKcGmzEzGvjD_HJGD6LHw>
    <xme:0rOPakIVNugEWC1pLaCrpd7YpLupvQIKQgIlNY7S2-SNnyGNfrrqoq58BCB81Vlb9
    1n00JWH4kcqvqnDzEo6Wpzsd4G6CDTOxqf15QCVAV5iuFrwoI2UfyI>
X-ME-Received: <xmr:0rOPakVPQX8PpnMI45q8hLWH7aKsqQ-VjbkvdqJt3TPk48of4n2pNHMFtpt9Ex5OSEk5zYg6M8lvn4dfBVgbSuyR>
X-ME-Proxy-Cause: dmFkZTEYLsNjwZvR8LgUNK4gNCDUAiT3hvNVWL3dR9rFD+8x5Bhs3FKPrZVeUj/XCrCBlc
    2JLs7/poT932usHaBwNmrP6R/eTj9hJ8NHO0LeMr/Y27b+vqciCvBa6FvP842QHbdh6q9d
    h8jx49hRSIx1BmObd7R+bDgn4+6VgV/A608wlK/f0obkzyilFQDXiDlcFHATbXBVJ8pXUM
    Zd6VDKYNQQpTAnUf7dXSU/Pt0+kGzGFxCKrP3bUH+9hq2NLLo1tzrP/CtdA4tCGtGQIFTH
    Eo+1ALT83FLRVVwjmjwMypEg50QtAeunQqnpeHqznStKNNCrN8fdLD1l8slR5l4wHUY9jH
    DEcfSsfGGRu2pi+n9U2rU+YDz7SOQErwLVZois7qCV4vWwIpMzHxstK2w9CMXepNtgb6qr
    p8ETmSd4M9qbcfoqtG0lbxgT8TrffibucGlGbEGn8PBS02ql2VjGoY72KTyegnOtHxbAlW
    gv+URjEujITMvKf5U5LzBfuhX0iVbz9MR7jxYwn9cHM67KRpSVxwnhLYiPVKANaF7mi1zW
    qtuwXirUEU02KqhmVjzHI4LnafERoxgLq2aWoiFvyMoOUHDI+e3OkDWncaqMwpwY3mU1a1
    33Z/OE+jbc0YLwJ4J8rI6DBtOOUiNxjwzabSqwSJJZe5kTPj8T5j8h1H1orQ
X-ME-Proxy: <xmx:0rOPamgHfe1pTrfW1lqiZGD9kA_2FswlVAoj5d_OtXJ1vqdwKH0lmg>
    <xmx:0rOPav8UimDK9YcQ0CD9LqmHRVVBWEqzjfcAyDjWUVpDhdp-J9Anrw>
    <xmx:0rOPagD2U0QiB4D9KwLvdukJNoQcYuix_tx_mM-ajcnfHT7YcLT7dg>
    <xmx:0rOPasJwWCpoWj-t5c_Hx7vGczDXg6WRVYtxgDhdrlDNGEYNXiC3nA>
    <xmx:07OPapgnCvJuAx9i3AuXBK-Fin1pgMX6WwWJGSTcrvu6whrcys9C1uTQ>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 23:49:38 -0400 (EDT)
Message-ID: <a1864929-f3df-4c0a-ae47-019cda875c99@sandeen.net>
Date: Wed, 26 Aug 2026 22:49:38 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH V2] mkfs: Emit a clearer message if too-small log is due to AG
 geometry
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
References: <20260827034228.938740-1-sandeen@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20260827034228.938740-1-sandeen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

There is a constraint in mkfs.xfs that logs must not be smaller than
64MiB. We can arrive at a too-small log without specifying its size,
though, if we specify so many AGs (or such small AGs) that a single
AG cannot hold the minimum-sized log. This leads to confusing output:

$ truncate --size=500m testfile
$ mkfs.xfs -dagcount=10 testfile
Log size must be at least 64MiB.
Usage: mkfs.xfs
...

because the user did not specify the log size at all! If this error
occurs due to the AG geometry specification, make that clear with a
better error message.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 mkfs/xfs_mkfs.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

V2: Ugh as soon as I sent this I realized I forgot to restrict this to internal
logs. An external log may be too small all on its own, unrelated to AG size.

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a4864c37..4f11c9de 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3456,8 +3456,25 @@ validate_supported(
 	 */
 	if (mp->m_sb.sb_logblocks <
 			XFS_MIN_REALISTIC_LOG_BLOCKS(mp->m_sb.sb_blocklog)) {
-		fprintf(stderr,
+		/*
+		 * An internal log must fit within a single allocation group.
+		 * If the user specified the AG geometry but didn't ask for a
+		 * specific log size, the undersized log is due to allocation
+		 * groups that are too small, not a log size the user chose.
+		 */
+		if (cli->loginternal &&
+		    !cli_opt_set(&lopts, L_SIZE) &&
+		    (cli_opt_set(&dopts, D_AGCOUNT) ||
+		     cli_opt_set(&dopts, D_AGSIZE))) {
+			fprintf(stderr,
+ _("Allocation group size (%lld MiB) is too small to hold the minimum 64MiB log.\n"
+   "Specify fewer or larger allocation groups, or use a larger data device.\n"),
+				(long long)XFS_FSB_TO_B(mp,
+					mp->m_sb.sb_agblocks) >> 20);
+		} else {
+			fprintf(stderr,
  _("Log size must be at least 64MiB.\n"));
+		}
 		usage();
 	}
 
-- 
2.55.0

