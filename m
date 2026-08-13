Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1654C3B777D;
	Thu, 13 Aug 2026 05:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786598659; cv=none; b=EOkKGOkHZR5V27SrP2Cb3EYmmVo+lp3XMgpH0GT5Enk21FGaFgmp5qUAjbTIATYdjYe1g5Oc5Vj0m/ln9UioDhziwNghHE53qAIQX4TgovGoXP9dRatm7Oslem9bHjx065Fblzohhxv7nhomn9QMCuJIjGBpy4r1ztPxxyJNurM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786598659; c=relaxed/simple;
	bh=OC1jWfkUmlzSgyP0je5q8m3zXgZ4sdTBfndQDcRfHYA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=Ik1cyw51YhPf5GAbI7d64C1EdmCjSwnGJXh89YKucOpBCXAZuvwpb/5HA7QiQUX524RCY018ttrOa0aY7Fc8k7pR+qufeAzdzWbRVPGZBgmR9LIY7gItePyk2Hz89+LFHlS9cRYPx5apOLz35sb9RGxV4G9YOB8aUgrABX8E534=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8I3yJG4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8I3yJG4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3D3FE1F00A3A;
	Thu, 13 Aug 2026 05:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786598642;
	bh=0dl5XAcdbD6Rg8elflFXkTNjSzObJovbL93ccqEo9c4=;
	h=Date:Subject:From:To:Cc;
	b=A8I3yJG4Fzwbb6fqmykYEBs2XWAzwYLvVlfnJj58zC5kcCfQd5LhPc1x97ZIrJAzl
	 dGlKlGgmmZMLtN5qlyPyZ8bpJUdJV3Mkq8IZtdiEYgGQtWYtVlV7NqSDiAc1nkXAmV
	 MdJDBKAIVJL6yiEhowP0y2znAe/hMGYEIS5z/2vQ8QX19mDlGi0Z2vm/ZsiV0NTjh7
	 39o6rAT6neGm0EQMPQrAaUkW2A0p72A14RDCYB2su37mYhtN3ZQH8I/41i6V0Mnbon
	 t49M0oapFKvpTZQjua51Y3EF1lOCzVr1WK2VfKnlp+yiEkdDUVYcUwdDbNxPmi4ElG
	 ipU1IJyv3vaFg==
Date: Wed, 12 Aug 2026 22:24:01 -0700
Subject: [PATCHSET 2/2] xfs: LLM-inspired bug fixes, part 6
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a sixth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-6
---
Commits in this patchset:
 * xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap filesystems
 * xfs: preserve owner on in-memory btree creation
 * xfs: don't leak new_bp if xfs_btree_bload_drop_buf fails
 * xfs: actually recover intended file sizes in xfs_xmi_item_recover_intent
 * xfs: don't modify file attributes or poke fsnotify for dry runs
 * xfs: fix bnobt repair space reservation disposal failure
---
 fs/xfs/libxfs/xfs_btree_mem.c     |    2 ++
 fs/xfs/libxfs/xfs_btree_staging.c |    4 +++-
 fs/xfs/libxfs/xfs_rtrmap_btree.c  |    2 +-
 fs/xfs/scrub/alloc_repair.c       |   18 ++++++++++++------
 fs/xfs/xfs_exchmaps_item.c        |   19 ++++++++++++++++++-
 fs/xfs/xfs_exchrange.c            |    6 ++++++
 6 files changed, 42 insertions(+), 9 deletions(-)

