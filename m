Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975ED8F4A
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389486; cv=none; b=Csai9E6qLJODkq76mZlqMYv/SwcokKh/kMyyms3JjJy8lYRppO8Wt1Vr698mGqsPUCXNeOq3JrgbLAjs8TCBluK+b4BACw3wRhcsrFFVX538NfGigS3nbrtca3syExLLSSJ36Ac2uH+E/+rxsJc/NbzHKyj1dP6dS6XO2cyQRbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389486; c=relaxed/simple;
	bh=YnTeqnEpcRncCLrzY4LCl4HzPKOxVItIuemeLxBGaQo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p6GESUK7vNmkOWHVmeK96Bf622INEdnVcOc9XYuhIHTJrEKe/okaW0LlM/LCDl4wWJXKdKqtBQm5WRW83sF8tc38fXZZt96I6eFFgZDdItPN25mr1OgwttC1NWGwL0z+LVcJMY2Ya9a9SjBjh5SWHicXx33qWZnwIe2LZ8GTb/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uKJyHQoi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uKJyHQoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5E0C072AA;
	Wed, 17 Apr 2024 21:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389486;
	bh=YnTeqnEpcRncCLrzY4LCl4HzPKOxVItIuemeLxBGaQo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uKJyHQoionGGK+6jMaI23lLTM3NyZL4GwWcxxTC18/NE2mRbwJsIs4GIYDsqYvaPJ
	 OMx4Z2lZ/EVWJxy32mW/TwtjlR9mURcWiunpHXfTlvWEGeitcwWDZCktkF+QErZvJ6
	 9ujuv4C2zMEC32bHAYhs2Q1yC3WOv4x9nuh0KaQ0NgB0et6mAsXHC2oZwjzYWrna4+
	 JQ1sxTJExfreYLH0Vz3PitZXA8yjDQxcIrpd3NPItFbku/xZ5zwVeeu7q9LpSQ3AKi
	 QGfYI03j4CbrK4BCrZJneopyCXmVWoTgfyCTZHR2F7p0DdCQKvVnWtRA7BRSgqFUA/
	 243/rvo7CVdNQ==
Date: Wed, 17 Apr 2024 14:31:25 -0700
Subject: [PATCH 37/67] xfs: dont cast to char * for XFS_DFORK_*PTR macros
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842895.1853449.11074801219916121156.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

Source kernel commit: 6b5d917780219d0d8f8e2cefefcb6f50987d0fa3

Code in the next patch will assign the return value of XFS_DFORK_*PTR
macros to a struct pointer.  gcc complains about casting char* strings
to struct pointers, so let's fix the macro's cast to void* to shut up
the warnings.

While we're at it, fix one of the scrub tests that uses PTR to use BOFF
instead for a simpler integer comparison, since other linters whine
about char* and void* comparisons.

Can't satisfy all these dman bots.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_format.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 9a88aba15..f16974126 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1008,7 +1008,7 @@ enum xfs_dinode_fmt {
  * Return pointers to the data or attribute forks.
  */
 #define XFS_DFORK_DPTR(dip) \
-	((char *)dip + xfs_dinode_size(dip->di_version))
+	((void *)dip + xfs_dinode_size(dip->di_version))
 #define XFS_DFORK_APTR(dip)	\
 	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
 #define XFS_DFORK_PTR(dip,w)	\

