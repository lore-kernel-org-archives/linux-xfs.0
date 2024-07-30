Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DE62563
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300607; cv=none; b=kU9j7laIEkzlCV2kh73G/jEs6QK3ZyDDcFqzOC5VxrbCUXG78Rne8KhgJhhxMQn9/+zLt8TAb9cbs+NmgpEJsMHP3nSnjwOQVN1l5tQj+QQTVnvtgW5AVFUg4vuHFOC0Nfl6bdZTTUC0PwnkxMmxKrYJSm9Z8m+gIifJw/fyAeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300607; c=relaxed/simple;
	bh=QY67knpmrPue324suU0s6X4F0LQvzJETQkZopPG0zE4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DpVDZ9sZ6KDHqwCVL4PHeDa8ZEYgU4y/RcsQ5KlOOvshE91bSbBixnH1LM64h5SgsEvj9QY8h4oHiAu00qc1gm5WEHeNbmxASbU4+6G/pOV6KLI1If8ac9Iq4JB2CiDqIKXHSvLEL3SdpWQSKsHLPMokJp8oqBqWS3RTs5jlRR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EzugyMVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EzugyMVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EA8C4AF07;
	Tue, 30 Jul 2024 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300607;
	bh=QY67knpmrPue324suU0s6X4F0LQvzJETQkZopPG0zE4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EzugyMVjs6K1EAY31KB3FQ6RLez7SWXaBCn6bi4WA8b3olwiGcBNGfZ4uwZ713jwb
	 qX5i1KEK+waUK7xXkdUKux365alMHSKj7zy7StF0HEvRr7d/MGHLZ7S04+QxqQoxuQ
	 GiHIGymKpUUTcWbSptp5NTJ0+WSAu9D6H+9rK31dxXAze+63t5ap+oBkRXjmxjmDJc
	 i25Io+iSfXmN1PMB2x09+vdI9DY3ESYar3VjANKCyzu22/v8pLbpAaPCZf4Z/rC1kR
	 WAq+gk9/Oteg3QOP2DhtiA6tLvyvtzButZhDTfBJiQ4qTpUXwgW4epTEXuOji5BSCi
	 F1F0KZoRp7UFw==
Date: Mon, 29 Jul 2024 17:50:07 -0700
Subject: [PATCH 101/115] xfs: do not allocate the entire delalloc extent in
 xfs_bmapi_write
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843878.1338752.8665884225036255363.stgit@frogsfrogsfrogs>
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
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 21255afdd7296f57dd65f815301426bcf911c82d

While trying to convert the entire delalloc extent is a good decision
for regular writeback as it leads to larger contigous on-disk extents,
but for other callers of xfs_bmapi_write is is rather questionable as
it forced them to loop creating new transactions just in case there
is no large enough contiguous extent to cover the whole delalloc
reservation.

Change xfs_bmapi_write to only allocate the passed in range instead,
whіle the writeback path through xfs_bmapi_convert_delalloc and
xfs_bmapi_allocate still always converts the full extents.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 9af65a182..e6d700138 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4518,8 +4518,9 @@ xfs_bmapi_write(
 			bma.length = XFS_FILBLKS_MIN(len, XFS_MAX_BMBT_EXTLEN);
 
 			if (wasdelay) {
-				bma.offset = bma.got.br_startoff;
-				bma.length = bma.got.br_blockcount;
+				bma.length = XFS_FILBLKS_MIN(bma.length,
+					bma.got.br_blockcount -
+					(bno - bma.got.br_startoff));
 			} else {
 				if (!eof)
 					bma.length = XFS_FILBLKS_MIN(bma.length,

