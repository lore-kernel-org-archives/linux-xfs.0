Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFFA80C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713228681; cv=none; b=OI+txOPS4JZR3YGaijYlPEYh/xwZ4P8rs270P8dYmIMqNcBWybkPUkMPE36m8wNBa8TAqwm7IdJA4ixKUNVK/BaXXfx1l/ypCvhOjs1rQ5sdPHaPOMO8H66r0jlmEsJbYOixGN1jw3kEkx+XcdZauqOO8Q6QNAEeUUOYEn8eNdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713228681; c=relaxed/simple;
	bh=vVo+u5Cq9cvx76IL7ejb57sXMoCSAFYsfda/xhBvX6A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hJ8YlxPW7IDs0ovj1BPAxC6tI3AiirvFYlbWX45d7nzducxuKHuUraXcOjATKlkuAjOScPSdVxFvxuKRI4uKDP7+ZyXWSouBlWO0JAgRzLJBgsr4tYjfGhpfCXfrgIi272I9wIqinyoCnhV/uRwul2oAa60pGi8QpW3ue0vXDGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFpMy7Wj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFpMy7Wj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F67C113CC;
	Tue, 16 Apr 2024 00:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713228681;
	bh=vVo+u5Cq9cvx76IL7ejb57sXMoCSAFYsfda/xhBvX6A=;
	h=Date:From:To:Cc:Subject:From;
	b=ZFpMy7Wj+DpWXl6qKppf0ThBMmVQCYQ/pNonQfE8BqVPTZ1sxzB1qLm/gqsrhiRod
	 dnaTaRAVuBRc6OaDYZ/gTg6SH0Wn0aGtwLHhoOOzDZCx/lgzEJgqircpcdEEiJkiIu
	 op9z1fKoSz8z2h5KLApwc0nJgZHuVm48rA5sLkjLMiAt7gYPipfUpg/QRucRcU7TSh
	 0i9c3E1QG8lDhj6hkeZdow6OzuRFpNxpQ6fPrVxpzw0BNyUl+HTYlLi0TX9YfJSVRT
	 5mtFfQfPqNkKr9Nkomc7phZgG+3fE+FYeHmaldyGyCYOti/fahBdo0lmcdj4HiA7O/
	 b2Ywv0X3vhskA==
Date: Mon, 15 Apr 2024 17:51:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB v3] xfsprogs: everything headed towards 6.9
Message-ID: <20240416005120.GF11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Carlos and Christoph,

This is a resend of my earlier patchset of everything that we need to
get xfsprogs up to a 6.8 release.  A handful of the v2 patches didn't
complete review, so this v3 patchbomb contains only the series that have
unreviewed patches:

[PATCHSET 1/4] xfsprogs: bug fixes for 6.8
  [PATCH 2/5] xfs_db: improve number extraction in getbitval
  [PATCH 3/5] xfs_scrub: fix threadcount estimates for phase 6

[PATCHSET 2/4] libxfs: sync with 6.9
  [PATCH 088/111] libxfs: teach buftargs to maintain their own buffer
  [PATCH 089/111] libxfs: add xfile support
  [PATCH 090/111] libxfs: partition memfd files to avoid using too many
  [PATCH 091/111] xfs: teach buftargs to maintain their own buffer
  [PATCH 092/111] libxfs: support in-memory buffer cache targets

(Only patch 90 lacks a review, but I decided to throw in a few more for
context.)

[PATCHSET v30.3 3/4] xfsprogs: bmap log intent cleanups
  [PATCH 1/4] libxfs: remove kmem_alloc, kmem_zalloc, and kmem_free
  [PATCH 2/4] libxfs: add a bi_entry helper
  [PATCH 3/4] libxfs: reuse xfs_bmap_update_cancel_item
  [PATCH 4/4] libxfs: add a xattr_entry helper

[PATCHSET v30.3 4/4] xfs_repair: minor fixes
  [PATCH 1/1] xfs_repair: check num before bplist[num]

--D
