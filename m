Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F37B18FC89
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991547; cv=none; b=VvA7SrniJziaDKPq6fcu/Lnrb8GnJijisQfFQVFQflCBCv4mviSHTcNLecyTJRFC5/ioTl3oR2gbCgo4+zQijox6GPLm10P27wInn8RQxKagS7OJV6LvIbLDvr5iky+Vwfk3j+mG+jACQfiqyAJRM9ssOTapgc8wXLCJ+GUmsK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991547; c=relaxed/simple;
	bh=1Gv2fL7DJbDq4b6HCWav61FQH7hWR7vPYebwyoRRXME=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gax7UZTvHenv0vgVChFt+PXI0vYFvT0L6VMCAybm2PwD/Ln7/M1w/e7wCEKs8VND0JrkHv/0cGZ6rwlvjSScz+UoX7dAMi2Xw8xaWOP73i+cKFJXxrSRH0QW8HdkJdCxNZKWGIbAo6+D9Qp0BW5DBCjjqSA+sGrAnqCBbgHcHa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqmUrYdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqmUrYdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BF2C4CED3;
	Mon, 23 Dec 2024 22:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991547;
	bh=1Gv2fL7DJbDq4b6HCWav61FQH7hWR7vPYebwyoRRXME=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eqmUrYdSAFFVz0XvKRQ2HRkgc68uKrhAskDnC5U8+kiNPplo7AalqL3y9CFh1tWrx
	 Gb0m3vZCfh9+19tLLbTi5isQ5pF9eAHs/JoNWvptLbUYP3WIVEwlQF7mz7ivvAR6ot
	 JCpA8sR2PjM3mN0AuIkzv6TB26cmbJZFb97JotcdHcJHTn68E4RLF07PhDPRMKcI5m
	 IowXivAnB4Umy6Rg2MTi+ZNrHdc2HwN/kui0VRMKt2AbvKqXhunItUSBqcnI6T/Idu
	 fqs9Eoj+VObuH1PdjJKoFRIFgcqn2ijSn815ouy7eb+V4xWwS+IzOnAsMRCI6uv5tA
	 RCCd5qgNLaqhQ==
Date: Mon, 23 Dec 2024 14:05:46 -0800
Subject: [PATCH 29/52] xfs: scrub the realtime group superblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942939.2295836.4289175961849740054.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 3f1bdf50ab1b9c94d0da010f8879895d29585fd9

Enable scrubbing of realtime group superblocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 4c0682173d6144..50de6ad88dbe45 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -736,9 +736,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 #define XFS_SCRUB_TYPE_DIRTREE	28	/* directory tree structure */
 #define XFS_SCRUB_TYPE_METAPATH	29	/* metadata directory tree paths */
+#define XFS_SCRUB_TYPE_RGSUPER	30	/* realtime superblock */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	30
+#define XFS_SCRUB_TYPE_NR	31
 
 /*
  * This special type code only applies to the vectored scrub implementation.

