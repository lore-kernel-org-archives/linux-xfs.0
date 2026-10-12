Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5AF31E82E;
	Mon, 12 Oct 2026 05:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784701; cv=none; b=ioxDuR85Te+7bgt72BnKALKxBypPDNpu+3JAJXAXwcaRPcadJQx/z/U/eFE1RnHRyijp9S84wyUsiS0ja9B8DvVQVEqTDCXio91w7atZZFj/V2263UGHf8+9mQFzzKPIAwRCrqqkw+/XlFGTZ1/92mZzFaZXsiF82I5PrLWmuOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784701; c=relaxed/simple;
	bh=zUoEoiVo8nKEmCCgzsTo22VPS8CFhuIkXccXyZvp2qo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rAeXMTqI5NkcLbQ6jXQraty5Y1dvVDJ15rlq6LJLwqmZ5rt1GYJPHpA6NxthPlwXIIW3EMa+YAv1xqL0ZKTr+gYc3KiH9FpRVxVXQttnTo0ZOJMlximI5DDK6x6KieAEBapbXarcLVQJ9AgDvlKVZ/+7cG9Z9YAUu4p9P8oSW70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OqcAC32T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OqcAC32T"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C614F1F0089B;
	Mon, 12 Oct 2026 05:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784700;
	bh=CCbACEfTRu2dlr+UmG68f4lahNWaA1G3MoX/D7Quik0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=OqcAC32TJYmTXB+7RuH+0JuIMCK/4etIEqJMHFiZlWOFl2X/UOYPQAjUEVQeLq55n
	 c3rQchMP2OCXJhlPtAkry/c/KgPxBJpzj+NJNM8Yb59dYBoO18r5C5rLHhYRyldK+l
	 OAOA6/dKTKPOM4zmWFsDgJKwMaM4Y2nhLjbqSRqYZDokmgnupruSmvJU4ENhVcmx8X
	 gOlEuZCFTTx9GyMULPcAzGsvZOYr/QH2G4MC1lkAyi2rgwGS3niCiWiM3HzTZGW6tw
	 Cso5WEbD8gRcM1Qdvf+vYviL4xG1dvUU3/sP/jAVY0K8hDeFgYvPWjID+8p7mtk5aw
	 maxu1qHCvz8lg==
Date: Sun, 11 Oct 2026 22:58:20 -0700
Subject: [PATCH 10/12] xfs: opportunistically skip btree block checks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065411.1058326.8664681046018160120.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that both callers of xchk_btree_get_block will return
early if *pblock is NULL after a successful return.  However,
xchk_btree_get_block itself can return 0 after flagging a corruption.
There's no point in continuing after we've found a corruption, so null
the pointer out.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: cc3e0948d2686f ("xfs: scrub the shape of a metadata btree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/btree.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 786b1e7c4dc37f..43b81432640777 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -602,6 +602,7 @@ xchk_btree_get_block(
 	xfs_btree_get_block(bs->cur, level, pbp);
 	if (__xfs_btree_check_block(bs->cur, *pblock, level, *pbp)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
+		*pblock = NULL;
 		return 0;
 	}
 	if (*pbp)

