Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D501F135A5A;
	Mon,  3 Jun 2024 20:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717445526; cv=none; b=X3UciRrvVRD15w75Rlf3QDOjBGR+/dKi2Yq5qRLV/PY/QY1nq8XdTu7mWVT+3S2L357WNaxCCdWBMZATCv0WA8/PY0pkR5mooXqmfebboFjMrIQVtziJKsTa+OHEpEOxKGeD7TQXjN2SjYHynELqJiUN7h/acUmLgLHpu7xR1p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717445526; c=relaxed/simple;
	bh=jgnX/e+HdTPalEi/ZQCH9hRit7BptaKyY6o/+R0/YC4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=AYPjM/rEjansNFUo0b0zvEpFzJ+l+h+LLewpfuuqX2Ks7Sx0W/bNi+igBKtJJ/6GJeX1JyCrWRCFwCO/H5yF0okXUSdaE7fnD2ogt/mAAI7jqDpeEkP8ORssMYXZfjD1qWBniNOODtCcfekujZvveRIsjLaM/G8/G0S1eAFT8ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDlQK/am; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDlQK/am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6C5C32782;
	Mon,  3 Jun 2024 20:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717445526;
	bh=jgnX/e+HdTPalEi/ZQCH9hRit7BptaKyY6o/+R0/YC4=;
	h=Date:Subject:From:To:Cc:From;
	b=lDlQK/amuwF1Cu6tKMSRDmD1qHJdEHQ+pyEwwxOu5cxvbjJLmBUe+Yhipeoiv2sy1
	 br+wns1MAujPjRUcpfR/PPEuD5wI9nrrDx5wiRpeOa1zpQb1blbZ+XnZokGrZ1mUMg
	 CBiJb3NhfnTRJwso5ZVdJpCQ3vJD5WfiOK+0IQg6CmQRskKEDqVkcIOGf3iZpnVKtO
	 hlsE/Hfo6d8aw3P6iBBPawPmoYVikOKKrs32vyARXyrfezuZ34gI1AO/7CDJNOskm3
	 fmEhoek7so7gB3pN4+aX4yNmaWjC8i/Qwkl1po0CpGF1J1KJCtcGIyV07hP2IrdCK1
	 zIoeQ3viqnBzA==
Date: Mon, 03 Jun 2024 13:12:05 -0700
Subject: [PATCHSET 3/3] xfsprogs: scale shards on ssds
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <171744525781.1532193.10780995744079593607.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

For a long time, the maintainers have had a gut feeling that we could
optimize performance of XFS filesystems on non-mechanical storage by
scaling the number of allocation groups to be a multiple of the CPU
count.

With modern ~2022 hardware, it is common for systems to have more than
four CPU cores and non-striped SSDs ranging in size from 256GB to 4TB.
The default mkfs geometry still defaults to 4 AGs regardless of core
count, which was settled on in the age of spinning rust.

This patchset adds a different computation for AG count and log size
that is based entirely on a desired level of concurrency.  If we detect
storage that is non-rotational (or the sysadmin provides a CLI option),
then we will try to match the AG count to the CPU count to minimize AGF
contention and make the log large enough to minimize grant head
contention.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-scale-geo-on-ssds

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=mkfs-scale-geo-on-ssds
---
Commits in this patchset:
 * xfs: test scaling of the mkfs concurrency options
---
 tests/xfs/1842             |   55 ++++++++++++++
 tests/xfs/1842.cfg         |    4 +
 tests/xfs/1842.out.lba1024 |  177 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1842.out.lba2048 |  177 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1842.out.lba4096 |  177 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1842.out.lba512  |  177 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 767 insertions(+)
 create mode 100755 tests/xfs/1842
 create mode 100644 tests/xfs/1842.cfg
 create mode 100644 tests/xfs/1842.out.lba1024
 create mode 100644 tests/xfs/1842.out.lba2048
 create mode 100644 tests/xfs/1842.out.lba4096
 create mode 100644 tests/xfs/1842.out.lba512

