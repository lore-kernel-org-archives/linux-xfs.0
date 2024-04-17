Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF2C7464
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 23:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713395810; cv=none; b=i3wHsTqmE9s9uSqoApva+p8o8Ay82VOvjl1EM0lSgryKGTDzWiCUjg4gsT/3EXDMtcCm10Wrn7e2OARivg5+h6YrS0rVm72ru6zkYFwqrUxub+e+ouZLdlIfinoG6q57JNQ27itst7O5xvlDohzL9QOjapQw6XO2ejkrSFD5Ct0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713395810; c=relaxed/simple;
	bh=N0JnjAFqvS1x5ICzcecvbAlbJvt/UYTbQtCbN3qglME=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jJ8bJVMj/DXI31WMtF7rpXEaRtvNPUdlOVEI9/ReT2I5N2q82jLvixJ0i01PIbtcE078ib0wPfHQrBk1mFj97uTPuwVfDgr6MkC6Yd63Kba68icPDLWdm77ISF0WAirqQBNpTkRlmNxsHT76VjFwOI3XLZiwJ9VZw51CStiwjls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GyJPMKvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GyJPMKvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFBAC072AA;
	Wed, 17 Apr 2024 23:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713395810;
	bh=N0JnjAFqvS1x5ICzcecvbAlbJvt/UYTbQtCbN3qglME=;
	h=Date:From:To:Cc:Subject:From;
	b=GyJPMKvMD7Tchf2z77VFzeNkyI780f6LeWOnAzdUuiC9AIxpiWz9nTbZQpCJiZlXl
	 0J+79OJQuYyfmpPTxWVFyB5E0U40Z6b0R8QKk0tmt1AFbGuO7uCohLwzSwqWYSiuPy
	 ehvAEi7K2KZSJDeX4bRyIYjDj6N2gj6UqWZJ6qQ+M2g9ZzyTtN05RZXhtwgAabdI+r
	 um80YeBmSuSpJj0gPavzfWTs1z7nekcqBz1X5BZ2vl4+qCRSpMSD57+DKg4gh5d3Df
	 /kV5rH+B3ttjRjJBq/r9XixOPzNMMmrPfqoUtqGqKdHvreixz8y/QzwUoXcYlRngw+
	 Z61cFfXjgpz5A==
Date: Wed, 17 Apr 2024 16:16:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>
Subject: [PATCH] libxfs: print the device name if flush-on-close fails
Message-ID: <20240417231650.GE11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

Print the name of the device if persisting the write cache fails.
Printing a pointer does not help the user at all, and this causes the
32-bit build to complain:

init.c: In function ‘libxfs_device_close’:
init.c:178:35: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
  178 |                         progname, (long long)dev, ret);
      |                                   ^
cc1: all warnings being treated as errors

Fixes: fc83c7574b1f ("libxfs: split out a libxfs_dev structure from struct libxfs_init")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 1e035c48f57f..6ac9d682490a 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -171,8 +171,8 @@ libxfs_device_close(
 	if (ret) {
 		ret = -errno;
 		fprintf(stderr,
-	_("%s: flush of device %lld failed, err=%d"),
-			progname, (long long)dev, ret);
+	_("%s: flush of device %s failed, err=%d"),
+			progname, dev->name, ret);
 	}
 	close(dev->fd);
 
