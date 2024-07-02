Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C051BA27
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881922; cv=none; b=KxPkV4vWtX3hF5FGyBNTG26BbGRz+yu8SwKC52C9hmxuENxNOrn5zEYy2qXuPEtq+Nyl+Ztid7C0nBTIT8bDjrFxdn6Oyi4/FMcECSHjtGd5ch17WBZGWfNiyfJKkn6sqESaorqZL6atxVED347Ud8eku2BEP55WPZ6Pz8hRPAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881922; c=relaxed/simple;
	bh=MIAPnN3/4ZoRfQYD/Vt2Q9/Fexwi89/YcxW1kyYbXmM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mZ0lFYUN2LwqxtR4obyRcE1OZoOcE/venRD142NCFDlGtvGTfYEEbUwaZsyJfcvI5rl+T7Geu3ubl7no0tEfcMfCE+eNW+auKNUGetZ/k0Zw4YrQNCR/FtpMrBWVNCNOBu8RfTYs9dST13+JEF6W2ydfZVkNswTXqY75RWjAsxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSR5EQ4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSR5EQ4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A60C116B1;
	Tue,  2 Jul 2024 00:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881922;
	bh=MIAPnN3/4ZoRfQYD/Vt2Q9/Fexwi89/YcxW1kyYbXmM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RSR5EQ4Wly0N0Az5/UduYR5ELboOlfTF8W1N6QyBsjUVFdeWz+/Qo2CHKsJg+IPnM
	 haSaMOtDNA7DRGVaASgk/MuJF/epE2pxPArVdGQJYBC8d+Y/nKEtzed8PiW5ODKYS+
	 lV/W8aJITi/AEycco+biKg1jvZSyRpnKdL9slvqUEsAg8PsMiaFNW8BLIKaZBe6tB8
	 0hLCcHPXXAyG6d9BtYWuU+hN14alP8s3h1JeuZb/LkGBEt+ROujCDy0uPbU28tsXAy
	 Ey/desFlO/RaFyLGvPeKlyZCexDfUoxbXPVzl73QoLYaLZH5UVzctu+AkJKrhVVOT8
	 Nm6cxj7/Dhh7g==
Date: Mon, 01 Jul 2024 17:58:41 -0700
Subject: [PATCH 05/13] xfs_scrub: guard against libicu returning negative
 buffer lengths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988117688.2007123.16198746541223850379.stgit@frogsfrogsfrogs>
In-Reply-To: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs>
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
---
 scrub/unicrash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 5a61d69705bd..1c0597e52f76 100644
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

