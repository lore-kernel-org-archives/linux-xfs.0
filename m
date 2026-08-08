Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A5337F8CB
	for <linux-xfs@vger.kernel.org>; Sat,  8 Aug 2026 23:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786232437; cv=none; b=lWanGY6RDxiXnLqvwIDLJ8dXCIrORPMc+Y1AryOmA4FQZlkLqnEb74r8sdfj470ZcCu7x8/Vez+e8TrXSE8adDgmNOOoETh5TcFUByilIjdyW13O8CG03AVYrRzZAW2nV783DFemYVpWuqqjBAMC4/ghoFRo1H50wI75WZT3kxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786232437; c=relaxed/simple;
	bh=RLoC+bLWmhMUbHM0JWWMbn4Gk548Sl3f/pkuN1JQxy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+kORMypC+icyHrFc572RjrkLAZ7wcAXp0w64bfSpDTntKRw30jsbx7KPwntJPaVXjcmx5qmQGTSdEOOhrJXXF8tTTQSICshbMhfEHuyYZybh4bD9QpfKtn+RwnfBerP1UXSlpLczLYyYXX99U9j1qEnbbz+c3TeXHc6WtgH0V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=zCeIPPRv; arc=none smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="zCeIPPRv"
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-739906c1b32so17297137.3
        for <linux-xfs@vger.kernel.org>; Sat, 08 Aug 2026 16:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786232434; x=1786837234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y8m07bJ9x4UZg3CIvhKYlzzd3b76M3lyayd1caP+7UA=;
        b=zCeIPPRv2af97cTLAYBt5YyBYrFTaFBpdBz2uErHxcxmRq9bhpNnnww8L4M7iqm4xM
         KRhTNILxK35TtYcVxBp9xwmUgIr+CGoF1o3RwIPdDaZocPt0r8x2QIdXZQVZHXTrmnwF
         eN3pjFU3vqGY83Geq2gE2U4CtreFWfy4MJ9OBUxrmInMCPL/sXMAblgKSsii1robPwjV
         4IG8yOSxMI8tLuLPTUn+p9rZXu/GdrWzNCxKN8xzb4HsxWTsMDfwqCJwGKuJgm2KQmL4
         UoI+9Lp6KRp1h/eanPmbYGrUr57mmKwQW1OQbpgwgHJG+iPJ/JApIGj5LKbRLjqr1OeH
         /jjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786232434; x=1786837234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y8m07bJ9x4UZg3CIvhKYlzzd3b76M3lyayd1caP+7UA=;
        b=OaVYern3Y6X2qi1Wt31zoyVfLLI013l4ZQznpWKbwDGmB9vJafESA8nED2d0kRXkUd
         OHl+lqV58+oqfYzBpHTarGUpBEm03Bhmr/hUnq0j56CN8ubrNAs69yaMqJUvtHecTSwX
         BW0gvQ1yPqEA6jJiQL7gnd2BhbbQ58KEY7rNHwWjo8swvBWu/7By7Uksj852BZLv/+R2
         q8HSkv5VxT+YKl9bJTtyg+KSGLnnuVnC5xMuz5BtnljVrhQKoqy2M1OxLKN3YTO7VWJN
         ZMGLtOtIlJwqVHCP7u72yO23bZH4o5vHHZxKak+ulOBkGqwuYgGO1YwFUBLM8izrIoT6
         wSdQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrcf48SWxUZE7S0pNJE+uGMyR2hOWXhw3XNkGq9wiwNO6bzOYTJ7leoYWlf8D/+T4+TgK0ddWkRog4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcfjER67QmiWk+6uLQ5+OVHb4YzcftKFUb+oy7l+6Z7e2xW6k7
	8XIMUnZZvejZZehCAZ5ApzHpbZdqsB8NiJ5Iy8ma8n4dsriJlaW4y+/u6QKCcYI0iNc=
