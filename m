Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD87197;
	Sat, 30 Mar 2024 00:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711759230; cv=none; b=I/hXIQF8NQ8kXXg13ReujfBbl5s2cb+Lr98cGP2/xfEHKgIbVFKvkxyY524kGM1NCT5wsHBop3b7Lpk50+k8PqsFLg8tSgnKuzyEYFkyqzqJ1LcJlOViJ9XmVnqtrY90JJk8gJoRu+Fj5aZu4/pgtQ724Rj236LVlNmcvaKhQqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711759230; c=relaxed/simple;
	bh=cITiFXCYbcuBuVyNhaUCjjeTCndRN2GdxXlaStJmO7o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DjTv6sIRClqMgZAdobTRmbJkoVhUnO/woAGdO0VqPIPfN7NBZUxtVtwZ6ybaglB/PwoWRdTo1fK0poRZ+opoTa2wU8tLqEys58iwaX14BTWwkzYQKjEgrbb+8VwMZa++9Odbx8u/sdn3FbpgEF1Fqv/ebaTTsjXx/qwdQFaOdwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qut0nkxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qut0nkxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84082C433C7;
	Sat, 30 Mar 2024 00:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711759230;
	bh=cITiFXCYbcuBuVyNhaUCjjeTCndRN2GdxXlaStJmO7o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qut0nkxFbnpDyAt8+D4p+prI46JN/CRqNEH5B52TkNdQLHmbgdLMakKr8Dpbh/v3H
	 kfNXaxyHhrHQUqm802TF8U4S7M7OAoyCyXkG80LoRQNXOvllZgFoYuT9O2sgTmgrJV
	 E2q8ahiHntu2uBJxTAawQ/MW91XdK+MF4b4elAY1uewW58IxzCVsN5hPFASGmJh9gt
	 TIqd1tIddBg+aukGZEyPttb6sMvlcGQvlIdGjbdbXZsnEQuT2CYmAU+jg9zpfo93pK
	 dXC7cXsnKnMdnAivq5vzQCfzi/aych2nSmcJJ93xv7FmzkaVay2eW+yKXO1aac2ZlU
	 tMkXTGc1iO6kg==
Date: Fri, 29 Mar 2024 17:40:30 -0700
Subject: [PATCH 17/29] xfs: only allow the verity iflag for regular files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, ebiggers@kernel.org, aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 fsverity@lists.linux.dev
Message-ID: <171175868843.1988170.2809557712645656626.stgit@frogsfrogsfrogs>
In-Reply-To: <171175868489.1988170.9803938936906955260.stgit@frogsfrogsfrogs>
References: <171175868489.1988170.9803938936906955260.stgit@frogsfrogsfrogs>
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

Only regular files can have fsverity enabled on them, so check this in
the inode verifier.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index adc457da52ef0..dae0f27d3961b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -695,6 +695,14 @@ xfs_dinode_verify(
 	    !xfs_has_rtreflink(mp))
 		return __this_address;
 
+	/* only regular files can have fsverity */
+	if (flags2 & XFS_DIFLAG2_VERITY) {
+		if (!xfs_has_verity(mp))
+			return __this_address;
+		if ((mode & S_IFMT) != S_IFREG)
+			return __this_address;
+	}
+
 	/* COW extent size hint validation */
 	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
 			mode, flags, flags2);

