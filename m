Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E63479CC
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301626; cv=none; b=WRvnGGzuDFZHu9GB2bXJ2felSNkrkKzizM22PjeumHtZoJpCDY7tDcoRJ8InPUS98AzXDJTCOhxDsa59H9lxLTqP5UoeDhoZ7tqMuEDVItEacugdoi9F/kveSOmCsu2fDELjfT3rp7GENheZ2KeTC4wlEzUr3fKWU5/SR/vcMR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301626; c=relaxed/simple;
	bh=HV883gwiwCo86qWToZxiQrD1tSoKqRiYuZ4qTl1jfno=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=csrGD/TJ64CCDNqDcoDUDudioPR2XxZBAavr8gnD/FoPadU50UxTd7OjnQzhOBXh3rpMYZF53bMN5Zw3puQ3LDOYva8JSwaMtWOCN2eoDWCMctQqkwOwx8tQCM4guGQojTRLbaqnIJJIyRCk7OL68eKMHrt0PKwf+pu07kXUp/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qG0ad+px; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qG0ad+px"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49715C4AF0B;
	Tue, 30 Jul 2024 01:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301626;
	bh=HV883gwiwCo86qWToZxiQrD1tSoKqRiYuZ4qTl1jfno=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qG0ad+pxKIjAjg74HoYHarHddbobMWWkT1pr1St/i5c8uBKEawWdWJDyEIY/Yrm3P
	 hX43Y4YOghunzRVH44FO52BlddbNbJ28meJYyub7+gW/hWvSVC+vVYaw9Y/NqS+izW
	 5RBnauhtty6Rba/qUhgSNRes6Odyg+6sdMXCBji7SNqtaZ378g0bj1uJxB9Nbgju62
	 80GVKbCCrCY/fk/wEJq3OMURwzWTpIOeyoxts1/AKMVqXNzoBn60jqilOQgrUCAC+M
	 NfeICrzXpi/hjPl/pWSoU1heUTiBspOz2/yfU8BfGbF7FLlYcL6vWSlkhoh/s6cEoG
	 WKMW8JTfmi1Uw==
Date: Mon, 29 Jul 2024 18:07:05 -0700
Subject: [PATCH 05/13] xfs_scrub: guard against libicu returning negative
 buffer lengths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229847607.1348850.1430158585543881123.stgit@frogsfrogsfrogs>
In-Reply-To: <172229847517.1348850.11238185324580578408.stgit@frogsfrogsfrogs>
References: <172229847517.1348850.11238185324580578408.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The libicu functions u_strFromUTF8, unorm2_normalize, and
uspoof_getSkeleton return int32_t values.  Guard against negative return
values, even though the library itself never does this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/unicrash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 4517e2bce..456caec27 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -189,7 +189,7 @@ name_entry_compute_checknames(
 
 	/* Convert bytestr to unistr for normalization */
 	u_strFromUTF8(NULL, 0, &unistrlen, entry->name, entry->namelen, &uerr);
-	if (uerr != U_BUFFER_OVERFLOW_ERROR)
+	if (uerr != U_BUFFER_OVERFLOW_ERROR || unistrlen < 0)
 		return false;
 	uerr = U_ZERO_ERROR;
 	unistr = calloc(unistrlen + 1, sizeof(UChar));
@@ -203,7 +203,7 @@ name_entry_compute_checknames(
 	/* Normalize the string. */
 	normstrlen = unorm2_normalize(uc->normalizer, unistr, unistrlen, NULL,
 			0, &uerr);
-	if (uerr != U_BUFFER_OVERFLOW_ERROR)
+	if (uerr != U_BUFFER_OVERFLOW_ERROR || normstrlen < 0)
 		goto out_unistr;
 	uerr = U_ZERO_ERROR;
 	normstr = calloc(normstrlen + 1, sizeof(UChar));
@@ -217,7 +217,7 @@ name_entry_compute_checknames(
 	/* Compute skeleton. */
 	skelstrlen = uspoof_getSkeleton(uc->spoof, 0, unistr, unistrlen, NULL,
 			0, &uerr);
-	if (uerr != U_BUFFER_OVERFLOW_ERROR)
+	if (uerr != U_BUFFER_OVERFLOW_ERROR || skelstrlen < 0)
 		goto out_normstr;
 	uerr = U_ZERO_ERROR;
 	skelstr = calloc(skelstrlen + 1, sizeof(UChar));

