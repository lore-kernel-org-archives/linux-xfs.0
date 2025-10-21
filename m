Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6879934D90E;
	Tue, 21 Oct 2025 18:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071962; cv=none; b=et2JpqnSdneYVhJk/+rsfGtZGYQOwrao34Zx6ztLH8qE8krQE1Q1ua8gZGprrC8N3mJ9Obg5crww8cH6Th0vw+9Hfl0AUxwhYci0FKOKQ/ybyMWMMqxeBPZs3fmjyQ41vR0pUIX0+1NMexXpcND6dYB06Bwfbhh1Xc/h70T992c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071962; c=relaxed/simple;
	bh=tZCCKA8JPA4Y1lsZqZf2augjaVdHMTmy45YPqqQCiIs=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=nr8mAzAZ+e1dNiZIexSShQmRpba1DoDHRAj/7celNwbjXtdmi7+tkSRFWpcL/v883ZME10EJygBaABRF+Mte2syROUl0QFkNMVKeXtUmkkMKwDnyjB44PxWdfgxVaXUvtCg1jRoOMsr9udADrPHsnX4JTLZN6Q5L66Heah/OTKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SzdzJRaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SzdzJRaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E505C4CEF1;
	Tue, 21 Oct 2025 18:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761071962;
	bh=tZCCKA8JPA4Y1lsZqZf2augjaVdHMTmy45YPqqQCiIs=;
	h=Date:Subject:From:To:Cc:From;
	b=SzdzJRaV0oqYriicw2GPyBFuOJ/dxQJCKEFJSYAGPHAK7TcJGpMwOJeonouFsYBTZ
	 beRILvkrqhMaPitYdonwtlK19ItVHghtcMwunpM0HXeu1rJ2nLfIHEQWeLpy5uulwX
	 QHm3xn2QUUPs0NU968bL7+Mz8olVO22cTsPOHnsSgijTBhwcoblIYdph6VlrUTBbPp
	 VuyzQ/S9m+/Ee45INqBjatw0dgKhZoilFFzNgi0MTXbJzYwEZ4EflotYD7xg1Af4uA
	 0sqEZ7HRTFCgWJQ0TMgamSaSB+Wkfulnq66hsqnpoR+Bc0SpfxvOzFb9gs/zzzPWFh
	 yE3OimJXGZncA==
Date: Tue, 21 Oct 2025 11:39:21 -0700
Subject: [PATCHSET 2/2] fstests: integrate with coredump capturing
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176107189031.4164152.8523735303635067534.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Integrate fstests with coredump capturing tools such as systemd-coredump.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=coredump-capture
---
Commits in this patchset:
 * fsstress: don't abort when stat(".") returns EIO
 * check: collect core dumps from systemd-coredump
---
 README         |   20 ++++++++++++++++++++
 check          |    2 ++
 common/rc      |   44 ++++++++++++++++++++++++++++++++++++++++++++
 ltp/fsstress.c |   29 ++++++++++++++++++++++++++---
 4 files changed, 92 insertions(+), 3 deletions(-)

