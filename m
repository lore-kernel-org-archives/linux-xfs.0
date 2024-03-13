Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E064BE62
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295361; cv=none; b=PiXdmxnjr0A32vkuOC5HLk5+gB0vWAgBezOtvz/5qPLeCf/UEO3eu5KJDHb2tg0kx/ry9gOWslfDqyeyAwgfI0sfjLXc+PxHHqqDuMBNlwSVzou3ne4TEAT5JAuC8ULin1R/uhLCK0i7TUt5foE2Ks4QCNEgYJ6tKDHZWQsezTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295361; c=relaxed/simple;
	bh=8N5NcRROZG7flLFIOQBQwDoI+sJ6w8ptbIdDbwJCqtg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PgPQzkxjp7NbvgRUl1ZUi5egss5jHtEOBOq1B6+M1XMkQaIzVL4/rBxcgAR9w1klxpsLxFh9jX/c/2+DBrgxn4FlP09e1JbFLpsWngcE2eqOC8FmDK9mJ1NBhV8kuqegWAVc3ISAk954ZZrw9nj4mwHa/C5MSJ00X6BIVGlIQik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ktzZW+CK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ktzZW+CK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77330C433F1;
	Wed, 13 Mar 2024 02:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295361;
	bh=8N5NcRROZG7flLFIOQBQwDoI+sJ6w8ptbIdDbwJCqtg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ktzZW+CK0Sf1G1phmCtD1iTkMDXTZNCRA4JCfFFOQYDGibSftdw//BR+mfG4PNc8b
	 mMBMYKJWtdE9Kemr78zgfGSn7BzxH6uEcnub+KAPqWrTZ8AG3uzKBzqLmp3A4N9iBE
	 upHwv+zJeCGubnQj/rnISIR8oT21m2uaviZ9ILI+jm9fF0nRjJ1ftRGfPL5L9A2twd
	 KNTQoGoF/OsDOqGD+yglOSKJnHrFsGJpBqAb8TXzZgfKcJje467eUzes/495cNRtjC
	 XZ1VyLadP+g9Le80QNydPxpsP7w2t3LKNOF/GcxBEZWILUDjOO5hukAG2OWp7BeCmj
	 ND36LjrYaEvmg==
Date: Tue, 12 Mar 2024 19:02:40 -0700
Subject: [PATCH 37/67] xfs: dont cast to char * for XFS_DFORK_*PTR macros
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431726.2061787.3502482156872365054.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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
---
 libxfs/xfs_format.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 9a88aba1589f..f16974126ff9 100644
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

