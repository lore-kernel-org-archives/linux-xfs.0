Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94B41E909F;
	Mon, 18 Nov 2024 23:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971150; cv=none; b=C6t2KD/IJ4HbeHfiTPmpePt4jbViLVpw8esvr/9VMvZUpBWecmOfPLPk3SudJsVOovmSUg8cG2eT3NjfPQgVhwtIc5bZ832CP17QZdscVr2ocdFvjKn8CvWuR98kLJuo0SlPuepBY9vH4K9fkqAi9y3pbUNGoYiVpTRx29AV/Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971150; c=relaxed/simple;
	bh=96Pae+UeVyDsjq0RGVcq5xt+TvbQKzRUBi7sUUINgOs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQbPpX8QBw4LhIQvUIu2xu+m42neoUlLN0fUfTz0I5OYpzTFMlhrpaYWqoT0irPpd5KNZDejJe4csk4UbJvrnom2jOfjFpsr57X4IsjUNQVwYeZjkxC6fVXTwuWlJwNFDk8E9IlfZTcUv8MsCd22+fe92n4GWVLDD1Kszd4GP6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rP5qArkP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rP5qArkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD42C4CECC;
	Mon, 18 Nov 2024 23:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971149;
	bh=96Pae+UeVyDsjq0RGVcq5xt+TvbQKzRUBi7sUUINgOs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rP5qArkPiOwHm2AGt+WsnzXpP7tbjv6CQXeBpwv+cXkTCs3LttyW4CFEmZLnpexuJ
	 87aaqGoWhjxEwugW+5FVeLsDY0bqSAqHWzQRfzWnDGvOOlhUY2+w/c2vxY+kgdtoXH
	 KC7GPU2Hn2+lFt4A9i2F2RzilNPJOcOsYjRA/YcAb3RpHgr144AaG6DSXvy4x9moOf
	 w7njg6HBEvm3yGIHmRtvqHIVWu6HhNpfObYGVaqpm4o+KqynACbV0kDTYwmtUw+27y
	 jaURtmX3impsG+hONk5gz7nPq2cmj8++k3wzQAhTv8Lu703WXIXRvJDWEPwZChxHZk
	 TUiXBMSHb1YBg==
Date: Mon, 18 Nov 2024 15:05:49 -0800
Subject: [PATCH 05/10] xfs: don't drop errno values when we fail to ficlone
 the entire range
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173197084499.911325.9564765824006983077.stgit@frogsfrogsfrogs>
In-Reply-To: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Way back when we first implemented FICLONE for XFS, life was simple --
either the the entire remapping completed, or something happened and we
had to return an errno explaining what happened.  Neither of those
ioctls support returning partial results, so it's all or nothing.

Then things got complicated when copy_file_range came along, because it
actually can return the number of bytes copied, so commit 3f68c1f562f1e4
tried to make it so that we could return a partial result if the
REMAP_FILE_CAN_SHORTEN flag is set.  This is also how FIDEDUPERANGE can
indicate that the kernel performed a partial deduplication.

Unfortunately, the logic is wrong if an error stops the remapping and
CAN_SHORTEN is not set.  Because those callers cannot return partial
results, it is an error for ->remap_file_range to return a positive
quantity that is less than the @len passed in.  Implementations really
should be returning a negative errno in this case, because that's what
btrfs (which introduced FICLONE{,RANGE}) did.

Therefore, ->remap_range implementations cannot silently drop an errno
that they might have when the number of bytes remapped is less than the
number of bytes requested and CAN_SHORTEN is not set.

Found by running generic/562 on a 64k fsblock filesystem and wondering
why it reported corrupt files.

Cc: <stable@vger.kernel.org> # v4.20
Fixes: 3fc9f5e409319e ("xfs: remove xfs_reflink_remap_range")
Really-Fixes: 3f68c1f562f1e4 ("xfs: support returning partial reflink results")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b19916b11fd563..aba54e3c583661 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1228,6 +1228,14 @@ xfs_file_remap_range(
 	xfs_iunlock2_remapping(src, dest);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
+	/*
+	 * If the caller did not set CAN_SHORTEN, then it is not prepared to
+	 * handle partial results -- either the whole remap succeeds, or we
+	 * must say why it did not.  In this case, any error should be returned
+	 * to the caller.
+	 */
+	if (ret && remapped < len && !(remap_flags & REMAP_FILE_CAN_SHORTEN))
+		return ret;
 	return remapped > 0 ? remapped : ret;
 }
 

