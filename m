Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F5F18B46E
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 22:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738621861; cv=none; b=OvfDh48IIaipiMXOdZTmghZndzfB1URaF82PzO6TLNaPAfcwj4WNlMUn22KcU/JvXQGrVxx65emEQ69pAYb1MHnD3azkIAzI4hsplEAGnS4XMBdRXgQ4Fs4iOFEDhMUE0lmn6k5l3+CdEP/xCvirgdJAb0us1uUKfPHT5JxR6zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738621861; c=relaxed/simple;
	bh=6PdE7ZIOxqu2MsLx0wUI2j2Y7hTfZnh/ajvfOPKZJH4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=snqeIKwhEhYswHB77jqPQNUf+hZp6w23j6PpAyr9EVgcJl7uXuzX9lUQFfq8drTqvOmQ5M1MF7C/DjSlM6i/ZCiEYeHPMw5s6jveYZmvmsL12e8rGxCLFkOihRy6c/9iX8JNzTrf1TZVOzLXIISwaJc2E40L16VrcdFrG79ZkMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bT+TGJ/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bT+TGJ/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BA0C4CEE0;
	Mon,  3 Feb 2025 22:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738621860;
	bh=6PdE7ZIOxqu2MsLx0wUI2j2Y7hTfZnh/ajvfOPKZJH4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bT+TGJ/5sx6AkLa7CsugrjA69muDT+AiQJep5+YbOJvL4NmjpvDApcLlMjwOrLS4U
	 N57f8vrS0vDV4bn9jkIbrZmAfsj41LppOwajTZeJMuh/bNRFo4H0G068WLn8yXnpEu
	 BTAkB276Dd/xWBYfLLan43jr027a8fCWLKaHIUOlwqx43owmO07tzZRYM5sXxLpvgz
	 STjDf1rgHUkhfIOt7eEQPF/NLQwnliyqSxbnWO30U++78vCUH7HKdcLv18C0qgCnKa
	 0oL4CJcMPIh/mxAJPXPmQb1DFa/JKO+xE4R6pkath1YQKnTy+sH4OxtAr7ncjw8wZI
	 hJFz/yqo867wQ==
Date: Mon, 03 Feb 2025 14:30:59 -0800
Subject: [PATCH 2/2] xfs: fix data fork format filtering during inode repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173862180326.2446958.17080352646335360731.stgit@frogsfrogsfrogs>
In-Reply-To: <173862180286.2446958.14882849425955853980.stgit@frogsfrogsfrogs>
References: <173862180286.2446958.14882849425955853980.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Coverity noticed that xrep_dinode_bad_metabt_fork never runs because
XFS_DINODE_FMT_META_BTREE is always filtered out in the mode selection
switch of xrep_dinode_check_dfork.

Metadata btrees are allowed only in the data forks of regular files, so
add this case explicitly.  I guess this got fubard during a refactoring
prior to 6.13 and I didn't notice until now. :/

Coverity-id: 1617714
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode_repair.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 2f641b6d663eb2..13ff1c933cb8f9 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1055,9 +1055,17 @@ xrep_dinode_check_dfork(
 			return true;
 		break;
 	case S_IFREG:
-		if (fmt == XFS_DINODE_FMT_LOCAL)
+		switch (fmt) {
+		case XFS_DINODE_FMT_LOCAL:
 			return true;
-		fallthrough;
+		case XFS_DINODE_FMT_EXTENTS:
+		case XFS_DINODE_FMT_BTREE:
+		case XFS_DINODE_FMT_META_BTREE:
+			break;
+		default:
+			return true;
+		}
+		break;
 	case S_IFLNK:
 	case S_IFDIR:
 		switch (fmt) {

