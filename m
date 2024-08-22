Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407F618756E
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 23:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724370751; cv=none; b=aQyyoi2p29CbIPaqyDxN7Rbh08yCVGPE2sBOe3uEEu8bnltgHSY7cFNOqBxQwss0IpkOZjBwTzXOCKrxTGOh0hK9a8XX4FoWuhRxL7YARv1u+fiUGhj/+6WSHUQWPlxIc2xxnaXJ5cmMh7eSe7apEkaklOGh54vL91+vnsy78ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724370751; c=relaxed/simple;
	bh=LQ5JiTKAhxACDCarf0aoLyduRl0wP8KYIF14ttGsuE4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=leEF7yTV7HvrxeuqHSiFY6WRUJks6SQBmRbxFbFs8p6hv9oNmE7dnzxE2yETxya/InQW4AMqCi8UtejeGGOhIQa1kSUjJyCLh02mOr9UTuWnDB/dWC6FhfKZ5h4bg+l8D3qMVGvqBVrhASg7Bcts1kJ7xBQO5GwUZySKockfFvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RQbLk5wc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RQbLk5wc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C4BC32782;
	Thu, 22 Aug 2024 23:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724370751;
	bh=LQ5JiTKAhxACDCarf0aoLyduRl0wP8KYIF14ttGsuE4=;
	h=Date:From:To:Cc:Subject:From;
	b=RQbLk5wc7AWRVSRM0x2SHABLFxuscb256/VY0YXCNlIi23c8sB1FoShWnDDKOeQnq
	 Qztj1ZxnlPvWLTN5CjoFDLWAQTsO+ynC7cfsDVnH8v2gVuEj/nQpmt0gILS+/ZSBTc
	 4s56D8ZY8xuMJHAbogbKFQx2myg9ypP/Ffm8sp5NIm8qhmvX7M1tKCAgz6Ks8wXYPX
	 M5KGwYtxqBvFB1l6et1+ssa5UO9WL5uwO6lKfhHVdq2sTCDvStb1xFX6jKKdExmJtv
	 ZVuOw57xLNtN3/EhvXwItCp79KdQt3xtB2AYt7Mog6UlF3vhAF/v9lHnURnV+cMLt0
	 FLeY9n7xmMQxw==
Date: Thu, 22 Aug 2024 16:52:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanbabu@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB 6.12] xfs: metadata directories and realtime groups
Message-ID: <20240822235230.GJ6043@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Christoph and I have been working on getting the long-delayed metadata
directory tree patchset into mergeable shape, and I think we're now
satisfied that we've gotten the code to where we want it for 6.12.

First comes all the accumulated bug fixes for 6.11.  After that is all
the new code:

The metadata directory tree sets us up for much more flexible metadata
within an XFS filesystem.  Instead of rooting inodes in the superblock
which has very limited space, we instead create a directory tree that
can contain arbitrary numbers of metadata files.

Having done that, we can now shard the realtime volume into multiple
allocation groups, much as we do with AGs for the data device.  However,
the realtime volume has a fun twist -- each rtgroup gets its own space
metadata files, and for that we need a metadata directory tree.

Metadata directory trees and realtime groups also enable us to complete
the realtime modernization project, which will add reverse mapping
btrees, reflink, quota support, and zoned storage support for rt
volumes.  The commit-range ioctl is now part of the rt groups patchset,
because that's the only practical way to defragment rt files when the
rt extent size is larger than 1 fsblock and rmap is enabled.  Also,
with Jeff Layton's multigrained ctime work headed for 6.12, we can now
measure file changes in a saner fashion.

Finally, quota inodes now live in the metadata directory tree, which is
a pretty simple conversion.  However, we added yet another new feature,
which is that xfs will now remember the quota accounting and enforcement
state across unmounts.  You can still tweak them via mount options, but
not specifying any is no longer interpreted the same as 'noquota'.

I'm only sending the kernel patches to the list for now, but please have
a look at the git tree links for xfsprogs and fstests changes.

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir-quotas_2024-08-22
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir-quotas_2024-08-22
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir-quotas_2024-08-22

--D
