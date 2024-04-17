Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CD280C14
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 22:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713391656; cv=none; b=s/S+chtTME7CXglhYtKV7WS27sq31hMGzRtUWp+dOsQfOLgt+OiEG9zNmSAqRVzN9SwzWvczovug8CD3H7zc4aszu3RSnZi+kK76btJFD0wHRDwuov7705X8xRofQfpdl946HjS0ClvcIdylG2xU2o6muFJm7hXo1K5zl6N8S9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713391656; c=relaxed/simple;
	bh=jyZfTWPsZjhFQFliT7WQudtEcKQ1zA5lsrTBH4mYBRc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=TPue89zoBMABnZW1Hl/ReOedSTV4gbB/TiSkKIuff/rbf9Egvu4XLnrWE9X+OF/Te5+g1m3BwH7WGIEON5IEhYyhGhKNB+ai7Xd/5kgJAr+3nXY7ffDt60tqUx7FTmZktqbg+PTHcwNlysWBK2q1V9+B0/+Ir9dQzjuwMVQNXWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GXkKnCOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GXkKnCOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1DCC072AA;
	Wed, 17 Apr 2024 22:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713391655;
	bh=jyZfTWPsZjhFQFliT7WQudtEcKQ1zA5lsrTBH4mYBRc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GXkKnCOjRBwvnKs+Lv7tRWj4TOsNHtpNvVWPgNnMhXDnSd3lY2JLlnTXoWVp+WM0R
	 k4nHcLTAGGwminStfV74LWaXMrXGAjW38twdk9j7uAAGE7hJdOIBzj6YLfKPA1ozyY
	 dr6APT3A1qYXiGFerY/kAX/LFlJfrHGlkamcZRwTAfGz5M+1F189GFE7FPjVF9JGSB
	 VIFhJHgTlnwBv4fj+trZ/ixBiWnKDlXREKiJkWjzKfu1HVZZ4+DC/Y02dwEtQ6Yi+2
	 UEavRyPhXVG0TcFkh0b3A1yC6kNPq0b2/lxNt6/9IXKqQ9AKFXeE5J6HOh2/U0JC+8
	 0xCl4/Jm9ep3Q==
Date: Wed, 17 Apr 2024 15:07:35 -0700
Subject: [GIT PULL 01/11] xfsprogs: packaging fixes for 6.7
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: bodonnel@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171339158311.1911630.13437553389622374759.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240417220440.GB11948@frogsfrogsfrogs>
References: <20240417220440.GB11948@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 09ba6420a1ee2ca4bfc763e498b4ee6be415b131:

xfsprogs: Release v6.7.0 (2024-04-17 09:55:22 +0200)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/packaging-fixes-6.7_2024-04-17

for you to fetch changes up to d27e715c3081306e1b210e64d21775457c9f087a:

libxfs: fix incorrect porting to 6.7 (2024-04-17 14:06:22 -0700)

----------------------------------------------------------------
xfsprogs: packaging fixes for 6.7 [01/20]

This series fixes some bugs that I and others have found in the
userspace tools.  At this point 6.7 is released, so these target 6.8.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
debian: fix package configuration after removing platform_defs.h.in
libxfs: fix incorrect porting to 6.7

db/check.c            | 1 -
debian/rules          | 6 ++++--
include/libxfs.h      | 4 ++++
libxfs/Makefile       | 1 +
libxfs/xfs_rtbitmap.c | 2 +-
libxfs/xfs_rtbitmap.h | 3 ---
repair/rt.c           | 1 -
7 files changed, 10 insertions(+), 8 deletions(-)

