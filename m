Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560EF39AF6
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2024 23:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706742044; cv=none; b=haXIe0rx4OT+Xx5pToRWte4lGWI08ZAUA5J2nuxGi+w9ZjnvLXliH20oeoTljxXjcwGTTq7ZJGX+X0QcTRUNM2Is3vpyUisbtaDo2g4VOWwULARO95RVbRVbM6cNmtd1xEmIdMt2/N4YQWCgmkp2GBcn+Q+WvR5KJ7xNpBfC55M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706742044; c=relaxed/simple;
	bh=v0MTQSiEzmp+c3PpSLOEwTW/N7Fqq6zTAVXq7H4fdR0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jKYsBFkExExmvXzfhy9JmZ6aiWuv9yFutoQLVPc9bWkz1yUOc4irFkMc0umnLbZz7dcI2j62Vcy7bkGO6cs1V6VVsEkXf8+gyzHEscC9OkJqNDWM/RDlfL+7XgxnuYwQg33Ee8s9pRcBSSVIaInIDPzfs0+l4x9G6q6CG5as8po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5a+Tmtc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5a+Tmtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A861BC433F1;
	Wed, 31 Jan 2024 23:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706742043;
	bh=v0MTQSiEzmp+c3PpSLOEwTW/N7Fqq6zTAVXq7H4fdR0=;
	h=Date:From:To:Cc:Subject:From;
	b=B5a+TmtcktCVMcYFo/cSLV8aBe2eTz9RyDc+DYFCsPrClEsVxdf0JW2rN3LgMc8Bh
	 DbtqsmTQ00CRxniJCPCCkd7/4XePKPak03oQQlkAxHvNg5WiYYankGYuG3Gdk36OuK
	 J/BWsV4Yeb8vBon752nm9sYpa7ASyDKVybZTU0ujoFiVQTBOIL4lTtRjvg0IMcquyl
	 SOiqQpXaYRTc4LJpp+Iwtgluq6wNPdzugFyO3HvNgodkbSgbmCcd448kFecLZUiOV6
	 1i6JRh/4zUzyC9oDJ97qjAG2x4Me7uOwUfkqthfFJji7zyA4Ua9FBaGpxFTNEIIk4k
	 G7JwIlIJPArDA==
Date: Wed, 31 Jan 2024 15:00:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: xfs_clear_incompat_log_features considered harmful?
Message-ID: <20240131230043.GA6180@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Christoph spied the xfs_swapext_can_use_without_log_assistance
function[0] in the atomic file updates patchset[1] and wondered why we
go through this inverted-bitmask dance to avoid setting the
XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT feature.

(The same principles apply to xfs_attri_can_use_without_log_assistance
from the since-merged LARP series.)

The reason for this dance is that xfs_add_incompat_log_feature is an
expensive operation -- it forces the log, pushes the AIL, and then if
nobody's beaten us to it, sets the feature bit and issues a synchronous
write of the primary superblock.  That could be a one-time cost
amortized over the life of the filesystem, but the log quiesce and cover
operations call xfs_clear_incompat_log_features to remove feature bits
opportunistically.  On a moderately loaded filesystem this leads to us
cycling those bits on and off over and over, which hurts performance.

Why do we clear the log incompat bits?  Back in ~2020 I think Dave and I
had a conversation on IRC[2] about what the log incompat bits represent.
IIRC in that conversation we decided that the log incompat bits protect
unrecovered log items so that old kernels won't try to recover them and
barf.  Since a clean log has no protected log items, we could clear the
bits at cover/quiesce time.  At the time, I think we decided to go with
this idea because we didn't like the idea of reducing the span of
kernels that can recover a filesystem over the lifetime of that
filesystem.

[ISTR Eric pointing out at some point that adding incompat feature bits
at runtime could confuse users who crash and try to recover with Ye Olde
Knoppix CD because there's now a log incompat bit set that wasn't there
at format time, but my memory is a bit hazy.]

Christoph wondered why I don't just set the log incompat bits at mkfs
time, especially for filesystems that have some newer feature set (e.g.
parent pointers, metadir, rtgroups...) to avoid the runtime cost of
adding the feature flag.  I don't bother with that because of the log
clearing behavior.  He also noted that _can_use_without_log_assistance
is potentially dangerous if distro vendors backport features to old
kernels in a different order than they land in upstream.

Another problem with this scheme is the l_incompat_users rwsem that we
use to protect a log cleaning operation from clearing a feature bit that
a frontend thread is trying to set -- this lock adds another way to fail
w.r.t. locking.  For the swapext series, I shard that into multiple
locks just to work around the lockdep complaints, and that's fugly.

My final point is that this cycling increases fstests runtime by a good
5%, though fstests isn't a normal workflow.

So.

Given that this set/clear dance imposes continuous runtime costs on all
the users, I want to remove xfs_clear_incompat_log_features.  Log
incompat bits get set once, and they never go away.  This eliminates the
need for the rwsem, all the extra incompat-clearing bits in the log
code, and fixes the performance problems I see.

Going forward, I'd make mkfs set the log incompat features during a
fresh format if any of the currently-undefined feature bits are set,
which means that they'll be enabled by default on any filesystem with
directory parent pointers and/or metadata directories.  I'd also add
mkfs -l options so that sysadmins can turn it on at format time.

We can discuss whether we want to allow people to set the log incompat
features at runtime -- allowing it at least for recent filesystems (e.g.
v5 + rmap) is easier for users, but only if we decide that we don't
really care about the "recover with old Knoppix" surprise.  If we decide
against online upgrades, we /could/ at least allow upgrades via
xfs_admin like we have for bigtime/inobtcnt.  Or we could decide that
new functionality requires a reformat.

Thoughts?  I vote for removing xfs_clear_incompat_log_features and
letting people turn on log incompat features at runtime.

--D

[0] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=djwong-wtf&id=fc6f493c540c520b24e28dfa77c23eea773fa20d
[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/tag/?h=atomic-file-updates_2024-01-30
[2] https://lore.kernel.org/linux-xfs/10237117-2149-d504-bbad-6ec28d420c9b@oracle.com/
