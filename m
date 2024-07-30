Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367FC184E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299215; cv=none; b=n18KNdjSnevCFZsJtRw9ChGgTjOO/wyy0zHIBS4MYc7MhnEOHM/jw0gN13BDjBkquSAzKZ8TKv7Xtfj6tfqT1Hs30IN63lmW8q1920OTbJN7iu0aLCV4N2VBFhG6PqQpU8AghUrxB1uYMWcmAXz1c/awExNQfLof4Ae/NhOuyPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299215; c=relaxed/simple;
	bh=iUq8o3oNa45FJ6P146tUzG7jT9mTzOy09+KkBgU+gEU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HgPzAeohEkkRYlYK3y5hYCE9hJIiqCKpZ0NsOc1j657xQLEYfMr8KzvZ1EZrSuKU7JOMxqrNm2bve79ufPZbrVomVEU3KzMrq/9ZXEPJ+40zB5cFoDNMw3jcnvuTcWjFX7pSg+oVXp8F19bjLJNHCobLtTMFu6vupbuWjtJWt5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aj5QLmVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aj5QLmVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF5CC32786;
	Tue, 30 Jul 2024 00:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299214;
	bh=iUq8o3oNa45FJ6P146tUzG7jT9mTzOy09+KkBgU+gEU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Aj5QLmVf5H6LS3yXJ3ns5DKRb3ikXszvtyb70zGceMMZJG97/C2i3FgeLsKN/eqFg
	 BKmziUVE4BMVVE8lJrFpWcAWbHFt1vFDe/FZ6x5dHBjGbEvhPRCfkqr4Bdo2A21AQh
	 Y8+PeElMUKLk97Nebz1vkEOCq7bQC7xaBz8K0dlo2d83I1lVHGq652jUjxLyVqbG7l
	 JbItk1rwqX7DRF8Z3cTlqTW0uK3ItFkwLwalPONp+L9sncl8LtKGDrRNci1K1zJ9V2
	 BnC0P5/vyTOc1vigYV0RNE4NJ/thXhgohlzcGJaRx+T/XYawZpQknsyQ6A0z8pJmJa
	 JEfj+Xt+XcKJg==
Date: Mon, 29 Jul 2024 17:26:54 -0700
Subject: [PATCH 012/115] xfs: capture inode generation numbers in the ondisk
 exchmaps log item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842611.1338752.17028313336357311290.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 14f19991020b3c712d626727c17599f134cc6efa

Per some very late review comments, capture the generation numbers of
both inodes involved in a file content exchange operation so that we
don't accidentally target files with have been reallocated.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_log_format.h |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 8dbe1f997..accba2acd 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -896,6 +896,8 @@ struct xfs_xmi_log_format {
 
 	uint64_t		xmi_inode1;	/* inumber of first file */
 	uint64_t		xmi_inode2;	/* inumber of second file */
+	uint32_t		xmi_igen1;	/* generation of first file */
+	uint32_t		xmi_igen2;	/* generation of second file */
 	uint64_t		xmi_startoff1;	/* block offset into file1 */
 	uint64_t		xmi_startoff2;	/* block offset into file2 */
 	uint64_t		xmi_blockcount;	/* number of blocks */

