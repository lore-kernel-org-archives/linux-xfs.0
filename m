Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D809979CF
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299793; cv=none; b=m+RYJpM1geLG+mF6x6wZi48clyIzK47Ms+UpC4uUe5AO2YmKZiTgi53nV1BeTOEvLIVCKVx2f7E9z7dOYvB42jSgUCmn8Ric5/8vM7DnXREC8GdyOGULfYRichS8yDKq9ixOJ4a8lozHzvkaWYNUZX83KJjHmsJPvhcU3Rx8YLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299793; c=relaxed/simple;
	bh=rjWPOZJ6I48QfdS2SZX4mNKVqOLLD1qW1zOCnXBPBlI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kqaEbHoEZrXBCSB5ucL2Li/KCF5h3TancldG20wTmzmMRcbazuLEt2xbaVKCQop3RtGuBEsFjKaBlnlNshYRfAkoJhkFaxfJ8+NyagHidNFYcWZZPTdCfRWUyjPrh3N0aR3nj3BTqFsTHcycvjOEE58tV55lIC4aS86YSdE0Bo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ru/LRkkw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ru/LRkkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15A4C4AF0C;
	Tue, 30 Jul 2024 00:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299793;
	bh=rjWPOZJ6I48QfdS2SZX4mNKVqOLLD1qW1zOCnXBPBlI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ru/LRkkwYfytB4XVoOeAw35jVuVWZdzcjdVF1BM0llNekv7HgL2aE0OvkJzQpn0MQ
	 5YEwGN3AwNRAEVzmeGJzmdlm3g5BhQ/mJ1p7MfC7CdUVuhmlz4zQsOOIG5QBFj6NsA
	 /3exsdqw9U6ZsNpnPjerwVs/T1OPx5nPh+KbaYVt1TbLxG+Hhv14fRmRTnUiFE/nd0
	 ac6ta+aXYoHvqyteR0FIULca346gSiTwd0EnHMqQ2Qdxo4abaFqIHo5sg4v8tpkLmG
	 3+yeAbkX6dWbLNgUEgi9oYo9EPUgXTYMDIGIfTSLXttStMLItgnqkgM8DzQC/dXThD
	 RN+7Qr4FUZs/A==
Date: Mon, 29 Jul 2024 17:36:33 -0700
Subject: [PATCH 049/115] xfs: use helpers to extract xattr op from opflags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843132.1338752.3256960158984018031.stgit@frogsfrogsfrogs>
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

Source kernel commit: 2a2c05d013d0562076ec475a6deb0991ce1942ca

Create helper functions to extract the xattr op from the ondisk xattri
log item and the incore attr intent item.  These will get more use in
the patches that follow.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.h |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index c8005f521..79b457adb 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -529,6 +529,11 @@ struct xfs_attr_intent {
 	struct xfs_bmbt_irec		xattri_map;
 };
 
+static inline unsigned int
+xfs_attr_intent_op(const struct xfs_attr_intent *attr)
+{
+	return attr->xattri_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+}
 
 /*========================================================================
  * Function prototypes for the kernel.

