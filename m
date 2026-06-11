Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE752D5940
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 14:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781186702; cv=none; b=MDbBJdWXbfX18orzeb1ZG6jTeIpLjkhFP5cf5CcmnuFxEoCDE1h738763/6nfxJu8eU5NP7aWmZoQ5H2PlSuWkXWEmTOqtH7IB+5MkxYYRhxQHaa8oBC9XjzKVwFXGUu3qkWm49Q74MkBinG6upLPMYFvAcBpqanYSIwv6xdHec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781186702; c=relaxed/simple;
	bh=dTNstQyYN7e4v10GPIiQC4upDzkiGDZejs9h8lSFQYI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=NkOadREYalCGFUD3xcZDinrGF7KcDWqXG36h5xdL9DhJs5A5d+VCd6X9CDAet8Dq0l6to7NWmLGY73TgBkAbKIn3U069DDAeHmrU3jl/taMrPjPUuTPLStwmL1c/bNRIaxt2VA70qmbxoN4AKsNMeVdQIeX3BpEy+10IZ0YGeSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0ZG02RR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0ZG02RR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2DD6D1F00893;
	Thu, 11 Jun 2026 14:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781186701;
	bh=Ddv1i+IMcYFQkYLQSFV+rGDH6CMJwgg3kHVAVXgI8+Q=;
	h=Date:Subject:From:To:Cc;
	b=G0ZG02RR7uXYRDo5eFNunE+nvD+D8GBkE/S/NUX5cU7iDp2n0CNTDfXsyD7jgp7YO
	 mXDGNQUQghmwpuXGKJMSCM5k4q3P6yR4vJQPjekFl5/rK5Vf/x0pb1b6t8z9wIlnf2
	 hZxticYbERjuTdLZ3FJRiW06colGxmthNA1mitJC4hUTzLnGe2xZxbcQiz56Rsu0hc
	 nUC4jg+3LsRqeknlR/Y20d72MUkyS35HFnRTRae3JS1yRovigJJrU+85cpRQsNOJZr
	 +QY00cpPJqhOU5QMugjBp/usJffqyjvfz9dn00jYV7T2WC33PgCBpKUMILY6PjJROA
	 MrEm8bSDK433w==
Date: Thu, 11 Jun 2026 07:05:00 -0700
Subject: [PATCHSET] xfs_healer: codex-inspired bug fixes, part 2
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a second batch of xfs_healer fixes resulting from Codex reviews.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=healer-codex-fixes2
---
Commits in this patchset:
 * libfrog: fix buffer overflow in getparents path_to_string
 * xfs_healer: don't allow aliasing of mon_fd in setup_monitor
 * xfs_healer_start: check listmount when doing a --check
 * xfs_healer_start: fix static checking
 * xfs_healer_start: increase statmount buffer size
 * xfs_healer: allow AF_UNIX socket access for xfs_healer instances
---
 healer/Makefile               |    5 +++++
 healer/xfs_healer.c           |    1 +
 healer/xfs_healer@.service.in |    4 ++--
 healer/xfs_healer_start.c     |   43 +++++++++++++++++++++++++++++++++++++----
 libfrog/getparents.c          |    2 +-
 5 files changed, 48 insertions(+), 7 deletions(-)