X-Gm-Gg: AR+sD11SdfIXgXAotEjmfianMkZpYP/4e89lZMBknwbhZMOGifDaErRLhSp1Phfnnpd
	Or4H8kzxC9cKAWUsvqMCLr5XVsxLGOAjXEmi9wAsGhGFRql/kWeEaL/B/NWV3AV4DJXTsOwKYQp
	19reckuffWvvmSvQkzbtcua8XHjsxZoyC/vdTooa97jbZz4FZUmMW8PtGe8zM6NsfMMl07meztl
	xD5wIWDkb44UPajj5aOt3azb5v7GnRvemocIcBHwNcks1nPe7+ZbTS7RA8BBp2VaFypo1gCscKZ
	UK0UjInUjy6mY1PFGjoxXQmhTqrtSpuyl2BlOwqbpEF/1jh9GdC9u9wLDvIE1EQ3uSxwUwWY0St
	KMELPM5iFyinnSLzxr1RffoQh27CEuzbOtY7oo80isAhh5IC1rJF7kXC13Yw7l82YEe9x+563Fy
	k85llLO9y5YXTJajyHvIfh3928001sTiE5qVJFm9do61zmVM3iFvXcUHhrA5Iy8Bwo
X-Received: by 2002:a05:6102:3ca3:b0:740:2974:57bd with SMTP id ada2fe7eead31-760e3aa3f3emr4976841137.0.1786232434470;
        Sat, 08 Aug 2026 16:40:34 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c420a2d1d8sm933268e0c.6.2026.08.08.16.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 16:40:33 -0700 (PDT)
Sender: Javier Tia <j.tia@peridio.com>
From: Javier Tia <javier@peridio.com>
X-Google-Original-From: Javier Tia <floss@jetm.me>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] xfs: initialise args->total for parent pointer updates
Date: Sat,  8 Aug 2026 17:40:22 -0600
Message-ID: <20260808234016.246054-12-floss@jetm.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260808234016.246054-7-floss@jetm.me>
References: <20260808234016.246054-7-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5235; i=floss@jetm.me; h=from:subject; bh=RLoC+bLWmhMUbHM0JWWMbn4Gk548Sl3f/pkuN1JQxy8=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqd75hNCWMnc2GW9Tosbw5mgnh76chi8Q/9CHct MWOgEqnUOuJAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCane+YQAKCRC17sMLqGd3 Hx3PC/4tWC6hsXgROpveLtrgXEFBsGRGw8KoQGxduMqxlaPyqbGNlIERhaLzvu0896EZskS4on2 hkiUU0Cys5SwcBrfHfphNGS3rqpGcCqscX/HGhkhVLerdsUq7NS0QYUcMWv9xVKfgeTvgAunky3 lID43hGjAiu88VKwv6m2xL67qnpb8cvq8DnmS6DrkkzNDriHzWVjXSBZw061L1JVdj6g2ONusva GYk8LRldTwPI/LQmohvT8uXAqhktP0cQxFQLYkOJJFr1d94FX83azTmORbjmz8leOdN/Tgz9JRK KOpSMNPGxhs8DcVBx0uIr/WXdmBpTCRnWvHp+jV59WEymrhtdEa+SL9bsPovRy2Td0CkRsW7BRJ yXX/0AkVHFN3OynPaS/uZBNdbTexEItdYksSsqk8ke8gIPZH9L3r3bOwnxTonrndHPlwuywGjas IT8ITNSMnAyJG6fyvIXp12ZSkWpdtkBRVCzUJkWBzzID/CY4NRTIi7GZd6rSG6+2dPJ1s=
X-Developer-Key: i=floss@jetm.me; a=openpgp; fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
Content-Transfer-Encoding: 8bit

xfs_parent_da_args_init() fills in every field of its xfs_da_args except
total, and the containing struct xfs_parent_args is allocated with
kmem_cache_zalloc() (xfs_parent.h:66), so runtime parent pointer updates
reach the block allocator with args->total == 0.

The log recovery path already gets this right, which is the clearest
statement of the bug.  xfs_attri_recover_work() reconstructs the same
operation from a recovered intent and does

	args->total = xfs_attr_calc_size(args, &local);	/* xfs_attr_item.c:706 */

for PPTR_SET and PPTR_REPLACE, and deliberately not for PPTR_REMOVE.  So
replaying a parent pointer insert from the log runs with a correct total
while performing the same insert at runtime runs with zero.

That field is not a constant.  xfs_da_grow_inode_int() treats it as a
running remainder:

	args->total -= dp->i_nblocks - nblks;		/* xfs_da_btree.c:2388 */

