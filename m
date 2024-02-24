Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED334C69
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738404; cv=none; b=f1ySEi0cv/SacT9j/VtEXfbOHNoWttP1ebo8dZbFdAHmNkW+lJomSOrJ34YUm69PMtFWL7VN1GB9jqEhTQXeaB7hjca83dgpx2f9p4ZB/Jbot3r/bPiSRTpX3lhpeUGKbE1aqFlzZXACluEQFHKkrQbR5VKLCNkSwUPwIWsrRSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738404; c=relaxed/simple;
	bh=tLBreaeO1uRCaeA/KX1928qw5vWstCx/fifueKSiqRs=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=aZuZhIQGZrjYLnGw+a63Kt8JDGVDi01gnFWHDcBuen7EWpNb6ytuTj8GOJ6EFiV7aKcBHXigC/POeeNFaRKYdB62lT7BWtTzW4jHF0t0eoM+0Zh/uLPnlDokp94lBDIh9EIDYIllilSFHoZ++fbAE3Xzazt22vUrm4TXzzKDWI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bN8aoags; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bN8aoags"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C01C433F1;
	Sat, 24 Feb 2024 01:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738403;
	bh=tLBreaeO1uRCaeA/KX1928qw5vWstCx/fifueKSiqRs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bN8aoagsAztVpzVYovA/NT+35klF9mbGHkLjURXvb4gH4PQRw8yoXxk4/dq9L+NUy
	 vzpgneYhprmCJ0wqMUXBmlJIHWYricl73OGRoMvFUKrzyoSEo9SJ/8zzvGtE0hozCO
	 ghF2irCGSi9jr5KvZAIidtZMMzcU37z4EYCb4dumbL2Drwb/VuEIZ/MRPfcoOQopol
	 y2BMJoV1IhfjedkCHF4ItNHbeQmsrmZ3iOW6wE/cUkM0xO6s/HCsd77UQu48gg3uBd
	 JS6/kGBYDw2S0YueLaQQDbaRj8F8BqRntRes+jkRYEujmHdI+oVJ43/cJ8sn4JHOtY
	 ci0zPjTM9OO7Q==
Date: Fri, 23 Feb 2024 17:33:23 -0800
Subject: [GIT PULL 17/18] xfs: support attrfork and unwritten BUIs
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873807375.1891722.5277726854433420352.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240224010220.GN6226@frogsfrogsfrogs>
References: <20240224010220.GN6226@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.9-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 1b5453baed3a43dd4726eda0e8a5618c56a4f3f7:

xfs: support recovering bmap intent items targetting realtime extents (2024-02-22 12:44:24 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/expand-bmap-intent-usage_2024-02-23

for you to fetch changes up to 6c8127e93e3ac9c2cf6a13b885dd2d057b7e7d50:

xfs: xfs_bmap_finish_one should map unwritten extents properly (2024-02-22 12:45:00 -0800)

----------------------------------------------------------------
xfs: support attrfork and unwritten BUIs [v29.3 17/18]

In preparation for atomic extent swapping and the online repair
functionality that wants atomic extent swaps, enhance the BUI code so
that we can support deferred work on the extended attribute fork and on
unwritten extents.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: support deferred bmap updates on the attr fork
xfs: xfs_bmap_finish_one should map unwritten extents properly

fs/xfs/libxfs/xfs_bmap.c | 49 +++++++++++++++++++++---------------------------
fs/xfs/libxfs/xfs_bmap.h |  4 ++--
fs/xfs/xfs_bmap_util.c   |  8 ++++----
fs/xfs/xfs_reflink.c     |  8 ++++----
4 files changed, 31 insertions(+), 38 deletions(-)

