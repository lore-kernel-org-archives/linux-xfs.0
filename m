Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB0228E8
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530098; cv=none; b=OHOmS/0WII8mQHdP/etmCS9EN2ETSlqqLed2Mzlwsbw5unHC1nBWz526UGS7u3HY2qtos0xPbbW2hoTLnW9TmH2P2Tg35z2QFROFlNQ+a27WiCn/n7LdHksIcZG325B4XcL/OlCivbx+ZiitvprBL93EInF8DJjNSZ+ZsGosDuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530098; c=relaxed/simple;
	bh=76nf2bUGEfcsgUoObG387U47Fq3tYQ4DUSKCwkubYYg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t8NMD0jDFSurBv3rYqa6UqYtoJWccgBNEiWymvfA8/TWRZmIw/463relsNfSWk5JlhYH5fOP6Mn9iuVEADAlOgjmFkvyvD6XkE2SbCRGo/TKXMWNJzudb+qNzhhKTN57jg5rWL96w/F23+XsewJc+2D9z6xrzXbtjetAWVpllmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+7o8CcH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+7o8CcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77596C4CED1;
	Sat,  7 Dec 2024 00:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530098;
	bh=76nf2bUGEfcsgUoObG387U47Fq3tYQ4DUSKCwkubYYg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O+7o8CcHxu16cPWQE92CQpWetkXlSxQm1uZD11mrDSJ/y8UW+wmCwt1J1P6EsV+fR
	 L61wOkEMnpHzN+bjIK8+BdB8XcceKD9Bx03Cs8FLoz83U78vRkVokhAkSDXk+fyW5N
	 J3r/0m4FLiSsf9lBW41Sv6AEznpc+Xi2VGT2ozMCfJUgUkjqdfiIdhvkynMIMPoG+9
	 fKokFkn5Z8BLlp7if1RqHR9Pk1v9nOo5+8WHViDYDW5hdMf7712a/7/xLRVUnwbchQ
	 M4CFXezW9cvYOUleHSbo7v6kiyA/utZKfr75xVSfogHfAsVtc+Ovp5HJhr9mIQaMo2
	 sDHaOlAMQ3SKw==
Date: Fri, 06 Dec 2024 16:08:18 -0800
Subject: [PATCH 13/50] xfs_repair: adjust rtbitmap/rtsummary word updates to
 handle big endian values
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752144.126362.17082355862911716811.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

With rtgroups, the rt bitmap and summary file words are defined to be
be32 values.  Adjust repair to handle the endianness correctly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/rt.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/repair/rt.c b/repair/rt.c
index 711891a724b076..65d6a713f379d2 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -24,7 +24,10 @@ set_rtword(
 	union xfs_rtword_raw	*word,
 	xfs_rtword_t		value)
 {
-	word->old = value;
+	if (xfs_has_rtgroups(mp))
+		word->rtg = cpu_to_be32(value);
+	else
+		word->old = value;
 }
 
 static inline void
@@ -35,7 +38,10 @@ inc_sumcount(
 {
 	union xfs_suminfo_raw	*p = info + index;
 
-	p->old++;
+	if (xfs_has_rtgroups(mp))
+		be32_add_cpu(&p->rtg, 1);
+	else
+		p->old++;
 }
 
 /*

