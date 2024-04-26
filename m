Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112A538F9C
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168566; cv=none; b=NCyQURCbiP1F+M1WvaqLCBw6TwyA95u+p1hk+v/iN9nAyG8K0T1myiKiTy1MBGQGx7GSFbUxw3FION5MYy7oOnZTfRabWOmxB86UpvUKr3NqnThLaPNWWqj4S/hn3nK0ZkDp7gR4QYPYCQzzCzRpQMgfBKWq3PHwD2GFRLZ2nCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168566; c=relaxed/simple;
	bh=lKWj+A+6Geg3knTDu04Ekq7yei1wMit/JDhaUC++eTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUjpITsuXdJITfverodm0ZP1+g81diQftnzgg1oHHDTtxX9hEgQDh/W44XFHtfmKIm+ohppLqrC/V5h0RNstjgPJE82N4eyiRfwzfr4jIvfGPWsQWTu5wvZR9w3YOPhJPXx1CQ+3sgN1s6IG1uqzRya7xVaJrMBhQftbWW+26sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=amPej8Ph; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="amPej8Ph"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1e5c7d087e1so24211035ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168564; x=1714773364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rHkOjOBlJX6eTTzXowp+zeMCB89DR2w2wGeNo3xZt3k=;
        b=amPej8PhhgU77v7K2FCSfna2iWHqau+5cxq4CzisBLfHSBBAz4mS+bK5EXVduB2MeL
         O0N78OAqV22fQaixtRSGzDQyw8/rSLGW/FNPobsAyiSYSzjZ5hM58qHX0CwplmBU1zVq
         Vu71i0ctQaXnrcYhjenXs0pPCTn5jUukB0pc9h8Gt2bWCwPavrLBbDShdEAD1Rad+yiT
         ky4HTz+LKBVe3FhKWiZkwcfXE7xJT7paW/n2vEfpKSK4lE7b/JFzWBiiM2f+2g1067kk
         OBVNbaii1QhNskfaa6h8kvgbGzwAan1oW994MpO8G5QUWpJgd5BD4EQecBA1eT8RRoB5
         VQNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168564; x=1714773364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rHkOjOBlJX6eTTzXowp+zeMCB89DR2w2wGeNo3xZt3k=;
        b=AwfHTKPKT1WRIIzLjCVme723YRTDZrSczKYHrDejq3ZDvWyXFllsbo3mmnD4L4lBjQ
         6xsU+QLUj23XCswXdVLjmErg+2SoPDNSRYL32zpv1UatIj1E1Xa5RMIQJ8ePXQKLltCy
         7DMuMk0gnnlUhj5EVyVQb2GQ7guLLJjVERBeA8UDHsumZJQtZuH27RTI/KNrt5SYLKxT
         Dticw5MbefW36k5efrFBFmMZLbJue7/G3QjGfmOdwrGCUm3I86vevgwv/gw3OAcFlrqz
         rVP71OzwaXtyaco2NnlUtQERu8zcANV1E1Er0lA52UlUxpmt6biRqiv4XuGqKHrL5XBr
         9vrQ==
X-Gm-Message-State: AOJu0YxUNYmhDxR8PS45LAjDl2VfDN6TX7sHWVDO0dLMqYa9/xBSRBZJ
	lgfx2vI/kKFdYT+1fvAJIqTJ/ItrHgG6gH9SbESyi6t+ntuVP/U4DwbKFvK7
X-Google-Smtp-Source: AGHT+IEHV8nlEi6XIzLDAEGNLTVV84W33+AMe7O9xNjKiNKGQ1dk80I4BDKgsWa5rtgv+4kF8WdNjw==
X-Received: by 2002:a17:903:2342:b0:1e9:43c:d176 with SMTP id c2-20020a170903234200b001e9043cd176mr4895080plh.12.1714168564304;
        Fri, 26 Apr 2024 14:56:04 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:56:03 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 15/24] xfs: attach dquots to inode before reading data/cow fork mappings
Date: Fri, 26 Apr 2024 14:55:02 -0700
Message-ID: <20240426215512.2673806-16-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
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
2.44.0.769.g3c40516874-goog

