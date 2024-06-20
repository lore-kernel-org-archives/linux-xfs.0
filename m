Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E3C2BAF3;
	Thu, 20 Jun 2024 20:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718916751; cv=none; b=p+xtPj+OKYVTj85iVC82fHwmWOHcwAwIsXGKYKarB6txnW5JriJ2OOg9FBIW2DrS9cLO4uSLVkmQBnW6aIAFnMHI5y7UDgN5OCxNNKS/Cm3seB0ZUHLRS/1e4UPNbe6fCiUe3+bnZb4F+bDdxCGdBiI0IADTm4IcCME0J3ROxbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718916751; c=relaxed/simple;
	bh=jgnX/e+HdTPalEi/ZQCH9hRit7BptaKyY6o/+R0/YC4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W+phNrndgi8pcTybH7CRynY8GiNwVpoUxxnU8zXbd3EzA1Qo6LtUTjaEQOw+26tgmhqfXzhL139d7j0e+EiwwQSYnOsxmht7Uqb8vg2CEfybWk7Y2bxK+A1+pWMRwtv3rszxDHTTQaL0IN+O53CgdI++hUdSxLsqUUptnp2EaiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sNyjH5kT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sNyjH5kT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB34C2BD10;
	Thu, 20 Jun 2024 20:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718916750;
	bh=jgnX/e+HdTPalEi/ZQCH9hRit7BptaKyY6o/+R0/YC4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sNyjH5kTFA8kO5BOKT4Pp896FcQF539/g3mtcNnFUeQh4QDQf47dkCE1fhAdVwfl6
	 DuCa4/Wo//lah02/NHAbek3+OA2ZD5Phkw5oIqzBd/IFK/+5a6uPdVWBRkqiW/x77k
	 0tSvHq3X/6Tm+o1SRf2sAu3D+td0o/tV98gLdkbVSHXGBM5tqTwMg2oThSHgvKm+NN
	 oX6XyJhUVNp90e65Nrpw/08T+S3nDkPmFtnDBsVJ+hyAjL0mJhCEo6sG8sByREoOVc
	 owmmDrjycYTvJe0qHvMOe9TSvPm5AslD0t1A9bUvAOg6mscP0+zb+SMFvcx7QPJaAd
	 X7srCFmUmBLNg==
Date: Thu, 20 Jun 2024 13:52:29 -0700
Subject: [PATCHSET 1/6] xfsprogs: scale shards on ssds
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <171891668738.3034747.8089506305966920065.stgit@frogsfrogsfrogs>
In-Reply-To: <20240620205017.GC103020@frogsfrogsfrogs>
References: <20240620205017.GC103020@frogsfrogsfrogs>
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

