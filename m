Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5064222FE13
	for <linux-xfs@vger.kernel.org>; Tue,  8 Apr 2025 16:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744128335; cv=none; b=VpEkYCUARMy2tg7f6NORs07Z92ctwijUAn2LTsmYt3ug63D5WhcBvkLjOsiFkplRJtoAJEgtU4c03qZRSY/WDUYjCAw4eSUbtBHC5lxCy2YgFTFqc6knPZydpadzhOea6XC8AnE80rLzuur/Qh1LTXo6teznM/uYJYShsvYl9j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744128335; c=relaxed/simple;
	bh=o7vOsgLVJgFcL9NA1pac2bzFpoDTZWEAmGlOnLE1MUA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=LP40Nt16LTOO1Eem3AG3Vjm/QWSo+R0jeEmM/1jCIyf8OUtZSEI71bHwrJPMCwaT799lSAfip8fuavFNXXnMcx/MyxLSzBqjg10X1LtDN7WmIMzjw9bKjc49HueaT1mSWb/Zm7n7H1WcjUCWyd3vvnOwbl2q6UCUN0ZRtajAGQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rBwJMU61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rBwJMU61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBDAC4CEE5;
	Tue,  8 Apr 2025 16:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744128334;
	bh=o7vOsgLVJgFcL9NA1pac2bzFpoDTZWEAmGlOnLE1MUA=;
	h=Date:Subject:From:To:Cc:From;
	b=rBwJMU61AG0ZD1jMR9fjW5iYoJ/mR4pEuznDitqxLJ48JEA8mENTZzKg7e+nmvv8m
	 sBnwVlcUDtEza/g9ztkSrGB10Be0Pj4ZZPwuvPoY4Y3K58/NTXeMtaRMd/n05Owbf4
	 HMvv7MmtlyCx8tYJCPCyESd+iyrhODcsNuRFHDLPYD1ZT1JLGtzle/aHoNFsen8/0H
	 9StBGk2PQQ2ZDXW+uTH5Usc1/hQslkCjpxpcJyfdOtpqPp8JinjrwODJ0IIHeA6bSb
	 4C54ao/APx5RkpPyjT7IPnVX4awcrcI4u311PtgkJzxMw4OGwXk5wetqIqmfAquxDx
	 MX3blsOf3FuWw==
Date: Tue, 08 Apr 2025 09:05:34 -0700
Subject: [GIT PULL] xfs-documentation: updates for 6.15
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174412809946.1477451.1579584673862023160.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Darrick,

Please pull this branch with changes.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit f512c164a1d0e83a54eabf757be689c3f8bc54a7:

Merge tag 'xfsdocs-6.13-updates_2024-11-26' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-documentation (2024-11-26 16:24:24 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-documentation.git tags/xfsdocs-6.15-updates_2025-04-08

for you to fetch changes up to 7d07fb949b0f3aa05fdaa289fba53e70931e974a:

xfs-documentation: bump design doc revisions (2025-04-08 07:55:56 -0700)

----------------------------------------------------------------
xfs-documentation: updates for 6.15

Here's a pile of updates detailing the changes made during 6.14 and 6.15.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (1):
design: document the zoned on-disk format

Darrick J. Wong (3):
design: document the revisions to the realtime rmap formats
design: document changes for the realtime refcount btree
xfs-documentation: bump design doc revisions

design/XFS_Filesystem_Structure/docinfo.xml        |  16 ++
.../internal_inodes.asciidoc                       |   7 +
.../journaling_log.asciidoc                        |  32 +--
design/XFS_Filesystem_Structure/magic.asciidoc     |   7 +
.../XFS_Filesystem_Structure/ondisk_inode.asciidoc |  16 +-
design/XFS_Filesystem_Structure/realtime.asciidoc  |  45 ++++-
.../XFS_Filesystem_Structure/rtrefcountbt.asciidoc | 172 +++++++++++++++++
design/XFS_Filesystem_Structure/rtrmapbt.asciidoc  | 215 +++++++++------------
.../XFS_Filesystem_Structure/superblock.asciidoc   |  25 +++
9 files changed, 392 insertions(+), 143 deletions(-)
create mode 100644 design/XFS_Filesystem_Structure/rtrefcountbt.asciidoc

