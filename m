Received: from rusty.tulip.relay.mailchannels.net (rusty.tulip.relay.mailchannels.net [23.83.218.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE133770E8
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.252
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723751384; cv=pass; b=JEF4EgsT07oVYFA5JGXwvyBiqp2+Q2xT14yke3KfpqCmUw0SJwM2id+3YUgbx5FcKOGUeLkNWp8gZqN4vkoyRninX9IanzvLcLlyxzSep03GsSq90K+3Y+h0uKNvR7j05j37ESlyrN7ZKLUO+/ivSSwwKL8oVPugBITXvSSx2f4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723751384; c=relaxed/simple;
	bh=HXs5X2SdPu5IPb39CCTlGl9JDtQi1NSB5c5urGcQwZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bUylvcmlXeydkzm6+tPjmb3lYW3sz4B/yEcbLnEmVVkHUO8tLfNN0Wen+rFYtj9kS4BsWCj3MHQWpq7DETMzKr6EMU827Sdbwh18b2uBNyO+w5/8NZ6r30wOuCMQO10DZcG2SRE+T6A1CAXNWuyD4wKqEA01l9/xfDlpfvi3U2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=DwC/dHX3; arc=pass smtp.client-ip=23.83.218.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="DwC/dHX3"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id A40C9C67BB
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:30:49 +0000 (UTC)
Received: from pdx1-sub0-mail-a210.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 5B93FC6564
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:30:49 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1723750249; a=rsa-sha256;
	cv=none;
	b=Nfwi0UDnftVLylYd+MPcMyhKrn7M+92cUJSS6/mPfl5Fo/72WK0GL42Y3YPu0EfenSDHpT
	hSVtHwSSmDljtO2vEZ9Io2zez875+yiSg0V0GWP78VqgTBGye4g4K89GAfBJR9C4rrOALb
	VpKAgAesVvBr/UiPe60eiw64EFlbUh8Tn5ENa2IkNSbUyFOXXUxIB1byXQ4WK8R3EMybl2
	gUglOx5ZtrOOk95OG2otNeuZZaWBIREfhqW08Lv31iLlIe5koPmD+HG9aw/hNK7cAXOBws
	TJhtNCG/lQ2hb7dmi6IGOXdejdVMbz0oy0tv5jjH1kclSbcGXwZBTtRosBXEQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1723750249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+yz8QnMgU01wHEONCpX/2eu2lt9HcGc3LQEgdolMzPY=;
	b=GuEjBaeOph2cVd4L/Ll6RyXvRuOSxe3GJ7Th2vuzu9Utg1kNf5ttlupclSGOC85H6RzT2D
	G6cvDKVGTZ2fYEB01CX+KVgmA946YKtADG9RKTH9WhEsHBxCQgqq2tEsK51ZvUx3RrwwOa
	Y4ttXGDvr6hudqG2Rwd9g44MVQD/x0UGuW0MJVIJE6JOTrRDMsNFkN6AVhk1G1cx75jCLe
	D1BQRMJMa1kQEO9dzack1HUwImZ6+N5N8LcmlOMM5YSCTKkHfZNsBnoznLnUvW9tzwaBKW
	eltsJ75HxSVUIaiGB/vmRD5tuP5soWYfD8/HCXXV8bd3dIhih88EhWrrl7B3jg==
ARC-Authentication-Results: i=1;
	rspamd-587694846-cgng9;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Trail-Irritate: 6c6b8e4e7d2753b3_1723750249586_2537820552
X-MC-Loop-Signature: 1723750249586:662977041
X-MC-Ingress-Time: 1723750249586
Received: from pdx1-sub0-mail-a210.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.101.250.139 (trex/7.0.2);
	Thu, 15 Aug 2024 19:30:49 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a210.dreamhost.com (Postfix) with ESMTPSA id 4WlFbD6bTczT6
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 12:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1723750249;
	bh=+yz8QnMgU01wHEONCpX/2eu2lt9HcGc3LQEgdolMzPY=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=DwC/dHX3f3Z5HTMh5N+t2PjQlU2gnxAWXhVtVj+BDend7BTgEMqFMoYXFsatCBbF5
	 RVjLZx948+J2uZTqNZgXw2KRU78Vunxzi44l65ntteK5bBF1880naEAV3TNOH/Bpav
	 BmR+XWHXZlN5CNct7u0gIKN5spiceGbBaJfMcMz4Q/uI8/mBPxQhhjGyHrbgj0u61a
	 OTir4HzlZYEnt/6fWEqQx8H120lI9ThR1Cb/XeeZ3u3W3mLVCY38nUrDR+hgH8zk35
	 lyV3tDOX0Au4zkmrd7bijYGyJsch0RPwneKziSjTi5zfjisu1UI1TYOWgQg2Hz8YNQ
	 rXy7a8sRI7ibA==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e0064
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 15 Aug 2024 12:30:47 -0700
Date: Thu, 15 Aug 2024 12:30:47 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 0/5] linux: Modifying per-ag reservation to account for
 dependent allocations
Message-ID: <cover.1723688622.git.kjlx@templeofstupid.com>
References: <cover.1723687224.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1723687224.git.kjlx@templeofstupid.com>

Hi,
These patches attempt to address the problem where dependent allocations
fail during a multi allocation transaction, often as a result of
refilling the AGFL.  The failure results in a filesystem shutdown.  In
many cases, it manifests as a warn in xfs_bmap_extents_to_btree, when
the dependent b-tree conversion fails after inadvertently getting an
ENOSPC.

The RFC series was here:

https://lore.kernel.org/linux-xfs/cover.1718232004.git.kjlx@templeofstupid.com/T/#t

This series attempts follows David's guidance around implementing the
reservation using the existing xfs_alloc_ag_max_usable and
XFS_ALLOCBT_AGFL_RESERVE mechanisms.  This mostly worked as advertised
(thanks!), however, a few additional patches were needed in order to
address test failures.

In particular, without the 'xfs: include min freelist in
m_ag_max_usable' patch this series would fail the generic/223 tests
around stripe alignment, because m_ag_max_usable was slightly larger
than the actually usable space.  This turned out to be the result of the
first pre-fill of the AGFL and once corrected the tests pass.

This currently has a failure in xfs/306.  I'm including a patch for
xfstests to address this.  The per-AG reservation size on the filesystem
in that test increased by just enough that the filesystem reservation
that was manually configured to 16 blocks was too small.  Increasing
that test's reservation to 17 allows it to continue.  The failure
manifests as dd failing to make progress and the dmesg filling with
errors about xfs_discard_folio.  Tracing showed that conversion of the
delalloc to a real allocation was getting ENOSPC.

-K

Krister Johansen (5):
  xfs: count the number of blocks in a per-ag reservation
  xfs: move calculation in xfs_alloc_min_freelist to its own function
  xfs: make alloc_set_aside and friends aware of per-AG reservations
  xfs: push the agfl set aside into xfs_alloc_space_available
  xfs: include min freelist in m_ag_max_usable

 fs/xfs/libxfs/xfs_alloc.c | 184 ++++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_alloc.h |   1 +
 fs/xfs/xfs_fsops.c        |  21 +++++
 fs/xfs/xfs_fsops.h        |   1 +
 fs/xfs/xfs_mount.c        |  24 +++++
 fs/xfs/xfs_mount.h        |  12 +++
 6 files changed, 207 insertions(+), 36 deletions(-)


base-commit: 7bf888fa26e8f22bed4bc3965ab2a2953104ff96
-- 
2.25.1

