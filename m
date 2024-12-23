Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A3BEAF6
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992313; cv=none; b=BdrZgYiwVRGxY6P6JOle1ESihjQO3bJuT5JNjH3Fv/+WGfFs3ual8844wVK3a5ngbbK1M9yfz9ph73mXz1XieXAGRgRNzYd7AqEm07wabH+HGoHSIzjzacSkbgYR5tSlw40SyjSgEH+Pdq7CRoiKJ/tB48AZJJh4VqjLFvG4WVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992313; c=relaxed/simple;
	bh=SjR5esQM5cTgIvofWVB9FXfnr/d1oI1WvibLAOIYsWE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BLV2kb1ebJTbbU3X/utAkOn+cgXdGdKf7A9Eea+xiQc141DU0BkpeTwuaNyNwmhOpoXrFSnzK8x0YEP7IJmR+pfftnVrvsoxBWf95+QN+fyuI2Vfk1X4QEaS0XfOZEmc/vJyb1SS+5EqB0hoiU+dUz0fiktCN5BYHsN/sKrsdo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EPVzoWGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EPVzoWGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58C4C4CED3;
	Mon, 23 Dec 2024 22:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992312;
	bh=SjR5esQM5cTgIvofWVB9FXfnr/d1oI1WvibLAOIYsWE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EPVzoWGuiQG8um5Gfsq6Ce/03NfJ2VeNbum+KhuU2SQpFLj+KyrHW1i2jIBezz+Fx
	 +yYqFnPPMgFEmGgbPbmcqTcoGuN+ntKpbEbbI9cl1/FwyqOMOJUTyc3PgEKW1ubIkL
	 xQDmg+1FCgSxWzXTWpk0EUNOFfBLIdoHoRhLbLFvAGTWEsycITb3HxFCqvEIj4551d
	 PrjCzG/G2PH2fgjqc6M0lI7TUu4jq8TrjQxPqfQn38Nwwu5kzR7Z+dReV6Asc329Dh
	 UCNGUa6lPG9hjWxSTVLeN+nb5oryqHVJVVjCgoNGxNlTx6YVRgaHy46RHzXZflS9ZF
	 awgA0siHqCZNQ==
Date: Mon, 23 Dec 2024 14:18:32 -0800
Subject: [PATCH 26/51] xfs_db: listify the definition of enum typnm
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944202.2297565.16068425676009397741.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Convert the enum definition into a list so that future patches adding
things to enum typnm don't have to reflow the entire thing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/type.h |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)


diff --git a/db/type.h b/db/type.h
index 411bfe90dbc7e6..397dcf5464c6c8 100644
--- a/db/type.h
+++ b/db/type.h
@@ -11,11 +11,30 @@ struct field;
 
 typedef enum typnm
 {
-	TYP_AGF, TYP_AGFL, TYP_AGI, TYP_ATTR, TYP_BMAPBTA,
-	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_RMAPBT, TYP_REFCBT, TYP_DATA,
-	TYP_DIR2, TYP_DQBLK, TYP_INOBT, TYP_INODATA, TYP_INODE,
-	TYP_LOG, TYP_RTBITMAP, TYP_RTSUMMARY, TYP_SB, TYP_SYMLINK,
-	TYP_TEXT, TYP_FINOBT, TYP_NONE
+	TYP_AGF,
+	TYP_AGFL,
+	TYP_AGI,
+	TYP_ATTR,
+	TYP_BMAPBTA,
+	TYP_BMAPBTD,
+	TYP_BNOBT,
+	TYP_CNTBT,
+	TYP_RMAPBT,
+	TYP_REFCBT,
+	TYP_DATA,
+	TYP_DIR2,
+	TYP_DQBLK,
+	TYP_INOBT,
+	TYP_INODATA,
+	TYP_INODE,
+	TYP_LOG,
+	TYP_RTBITMAP,
+	TYP_RTSUMMARY,
+	TYP_SB,
+	TYP_SYMLINK,
+	TYP_TEXT,
+	TYP_FINOBT,
+	TYP_NONE
 } typnm_t;
 
 #define DB_FUZZ  2

