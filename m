Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE53384A4D
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 22:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924273; cv=none; b=a3HM+MWU0xmPTFXXpEAFQVTvmJafKe7Pw4zN9S1gA7A1cUgvQZUvC989nVCegMgqmZuL8CUVZ5NE6nKnUmcI40Loyq3HaEDJFt1myv1wlS9CB+w3WXmyAKYWAwItC1qxx9auSO6rDsqDOCV3TrP4tXtKERtLVoT5leOUe4aJuaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924273; c=relaxed/simple;
	bh=QpBo9v63SkJywsP6TEP9PuHTVaDVG0P2KU3PYWz40vw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IqVOzxWf6wsbJObRzGwf1QwrispnYDQTt5QfWavhw6qTMtsKBQRaXh6Ozre8/XNwYok3J7KLCa2sT59scY/WQCqOhtq8R13sFVw/qev46Y4VBeSq34YFPUIZEu925G5qi3E2JSm48/+rHbrYYd5p1QrMdHE/rxXGqTgfF/M8CzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O7UFD0XU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O7UFD0XU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53048C32781;
	Thu, 20 Jun 2024 22:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924273;
	bh=QpBo9v63SkJywsP6TEP9PuHTVaDVG0P2KU3PYWz40vw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O7UFD0XUcnacvxDWhv3MP54KafHVEMpwd2LUrDUCecv7BO48Q3kMcWeta/9IgKDAP
	 4dyaJ8+2P/72evQSq8BT41TndTDO+hR/24CmRixFU1sYOrUMc97F0XLIKJLzC2Ge5n
	 bItJQhRggXc/xKBBcQkyiGeEawlAF8jxLpfe/XuIbIsJxHZthlCufVIVc5mOrk9KCv
	 HNgi/8P2G0pdRrdR/HrIJQjFvrVQqV2JICm4+QbwyVlODDIPSQmB5qEp5lIWVBpEl3
	 St/AQMP6ef0BdVS9amXK1hbX50ek4qCcK+XJAawUFDT5cgH0HP/7grdXpvw8sUYung
	 prmSN7WjIEmMg==
Date: Thu, 20 Jun 2024 15:57:52 -0700
Subject: [PATCHSET v3.0 3/5] xfs: rmap log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
In-Reply-To: <20240620225033.GD103020@frogsfrogsfrogs>
References: <20240620225033.GD103020@frogsfrogsfrogs>
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

This series cleans up the rmap intent code before we start adding
support for realtime devices.  Similar to previous intent cleanup
patchsets, we start transforming the tracepoints so that the data
extraction are done inside the tracepoint code, and then we start
passing the intent itself to the _finish_one function.  This reduces the
boxing and unboxing of parameters.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rmap-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=rmap-intent-cleanups
---
Commits in this patchset:
 * xfs: give rmap btree cursor error tracepoints their own class
 * xfs: prepare rmap btree tracepoints for widening
 * xfs: clean up rmap log intent item tracepoint callsites
 * xfs: remove xfs_trans_set_rmap_flags
 * xfs: add a ri_entry helper
 * xfs: reuse xfs_rmap_update_cancel_item
 * xfs: don't bother calling xfs_rmap_finish_one_cleanup in xfs_rmap_finish_one
 * xfs: simplify usage of the rcur local variable in xfs_rmap_finish_one
 * xfs: move xfs_rmap_update_defer_add to xfs_rmap_item.c
---
 fs/xfs/libxfs/xfs_rmap.c |  268 ++++++++++++++++------------------------------
 fs/xfs/libxfs/xfs_rmap.h |   15 ++-
 fs/xfs/xfs_rmap_item.c   |  148 +++++++++++++------------
 fs/xfs/xfs_rmap_item.h   |    4 +
 fs/xfs/xfs_trace.c       |    1 
 fs/xfs/xfs_trace.h       |  198 ++++++++++++++++++++++++----------
 6 files changed, 321 insertions(+), 313 deletions(-)

