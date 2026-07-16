Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6052234994;
	Thu, 16 Jul 2026 06:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784181978; cv=none; b=dK8xvyUF8b9yf9K1mzzJiXMTHklVSL2+shp003vT3s/9kGVIaoT8Yc2H9S8phgih9uQ4zut8i+Ht3fG9ThkZsfeAz9eQsW1SwwyBMGtZMN6zkuM3DxVz1o4mAkvh2ebXrAoEZnmDHv32C15pjy/zjgfcBYIHti8I1vrH8SHvOnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784181978; c=relaxed/simple;
	bh=u2HZWZS5ZzBuN4s37LjQOE3WLC6+rhqwcF6gdLaEKf4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=jiK7uHb3omP0UZXlt7Mqroz35rFiaVE/llcUHuuMAasmvamViny3VzLZnFCRPY+xZxq94/YMn13Bm8fPViGAQL8vIKIoJRDlWP3diSA+6OFfeckc2ThA8W+TXBD3BJMKcHy+LWl2T825VR426tos9ubnfBrgoUW+RRXm+tHH988=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjagNwIZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjagNwIZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7A46E1F000E9;
	Thu, 16 Jul 2026 06:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784181977;
	bh=2aA/3rCH7xXbxTNZ1vldW87m7z2DZl9bN/tJw7L43bk=;
	h=Date:Subject:From:To:Cc;
	b=QjagNwIZVZquZ9vGMjEW0ehHgcLlerCTne5J65xYUIcm/XoS1Us6VaYUZJuQ7IyOg
	 Qt7skXiwVSqPrVIKSG1uwxtr/tNLIIsotYYYoZoRp+qtYWScXaGJHOAUmKrOxFpnUb
	 Goo/7Qq7QmRAgkbORUrNK6TkdmM3MvXhgb+ZAqiuG8Gt6Iz80ym7JfnbsHLDptdFbi
	 vIhGASyFWiVNMDT990MVJ7z1v3WnaBZo4v4vOBQP/8t6NswuV6dqKkZnH/uD+0q+CX
	 PtU8RrHJMIiFHMjRBOvItq+G01rdJnT5kCyDAg+hI1GwA8g80uB1K9D451wKrexC0A
	 P25mMUan+cZwg==
Date: Wed, 15 Jul 2026 23:06:16 -0700
Subject: [PATCHSET] xfs: LLM-inspired bug fixes, part 3
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a third batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-3
---
Commits in this patchset:
 * xfs: check cowextsize in xrep_inode_cowextsize
 * xfs: fix transaction block reservation in xrep_rtbitmap
 * xfs: rtsummary scrub should treat rtbitmap corruption errors as an xref error
 * xfs: zero i_nlink before repair puts inode on unlinked list
 * xfs: mark nonzero sb_gquotino as corrupt on metadir filesystems
 * xfs: don't livelock in scrub on a circular unlinked list
---
 fs/xfs/scrub/agheader.c        |   90 +++++++++++++++++++++++++++++-----------
 fs/xfs/scrub/agheader_repair.c |   17 +++++++-
 fs/xfs/scrub/inode_repair.c    |    2 -
 fs/xfs/scrub/nlinks_repair.c   |    7 +++
 fs/xfs/scrub/rtbitmap_repair.c |   46 ++++++++++++--------
 fs/xfs/scrub/rtsummary.c       |    2 -
 6 files changed, 117 insertions(+), 47 deletions(-)

