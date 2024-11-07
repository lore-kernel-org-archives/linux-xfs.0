Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0741819B5B1
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 23:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731021916; cv=none; b=ZiYKV0197LlduIhWOvBfMCtxAdlFSIJfth+fgVI3ynCJhA1zWj5+yXOzpjF809CYyy5ICv50SXfmFAPcUYbYJNntUZwSS+eoefLX1HMOlFPN/8xQp182EnmXUy9njPe4d1mx0Cj6aH/GUsI4R479LT2akuo0k+tRaicOxkVO9Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731021916; c=relaxed/simple;
	bh=j1fbUPNNi0moi58zkiPSRFQx0XbyH5yOo8NXmBr+NAE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sUBKnQBumISfTE5/dZsqWmUT+t9W9NU7ng0bTCYsLRJ4JjCVZ3ULuxhK/Yd/1qj/3lYfjDLuEuBlxoPBd/uygcW/WGF0NU6t3HAhweOtUeWYi0rNjcSEUtwtRIC+Cxv5F30vm8KW4wus4av5ppuYeHv7GIqX37hKNRn0Fri2ZvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJbuUwuv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJbuUwuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DA9C4CECC;
	Thu,  7 Nov 2024 23:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731021915;
	bh=j1fbUPNNi0moi58zkiPSRFQx0XbyH5yOo8NXmBr+NAE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JJbuUwuvzKaAd+SnIrxSJiE75gwEhGFOECwFweR9fAIQuDhfuecVSBlW1pWnyvT3P
	 qTJc9NyICF7YN0gxdC/EG4MsyINHntuIXCpGxujbXCEFyaXy5XGqWSQB4YJlOMkCuH
	 dwarCRk6wYsSOu5bXsKGAf4gt1JfIPlzS88iki041GLZ5suYBYR/TunLYLMRBdN4cy
	 W2/WiG7mnUOVukaRzmhxG/xVr/ggPRetQbQxNxRNqVSmBmu1Zyt8bz2jTU1Oo5dZSf
	 7EW/6t0rWsix47ZYoD5QGLXVfXBzadRmS5RtlNKB7Xzs15r+MCoScl17qsonk7Hhvj
	 kOuu42UrRVq2A==
Date: Thu, 07 Nov 2024 15:25:14 -0800
Subject: [PATCHSET v5.6 2/2] xfs-documentation: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173102187871.4143993.7808162081973053540.stgit@frogsfrogsfrogs>
In-Reply-To: <20241107232131.GS2386201@frogsfrogsfrogs>
References: <20241107232131.GS2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Document changes to the ondisk format for realtime groups.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-groups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-groups

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-groups

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-groups
---
Commits in this patchset:
 * design: move discussion of realtime volumes to a separate section
 * design: document realtime groups
 * design: document metadata directory tree quota changes
 * design: update metadump v2 format to reflect rt dumps
---
 .../allocation_groups.asciidoc                     |   20 -
 .../XFS_Filesystem_Structure/common_types.asciidoc |    4 
 .../internal_inodes.asciidoc                       |   41 --
 design/XFS_Filesystem_Structure/magic.asciidoc     |    3 
 design/XFS_Filesystem_Structure/metadump.asciidoc  |   12 +
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    5 
 design/XFS_Filesystem_Structure/realtime.asciidoc  |  394 ++++++++++++++++++++
 .../XFS_Filesystem_Structure/superblock.asciidoc   |   25 +
 .../xfs_filesystem_structure.asciidoc              |    2 
 9 files changed, 450 insertions(+), 56 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/realtime.asciidoc

