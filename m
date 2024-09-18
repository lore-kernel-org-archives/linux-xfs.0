Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EEC45027;
	Wed, 18 Sep 2024 20:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726693035; cv=none; b=TItQIkeLfjsUyoJSCoy+yTvkAB9XI4PAMOFH4wsVwEbeuiXA7spdoaZSac3ciYVfPbZ/q1tGsdg/CvvzaAX1DZa7Eal+5IuQC8lC90AKJ8ArifDRNs6mBzJ8BUpB7K5rsdpgLmZ2XEb3kBahVt3zFlf4xhMAN2CXujajwLVzsJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726693035; c=relaxed/simple;
	bh=RcoIgUz2g4EeD5KraN287hh3R0L6wj2LS/yte9H4EMA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=Q0l8hBwQuLOxmpFKOogNWfGocrEkUUz+x2C5rDG9e7E3f1pSALW2ZXw4TppBbAQlI4sVLjcR9JbFfM57oGgJ4nWwrKXROpyjxHkUwVVdKdcZRrylaJN3MxI70EhY30+IaN0dQBrl8OlEDukD7MdYvFFTedhqISndp/YviFjBBOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rI74NxBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rI74NxBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65396C4CEC2;
	Wed, 18 Sep 2024 20:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726693034;
	bh=RcoIgUz2g4EeD5KraN287hh3R0L6wj2LS/yte9H4EMA=;
	h=Date:Subject:From:To:Cc:From;
	b=rI74NxBygEYTHAm3OrrfPChhnHTjN03+CtYa11aXazXkmSqiG8HmcDtSUbqasedB1
	 hzLcDNYU66SXOVpSiwzXR7R4HQuKgwNaoWY1Y+FipWhIJNzA1RnaGgObT1IST3ktlK
	 jpT09hvvVM7fhBOWMzDLInNV14CCRWQ7n2WzFG870RYCksHI0IvUMovjlLhV+0k6aE
	 WItDLSU6EyNWG1DFqY1WxuNemttZq+usfSdYfdhqBKr8AWz20mRSsRaoZeQ+vEacXe
	 x0KkHOdaRn9/EuORjvAB57l6Q0j5dAqnOg4lPb63uLEv4bFi2tXJgzFfX6KLLP9aqc
	 ydnp1XW962Fdw==
Date: Wed, 18 Sep 2024 13:57:13 -0700
Subject: [PATCHSET] fstests: updates for Linux 6.11
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <172669301283.3083764.4996516594612212560.stgit@frogsfrogsfrogs>
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

This is pending fixes for things that are being fixed in 6.11.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-fixes-6.11
---
Commits in this patchset:
 * generic: add a regression test for sub-block fsmap queries
---
 tests/generic/1954     |   79 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1954.out |   15 +++++++++
 2 files changed, 94 insertions(+)
 create mode 100755 tests/generic/1954
 create mode 100644 tests/generic/1954.out

