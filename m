Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E1413AF2
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 22:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740089279; cv=none; b=D0LC7XbYb4tG920nMLH9s/YEdc2PceMiPVxm/e77awk8keepqFa22VrFDS1yhyZS15Y08UZIQ/Uc4bceJGcWkcp+CJERZ3NIRLBXLO9jc/pgLXhY/rE53zIXEG9VIHBtsP97dlZxGpmFCTwvRudFZ/pQuqIBDgfMqVOf4nnDIEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740089279; c=relaxed/simple;
	bh=nch0D7ubk7sEsrZ+3egyO/0P0+kExtib5FOXiUELGZI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tyepS3XcQaeVRIjEyOEPJ1Mi1zv4dOuODzrtI4SxIx/3c8vcNwx3a93N4mGvAIEqqvd1yLYNoT5BbiKJKyPQfdoiuQ/84RxsdLPX+id6dkF7+xgMLzaKnLk9d3R/jzlms0mRrZQ9+9SF8t/v/CBjFYFo/RLxiJJm2Wc2NWLh/c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=juFrm3gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="juFrm3gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A13C4CED1;
	Thu, 20 Feb 2025 22:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740089278;
	bh=nch0D7ubk7sEsrZ+3egyO/0P0+kExtib5FOXiUELGZI=;
	h=Date:From:To:Cc:Subject:From;
	b=juFrm3gciVU/qNjGfBjDEkN64V1AZul9l7aE8+LoJa3ztcwx5ALx67ZJwVUc8lU/r
	 zJEUlVVi3WK9EfpS4v4DwtuLhDp6T5SwSfK7s36yTudyAVvV5xkU+AYyXMm8gyFGAo
	 tlnnT4hDd7SX9g85SO4pEjpd4bcZLZivDfpd5dMvZdBrWADBzr1XvDUeo07R18GXtO
	 lRlFC8c4q4/jwglPT+FubcvLxBigj6rpo+LHx0NfrXUiDnnBPp88wZsOGPqcfSczFY
	 dPu4Cs7i6sXqff8eoUrJCSenENF0+toutseeMvN+jw1O5sjnJuYl0cEgSD/rxxdcyi
	 3U/uC2ZgKnHHw==
Date: Thu, 20 Feb 2025 14:07:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, hch@lst.de
Subject: [PATCH] xfs_scrub: fix buffer overflow in string_escape
Message-ID: <20250220220758.GT21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Need to allocate one more byte for the null terminator, just in case the
/entire/ input string consists of non-printable bytes e.g. emoji.

Cc: <linux-xfs@vger.kernel.org> # v4.15.0
Fixes: 396cd0223598bb ("xfs_scrub: warn about suspicious characters in directory/xattr names")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scrub/common.c b/scrub/common.c
index 6eb3c026dc5ac9..7ea0277bc511ce 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -320,7 +320,7 @@ string_escape(
 	char			*q;
 	int			x;
 
-	str = malloc(strlen(in) * 4);
+	str = malloc((strlen(in) * 4) + 1);
 	if (!str)
 		return NULL;
 	for (p = in, q = str; *p != '\0'; p++) {
