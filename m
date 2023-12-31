Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362631171B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITq7QEzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DC3C433C8;
	Sun, 31 Dec 2023 21:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059810;
	bh=gZYA1weZfJ3HP/d7VEAjufvv33VpmlWVw4WZno1SNsY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ITq7QEzWGlIKHkZ6KCqDeAlyTeqhV8KYdmbJ4EV9mct6TYjLYb7i/UH7sKyUz4Dw1
	 KsNzANGa5pqlZyeVHg+7T+RjV+mxF3sI/jy5Vt6rqSC7Z6BBsVwtF7u6MJoetO8zv4
	 IzvgSn8u5h9NTsQYs6nvWXXwC3CDIFOEB5qQ1ZOqK2imgFXOuRsMifL6o/2Wbn2Pzf
	 xF2HRcahtMW5IpRWQGQ12JNlkZwBwCFOr/iRSQSuGeSP7S+2sViytZ+tXPSAd9QfAu
	 5xySjwYOb8e9KGoLS4nxTHhhaqgi0+thIkfrytAjPjhW9oGZqBj/R4PK0m4UZqDO2R
	 ffFZjSRlNNI2Q==
Date: Sun, 31 Dec 2023 13:56:49 -0800
Subject: [PATCH 3/9] xfs: forcibly convert unwritten blocks within an rt
 extent before sharing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852719.1767395.5382072798264653253.stgit@frogsfrogsfrogs>
In-Reply-To: <170404852650.1767395.17654728220580066333.stgit@frogsfrogsfrogs>
References: <170404852650.1767395.17654728220580066333.stgit@frogsfrogsfrogs>
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

As noted in the previous patch, XFS can only unmap and map full rt
extents.  This means that we cannot stop mid-extent for any reason,
including stepping around unwritten/written extents.  Second, the
reflink and CoW mechanisms were not designed to handle shared unwritten
extents, so we have to do something to get rid of them.

If the user asks us to remap two files, we must scan both ranges
beforehand to convert any unwritten extents that are not aligned to rt
extent boundaries into zeroed written extents before sharing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d5773f9b7ec54..5d68603506f27 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1693,6 +1693,25 @@ xfs_reflink_remap_prep(
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
+	if (xfs_inode_has_bigallocunit(src)) {
+		ret = xfs_convert_bigalloc_file_space(src, pos_in, *len);
+		if (ret)
+			goto out_unlock;
+	}
+	if (xfs_inode_has_bigallocunit(dest)) {
+		ret = xfs_convert_bigalloc_file_space(dest, pos_out, *len);
+		if (ret)
+			goto out_unlock;
+	}
+
 	/*
 	 * If pos_out > EOF, we may have dirtied blocks between EOF and
 	 * pos_out. In that case, we need to extend the flush and unmap to cover

