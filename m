Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19892194BD
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191437; cv=none; b=ZuHf0HKyeQ3NNBq+BKDeAMdRATHHA+ofsUX2PrmZ11YzCHye9s3nF6aqO8RnN05IY1wjM0uo57RCtISqDHZLzaaX8Z1DxdRSZFQMoMETaH6+7AzVicSOx5gb+G0lL2BKnj3E/vs4cFTiD03EUOjrejtQXEw96VY0fIndTcQyxeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191437; c=relaxed/simple;
	bh=wCcqib4BZHcOY+pFwj4bKL8jYHfIgqr20aFnyroDLoA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QrmXbs0Wfa7NPfEGuKsefLTy4ZLuzmO4/hxDSQ3Qb4ZqRE+tHxTaxnb5v7uRo/8OgA5BFK2BxK3qwk0rn6cBx6tPX6IBVHWJ3OIFdhZ+8gIXdNaK8z1lbPeNkTWulE4wszXUfn6MsFXL1YRi0DNjdJbs942pnh3BJgv/iREiTKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SzvLWp4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SzvLWp4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85321C4CEC3;
	Thu, 17 Oct 2024 18:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191437;
	bh=wCcqib4BZHcOY+pFwj4bKL8jYHfIgqr20aFnyroDLoA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SzvLWp4kFKchEvrv318nqRwlOgLUY7/BoVY2K+qIdS1aOcLck0wd4lqV9TEm0A1n7
	 8CLh8TpoaivjWCRBjmAmC0OJy2kwGj1MmjdGgTSlPz6o41U5Fdj1JKgeq4tHAmeQz9
	 LbdnT++owQ4Si7P3MUpdWROn9ZbHcBkDG3vynXAOnu2cb1Fa8vUYAlRPwyAZX/9l9j
	 CcewV7O6mQFTW//GRJ58q+Y9v51h368tM7VLQx1Ya/oEElKh0hWqDe7ALoymgwD1w3
	 b9bMqvkC9hCQ/E6pcbbB5oFF+wAsdeTJYXPs8HpSAcV497U3dheSedOFeW4IPR8Vao
	 1wGLpBl2U7tEg==
Date: Thu, 17 Oct 2024 11:57:17 -0700
Subject: [PATCH 15/29] xfs: mark quota inodes as metadata files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069708.3451313.11147663818086145679.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're creating quota files at mount time, make sure to mark them as
metadir inodes if appropriate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ec983cca9adaed..b94d6f192e7258 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -824,6 +824,8 @@ xfs_qm_qino_alloc(
 			xfs_trans_cancel(tp);
 			return error;
 		}
+		if (xfs_has_metadir(mp))
+			xfs_metafile_set_iflag(tp, *ipp, metafile_type);
 	}
 
 	/*

