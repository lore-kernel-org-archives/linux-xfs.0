Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA811607B2;
	Wed,  1 May 2024 18:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588893; cv=none; b=gfJpwk5X9+/P64egGzMcbWEvMaw1mPo/qXZorkzr7ce7p0wYfHvdGFqiwHFCTnO0fUpXKmXN3oTi5179TchxIZozgL/60gxgfD0rSu3t7kQ+THKsimGpI3kpiv7zkwJ7BJhDWIUIc+ziU2U25NfENsLb53w0xFrojDmuApqjRbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588893; c=relaxed/simple;
	bh=KgNKmdvRhbteXlYA1qRmNazSdqVHiolUTLcA7KZB8lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkP/Ujn6FCAVu9IPFOIOO4IHctQaAv51i4WXwUuDt2N1Ma9YOBN17Yj/uIBsK288BfJQEcsgSFoQEiEBaT7BPqeBisP8bYukqegtInzmX3aLSlmw6tCrfm3LGWYBg4JykRDi94chokfRGJJZEoKMSkWimOXVkbfVUxksrdX2is0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q8CYVndV; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q8CYVndV"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6f30f69a958so6116933b3a.1;
        Wed, 01 May 2024 11:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588891; x=1715193691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9StMf4Na2dHNSmM9yPOAXAhSD4SXWdlQn6JM5uJ3Giw=;
        b=Q8CYVndV56UlMGBQ9k75BPjXqTz0V/fZrHVXfb3ZAredT6eP3rWIw5ONmjBK2As9Ko
         +qvkPIrKy5GXJeDiESxY8wKAwy8hyh158gDgDevB0zdnvbufvg6ANYYSioB/mOB0Nmwb
         5T6HJKb7SgxFs/vFLpAJf+DZgzYAqogO18MM6laW0AwyJgJR4989mRKB1vL4SfUqTc4c
         D+m+Kk8vR0+/KKEE1XGGT0939mY8woctnE+c1XK3VVJjUvx++U2MchwQm7lK0GUfw0qd
         Uy4Gm2JwQdDzK2sX4I1Mi4huAGBy7IryipzGicd8wgD9qSkIJwWzgej+IidnuAQxPuh8
         m2vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588891; x=1715193691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9StMf4Na2dHNSmM9yPOAXAhSD4SXWdlQn6JM5uJ3Giw=;
        b=tkdXhbJdY5RY9LlctbY9BqFLwWsMejvqD+v+Ao1g0+wqKg1pJTdtqeWnd4q6ZDofhX
         uYL3N9xOq3Bx/v+XKRXPVqeOKdJAHPfqmwiFHTJCjLtJ5k6roT5w1UZA3dXZmtIpfxve
         iSyNhSHg9PXOp3L49fmEiEJ3Qzj2XTYoLbFARXXNZ421xV9N793RbEB0s0rRMl9nmNAC
         a5MQpH0//Uowtjwqw/kHXyiwVJ4JWSNKNMESNVkJkf+FBno28VW9EmM9VdOUWC11lDRh
         MZ6dRBKgE0rjjGH3uLRyNglJX12vNSD3rNEtybSnNhGMjJ+QB6fBhSgA+n9P1LtcM0wm
         RG8A==
X-Gm-Message-State: AOJu0YyrvN9e1VgKkDgU4rpLqsCVR9nxs0r0cNdTowRuL8QMX+fQ6/X+
	Ch1xTLHyPZgxDwhHUqr3yu/PwU5e1RrAjV/bsXXPkEGA64mQuU+zhDzNdpF6
X-Google-Smtp-Source: AGHT+IE+0CHIdcmKj5rc/9ZHMwsZrOphM5y8UOntnHMRKj2d3PGDAoQfDRKzmUBLPntMsawFRJi2Kg==
X-Received: by 2002:a05:6a20:2d27:b0:1aa:8aff:4695 with SMTP id g39-20020a056a202d2700b001aa8aff4695mr4757710pzl.42.1714588891236;
        Wed, 01 May 2024 11:41:31 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:30 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 15/24] xfs: attach dquots to inode before reading data/cow fork mappings
Date: Wed,  1 May 2024 11:41:03 -0700
Message-ID: <20240501184112.3799035-15-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 4c6dbfd2756bd83a0085ed804e2bb7be9cc16bc5 ]

I've been running near-continuous integration testing of online fsck,
and I've noticed that once a day, one of the ARM VMs will fail the test
with out of order records in the data fork.

xfs/804 races fsstress with online scrub (aka scan but do not change
anything), so I think this might be a bug in the core xfs code.  This
also only seems to trigger if one runs the test for more than ~6 minutes
via TIME_FACTOR=13 or something.
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/tree/tests/xfs/804?h=djwong-wtf

I added a debugging patch to the kernel to check the data fork extents
after taking the ILOCK, before dropping ILOCK, and before and after each
bmapping operation.  So far I've narrowed it down to the delalloc code
inserting a record in the wrong place in the iext tree:

xfs_bmap_add_extent_hole_delay, near line 2691:

	case 0:
		/*
		 * New allocation is not contiguous with another
		 * delayed allocation.
		 * Insert a new entry.
		 */
		oldlen = newlen = 0;
		xfs_iunlock_check_datafork(ip);		<-- ok here
		xfs_iext_insert(ip, icur, new, state);
		xfs_iunlock_check_datafork(ip);		<-- bad here
		break;
	}

