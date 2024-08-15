Received: from skyblue.cherry.relay.mailchannels.net (skyblue.cherry.relay.mailchannels.net [23.83.223.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2250814E2F5
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 21:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.167
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723757080; cv=pass; b=a/2A+kwZxyKMya3CtiZmkczT1Vwb5YuHIrZgZosEeR+kWkuTbzFnZAVDwKg/q/wH0AUHTJTWn7HONrAOg5zgYkqegJ2vdseCHpt36zezV5KzFoBPkhmD24S7T4qq/D7V5+wEoniWFkn8lglsdXQPcdC0cb/zvTqFTCxyjtvxOzw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723757080; c=relaxed/simple;
	bh=QQK6GS69aXX+74krEAXspDA0eQU5MIwzbpRH8P40iVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sp8+iTT/ER4r/1VbGYSjcKIg0geggIKS4xV+cLN+2PLiroL5kh9vrmdDsvVmhlBCBmuhEvdfKscrekA1bwsBIUuQigYBTYsqjDo+H01Z+jszOePlWS41ckI6WCclus8UvDYyrJfxmmsqRGDn/8UtOHm0jIrcArNFcx5RlNlTXOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=O/+YGfyH; arc=pass smtp.client-ip=23.83.223.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="O/+YGfyH"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id CD33F14613F
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 21:17:29 +0000 (UTC)
Received: from pdx1-sub0-mail-a258.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 81400146C0D
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 21:17:29 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1723756649; a=rsa-sha256;
	cv=none;
	b=nxQvxtewhG2BaKD/pdRZK5phDLTPSfiZ0Y6MQ538AlVO6w8BzkdbuQy5T8kDHIsGn0Pk1r
	TcPP5I8HLxG7GbbB+KvmQdH6CQib+gGogt/wcZyV6BDp71qJTNTBC4L5q6MrtMnW7upWs8
	wVlGUq4h8tiJYWm4A1Ad6MvKWyh1a64/4OOSleQo85S78ZIx6qGC3NJkzXs+5DJSTNNrPE
	F9wG9ta01TvLC5Ubqv3WfWm1+Dv4HSy11q4LCiMYwtYUFWZn2t/aPZgnMieWdxMJlGJ5vW
	o+GLKgFLaxurXNQCNp9JfMEPEP4Og6FsyKhRSE5wVFR98U+Z0KquvcgyUAP7qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1723756649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 resent-to:resent-from:resent-message-id:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=RBN71pbRJTwK1EZaifhgiID77GSAsx/n1jmj9UaAqpI=;
	b=2CqNyczV59PLXvLgagoUvj4QyPCSfnOGdlOh+ku4D72HSVuaK0VgQHmCORfZKJ8ujYieya
	vfG4w7YYSSo2ioNzMYWAs1bEpEv2cKv6aGNg/ZmaT/OH9dPfUi3aXkwd/6NO47XH0tyBRW
	pe7lWuzjxLuOBhdi/rS7RfVWxNqw6cIQIx5sSibG47ldspXw2KAgAbM1lvJheR/vbfYRve
	Ee21rsEB7dIvcRTiNZYQF146zqFLWr3deMNy9TB2J/1ec85RW8D89VnaS6hR0gFu3YTRI1
	lYc4veZAGDhba/RLBsdjnpJmBI9qexusjZUTBc+j31e/QQmdyw6TQFa/bDqawA==
ARC-Authentication-Results: i=1;
	rspamd-587694846-7tw8q;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=johansen@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Inform-Shoe: 3cb03cdb7cff3d28_1723756649742_1857344380
X-MC-Loop-Signature: 1723756649742:687845733
X-MC-Ingress-Time: 1723756649741
Received: from pdx1-sub0-mail-a258.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.111.125.119 (trex/7.0.2);
	Thu, 15 Aug 2024 21:17:29 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a258.dreamhost.com (Postfix) with ESMTPSA id 4WlHyK2LLRz6H
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 14:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1723756649;
	bh=RBN71pbRJTwK1EZaifhgiID77GSAsx/n1jmj9UaAqpI=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=O/+YGfyHlzTvlKzSr38H4uCzJ0747UU0fN9j5F4r34ZWFO/bXi4+jWq0fCMHI6Ilo
	 oWsMLu0/1OUJQdoNQonCWWRj4sclbykuIQIXu+U/eQsJF37uMsiKqE6mMYqDwcVnov
	 VMZ8ShagWqNPY2hcJvEon0I7lOmhEJmH64kdnIujzNuymnQQM6UzoWjthAyqIHmREt
	 yb9dZKbvbtlZ1pFJEuMCBCSmB7+pnstI+ivATJ8HocydjzI7F72Shfh4RngPcFWWVq
	 eJH+E5wV3VWxKXCQD4K6H/4QqNTN9UOOKekgi+Fl5XiiKk8gJz/ncEhnuBeSeRomdU
	 9PL8Cf6DSXKgg==
Received: from johansen (uid 1000)
	(envelope-from johansen@templeofstupid.com)
	id e0138
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 15 Aug 2024 14:17:28 -0700
Resent-From: Krister Johansen <johansen@templeofstupid.com>
Resent-Date: Thu, 15 Aug 2024 14:17:28 -0700
Resent-Message-ID: <20240815211728.GB1957@templeofstupid.com>
Resent-To: linux-xfs@vger.kernel.org
Date: Thu, 15 Aug 2024 12:35:49 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 5/5] xfs: include min freelist in m_ag_max_usable
Message-ID: <4b9b30af3719389701c2dd00f8cb20f12043b3ee.1723688622.git.kjlx@templeofstupid.com>
References: <cover.1723687224.git.kjlx@templeofstupid.com>
 <cover.1723688622.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1723688622.git.kjlx@templeofstupid.com>

If agfl_reserve blocks are conditionally withheld from consideration in
xfs_alloc_space_available, then m_ag_max_usable overstates the amount of
max available space on an empty filesystem by the amount of blocks that
mkfs placed into the AGFL on our behalf.

While this space _is_ technically free, it's not usable for a maximum
sized allocation on an empty filesystem, because the blocks must remain
in the AGFL in order for an allocation to succeed.  Without this, stripe
aligned allocations on an empty AG pick a size that they can't actually
get which leads to allocations which can't be satisfied and that
consequently come back unaligned.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 4dd401d407c2..26447e6061b3 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -246,7 +246,9 @@ xfs_alloc_set_aside(
  *	- the AG superblock, AGF, AGI and AGFL
  *	- the AGF (bno and cnt) and AGI btree root blocks, and optionally
  *	  the AGI free inode and rmap btree root blocks.
- *	- blocks on the AGFL according to xfs_alloc_set_aside() limits
+ *	- blocks on the AGFL when the filesystem is empty
+ *	- blocks on needed to AGFL while performing dependent allocations close
+ *	  to ENOSPC as given by xfs_allocbt_agfl_reserve()
  *	- the rmapbt root block
  *
  * The AG headers are sector sized, so the amount of space they take up is
@@ -259,6 +261,13 @@ xfs_alloc_ag_max_usable(
 	unsigned int		blocks;
 
 	blocks = XFS_BB_TO_FSB(mp, XFS_FSS_TO_BB(mp, 4)); /* ag headers */
+	/*
+	 * Minimal freelist length when filesystem is completely empty.
+	 * xfs_alloc_min_freelist needs m_alloc_maxlevels so this is computed in
+	 * our second invocation of xfs_alloc_ag_max_usable
+	 */
+	if (mp->m_alloc_maxlevels > 0)
+		blocks += xfs_alloc_min_freelist(mp, NULL);
 	blocks += xfs_allocbt_agfl_reserve(mp);
 	blocks += 3;			/* AGF, AGI btree root blocks */
 	if (xfs_has_finobt(mp))
-- 
2.25.1

