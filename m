Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584AA12838B
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422750; cv=none; b=GSNoqj+/8LsfIdgpJx0BcLmCZukIZEWJfKolVBYmZ4YeHnz5EaaRNBtLj5tOTijRyS6oISj20C+/7GzwvRDMT/Yb8D6PMmrITAFI34okcRea+RQCmCElZhF2vHbcbFRDcFgEVcIO3zzcVr3t4lYi1ZJR37IZAiczNbO5x+Try5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422750; c=relaxed/simple;
	bh=Je6GLh52r5uIrhNoVU4LiOvElJebtz5LS4LoCi8jMUI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sNQe/T9P0BZaJBF74QZ6Dy6mY/xBvUoHPCC56ueMrjxiCfpAb8jmownmNq7C8QNXk7D1WMAon5+BarDWxCzx3nDYZAdfjOr00odVXodAXYaOHqLHj9E9gcpWlwQ5KLZGfhdlEhvawsQFFJfXDiWdXbuoqSvj9qgITv+kGKyARaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RVhmMm3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RVhmMm3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D7DC433C7;
	Tue, 26 Mar 2024 03:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422749;
	bh=Je6GLh52r5uIrhNoVU4LiOvElJebtz5LS4LoCi8jMUI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RVhmMm3jHQoRtBEMMlWl9YdU5a1UjU57XISKFJOwqnyP//EIH9GG0B4EXQIWnldVV
	 BbT/Ex9qi1AFHhCwmVkWcgz7TABxH7uz3O2M9hY7aSStejwQFNAtuXCj2IWATRLe1Y
	 Io5MGkASxOYvDH1y+HPm+xeIGjSYns8mRTY6G/fQNiGjAwtCWgBBOQfVYgizL2C37P
	 CsnSmrEo6YfJIl5/A2BBcn71x9AoFUA7OGuQHE3ooMoV9kvxcrKbZuiW/L7a6wLqzl
	 cm5i20XDCPg2VVIhbOjl0BFG0buEXBD5zjFaI8fruJArRMOu/n3WZ7eETWqHvR6zNA
	 rcYP3wJjdPMEA==
Date: Mon, 25 Mar 2024 20:12:29 -0700
Subject: [PATCH 37/67] xfs: dont cast to char * for XFS_DFORK_*PTR macros
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127495.2212320.13500330506781856288.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: 6b5d917780219d0d8f8e2cefefcb6f50987d0fa3

Code in the next patch will assign the return value of XFS_DFORK_*PTR
macros to a struct pointer.  gcc complains about casting char* strings
to struct pointers, so let's fix the macro's cast to void* to shut up
the warnings.

While we're at it, fix one of the scrub tests that uses PTR to use BOFF
instead for a simpler integer comparison, since other linters whine
about char* and void* comparisons.

Can't satisfy all these dman bots.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_format.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 9a88aba1589f..f16974126ff9 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1008,7 +1008,7 @@ enum xfs_dinode_fmt {
  * Return pointers to the data or attribute forks.
  */
 #define XFS_DFORK_DPTR(dip) \
-	((char *)dip + xfs_dinode_size(dip->di_version))
+	((void *)dip + xfs_dinode_size(dip->di_version))
 #define XFS_DFORK_APTR(dip)	\
 	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
 #define XFS_DFORK_PTR(dip,w)	\

