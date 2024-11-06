Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D4D2010EC
	for <linux-xfs@vger.kernel.org>; Wed,  6 Nov 2024 19:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920672; cv=none; b=FFXHB1IhQOAu7K9UJ4WVffNt/WKdUpVsgBbcaxbXD4zcThkJUE6NA8tQndW4ngIUP/QUMfaHWlCo2ag5J4C3IsNWnjhKscJuGJEd7FW5HcBOeZAkHwfH90kVT22BlEk9EpAX0eQgh8wzAmHxcZit5bmpM/xc17Bk9pAO0ptq4Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920672; c=relaxed/simple;
	bh=d3QmKEWwVhP9M6OnKtJWPCu3kGFseuLuOui3iEMArlk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oes3fLwzfLlGF9C8DFutvbx3OCQ+ydjqwHCZkDq9/ihQhPoTM+3EELAGAUjbSMp2cS32oxJqOZf/gFgY2K1P6lxAVOcTarPP93bU2YTy5nDgQ2/cwwQJ8yAnfc+rEc+UHCdVsxHA4xoK5wlWU3v8oH7hKOEY9ZfO475YUfdcSDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sOhjG9C/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sOhjG9C/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067EAC4CEC6;
	Wed,  6 Nov 2024 19:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730920672;
	bh=d3QmKEWwVhP9M6OnKtJWPCu3kGFseuLuOui3iEMArlk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sOhjG9C/wHQIdQaMit6I2SbvibZi0ZitWHuSaAGLcyMuQEGSiTXSniqL+oSpmqcjj
	 a42dazKsAg7rb2Yj3QzbvtFiqlOowksCPTpe0aeljd2qK43dL1c6KjERy8HTtYSkay
	 d7I1YPValhIRhEfii5Bt3CCvLE/7KMf6b8aul2/FZhU0lDvkCyy4LDaiXu2cf7+Sru
	 tQ7qNCARdoSEYL8325p9PIoo3IMNJtwrCrupA+nwp5/PoDQY4hFq7xOotDgqMyUXj6
	 d0dp856RTwTtO0N+stCatAJHLYzozQh4Wb+sC2jn/HWHCPefvtCY56lVgCwXfXILFH
	 9ePHXN58HrRKQ==
Date: Wed, 06 Nov 2024 11:17:51 -0800
Subject: [PATCHSET v5.5 3/3] xfs-documentation: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173092059696.2883258.7093773656482973762.stgit@frogsfrogsfrogs>
In-Reply-To: <20241106191602.GO2386201@frogsfrogsfrogs>
References: <20241106191602.GO2386201@frogsfrogsfrogs>
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
 .../allocation_groups.asciidoc                     |   54 ++-
 .../XFS_Filesystem_Structure/common_types.asciidoc |    4 
 .../internal_inodes.asciidoc                       |   41 --
 design/XFS_Filesystem_Structure/magic.asciidoc     |    3 
 design/XFS_Filesystem_Structure/metadump.asciidoc  |   12 +
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    5 
 design/XFS_Filesystem_Structure/realtime.asciidoc  |  394 ++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |    2 
 8 files changed, 459 insertions(+), 56 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/realtime.asciidoc

