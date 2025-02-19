Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619601EEE0;
	Wed, 19 Feb 2025 00:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926030; cv=none; b=OeRgyBkbJfO0vJerSu2YUtWZHPHsrUF2GJQK2vYF6SGHbDpEB51m1okr2CDIrF6NtqhasrvCKKooRRaYW3J1M3JoHZfGD2YVfZQbYwTzPRi/AuLoWsexR4oKkTmxLHajwW8/WzjcOcY/DNr0Wgc53gCdt7mAXnwlmZYPODhRNWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926030; c=relaxed/simple;
	bh=IQgrzgKIQVLEmaOb0HA0GnRJEeiA5WRY+ZUvXYHNbQ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FxU04jtW5lKa9F3aXscUoFOqcTOqYhxcYRsWXb0p+aQnrp9+ozAAYVfpG5qjN2bejadADOs8uAG6xkKlhj+OaoIB/oFvUUQGoYAtiHPSDH7eq0kaDClVXGNAPqNp3FAgsaeMbVce9+teUWBnQ75Aw+d2gg4QSN1asumLYHmVzXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q0JVUWxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q0JVUWxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFB1C4CEE2;
	Wed, 19 Feb 2025 00:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926029;
	bh=IQgrzgKIQVLEmaOb0HA0GnRJEeiA5WRY+ZUvXYHNbQ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q0JVUWxW58f0BDiR6W7lOWeXNTjMpnzEow6vrzk+VT0TIVYXLzHTXSfw06s3LC919
	 p6wXgV7YQw80XmeT7+TuDwMfo6ZE1X0GQ1DUS2FcrT4lrM+Z13Mfn7j7HFfoAJ6PIT
	 78+6XSehsEuMELLj9IGi9k4k6QoSpYVYjXvTHxKXSt0DJVLAyZBmhpEW3AgPfHxf7x
	 UblA8+NNgsxYKM/AZHVoXi3jqTbTPslqP/5cYjkxMsDoeRjzyLAihlq+j/I3kPvvBh
	 XfrupKwkcKB5xkoEoHkiZArGhb0Z58EtNu1KzeyfELVD6/1LXU1k+gfnP0U6IlJy5a
	 7LP2k/2vq8HgQ==
Date: Tue, 18 Feb 2025 16:47:09 -0800
Subject: [PATCHSET v6.4 05/12] fstests: make protofiles less janky
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992588634.4079248.2264341183528984054.stgit@frogsfrogsfrogs>
In-Reply-To: <20250219004353.GM21799@frogsfrogsfrogs>
References: <20250219004353.GM21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Add a new regression test for xattr support of xfs protofiles.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=protofiles

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=protofiles
---
Commits in this patchset:
 * xfs/019: reduce _fail calls in test
 * xfs/019: test reserved file support
 * xfs: test filesystem creation with xfs_protofile
 * fstests: test mkfs.xfs protofiles with xattr support
---
 common/config      |    1 
 tests/xfs/019      |   14 +++--
 tests/xfs/019.out  |    5 ++
 tests/xfs/1894     |  109 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1894.out |    4 +
 tests/xfs/1937     |  144 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1937.out |  102 +++++++++++++++++++++++++++++++++++++
 7 files changed, 374 insertions(+), 5 deletions(-)
 create mode 100755 tests/xfs/1894
 create mode 100644 tests/xfs/1894.out
 create mode 100755 tests/xfs/1937
 create mode 100644 tests/xfs/1937.out

