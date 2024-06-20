Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084C02BAF3;
	Thu, 20 Jun 2024 20:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718916829; cv=none; b=J7Fe4VhpU3yIQt6rqFeVleP22V1OTMAlZyzhiDp6v9PpE1/8aI2yf4hpDzNr7ddPetaqr/Qt7wh9wdRB3m7/aJApimhFRkTmSTT9vmPuwf0XLheTQ0VqC3cs1vIdxCSLOLtkeIvkl977AvV0+JB/54OAcNq/sh5m64xlwZfXqvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718916829; c=relaxed/simple;
	bh=VZIKT9Sh1wYygAzuAXzmINhXjWd+LX5b3abfdDh6XlQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PJt3fIsavY7jBZUZAw/XRSLd+1B7j4hG/vSiP6Zw6COVcjiY8+ryNq52O7tGaDUZNkGxtmdtbjnY35NDcwyzgSzRn7/FmSppSGk1thiuiDkK9XasN9SPcte6xJQyPpM/BnGFkt5gI3U+sfd+QbMviYeYgmUOF/0DMCTiulQZAL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VckN1Gux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VckN1Gux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C25C2BD10;
	Thu, 20 Jun 2024 20:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718916828;
	bh=VZIKT9Sh1wYygAzuAXzmINhXjWd+LX5b3abfdDh6XlQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VckN1GuxxuJUPy1yOnr/MCcxLgxa45RB6/1WPXqu3kLWuwOrkLEqeNXgKzVGhTodw
	 qPMOdMb//nng37LMSXcPPjsKSTMCQpgMDtvmE577p/oVmWGeI3fUEFm4qSUOubvRXp
	 BMnDlK1+J4gJ6zLCWDSOtZEUyQNXn0znWjPx9uVTeONk+GGCFaB+/ctN7WhB2T5IzM
	 jsErokkZJYrUcyy80HWlW0EEmVAT0u1vZoeYezKgJcazTkk5ldXCcBxQzCQEtur/wP
	 X1GDMO0BgOtOia7xPL2zSmvYtI10ThyYT8EdIGp1spKMVjSsUAkWm328zK1ePORTzq
	 uwdsrQ/e8Djsw==
Date: Thu, 20 Jun 2024 13:53:47 -0700
Subject: [PATCHSET 6/6] fstests: minor fixes for 6.10-rc1
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <171891670876.3035892.9416209648004785171.stgit@frogsfrogsfrogs>
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

Here are some fixes for the stuff that just got merged for 6.10-rc1.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.10-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfs-6.10-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-6.10-fixes
---
Commits in this patchset:
 * xfs/348: partially revert dbcc549317 ("xfs/348: golden output is not correct")
 * generic: test creating and removing symlink xattrs
---
 tests/generic/1836     |   58 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1836.out |    2 ++
 tests/xfs/348.out      |    2 +-
 3 files changed, 61 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/1836
 create mode 100644 tests/generic/1836.out

