Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5934A8528E;
	Thu, 23 Oct 2025 00:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761177636; cv=none; b=At8mze+Bjt1rv6kkbWLCSQvjnw4iHeMVzgOuzIiygSEmdTlAHwAs8sF5jx24e0KHKf7/0tFALnVTww8/s1T56eVMsECeioLtOmpqqbFXZjuRn4Qat2YZMSR7MJm94vbS/L0rIUUf2IUNaYSTvrtMi1+VjAOBmH1gyogvKShIT+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761177636; c=relaxed/simple;
	bh=Ro9mNIV62Fp6wJCt6/AvYxCWzprkYtpGnQKGD2I5un0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OndMujPG9J0+5GpVpt6XaYxD9pyrVBlArSAEDsWnrkxeYuGKpfajOBe+CQef1DTlbMa4RRiTbDac7kJJLG26QHrev8XivXVJVdF2m030mOEAuBGzwlkTPElIY1Da3FZQnkcSk37toORUgQ+iVWD5QqokatPzPE3SrCRkhnMqfEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oynsdZ9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oynsdZ9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28899C4CEE7;
	Thu, 23 Oct 2025 00:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761177636;
	bh=Ro9mNIV62Fp6wJCt6/AvYxCWzprkYtpGnQKGD2I5un0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oynsdZ9eOyLxg0NiHkiOinZQ9Tl8uUmLYtX6yZHol8uy1RRJvp3ROhPk1GOxUMXr6
	 XFz+VTnYaZyq2uBd+hkyjV9vOAA2NIpqUKI7M3U1PzxZK5POkSULRZKx6mhV6x0l93
	 YRydbXaO7xyxq/qCNmgq+VsefPCgR9GlZS9Mj2mPgqFmR4g5JMCRSOMhgGdN2PEw1p
	 LPmFDpsq3AZLzOm0QVxtJwdeGfXijRfOEDZQYdS8LEXKjjUnV5rFwd5LplgipkdTBq
	 RVtedL+MqS8/J6xJyDBvz+n5CWlsruRAxamchAdEOoJAy9WkPEVOn5kz2ZLwEDwy0G
	 NJn7RWVJOQ3cw==
Date: Wed, 22 Oct 2025 17:00:35 -0700
Subject: [PATCHSET V2] fstests: autonomous self healing of filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <176117749414.1030150.3638956559465976455.stgit@frogsfrogsfrogs>
In-Reply-To: <20251022235646.GO3356773@frogsfrogsfrogs>
References: <20251022235646.GO3356773@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series adds functionality and regression tests for the automated
self healing daemon for xfs.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=health-monitoring

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=health-monitoring

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=health-monitoring
---
Commits in this patchset:
 * xfs: test health monitoring code
 * xfs: test for metadata corruption error reporting via healthmon
 * xfs: test io error reporting via healthmon
 * xfs: test new xfs_healer daemon
---
 common/config       |    6 +
 common/rc           |   15 ++++
 common/systemd      |   21 +++++
 common/xfs          |   86 +++++++++++++++++++++
 doc/group-names.txt |    1 
 tests/xfs/1878      |   80 ++++++++++++++++++++
 tests/xfs/1878.out  |   10 ++
 tests/xfs/1879      |   89 ++++++++++++++++++++++
 tests/xfs/1879.out  |   12 +++
 tests/xfs/1882      |   48 ++++++++++++
 tests/xfs/1882.out  |    2 
 tests/xfs/1883      |   60 +++++++++++++++
 tests/xfs/1883.out  |    2 
 tests/xfs/1884      |   90 ++++++++++++++++++++++
 tests/xfs/1884.out  |    2 
 tests/xfs/1885      |   53 +++++++++++++
 tests/xfs/1885.out  |    5 +
 tests/xfs/1896      |  206 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1896.out  |   21 +++++
 tests/xfs/1897      |   98 ++++++++++++++++++++++++
 tests/xfs/1897.out  |    4 +
 tests/xfs/1898      |   36 +++++++++
 tests/xfs/1898.out  |    4 +
 tests/xfs/1899      |  109 +++++++++++++++++++++++++++
 tests/xfs/1899.out  |    3 +
 tests/xfs/1900      |  116 +++++++++++++++++++++++++++++
 tests/xfs/1900.out  |    2 
 tests/xfs/1901      |  138 ++++++++++++++++++++++++++++++++++
 tests/xfs/1901.out  |    2 
 29 files changed, 1321 insertions(+)
 create mode 100755 tests/xfs/1878
 create mode 100644 tests/xfs/1878.out
 create mode 100755 tests/xfs/1879
 create mode 100644 tests/xfs/1879.out
 create mode 100755 tests/xfs/1882
 create mode 100644 tests/xfs/1882.out
 create mode 100755 tests/xfs/1883
 create mode 100644 tests/xfs/1883.out
 create mode 100755 tests/xfs/1884
 create mode 100644 tests/xfs/1884.out
 create mode 100755 tests/xfs/1885
 create mode 100644 tests/xfs/1885.out
 create mode 100755 tests/xfs/1896
 create mode 100644 tests/xfs/1896.out
 create mode 100755 tests/xfs/1897
 create mode 100755 tests/xfs/1897.out
 create mode 100755 tests/xfs/1898
 create mode 100755 tests/xfs/1898.out
 create mode 100755 tests/xfs/1899
 create mode 100644 tests/xfs/1899.out
 create mode 100755 tests/xfs/1900
 create mode 100755 tests/xfs/1900.out
 create mode 100755 tests/xfs/1901
 create mode 100755 tests/xfs/1901.out

