Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1E18F40;
	Tue, 26 Nov 2024 01:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584362; cv=none; b=cI6fnQBEXb9hdOlrxKM6jm0qcGon0hTdEKwKhzfoIR7oyzjs5s+v+idSaJTI6y5R1FaLJynWUiLapThSve7AtJ0rj4oj9ZEaD8Hz29M/fSLi4MzxOSqr6mllZj5LrdQ+z7cXrR9LFkqqdGEUmAmW+rr/ixHp6m7MyOIs4vVVCcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584362; c=relaxed/simple;
	bh=wrLq6yPT9pDVWwYoAd9TNkIvx+ryLd43WU7ftb1pqzY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CwUUZv4d45gEGgj1PpGwHH1bbz6QlhGakxnD93Tj7Cfmee28dMLlBT8VpMAKXs+xO6Kben49uNBHS0V80UFnBHwd0e7Vzb/wWodR6US6t1i9q6/Ftp/zkXUYtCD6Axj3QhE+JRTlNJBmiar3SMcJugbNrSGv0fkdKl4B3+D+dA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=irpPdkEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="irpPdkEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CDEC4CECE;
	Tue, 26 Nov 2024 01:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584361;
	bh=wrLq6yPT9pDVWwYoAd9TNkIvx+ryLd43WU7ftb1pqzY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=irpPdkEVt7s/y5NSRMSzZy6wQVBCIYHTHRlLuYBjBwEe5RVdUNQun4OyrpmP0Wgkh
	 Umlwn3vfoANEzthBOGnXnRXz9yhhUWyc7/v8F4YOMA0BqfOXJFap2QHA8f4YzkdN6M
	 hsYjOaZ4n8ckDmZqf+t05hsNLJ2doLncwc4VOlQRJPWjmEqrGbI0sAP64ADtzgClWW
	 PDAhDsKaTUSTYjMEahiv6N9xa5RoS9hbqxMpLE/iIRm4x/E2z8johVr6a086UyM/jm
	 BWHOtKslow9KlCwpV3mpppZPxa/n+bTAVyFsofbgjkHrY+iTANqP7fMdMJXqPEJv+7
	 /UIwXV/HRMJDQ==
Date: Mon, 25 Nov 2024 17:26:01 -0800
Subject: [PATCH 05/21] xfs: don't drop errno values when we fail to ficlone
 the entire range
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173258397889.4032920.12946980376907187230.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
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
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c6de6b865ef11c..73562ff1c956f0 100644
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
 