I recorded the state of the data fork mappings and iext cursor state
when a corrupt data fork is detected immediately after the
xfs_bmap_add_extent_hole_delay call in xfs_bmapi_reserve_delalloc:

ino 0x140bb3 func xfs_bmapi_reserve_delalloc line 4164 data fork:
    ino 0x140bb3 nr 0x0 nr_real 0x0 offset 0xb9 blockcount 0x1f startblock 0x935de2 state 1
    ino 0x140bb3 nr 0x1 nr_real 0x1 offset 0xe6 blockcount 0xa startblock 0xffffffffe0007 state 0
    ino 0x140bb3 nr 0x2 nr_real 0x1 offset 0xd8 blockcount 0xe startblock 0x935e01 state 0

Here we see that a delalloc extent was inserted into the wrong position
in the iext leaf, same as all the other times.  The extra trace data I
collected are as follows:

ino 0x140bb3 fork 0 oldoff 0xe6 oldlen 0x4 oldprealloc 0x6 isize 0xe6000
    ino 0x140bb3 oldgotoff 0xea oldgotstart 0xfffffffffffffffe oldgotcount 0x0 oldgotstate 0
    ino 0x140bb3 crapgotoff 0x0 crapgotstart 0x0 crapgotcount 0x0 crapgotstate 0
    ino 0x140bb3 freshgotoff 0xd8 freshgotstart 0x935e01 freshgotcount 0xe freshgotstate 0
    ino 0x140bb3 nowgotoff 0xe6 nowgotstart 0xffffffffe0007 nowgotcount 0xa nowgotstate 0
    ino 0x140bb3 oldicurpos 1 oldleafnr 2 oldleaf 0xfffffc00f0609a00
    ino 0x140bb3 crapicurpos 2 crapleafnr 2 crapleaf 0xfffffc00f0609a00
    ino 0x140bb3 freshicurpos 1 freshleafnr 2 freshleaf 0xfffffc00f0609a00
    ino 0x140bb3 newicurpos 1 newleafnr 3 newleaf 0xfffffc00f0609a00

The first line shows that xfs_bmapi_reserve_delalloc was called with
whichfork=XFS_DATA_FORK, off=0xe6, len=0x4, prealloc=6.

The second line ("oldgot") shows the contents of @got at the beginning
of the call, which are the results of the first iext lookup in
xfs_buffered_write_iomap_begin.

Line 3 ("crapgot") is the result of duplicating the cursor at the start
of the body of xfs_bmapi_reserve_delalloc and performing a fresh lookup
at @off.

Line 4 ("freshgot") is the result of a new xfs_iext_get_extent right
before the call to xfs_bmap_add_extent_hole_delay.  Totally garbage.

Line 5 ("nowgot") is contents of @got after the
xfs_bmap_add_extent_hole_delay call.

Line 6 is the contents of @icur at the beginning fo the call.  Lines 7-9
are the contents of the iext cursors at the point where the block
mappings were sampled.

I think @oldgot is a HOLESTARTBLOCK extent because the first lookup
didn't find anything, so we filled in imap with "fake hole until the
end".  At the time of the first lookup, I suspect that there's only one
32-block unwritten extent in the mapping (hence oldicurpos==1) but by
the time we get to recording crapgot, crapicurpos==2.

Dave then added:

Ok, that's much simpler to reason about, and implies the smoke is
coming from xfs_buffered_write_iomap_begin() or
xfs_bmapi_reserve_delalloc(). I suspect the former - it does a lot
of stuff with the ILOCK_EXCL held.....

.... including calling xfs_qm_dqattach_locked().

xfs_buffered_write_iomap_begin
  ILOCK_EXCL
  look up icur
  xfs_qm_dqattach_locked
    xfs_qm_dqattach_one
      xfs_qm_dqget_inode
        dquot cache miss
        xfs_iunlock(ip, XFS_ILOCK_EXCL);
        error = xfs_qm_dqread(mp, id, type, can_alloc, &dqp);
        xfs_ilock(ip, XFS_ILOCK_EXCL);
  ....
  xfs_bmapi_reserve_delalloc(icur)

Yup, that's what is letting the magic smoke out -
xfs_qm_dqattach_locked() can cycle the ILOCK. If that happens, we
can pass a stale icur to xfs_bmapi_reserve_delalloc() and it all
goes downhill from there.

Back to Darrick now:

So.  Fix this by moving the dqattach_locked call up before we take the
ILOCK, like all the other callers in that file.

Fixes: a526c85c2236 ("xfs: move xfs_file_iomap_begin_delay around") # goes further back than this
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1bdd7afc1010..ab5512c0bcf7 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -968,6 +968,10 @@ xfs_buffered_write_iomap_begin(
 
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
 
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return error;
+
 	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
 	if (error)
 		return error;
@@ -1071,10 +1075,6 @@ xfs_buffered_write_iomap_begin(
 			allocfork = XFS_COW_FORK;
 	}
 
-	error = xfs_qm_dqattach_locked(ip, false);
-	if (error)
-		goto out_unlock;
-
 	if (eof && offset + count > XFS_ISIZE(ip)) {
 		/*
 		 * Determine the initial size of the preallocation.
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

