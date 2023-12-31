Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79604C8CA;
	Sun, 31 Dec 2023 19:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lF8B6QQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48532C433C8;
	Sun, 31 Dec 2023 19:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052645;
	bh=i3yHr9k0x9oRaKw5GHrv6qsO2s3W5Nf0HiUpMTSZuDE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lF8B6QQJ4YabiFSGfxBzZv+x4pJN5bzhPyCyRc3K7INpgghXZYD+o1lWdy75Of5lE
	 B7FqSNPFoJSJP6m1lPjrthiVpuqJQxBjNxZ/nGsGq/jmXW19kwS9yXkXv+1sK7DGgq
	 1cejWJe7fbkEYkYppRDFtqc2EEn70GUR4BcZbL3qRTtnjzFLvSYnfGcjzFh9u6wy7B
	 fLqkYLiPnExj3uo9UJBMnoEUBfe2zyRyA1LHrbh3dQXvo35RVDp2fHzmdXBdFZamtH
	 pPEf5yCEXrT0+GdS1Fht/nnp+1r3pvhGD/iXTRGq0rDu7ESjQZPLk5P/dWn8ORfR2S
	 j0C8Dg+38GcpQ==
Date: Sun, 31 Dec 2023 11:57:24 -0800
Subject: [PATCHSET 2/8] xfsprogs: scale shards on ssds
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405025931.1823561.11251524119820744796.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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
 tests/xfs/1842     |   51 +++++++++++++++
 tests/xfs/1842.out |  177 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 228 insertions(+)
 create mode 100755 tests/xfs/1842
 create mode 100644 tests/xfs/1842.out

