Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307D61F3D3D
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528927; cv=none; b=aKL9T7W0EWNp5GwrH5Febym05KOGPkj7Hp9HUPJoEArz2wgtp1R9Y8pphwAtcxdH5f8lzbHJsp2HCWgcgk3J2glWQUJr33+mcmCSp9vWTukdxOo+ARaIz17jMFmKV+yVVWENo/raOmFKbzVITbIbBikJGmEtnlWfSHN705I8U7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528927; c=relaxed/simple;
	bh=rTu67UyeQ3mwj1NH6uwAT37q1TOaGK1+Lw55YUVlN34=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SeFkaTQ2y0C73v3hNG/kGcZWIU17w+ZmicvFd3nsNL9iexf79yaqAd7tHDid1uarQhtcekLkriOVByVDP49w7VmWa4Y5cJ5qUkERllTjoReZQ1w0n2jsfzjbdttHvssDTgx3iG90N+59vsDUUeakMHNd3xv1MGyQ2AuaZjacOMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OE6Av5b8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OE6Av5b8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952EDC4CED1;
	Fri,  6 Dec 2024 23:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528926;
	bh=rTu67UyeQ3mwj1NH6uwAT37q1TOaGK1+Lw55YUVlN34=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OE6Av5b8qV/jF4QkrWPt1RL+m+obrEDqUX5qJUjsX6aKxkOERET4WiqYq8eUV2mNc
	 5vlIdbLt339BW1ZzN7iTonI/DwpCQAxz0glXXaNM8rBxQg5/b9m6atFzloGLnfBLx2
	 IeTSOf0KozQ3gDSqxQ9/AZF0asuZ58vAkWytR59DpZxeMECswBVZn5pygHWmeoM1K/
	 WGfizZQupes5z2yHmUwmROOv5h7v6mGn0bufBnLiuXBdD78AFt7GJ+tbqh9Agcc/b9
	 dZlHg1aA5OacIPKxQrBIL6snFNGuZVzeYvGY7HHAmO0MQITaOdLRMl/RzCJa44FVLD
	 t7Z+/92cSnP7w==
Date: Fri, 06 Dec 2024 15:48:46 -0800
Subject: [PATCH 35/41] xfs_repair: metadata dirs are never plausible root dirs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748771.122992.7993160341325290029.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Metadata directories are never candidates to be the root of the
user-accessible directory tree.  Update has_plausible_rootdir to ignore
them all, as well as detecting the case where the superblock incorrectly
thinks both trees have the same root.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/xfs_repair.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 70cab1ad852a21..30b014898c3203 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -546,9 +546,15 @@ has_plausible_rootdir(
 	int			error;
 	bool			ret = false;
 
+	if (xfs_has_metadir(mp) &&
+	    mp->m_sb.sb_rootino == mp->m_sb.sb_metadirino)
+		goto out;
+
 	error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &ip);
 	if (error)
 		goto out;
+	if (xfs_is_metadir_inode(ip))
+		goto out_rele;
 	if (!S_ISDIR(VFS_I(ip)->i_mode))
 		goto out_rele;
 

