Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29EA1E4A2
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346330; cv=none; b=njztQOm6pIBd9en05J+e0LoYkSJVBSWCMWyuwzhQOhw57z7pNf5PDwQrEWYrilk80ImXOSlUmrfqn2k1Cory11NdO17T71avhfGqny8z7osS1wL7yjDmbLL3MkBnmHQ7IY8A6EoyjaADUxUQoh4RoXz7gzK8fVowbuhyFm6p7ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346330; c=relaxed/simple;
	bh=vpL4PpOCdaGJFyq+hh/Abol61bJK7B6Su99uDZx/o+A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lo9k206NKgVms2MuEZ1MzYcahe0fZ7eFHEwiMubhRiRzUUk4cKZ8WI4SLSDzz0H7iUYyb/8eWuiClI5JJjL0eKzykaRk4ivrbIF9Xs+Ds2ouUOMUFHBP3QXZZJlWwpX0bB4xl/kDwRdD2gkJtW6zxCiCIhwpNYD3pAXFM79iHjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p/DdGPFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p/DdGPFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD881C2BD11;
	Wed, 22 May 2024 02:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346329;
	bh=vpL4PpOCdaGJFyq+hh/Abol61bJK7B6Su99uDZx/o+A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p/DdGPFRSIOQ85yQ8RQTRlnWmvTtuRUd1UYjpe/aYZz2jsjbHlHqW+JKiAyGTEgq/
	 4UCc1QyvC/ezGQPmIlEAfy4atiZRhzYJaRJHRxEZ4sME0Kitw/9cEc1WzhnSgq+Fzy
	 jiQz9crBhGdJCIJrCInCdIW56FfCa1IN2IT2NHl5kj+DtaKeWMR7/K/GY7Ky1gurPj
	 LQtHeqNj0YJHcWnRKw7Wh9ekQyxyBO8CEtPINNgVbqxB/0sR0aPbydxZnw0TuIpKTn
	 3oot6upHaLYOKc+MsBRF77RXRlqsdK0Su0chSZhbm2AmkzTwJc244ky7RmiVY1h9F2
	 Gv6dvGyL2ocXw==
Date: Tue, 21 May 2024 19:52:09 -0700
Subject: [PATCH 013/111] xfs: implement live quotacheck inode scan
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634531906.2478931.7802762074138019163.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 48dd9117a34fe9a34a6be0b1dba5694e0f19cbd4

Create a new trio of scrub functions to check quota counters.  While the
dquots themselves are filesystem metadata and should be checked early,
the dquot counter values are computed from other metadata and are
therefore summary counters.  We don't plug these into the scrub dispatch
just yet, because we still need to be able to watch quota updates while
doing our scan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 711e0fc7e..07acbed92 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -710,9 +710,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_GQUOTA	22	/* group quotas */
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
+#define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	25
+#define XFS_SCRUB_TYPE_NR	26
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)

