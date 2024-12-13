Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920CB10F7
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052966; cv=none; b=cX3FJkOnXROPG6vCGjs4qzmCgZw3DtzbTWmUqCb+9EQWZi1uH1jI63WSPAsDaLev2WvBygduI5vgFSlWrP/D3A+0p4Bs8PMSMw2ohxo80zOKlyUEjtlQj0hh0AdQB8V3PxSUWehUY9JNkyXLOvlf4QGlxxF7okBg+dlDRYKSvZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052966; c=relaxed/simple;
	bh=obt8JtmVqGfnEZXDgRPBqcNTF6MXDbdglCegtRtE85o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p5oUY2KiDCMeQxdpv1fHrMBK4tvbqo3bUm9U9DHH6NBrqjTz30HERKA5N+VroPN3Px2aLGKzTBtAHixEgENFEFxGulyON8G57OBGwAIviMnLS5Rf3jaO489m8ZZxUA92ckGB6c5mxpbh3GtC0xefzs0QOZtABXVbiPY6IAaD4aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j0OJxFLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j0OJxFLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680D3C4CECE;
	Fri, 13 Dec 2024 01:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052966;
	bh=obt8JtmVqGfnEZXDgRPBqcNTF6MXDbdglCegtRtE85o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j0OJxFLPcT8DdEORVtsl29kC8MS6z4FY26zDAoRV1WfXaJEOsGMh8HCMd6mLCwugW
	 whwKeCJPiM6iILyZeAYwODtFTJB1RvEBSq+1ed4LxuN9ELduRTZwZ6u2c8orcBBMtS
	 o6gbMwf9YrKHgyZxbsXxfzD+YPYaFyUnFZgbGfj1wpANvxuP3y7uw+snHrZZdQ5a/d
	 RKd0KmDhXsJi3UIbMbKo0fQ2LioRui8qkpkqLocTwilnOYHglB18TuOhNTC6XkTrUR
	 q4qyUIoPTdnPMTIRqySfI2gXGyzV1Pj5Wn7ZJbNzk3SvtSJoZ8RUDEaImWHtWdasDx
	 FSzn9SG7aP7uQ==
Date: Thu, 12 Dec 2024 17:22:45 -0800
Subject: [PATCH 05/11] xfs: forcibly convert unwritten blocks within an rt
 extent before sharing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125829.1184063.12093363819984841679.stgit@frogsfrogsfrogs>
In-Reply-To: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
References: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

As noted in the previous patch, XFS can only unmap and map full rt
extents.  This means that we cannot stop mid-extent for any reason,
including stepping around unwritten/written extents.  Second, the
reflink and CoW mechanisms were not designed to handle shared unwritten
extents, so we have to do something to get rid of them.

If the user asks us to remap two files, we must scan both ranges
beforehand to convert any unwritten extents that are not aligned to rt
extent boundaries into zeroed written extents before sharing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 4f87f7041995c4..82ceec8517a020 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1666,6 +1666,25 @@ xfs_reflink_remap_prep(
 	if (ret)
 		goto out_unlock;
 
+	/*
+	 * Now that we've marked both inodes for reflink, make sure that all
+	 * allocation units (AU) mapped into either files' ranges are either
+	 * wholly written, wholly unwritten, or holes.  The bmap code requires
+	 * that we align all unmap and remap requests to an AU.  We've already
+	 * flushed the page cache and finished directio for the range that's
+	 * being remapped, so we can convert the mappings directly.
+	 */
+	if (xfs_inode_has_bigrtalloc(src)) {
+		ret = xfs_convert_rtbigalloc_file_space(src, pos_in, *len);
+		if (ret)
+			goto out_unlock;
+	}
+	if (xfs_inode_has_bigrtalloc(dest)) {
+		ret = xfs_convert_rtbigalloc_file_space(dest, pos_out, *len);
+		if (ret)
+			goto out_unlock;
+	}
+
 	/*
 	 * If pos_out > EOF, we may have dirtied blocks between EOF and
 	 * pos_out. In that case, we need to extend the flush and unmap to cover

