Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBAF8F5E
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609516; cv=none; b=EGfdHmc/avyNmfycPlQ5S/DlvTDLZ+NfMNfOqCpZqGW29ob8c2Q5ErDfEjXo10NYJna2RINU8PH75ros98a3LChqZie9iXYttv2pO0eWUV3QmHHXkf7N2r6Rm9zZcVJ9ZoaQiR4Y2KwfMprIFgx31DbdZXnWiWVqfizemUEolnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609516; c=relaxed/simple;
	bh=36otk+ag9kT8z9ubIZXBJaEXq029KfiVJIiHBbQ6tps=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DVp98B8rlV/qsQ/S47zcc08aylrdaFzFwtDw6OmXuM1uLdzvdnmSXC9pqCAhd5at/i7GPxgEdp8x0h3wv1whL/VFx8wSeL3Bt6rdJyy61iypzgxb+Q4RGazgrUNuVUhzGj+EqYTh5Q0rb9sZvXAx7H4a5eaZW5rS9lzLThCIGhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bG57Bn3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bG57Bn3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A02C4CEC5;
	Fri, 11 Oct 2024 01:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609516;
	bh=36otk+ag9kT8z9ubIZXBJaEXq029KfiVJIiHBbQ6tps=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bG57Bn3I2lSK/8ugB2ID7/eIEQvCU1qu8pAVlD9IIy6kpXYgSaD6xk75KZbkQWUno
	 TdAtUhhAniwDT6+cvf8bVQj6eU1WJRsesOW2YqOz2nGySc07NtdQYJX7JGGuzSZav+
	 hcqnP8PYCIXaopU/kbYzsDlXz1rhUUpQcRYaXpMtoXSR05tpS5/PWfoWRcMYXDgRL/
	 25zyDThRFhIIJMOKZU4TnRa3VaegzgKWJIjiro0vA/0zH0O7M1WbS77YFRRKYrCP33
	 fuFJqiLDAlGe1houhyxoyokogL7oOlXFIv1IR6V6GEvGXJ4nNxCRCaC6ehhcGPtFOz
	 Pn4VstP0/3ezw==
Date: Thu, 10 Oct 2024 18:18:35 -0700
Subject: [PATCH 17/38] xfs_repair: check metadir superblock padding fields
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654237.4183231.10990861663048107166.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

Since metadir removes sb_bad_features2 from the ondisk superblock, check
that the padding field is zeroed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/sb.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/repair/sb.c b/repair/sb.c
index 1320929caee590..80b09225cd97d2 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -479,6 +479,11 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 	if (sb->sb_blocklog + sb->sb_dirblklog > XFS_MAX_BLOCKSIZE_LOG)
 		return XR_BAD_DIR_SIZE_DATA;
 
+	if (xfs_sb_version_hasmetadir(sb)) {
+		if (sb->sb_metadirpad)
+			return XR_SB_GEO_MISMATCH;
+	}
+
 	return(XR_OK);
 }
 

