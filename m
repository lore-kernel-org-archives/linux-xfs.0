Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF27013B29F
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717444516; cv=none; b=RL0gQkbVp7z9ODhjUI36cAp0RheXeg8p5Q/Jdwkoq7xd3oHYIjXWpBFhjoQ4bO/jya1cLpTXx24K3fu7zNpH5FXbzEx2vQQugshjQifad0mx9h3QKarPF/LTVVnVXo6gAEecJj7vHmkhCLiY04aowGxPyyVvy86c7ebvzoJXVpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717444516; c=relaxed/simple;
	bh=655hj8+jQVAcPCeiT3sNNQ+vQ/vcXc/+SGEf/fMJWmM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=CLLwex5BQBGKZljq/4eAhehI+w5D99phHxiH2jHl9vN3LirUVWQeCJj3JLLhfEo3jM512K/3SOmTgdNP1+Fyzt3GV6zNRFVlC0IUp6BFgTspTyA2qeMt6HUL8CGcU1GeYhJgh5Ta4bDTA6CCAEwpcOMZmIvSearcPK5bEIzqtO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lmm95o6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lmm95o6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B100C2BD10;
	Mon,  3 Jun 2024 19:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717444515;
	bh=655hj8+jQVAcPCeiT3sNNQ+vQ/vcXc/+SGEf/fMJWmM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lmm95o6/fwkl7l3QrNQEQr22A5v70UGb81tCuKCdJu48Mikq8Mu5QyOxsP3mnKDws
	 a74B9Qkt6zt4y+d0qQAGHwEfnVEtCyBPJqcz68emNsLIetq3hSdIPocU78MiqeGA5x
	 gkwCb0f0ONFJvGmC6OIJWJiZBiz0mq9p7Kf6cf67WHWwLgHKJt9xmLg89PSup55EMh
	 B6AsKPfy201TI6RTblMkDLpcnYB8DqXeFFN4uptUAt3lFGV7H4NbUadNnGxUeWlUgH
	 M//v2730bQLtFkd2I/NYFUpocm706VxXpwqP0eeHtNppQOwjswqFtkwt2oCRViWf3X
	 zNHfpdUmUGiMg==
Date: Mon, 03 Jun 2024 12:55:14 -0700
Subject: [GIT PULL 03/10] xfsprogs: bmap log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171744443541.1510943.8970030122235049349.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240603195305.GE52987@frogsfrogsfrogs>
References: <20240603195305.GE52987@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit a5974a2d10bdbfbfff9a870b832f2ca2b711ec14:

xfs: allow sunit mount option to repair bad primary sb stripe values (2024-06-03 11:37:41 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/bmap-intent-cleanups-6.9_2024-06-03

for you to fetch changes up to 5ac16998a64422509f3123304891aae905e1ff04:

libxfs: add a xattr_entry helper (2024-06-03 11:37:41 -0700)

----------------------------------------------------------------
xfsprogs: bmap log intent cleanups [v30.5 03/35]

The next major target of online repair are metadata that are persisted
in blocks mapped by a file fork.  In other words, we want to repair
directories, extended attributes, symbolic links, and the realtime free
space information.  For file-based metadata, we assume that the space
metadata is correct, which enables repair to construct new versions of
the metadata in a temporary file.  We then need to swap the file fork
mappings of the two files atomically.  With this patchset, we begin
constructing such a facility based on the existing bmap log items and a
new extent swap log item.

This series cleans up a few parts of the file block mapping log intent
code before we start adding support for realtime bmap intents.  Most of
it involves cleaning up tracepoints so that more of the data extraction
logic ends up in the tracepoint code and not the tracepoint call site,
which should reduce overhead further when tracepoints are disabled.
There is also a change to pass bmap intents all the way back to the bmap
code instead of unboxing the intent values and re-boxing them after the
_finish_one function completes.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
libxfs: remove kmem_alloc, kmem_zalloc, and kmem_free
libxfs: add a bi_entry helper
libxfs: reuse xfs_bmap_update_cancel_item
libxfs: add a xattr_entry helper

db/bmap_inflate.c         |  2 +-
include/kmem.h            | 10 +-------
libxfs/defer_item.c       | 58 +++++++++++++++++++++++++----------------------
libxfs/init.c             |  2 +-
libxfs/kmem.c             | 32 ++++++++------------------
libxlog/xfs_log_recover.c | 19 ++++++++--------
repair/bmap_repair.c      |  4 ++--
7 files changed, 55 insertions(+), 72 deletions(-)

