Received: from slateblue.cherry.relay.mailchannels.net (slateblue.cherry.relay.mailchannels.net [23.83.223.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0460E139CE2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 21:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718312681; cv=pass; b=kGkhnuxY52ATUvPbfav2QJw52zsBt8sSdHjoOSksg1C5Gqz5jSCVaE5ZwM+LlWHA+egxL+ntAAI2FaS56oDB3MtIz58I//ysGu5AsewdP2NVEnBXJAmiw8mkzmW8LEq4JNwNzUE+B5uJJPeR8RpQAk9FWk+Og/n1NWQPtCcKFsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718312681; c=relaxed/simple;
	bh=KKXfdBBnIPYmG1XO0GmAhqMNiG/SIlrzi1yHtXlxbJs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=aUNPfDr5PK46UJItK3zeRp57ubiDPhufRpwUzS3YmCBMZL3tCnjrgZrb0eWizD31z2NBuLL7qtXRRUkhgDZIje3jjwuxCRfukLj4KZ4H+dO534c1QpbNS3ogzgdITbNT+DOwSois8REvJOpfWvDoKsxn/ZFQDmDnMjUSF4HxWKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=aYRWyLvJ; arc=pass smtp.client-ip=23.83.223.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="aYRWyLvJ"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 0B9715035C4
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 20:27:20 +0000 (UTC)
Received: from pdx1-sub0-mail-a231.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id EFC36501C93
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 20:27:18 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1718310439; a=rsa-sha256;
	cv=none;
	b=6PTtcsOiVRXCpP9MSacwmaPpZHGVC/96gJyYG2zH/VJjgAgcDF89ZSZpalYiwPuhaBQBCw
	NLkD0PjOX5vkLTq+VzwIvhFwQ3lETFUXaHJq84UMHPBwN3t+/yf62MvC4uc6YPTrcOAq8Z
	n6jmNVEtCwMnLBAPWOPRLJk9dO+S/T9y0doytB93Ap6eg4TQGZdMTUFWDh+73xFOtV9Usz
	obaz0jYAhYZzEWFkeXGgcr1kX96fiaZMFtq2olZlnDgyJsfzaTOc/b9EIdDRHrMlcxfLdS
	GuaZd2jAmW57PfWIpxoKfTTCr6Cb6nO8lZeQq+0gVctVygXHYA4ZmBVc+Ykv3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1718310438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 dkim-signature; bh=3yF3i/E/30ehmXe9s/2FjETaseFYFWGcCxYD6rF2kdA=;
	b=sdiDPuxFJUikeSD38QOJuYke6tKvXZdXsZ/Vrb83YCCc9UVKBZhjaE4DbF04mUWJZEtE63
	HE12PzKArYdMwrQR8pZH20Sq9huX9fFfg4JPxB9cON2pbUrHycgd/rhJEPDWfDA5QAmSYU
	BQ6tzXd1qFOmPZoPTRdnzll+7UgnPO8BhZvasvrErqnFC7nmeU8R8DPk0EtjUVCgXVMAdx
	c1+00l+CJBPnLKXxDfMDiKt/nDR6BGdngmvWCx8YKhZ/c3RHWtqS2nbx1F6Rgiuv4I5EPc
	9fPZXlkzD9e1RDpwndQnQAX8c6/6HvcfJg1OQFTWhkHh3JxLzD9V/ooY7Gbs1Q==
ARC-Authentication-Results: i=1;
	rspamd-79677bdb95-mv47m;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Suffer-Blushing: 2f2f17d90ae7e1ad_1718310439228_4272099224
X-MC-Loop-Signature: 1718310439228:3775423568
X-MC-Ingress-Time: 1718310439227
Received: from pdx1-sub0-mail-a231.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.114.12.91 (trex/6.9.2);
	Thu, 13 Jun 2024 20:27:19 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a231.dreamhost.com (Postfix) with ESMTPSA id 4W0YqV5MntzmL
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 13:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1718310438;
	bh=3yF3i/E/30ehmXe9s/2FjETaseFYFWGcCxYD6rF2kdA=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=aYRWyLvJwTG7YCRwiacQ7jsU0qiYSJM8JzaYUYSZHEi38tAWrxbkakHc0LAgqcu7s
	 DTiY8JmQ8/RNv7F/qwTi6q9k/AAGHt4z0YTE9wJq2FQjrXLyyJzjn07F0/o+AueM9+
	 SuYh/+a64UIbW/OdiuRCCQkjpSR30wuOXSnW+twRj2VjwY8CYqDRN2lK6sIXkgnaRC
	 yAF7XQWkHyXAl4jAZaxCnd5jwB/Iu756WOZ21AdgOpBIY79WKGPUezJgUjCciYXb3a
	 kgzDYxeLFwLgdI8JSrTv0uY5t78pL39wqtQdkg+aP+mtEcZnzmtuuxYWtCuaGj16RP
	 B4O33cr3a6Erw==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e006b
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 13 Jun 2024 13:27:09 -0700
Date: Thu, 13 Jun 2024 13:27:09 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>, linux-xfs@vger.kernel.org
Subject: [RFC PATCH 0/4] bringing back the AGFL reserve
Message-ID: <cover.1718232004.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
One of the teams that I work with hits WARNs in
xfs_bmap_extents_to_btree() on a database workload of theirs.  The last
time the subject came up on linux-xfs, it was suggested[1] to try
building an AG reserve pool for the AGFL.

I managed to work out a reproducer for the problem.  Debugging that, the
steps Gao outlined turned out to be essentially what was necessary to
get the problem to happen repeatably.

1. Allocate almost all of the space in an AG
2. Free and reallocate that space to fragement it so the freespace
b-trees are just about to split.
3. Allocate blocks in a file such that the next extent allocated for
that file will cause its bmbt to get converted from an inline extent to
a b-tree.
4. Free space such that the free-space btrees have a contiguous extent
with a busy portion on either end
5. Allocate the portion in the middle, splitting the extent and
triggering a b-tree split.

On older kernels this is all it takes.  After the AG-aware allocator
changes I also need to start the allocation in the highest numbered AG
available while inducing lock contention in the lower numbered AGs.

In order to ensure that AGs have enough space to complete transactions
with multiple allocations, I've taken a stab at implementing an AGFL
reserve pool.

This patchset passes fstests without any regressions and also does not
trigger the reproducers I wrote for the case above.  I've also run those
with tracing enabled to validate that it's got the accounting correct,
is rejecting allocations when there's no space in the reserve, and is
tapping the reserve when appropriate.

The first patch is the plumbing that re-establishes the reserve for the
AGFL.  I'm happy to break this into something smaller, if it's too
large.  The remaining patches add additional pieces needed to check how
much space the AGFL might need on a refill, and then to actually use the
reserve to permit or deny allocation requests, as the case may be.

I'm sending this as an RFC, since I still have a few outstanding
questions and would appreciate feedback.

Some of those questions are:

Patch 1 includes all freespace that is not allocated to the rmapbt in
its used / reserved accounting.  It also borrows the heuristics from
rmapbt in terms of picking the initial size of the reservation.  The
numbers I'm getting seem a bit large.  Any suggestions about how to
improve this further?

Patches 3 and 4 use the allocation args structure to attempt to decide
whether an allocation is the first in a transaction, or if its a
subsequent allocation.  Are there any recommendations about a better way
to do this?

Thanks,

-K


[1] https://lore.kernel.org/linux-xfs/20221116025106.GB3600936@dread.disaster.area/


Krister Johansen (4):
  xfs: resurrect the AGFL reservation
  xfs: modify xfs_alloc_min_freelist to take an increment
  xfs: let allocations tap the AGFL reserve
  xfs: refuse allocations without agfl refill space

 fs/xfs/libxfs/xfs_ag.h          |  2 +
 fs/xfs/libxfs/xfs_ag_resv.c     | 54 ++++++++++++++-----
 fs/xfs/libxfs/xfs_ag_resv.h     |  4 ++
 fs/xfs/libxfs/xfs_alloc.c       | 94 +++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_alloc.h       |  5 +-
 fs/xfs/libxfs/xfs_alloc_btree.c | 59 +++++++++++++++++++++
 fs/xfs/libxfs/xfs_alloc_btree.h |  5 ++
 fs/xfs/libxfs/xfs_bmap.c        |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c      |  2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c  |  5 ++
 fs/xfs/scrub/fscounters.c       |  1 +
 11 files changed, 207 insertions(+), 26 deletions(-)


base-commit: 58f880711f2ba53fd5e959875aff5b3bf6d5c32e
-- 
2.25.1

