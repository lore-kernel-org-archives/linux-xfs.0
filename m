Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612646F085
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 22:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924289; cv=none; b=WtDP07ygBp6EJxuWPkAi0+wgGE53yTCTrzAGgorPSR2wjppSdKmRlqeRaE8lc0WyNReXty8XKUuJLgGqOYEWWstZEcX8mYQY6N1w2WOzfFstGjVEhWYjblw6X35TFWRkKqvqDJzWusib+g/VhoKUluehM1wQtuzv1jh4lGwVWT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924289; c=relaxed/simple;
	bh=xyEz3vRaT5asH8L7eju0igVF5DjwtA+Pc04k1hluBRQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CmF5Lq7YOfan4j9H9uSfITeSl1pDjuzFDYMi0l+TClncNkO2NJkkxP2m9iiKfhpck7CCEeQYhk/TWKoSWmbNAoloTz1BTWnPt6FsIU49HbU4p5Hd5iwVU4LS/goCPQF/hDEVnIxlzQAuoI38aPTuzehoJY1TjgUCYd0kpgvuGkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rkjtQRup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rkjtQRup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBCFC2BD10;
	Thu, 20 Jun 2024 22:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924289;
	bh=xyEz3vRaT5asH8L7eju0igVF5DjwtA+Pc04k1hluBRQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rkjtQRupMjj+7A5NQGUEx68SaJtlLcYhDRCCLbXfnVbxUgZjeTJ95o+GxWH05c/DS
	 l080Mnz8QJvYeDxNZDki7pw2eu07Pf4PzEa9Tg/+qEXzJVBUP5jP/eMBfK0WGXGFLt
	 lRM4TWcJLlW7HJM5CWCRVG3PlXyjAO0dylCeYR55C+RRjQrm/IOL/RXpfLPXsSSoYB
	 cqu2qy4Q+he3iczQPYGYE8gCm9XPrD425PbC+K83n/BoDsNOaUxgbZbAaUaQEHtRJn
	 QuholI6xomVMJ33FDWg63RyvRzdL5tdNBjq1YYO3qOsKHYMAl/LrbuxckmXvKWD/5V
	 5FbLU4QKi34Kg==
Date: Thu, 20 Jun 2024 15:58:08 -0700
Subject: [PATCHSET v3.0 4/5] xfs: refcount log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
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

This series cleans up the refcount intent code before we start adding
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refcount-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=refcount-intent-cleanups
---
Commits in this patchset:
 * xfs: give refcount btree cursor error tracepoints their own class
 * xfs: create specialized classes for refcount tracepoints
 * xfs: prepare refcount btree tracepoints for widening
 * xfs: clean up refcount log intent item tracepoint callsites
 * xfs: remove xfs_trans_set_refcount_flags
 * xfs: add a ci_entry helper
 * xfs: reuse xfs_refcount_update_cancel_item
 * xfs: don't bother calling xfs_refcount_finish_one_cleanup in xfs_refcount_finish_one
 * xfs: simplify usage of the rcur local variable in xfs_refcount_finish_one
 * xfs: move xfs_refcount_update_defer_add to xfs_refcount_item.c
---
 fs/xfs/libxfs/xfs_refcount.c |  150 ++++++++--------------------
 fs/xfs/libxfs/xfs_refcount.h |   11 +-
 fs/xfs/xfs_refcount_item.c   |  107 ++++++++++----------
 fs/xfs/xfs_refcount_item.h   |    5 +
 fs/xfs/xfs_trace.c           |    1 
 fs/xfs/xfs_trace.h           |  229 ++++++++++++++++++++----------------------
 6 files changed, 222 insertions(+), 281 deletions(-)

