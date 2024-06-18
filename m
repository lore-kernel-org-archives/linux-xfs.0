Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02684A1A;
	Tue, 18 Jun 2024 00:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671572; cv=none; b=HO3AtvWgkofsn4NkYe1/+8wT82UQcV/n8etJtll2cgAPbuUzA/XqDEJ5KHFdl+IviFGFpn17qIoPf37J9j4XckbFZuMAk0Eazj0CW381VStBpiL0RNisK/HhaX54RVvaz9JsTuaz3Bib9BpsSGoGGhI/4jD6RnXK8XmQtp9V+Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671572; c=relaxed/simple;
	bh=jgnX/e+HdTPalEi/ZQCH9hRit7BptaKyY6o/+R0/YC4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=fkEvSrGM8LSyknKUrIeShXHgk7V+DAnAe7cbBuuzdg0zZijwRf2RadEGp1FqYEQ3Fl4vUZ4rJt4ThfP4AMY5Bh8TNexs8F0i3FxjLQIcZ5sSPgtdb73NwdXSTW4rqsxxP30lp2Wlk1XThbF7S9fMJs8JUnTab5EljyoS2iWAv8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AVhDBFu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AVhDBFu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E88C2BD10;
	Tue, 18 Jun 2024 00:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671572;
	bh=jgnX/e+HdTPalEi/ZQCH9hRit7BptaKyY6o/+R0/YC4=;
	h=Date:Subject:From:To:Cc:From;
	b=AVhDBFu0oUS4SRt0Ds9K5u5PsSMUh3FlLGgUJHJM3sVwU5EKvLaE3BGuLtCsnkgX9
	 uJIMbMBS7WrJZWj5df57aIMvUrzw0sM3X1S20vpiDWgzZH2VRUJYGIPamIhZj0HHDc
	 VhxSsJf5NP4iqnGcnBlslHUkpUCZymCwn4AJJvl0fOBzqT4n0aeorYH0KOhuKfT2Jm
	 sLtoe8IjYe+9XJwcjdfe0fi8L62j+ZV16v0EU+yhAwPjSemObV9uaLB+ilZ+4CXFHz
	 W9GrcKQOy194bpkmQ6TThot8otyHiuJq8WL284EDkoGhD6YYhTUvA4OfNOPXlqkpFJ
	 gXUNvRqRBR+9A==
Date: Mon, 17 Jun 2024 17:46:11 -0700
Subject: [PATCHSET 1/6] xfsprogs: scale shards on ssds
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <171867144916.793370.13284581064185044269.stgit@frogsfrogsfrogs>
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

