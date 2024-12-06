Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C420B1DBB2E
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529535; cv=none; b=bcXMzhMVheQPrIRNRSn9CgmCsMd7QRuDMpITsNb9f7fAG+KkkPRhQtyJ2CHUvl5aLWtyvfejmD2WAjFsqkGd5w13By3kaSm+IOdbAdZ4byCdV2B++L9oQWnZ9H7WUCjXR1pUPa8Yn2s60nMEKc90cB4PWHXQt+VOVOg7awHjJzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529535; c=relaxed/simple;
	bh=1Gv2fL7DJbDq4b6HCWav61FQH7hWR7vPYebwyoRRXME=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e31rbaNxnxvxNVc2iaXz6ZciTc0DHFTr4vnA18a3Hsyx9v4iOJmBjGpEQaMVt8wMNO09GDfYO3iZWA3s4AdmxVW4DRpvDBCMuzjqZ0AucDuV28ciI48GniIODRIi5Bp/JTdh2sdkTxoPpLjJNblMwO5qVwUMvoLWkVqg4TTK1Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JGJrG4BO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JGJrG4BO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD74C4CED1;
	Fri,  6 Dec 2024 23:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529535;
	bh=1Gv2fL7DJbDq4b6HCWav61FQH7hWR7vPYebwyoRRXME=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JGJrG4BOS/O8PRM+lPqnEU5y8HX6cKVwL0UBMCr93oFrFDaZ77uZ0EnNUrSVFJjtV
	 0RO6g6wn8vZ5jioitgAS3M7ec1VZC2nI2ncxNKBxF4V91spv+AOOvPBwJMUys4pPRo
	 VvdQfe0JyJ4FvbI22VzI9ORH+DvUopozYuVkvlRDXGxpXMHr8ApEoCT+u1/lWjNdQ0
	 Ytmz1bfeoRQRnUhsYbVq/iQ00DEMBMZ46VU9RR//HXNzDjTWRhTBERvoGSdn0Z8yAt
	 k7VeiHpjbfT+UG2I83noF/qgTP9vYG2aEokfp3+FqnMzzvRnDobkOVLaGwQItKK981
	 2gqXuNQ9+6KlA==
Date: Fri, 06 Dec 2024 15:58:54 -0800
Subject: [PATCH 29/46] xfs: scrub the realtime group superblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750438.124560.9602442983101683052.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
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

