Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D412417CD
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882669; cv=none; b=Ajg8X7yBIVD099cqOzjI29FiOpxDQSCH7++MguVjVm/8itsmtgOr698x8cDFGN94UJ/SMJ1bDZbEXqutUQQlv9VlefUGGnKacJ0I92NCylbPbXc3oaG54B96PEi2jqf7RTntzE/U3VASlnCX37wQAgtJCru6172Jyp0/rS8sG8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882669; c=relaxed/simple;
	bh=Y1kCCBfPADLDpzd9UJdQp7p4k1pfZr2qn3Un/we2+7w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bNi9FODYVZrjml8HF/zSJvnYYEA8osqdZfNctlCi8kGjYWvttow/uOoTQHwmL0MaCTAoxvEDCybXUs6llcbg1xEWyaohzDmWEwgpujAYqGgfvEPSAEUYxHG+2rQ2dolQoszScEyXw3t7q8YshvORnK40Kn4CPvwls2gOL3aUyAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GMsY8u6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMsY8u6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6E2C4CEDD;
	Thu,  6 Feb 2025 22:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882669;
	bh=Y1kCCBfPADLDpzd9UJdQp7p4k1pfZr2qn3Un/we2+7w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GMsY8u6mOcEHswXMYUFFzm1io5e2QziMSQyUoeXofNvY17qdD5cxJhQnULxRVj282
	 mzvX+Fy5paH2KTYsy/xN0LXWvnwJn7ngazqMqP7aqjroay3XMInG+1AQ+O/pOB6wOx
	 HUascDZktDrnVtM4ZW97bCUoMMPE6GhIr/TZMBtQkbtCMYlTp2amdH9+uDpgrXNdTU
	 VHlQg7FtC22khjSuODexJOsiCCdpBtVbVs9HtzWgZydR+F5tXvMYIoD3bYCJ5PW6NS
	 uC+yTPuts3cUsDFuhF5R4MzCbvwEc7dSuBMwaA5q1IxAHDzjwtq5+gVI2DGMKmL28Z
	 xj+7KM1kanewQ==
Date: Thu, 06 Feb 2025 14:57:48 -0800
Subject: [PATCH 04/22] libfrog: enable scrubbing of the realtime refcount data
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088996.2741962.5133912501507693446.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a new entry so that we can scrub the rtrefcountbt and its metadata
directory tree path.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/scrub.c |   10 ++++++++++
 scrub/repair.c  |    1 +
 2 files changed, 11 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 11d467666d6b5a..9ffe4698e864ab 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -169,6 +169,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "realtime reverse mapping btree",
 		.group	= XFROG_SCRUB_GROUP_RTGROUP,
 	},
+	[XFS_SCRUB_TYPE_RTREFCBT] = {
+		.name	= "rtrefcountbt",
+		.descr	= "realtime reference count btree",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 
 const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
@@ -217,6 +222,11 @@ const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
 		.descr	= "rtgroup rmap btree",
 		.group	= XFROG_SCRUB_GROUP_RTGROUP,
 	},
+	[XFS_SCRUB_METAPATH_RTREFCOUNTBT] = {
+		.name	= "rtrefcbt",
+		.descr	= "rtgroup refcount btree",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
diff --git a/scrub/repair.c b/scrub/repair.c
index e6906cbd37d0b3..b2c4232fe8cea1 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -548,6 +548,7 @@ repair_item_difficulty(
 		case XFS_SCRUB_TYPE_RTBITMAP:
 		case XFS_SCRUB_TYPE_RTSUM:
 		case XFS_SCRUB_TYPE_RGSUPER:
+		case XFS_SCRUB_TYPE_RTREFCBT:
 			ret |= REPAIR_DIFFICULTY_PRIMARY;
 			break;
 		}

