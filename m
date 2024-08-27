Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6411F84D34;
	Tue, 27 Aug 2024 18:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784290; cv=none; b=J3X0d+nWxC7jbW/y/0dKwgyN5NZWGxe7AbBMdJ6Q0rICQLsz5pFQv+w15y55Oy3XTPZZIoyIch29mJFFaea9JXEEPCPmXsannR6QQztK/ts9+lP8sxXfie7zM/gLe6MQcL7LQfU1ZCp9S5KKUhCYchSD6/5qAkvW+jZpMmP9vaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784290; c=relaxed/simple;
	bh=lpXKGw4wrV4trbpYDgy0jam5RV5/tPlvR0Wb+lxJU+w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=njFA+hHXVdN6YzSZoO/l+A5RBUT4ahuXbZgc+CaVWoTPkf6musqaMcy1O6U43+0k5i7k6F8UM2Drns6Lb73ag6k/zbfdvCqtXRjpI5Taz03ReTOWhkLfFutjvaf1L0oMGlHEdNyf/pZaiJi+VlTkfYZvXSWZ5eEPq5NJWNRUGVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O7NY2WE0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O7NY2WE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB8FC4FE9D;
	Tue, 27 Aug 2024 18:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724784289;
	bh=lpXKGw4wrV4trbpYDgy0jam5RV5/tPlvR0Wb+lxJU+w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O7NY2WE0zCRVt8AoZvfO++lDc/rTGvT0dYnsIALNHZpqJjFCgsv0dIQQPvTaf6x6e
	 IDlEooT0y/21hgzQ71cRffc0LeneKe3Mv9zqTj7bvH3X77CyiUv9CNTUfKrlaBZeRy
	 rUtIgU4xuSgHJn0ijoVZhzhE8iqJ22+94Qln/fnaCQfLa9DSfuuNHxhCbkU/znJj4v
	 AjIqCXFgsrKkEoMvUMnI0yvyHKIroOZnmoKMeH87ZoxB6favslO/dO6LEJWrGcMdHy
	 Bpjmrv93NqShx+VzJoe+vZyCjgNx5wKD2lfBK5uhXfvSOyc6irYEmVg7/lscPzfcZY
	 rKKBeF96mRUlA==
Date: Tue, 27 Aug 2024 11:44:49 -0700
Subject: [PATCHSET v31.0 2/5] fstests: test systemd background services
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172478422640.2039472.46168148654222028.stgit@frogsfrogsfrogs>
In-Reply-To: <20240827184204.GM6047@frogsfrogsfrogs>
References: <20240827184204.GM6047@frogsfrogsfrogs>
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

Add a couple of new tests to check that the systemd services for
xfs_scrub are at least minimally functional.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-improvements
---
Commits in this patchset:
 * xfs: test xfs_scrub services
---
 common/rc          |   14 +++++
 common/systemd     |   73 +++++++++++++++++++++++++++
 tests/xfs/1863     |  140 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1863.out |    5 ++
 4 files changed, 232 insertions(+)
 create mode 100644 common/systemd
 create mode 100755 tests/xfs/1863
 create mode 100644 tests/xfs/1863.out

