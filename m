Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D254E5357;
	Mon, 28 Sep 2026 15:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790609768; cv=none; b=AXYLGWkoSXZ+uvqoUBfuqeTYe/HvKfGQLhS/HeZEYAuqXv7I8uGUEnJX0Yxks55kYKv3OJ9dWImoEi2Zc+wtQ2PoYGP5T1zT+r3gydHh+xv5Ifu5CG4bmCOIaxxzZSSgilY8BzulaLuPJbKrt/aldbPGrG1vIJrb3imNeIpS1wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790609768; c=relaxed/simple;
	bh=I1cIRg0tPzfT33V+9Nvd4y/MYN3ZeDyeji4THqZ2/vc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=SsqGSrzOz/DiI01SxSsPHSbCMokY5keZVPqO7ytj+U60eNnrLm4qJfDXppRzcYyE7srcc+41tNFvyNEGN0hRDjtq1v/+APxwtGQXLju9jT7CKnN0xKzFWx5lH27OBgxBxtzLA6Cw7Q60DyMfqcvG5SfLwLiRwkzztDV8kyQyeVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5YVtX8P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5YVtX8P"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8C4CB1F000FF;
	Mon, 28 Sep 2026 15:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790609766;
	bh=dG0TStE4/uu8NUnWBeTnB+uC9VL1ifT4939NLRyoGJM=;
	h=Date:Subject:From:To:Cc;
	b=R5YVtX8PcIy8ynrav8PNuFAfo0mxtS0jw7zQ4KyA9fBBJ9EH5Ol+OXtgFX7LOBkTy
	 2nFKS5AQrrxw++KaCYbcYAx+gDC4UM7nk5eHprLlnVH09fRGlDraKP0icGQM4Prset
	 Xnyx7VNTX6Fi0HTGQ8z7ShFVuXveB33ArZyhSU4LIE8quLv9h2/VIdYmYDCKWi4uhg
	 MH3c2LSAvMDQfLsiQtWRUiwK48XDSf492f6wh8A99XMzEoy5wU4OASV3mQyoTuN8Lc
	 fIc+8erTGOMWdpTaW66c7F6jERq4+bUiwx7cpkvgAvc4ybg6kGVIAXECozAE92eENT
	 MyapdU5pDqyCw==
Date: Mon, 28 Sep 2026 08:36:06 -0700
Subject: [PATCHSET] fstests: new tests for old features
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: hch@lst.de, qsa@qualys.com, aalbersh@kernel.org,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <179060965752.790984.3511820348115861306.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here are some new tests for old features.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=new-tests
---
Commits in this patchset:
 * generic: regression test for refluxfs fixes
 * common/xfs: add zoned/rtstart info to mkfs filter output
 * xfs: basic functional testing of media verification command
 * xfs: test mkfs.xfs config file generation
---
 .gitignore             |    1 
 common/xfs             |    3 
 src/Makefile           |    2 
 src/refluxfs.c         |  435 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1956     |   58 ++++++
 tests/generic/1956.out |    2 
 tests/xfs/1908         |  123 ++++++++++++++
 tests/xfs/1908.out     |   28 +++
 tests/xfs/1909         |  163 ++++++++++++++++++
 tests/xfs/1909.out     |    2 
 10 files changed, 816 insertions(+), 1 deletion(-)
 create mode 100644 src/refluxfs.c
 create mode 100755 tests/generic/1956
 create mode 100644 tests/generic/1956.out
 create mode 100755 tests/xfs/1908
 create mode 100644 tests/xfs/1908.out
 create mode 100755 tests/xfs/1909
 create mode 100644 tests/xfs/1909.out

