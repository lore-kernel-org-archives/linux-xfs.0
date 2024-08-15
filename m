Received: from cross.elm.relay.mailchannels.net (cross.elm.relay.mailchannels.net [23.83.212.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E609A13C906
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.212.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723751678; cv=pass; b=nVqbmbnq1AoN9DG8IJ8cVgA8uO3GBnDmPY58jW0pPMG6uNZjZ/mzsN1z5YtGfzGmgfAq8PHe+qhB0vYkRuWrSbM9K6iGyGUGV1GaM6SbnTmC45YvjkFGlxqQ4ZZm4rl6I7AGDBRo9unqlkzaN5B+0mNW6zVg6ZtjxNnWyFx2gFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723751678; c=relaxed/simple;
	bh=f/ym/HhI+ad2ud3xHFvHvQqkvkiRfRFQ2kpUJ75CE8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kmnV5VjdwjnZG+8BZUbGZ0cLcMEj+DUfMsr0AswA1QfJ+YP9EdSAm76JucGA5dIgo00hJbBy6A8w5S4js6oyfpTZ3yIq7jTtjjV7Gj+SYgK672elXyXhbc3q9wZcHqQmofUhOwmjv6KBY3GYtLvmSjNa4wSTRsuE/QqBs5z/xbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=pxOM23Vb; arc=pass smtp.client-ip=23.83.212.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="pxOM23Vb"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 6198A2C3EDA
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:34:51 +0000 (UTC)
Received: from pdx1-sub0-mail-a210.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 16F1A2C50EC
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:34:51 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1723750491; a=rsa-sha256;
	cv=none;
	b=rB8zjbkFp88Y5F21MvPTbS8VXmU8TMYD0oN9enjSt8v0cXpUV4wvWYOul0/14h5TzREWix
	gkSlj5YJcFvNjN34YjsnEOg/TVGnD4HcwYrlyKdbrxbdj/ogTj9Ok2kCZ331inaPakZz/D
	s1bc+UXWBsQ5tuMYYZm6OHWxwSJLD8u38zsv8As5ljtMzVNl2s8+uPVdGpPDTSC0NQav5B
	ETSvut8+PBzIH2jb8QVswjnMh0HKidl/JSFhfDNzaQUU31Sgn2Nz/S8lJjUV28kIH7lJFg
	SQe4hXyd7TSrKI3MfmQnQFW2czwt87Cq0BSKGY249C//57VJXQEjezZkovEDsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1723750491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OTZU2GHi0cFIUNIMsupcprXCrGD2KiplaAerMY4u130=;
	b=Iuk5ETnxxyNKmCItKgAP8QgX7cJIQ3DI26dqHIT0f4kt9Uh34HAkKY7CTjOWDZQGJTjJkv
	246Ujm/Yfp6hHxtWNeAVvSdy8/3gu6CHFvZOnf44aTKCV4qwfsVOTFqpzw1YIuQvCkP8aB
	aYEoQVwkUsr93OCmnfDZjJ2zyV2mA+LDAcirNjamvV0oC8tjfgbSK9+bRwRI/J9wKUiCt5
	lgvsWN9ycxD1ZdIb6NRA7MHEkNNWQXwmJPASC2pUwhTH+fEEdTx9G506L4y22PE4Ou/boD
	aFpAgwu068BmfHuAJXgwGcwbmRBHvbbWoBa/lNXA9VUXpnfPieWNBKyLHVhSOQ==
ARC-Authentication-Results: i=1;
	rspamd-587694846-cqc8b;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Average-Absorbed: 2b146f883df8cb89_1723750491308_2652576341
X-MC-Loop-Signature: 1723750491308:1308885418
X-MC-Ingress-Time: 1723750491308
Received: from pdx1-sub0-mail-a210.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.75.38 (trex/7.0.2);
	Thu, 15 Aug 2024 19:34:51 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a210.dreamhost.com (Postfix) with ESMTPSA id 4WlFgt6W1Cz1x
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 12:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1723750490;
	bh=OTZU2GHi0cFIUNIMsupcprXCrGD2KiplaAerMY4u130=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=pxOM23VbFZ6DXUgMDDvc0LdqXLWbOzjUlhG+McdghFZxE0Y4NytFtQwusPsn6mSAo
	 DaHIjTCIZnfWiReQwLhLKHO5H7jGWS6Cx2aJ4V4bo+E7axCdR+X6OwVIVOF0992J8d
	 OAq4XoNA4vUOuyFvEW6en57/Jvdv/tdJLR02iIiph8zXXxj5Gg+Ecgk/HHfHGf2qQF
	 wuaMnHPWBm3HeiDDxyBJjXHkMlZbzxSsYL0OMSKEsKUROc+AZ7M6omOL7M9qY2avZN
	 T3lWWc3c/mpCd70GDyI1vuhKOm49t1MgWdwH2/7zBerm+S8UOxv89MGhc/UEr73hnb
	 Uu3iPPcGpO6UQ==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e0064
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 15 Aug 2024 12:34:49 -0700
Date: Thu, 15 Aug 2024 12:34:49 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 4/5] xfs: push the agfl set aside into
 xfs_alloc_space_available
Message-ID: <d6841bd2b2c91912e361063d0f4ac0344298f0a3.1723688622.git.kjlx@templeofstupid.com>
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

The blocks that have been set aside for dependent allocations and
freelist refilling at reservation induced ENOSPC are deducted from
m_ag_max_usable, which prevents them from being factored into the
longest_free_extent and maxlen calculations.  However, it's still
possible to eat into this space by making multiple small allocations.
Catch this case by withholding the space that's been set aside in
xfs_alloc_space_available's available space calculation.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 15 +++++++++++++--
 fs/xfs/libxfs/xfs_alloc.h |  1 +
 fs/xfs/xfs_mount.c        |  1 +
 fs/xfs/xfs_mount.h        |  5 +++++
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 826f527d20f2..4dd401d407c2 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -153,7 +153,7 @@ xfs_alloc_min_freelist_calc(
  * middle of dependent allocations when they are close to hitting the
  * reservation-induced limits.
  */
-static unsigned int
+unsigned int
 xfs_allocbt_agfl_reserve(
 	struct xfs_mount	*mp)
 {
@@ -2593,6 +2593,7 @@ xfs_alloc_space_available(
 	xfs_extlen_t		reservation; /* blocks that are still reserved */
 	int			available;
 	xfs_extlen_t		agflcount;
+	xfs_extlen_t		set_aside = 0;
 
 	if (flags & XFS_ALLOC_FLAG_FREEING)
 		return true;
@@ -2605,6 +2606,16 @@ xfs_alloc_space_available(
 	if (longest < alloc_len)
 		return false;
 
+	/*
+	 * Withhold from the available space any that has been set-aside as a
+	 * reserve for refilling the AGFL close to ENOSPC.  In the case where a
+	 * dependent allocation is in progress, allow that space to be consumed
+	 * so that the dependent allocation may complete successfully. Without
+	 * this, we may ENOSPC in the middle of the allocation chain and
+	 * shutdown the filesystem.
+	 */
+	if (args->tp->t_highest_agno == NULLAGNUMBER)
+		set_aside = args->mp->m_ag_agfl_setaside;
 	/*
 	 * Do we have enough free space remaining for the allocation? Don't
 	 * account extra agfl blocks because we are about to defer free them,
@@ -2612,7 +2623,7 @@ xfs_alloc_space_available(
 	 */
 	agflcount = min_t(xfs_extlen_t, pag->pagf_flcount, min_free);
 	available = (int)(pag->pagf_freeblks + agflcount -
-			  reservation - min_free - args->minleft);
+			  reservation - min_free - args->minleft - set_aside);
 	if (available < (int)max(args->total, alloc_len))
 		return false;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index fae170825be0..7e92c4c455a1 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -70,6 +70,7 @@ typedef struct xfs_alloc_arg {
 /* freespace limit calculations */
 unsigned int xfs_alloc_set_aside(struct xfs_mount *mp);
 unsigned int xfs_alloc_ag_max_usable(struct xfs_mount *mp);
+unsigned int xfs_allocbt_agfl_reserve(struct xfs_mount	*mp);
 
 xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_perag *pag,
 		xfs_extlen_t need, xfs_extlen_t reserved);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ec1f7925b31f..1bc80983310a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1002,6 +1002,7 @@ xfs_mountfs(
 	 */
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
+	mp->m_ag_agfl_setaside = xfs_allocbt_agfl_reserve(mp);
 
 	/*
 	 * Now we are mounted, reserve a small amount of unused space for
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 800788043ca6..4a9321424954 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -220,6 +220,11 @@ typedef struct xfs_mount {
 	 * one.
 	 */
 	uint			m_ag_resblk_count;
+	/*
+	 * Blocks set aside to refill the agfl at ENOSPC and satisfy any
+	 * dependent allocation resulting from a chain of BMBT splits.
+	 */
+	uint			m_ag_agfl_setaside;
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
 	struct dentry		*m_debugfs;	/* debugfs parent */
 	struct xfs_kobj		m_kobj;
-- 
2.25.1

