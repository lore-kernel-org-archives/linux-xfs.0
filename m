Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1B64C62
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732668243; cv=none; b=fKGlN6a4KvpsC9hpoOD3cSzWHBs7GOTg5+VemVu7IaLA02IeqWEeGbMR6NumVeyTjcFN8CYUUlAyVm/IhBUJVOtOrBo8X09aAUOMVz4DocQTKVeoPOlLRizodhu641r8JwmY8IGIaiWFAxWKm3mhZZZOJGYcP26DY5Pgoy4als8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732668243; c=relaxed/simple;
	bh=b1K6NVCQLt6jjv7YqEyj6KQEXIDY12emwFJP/99di8g=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=f8T2XaMiGJeI0ZAaJYSvo/me+P8Vl6TXjXDd+hQmhLKXIaNR+XEl9Wt/ze05RJgEdDEIhgVxhfQIhhB6niWTL3u0F4RSOx+IKF4nDnkHqEiDgNO+D09/ffH/XlSyapPzEssBkTTbzTEkuMp6/KlIhZuGej8JfjCYJ1XSsTf73+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LzksXWLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LzksXWLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7380EC4CECF
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732668243;
	bh=b1K6NVCQLt6jjv7YqEyj6KQEXIDY12emwFJP/99di8g=;
	h=Date:From:To:Subject:From;
	b=LzksXWLVLixNs9Lc29lkcBZhQWP9mID3P5ZmxQV/BOWPpi5DCp/59l8NNfFD/gRln
	 0JU0ClbrN76WNFv8qat9O+84zAEJOJ8MYVt8LCBxrphn0EvBhVHqG4W0HTGM/9LKxi
	 XCzi8NSXeSS+mYVl28O2iZQRXcFhS4lnCxbfopUsJ3G3ZDwrjJ2kzgdaucY6byXnf1
	 PTcypaIlZwI7yWn6n3rO8e/61lvTDGVQWjrodw2S6F/3e3QHB4RL7OVfmUnSeaBqKJ
	 BbJozS4pehut1LE+jOjXqwv1Ci9Qb/ypfuuSiY9SbucRLBQyKiuksKomXOG6CVj1mU
	 nbLIP0hpgZqGQ==
Date: Tue, 26 Nov 2024 16:44:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-documentation: for-next updated to f512c164a1d0e8
Message-ID: <20241127004402.GR9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The for-next branch of the xfs-documentation repository at:

        git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git

has just been updated.  You can find a pdf version of this document
here at some point when kup finishes syncing mirrors.

https://www.kernel.org/pub/linux/utils/fs/xfs/docs/xfs_filesystem_structure.pdf

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

f512c164a1d0e8 Merge tag 'xfsdocs-6.13-updates_2024-11-26' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-documentation

11 new commits:

Darrick J. Wong (11):
      [d1eae8f704d8c1] design: update metadata reconstruction chapter
      [50cc5ebc4df7da] design: document filesystem properties
      [7e5b5ce0cdf2ce] design: move superblock documentation to a separate file
      [96dbe1c6444ac9] design: document the actual ondisk superblock
      [9feec865ecec2a] design: document the changes required to handle metadata directories
      [94508b87c93d10] design: move discussion of realtime volumes to a separate section
      [770553ba7196cb] design: document realtime groups
      [7a34dc0985cf92] design: document metadata directory tree quota changes
      [6d3d7596b8635d] design: update metadump v2 format to reflect rt dumps
      [368784fa00f920] xfs-documentation: release for 6.1[23]
      [f512c164a1d0e8] Merge tag 'xfsdocs-6.13-updates_2024-11-26' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-documentation

Code Diffstat:

 .../allocation_groups.asciidoc                     | 570 +-------------------
 .../XFS_Filesystem_Structure/common_types.asciidoc |   4 +-
 design/XFS_Filesystem_Structure/docinfo.xml        |  19 +
 .../fs_properties.asciidoc                         |  28 +
 .../internal_inodes.asciidoc                       | 154 ++++--
 design/XFS_Filesystem_Structure/magic.asciidoc     |   3 +
 design/XFS_Filesystem_Structure/metadump.asciidoc  |  12 +-
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |  27 +-
 design/XFS_Filesystem_Structure/realtime.asciidoc  | 394 ++++++++++++++
 .../reconstruction.asciidoc                        |  17 +-
 .../XFS_Filesystem_Structure/superblock.asciidoc   | 574 +++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |   4 +
 12 files changed, 1192 insertions(+), 614 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/fs_properties.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/realtime.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/superblock.asciidoc
