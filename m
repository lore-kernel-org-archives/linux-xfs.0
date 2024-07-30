Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AC01854;
	Tue, 30 Jul 2024 03:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309584; cv=none; b=XZj9gkOw2mcnu7MJtOPb4q4uxp/u6iuaS3obC3bKltVlYfRLPOfq9ZzxC0dpyKewOpwAaD+K77ubJZcbA07YeWA3mu7FqZJhc22hkUdDjzwAmi+YQGENNCENouTHRDfsQaM2IgssfBB5sikz+JlyQFjtKLmVpwsXC0Nt4FoTMeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309584; c=relaxed/simple;
	bh=bgvZ3WAnMMBGextpPEDs3DO5D7f3ixUZW0tyegdwk7M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=taJMuiBHRofXIVsratI7PtXFYxlGTfjrvSWOjMiNaCdghzuEE2rzxU4oIHX+Kaxp71nCiw6z3RAwClufkndvjowc7uajsiY+zVKnsqF6Yt8gIpZiXXbGrPmfChC6NgjHuMiLldajM3i3lbR184QmnCS6cplCdC1bl85nVqgeiCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AYb79Dh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AYb79Dh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4776C32786;
	Tue, 30 Jul 2024 03:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309583;
	bh=bgvZ3WAnMMBGextpPEDs3DO5D7f3ixUZW0tyegdwk7M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AYb79Dh6UfViwGBZx1PvlmbXmGDt/3/GvvCcg1B7maMnMneEaGuixKDgkhKrBnKpd
	 pYtbffi95hI/sfAXOEnT1iNs7QE2Qob5H1SCBQhTJaWQdCGTtAnqovFkxHRStgjWOc
	 1atVoZAfwB4+Bqc/g4DW0BaRjSE4+0sjk1zRsF86t3nG+musfISkF4qJjepWvJpIzy
	 leU9AEDA0v+C+b+87XID2bvUcUiu9VVIPqpl1NTW6GirGW6XbziJjdOw/0/INuEHtA
	 NmMSFO/KUqucbq4RnFx5ba06RZNuTAwe/+E/JIB8BRezgup1FBy6fIFWvR5bI0LdlA
	 r43mQcJeirr7Q==
Date: Mon, 29 Jul 2024 20:19:43 -0700
Subject: [PATCHSET v30.9] fstests: xfs filesystem properties
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <172230948293.1545890.16907565259543283790.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730031030.GA6333@frogsfrogsfrogs>
References: <20240730031030.GA6333@frogsfrogsfrogs>
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

It would be very useful if system administrators could set properties for a
given xfs filesystem to control its behavior.  This we can do easily and
extensibly by setting ATTR_ROOT (aka "trusted") extended attributes on the root
directory.  To prevent this from becoming a weird free for all, let's add some
library and tooling support so that sysadmins simply run the xfs_property
program to administer these properties.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=filesystem-properties

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=filesystem-properties
---
Commits in this patchset:
 * xfs: functional testing for filesystem properties
---
 common/config      |    1 
 common/xfs         |    4 +-
 tests/xfs/1886     |  135 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1886.out |   53 ++++++++++++++++++++
 tests/xfs/1887     |  124 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1887.out |   46 ++++++++++++++++++
 tests/xfs/1888     |   66 +++++++++++++++++++++++++
 tests/xfs/1888.out |    9 +++
 tests/xfs/1889     |   67 ++++++++++++++++++++++++++
 tests/xfs/1889.out |    9 +++
 10 files changed, 512 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/1886
 create mode 100644 tests/xfs/1886.out
 create mode 100755 tests/xfs/1887
 create mode 100644 tests/xfs/1887.out
 create mode 100755 tests/xfs/1888
 create mode 100644 tests/xfs/1888.out
 create mode 100755 tests/xfs/1889
 create mode 100644 tests/xfs/1889.out