xfs_da_args.total is an xfs_extlen_t, i.e. uint32_t (xfs_types.h:14), so
subtracting the first block the attr fork gains wraps it to 0xffffffff.
It is passed down as xfs_bmapi_write()'s total argument
(xfs_da_btree.c:2348), stored as xfs_bmalloca.total, copied to
xfs_alloc_arg.total (xfs_bmap.c:3214, 3379) and finally reaches

	if (available < (int)max(args->total, alloc_len))

in xfs_alloc_space_available() (xfs_alloc.c:2525), where the cast turns
~0U back into -1 and the minimum-free-space test can no longer fail.
Parent pointer allocations therefore skip a check that every other xattr
allocation observes.

Growing the fork twice in one operation is ordinary, not a corner case:
XFS_DAS_LEAF_ADD calls xfs_attr3_leaf_to_node(), which grows the fork
(xfs_attr_leaf.c:1319), then sets XFS_DAS_NODE_ADD and returns -EAGAIN;
the next cycle can reach xfs_attr3_leaf_split() (xfs_attr_leaf.c:1462),
and a node split reaches xfs_da_grow_inode() again by way of
xfs_da3_split() (xfs_da_btree.c:748, 866).  The xfs_da_args lives across
that roll, so the later allocations are the ones that see the wrapped
value.

Set the field from xfs_attr_calc_size(), matching both the recovery path
above and xfs_attr_set() (xfs_attr.c:1150), rather than clamping the
subtraction, which would leave total meaningless for parent pointers and
hide the omission.

The initialiser is shared with five other callers and the value is inert
on all of them.  Every reader of args->total in the attr code needs
xfs_da_grow_inode(), whose only attr-fork callers are the three growth
functions in xfs_attr_leaf.c and the two split functions in
xfs_da_btree.c, and the state machine cannot reach any of them from a
remove: each remove state completes with
xfs_attr_complete_op(attr, xfs_attr_init_add_state(args)), and
xfs_attr_complete_op() replaces that add state with XFS_DAS_DONE unless
XFS_DA_OP_REPLACE is set (xfs_attr.c:497), which only the two replace
helpers ever set.  xfs_parent_lookup() never allocates at all, and on
xfs_parent_set() the assignment is immediately overwritten by
xfs_attr.c:1150, so it is dead there rather than merely unused.  Setting
it unconditionally is simpler than mirroring
xfs_attri_recover_work()'s switch.

This makes the allocator stricter for parent pointers rather than only
more correct: where total was 0 the test reduced to
available < alloc_len, and it now asks for the whole remaining
reservation, 25 blocks on a 4k-block filesystem.  That changes which AG
is chosen and can cost an extra allocator pass, but it does not
introduce a new failure.  xfs_bmap_btalloc_low_space() retries with
args->minlen and sweeps every AG before declaring ENOSPC
(xfs_bmap.c:3511-3532), and a parent-pointer link never runs
reservationless in the first place - xfs_link() refuses the resblks == 0
fallback while pptrs are enabled, precisely because it cannot back out if
the xattrs must grow (xfs_inode.c:948-954).

Fixes: b7c62d90c12c ("xfs: parent pointer attribute creation")
Signed-off-by: Javier Tia <floss@jetm.me>
---
 fs/xfs/libxfs/xfs_parent.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 3509cc4b2175..d6588d0a9286 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -156,6 +156,8 @@ xfs_parent_da_args_init(
 	xfs_ino_t		owner,
 	const struct xfs_name	*parent_name)
 {
+	int			local;
+
 	args->geo = child->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	args->attr_filter = XFS_ATTR_PARENT;
@@ -168,6 +170,17 @@ xfs_parent_da_args_init(
 	args->value = rec;
 	args->valuelen = sizeof(struct xfs_parent_rec);
 	xfs_attr_sethash(args);
+
+	/*
+	 * xfs_da_grow_inode_int() subtracts every block it allocates from
+	 * args->total, which is unsigned, so the zero left here by
+	 * kmem_cache_zalloc() wraps to ~0U as soon as the attr fork grows once.
+	 * Derive it the way xfs_attr_set() does instead.  A parent pointer's
+	 * value is a struct xfs_parent_rec, so the entry is always local, which
+	 * is what the ASSERT records.
+	 */
+	args->total = xfs_attr_calc_size(args, &local);
+	ASSERT(local);
 }
 
 /* Make sure the incore state is ready for a parent pointer query/update. */
-- 
Javier Tia

