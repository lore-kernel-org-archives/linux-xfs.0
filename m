Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A571B3B47EE
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 23:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786403178; cv=none; b=IKdwYbulpXlrflmYTHfZrALHFvmCgiigSDOAoban/tbdGA1vPghF8vkxCgpQEgpwfSDb+KgzP76zM+SsLjLbMWNpJ6dyuiQ0ttr5JUrpRQiHKDFXI7o72k/0J3V5NJhy8i0Rq7pr9WO/6ytgfFSs9oqJYEGXaLqOKQSu5F6I+EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786403178; c=relaxed/simple;
	bh=kf7VqWSdxbfDgBwP6U8abX+Emf6uFjHmvlQvz0R9ONs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OfExglRY1VqlHCwAZEFCOhW5DsiuQvdhfhU7gVHKhTedWTxwms69pbMR9hL9MIMjZDmvSo65qO1w85PM1QYxDAjyhqO8iouMxSWWcYpiohafitbzJeRw96+t6scnpoS/ia8d+42c6Rwd926KCqEiNlOVNuAu/D4/WP8n83cORTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=O6BjZk7S; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="O6BjZk7S"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-977b2fcfdedso62037241.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 16:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786403175; x=1787007975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kMub5jaAJodw8w8Jw0r/v+VFIH+A+JBmuh8oZqGypB4=;
        b=O6BjZk7SIwtCLdEwtTkPBrinuiuF1aXZRh/ead6eSZZ/49y7Ebu+wm70tFW37lvIVD
         2G9uG63J1sAjPdWwBPHlJBwl0m8qjdFnruAzm60jsqzT3eKkMxwqQHwNUHnhe1AlynLs
         QUWHHWCdRHko2s7uq3k+bzOgksNg987e18uz+XByCoX9k8Ustog0kDAj1kABxO0sOPpI
         4fZPBlNBsjIbQ4aBoDiFkUOcUPaxz8thgGGbg/40LsnuOu5vveNflUPH7O7fTJuG84CT
         8NLr5C9OVZeZXxezJOK0Mo0VIb2GppYY31EHtfdVU90iaiOzOsZhpAobLxxKm34KRWo9
         drkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786403175; x=1787007975;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kMub5jaAJodw8w8Jw0r/v+VFIH+A+JBmuh8oZqGypB4=;
        b=qYrhjH6GmgKAT7epeqXEIh7dHwCBuKYike0XtXZ/aBpHtHg0oqhKuK6BLVDJeyNjps
         rGMYOzFDm+nLE14p8SVHiIIn/fy7RCr3gTxS6tOGeb0H+tPE0HKPNBXcCdFuNZjNciOZ
         e43JFO8VYKg/gGLiORnqqV4wHKPTLM3zFU2okmTlt8P9IsEUrl0aDyU5x4Be46h37fpP
         qk3d85qRvg0sECBdofcuUDOcAn3EtQ0HZS3z4VVmCU/7vlYpa6a3V/jJNEtVdrAvfF9r
         zl6E7pWZG1cFvgWYu2MvRlj1cqNrYVWScA10O4uykfxokI8rxcgnMbtgMlNMZ8b2/imu
         nJfA==
X-Forwarded-Encrypted: i=1; AHgh+RonDbTGn9rHw1K91yR0BvfXUNZWwo38mewMT7+xAg3I5kWpfIpomFfcLCe2+myrDzkyBuMVa+Yej5A=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl6/zgqQpckKCnXvxXyHuM5uXMLtOFJvEzhAGPhk4qfxqXGkV3
	yzYW4DxUOnE1p6jmNag4nEoHxWlFOH336d2ahJXuOq4/58RcUT/YcYBhqpgdwVs2QPZgeDWBMJ0
	pHcXseJ4=
X-Gm-Gg: AR+sD13c/Q2SuJuaXEgPpgwuY7ULJfMCvfzh96buL+fk//Cte+xssrJ06mMLa7RtcP0
	nwnenq8j4e97NS/pdymBwcsP12e5JAwzb4O+slUOA5wh8C1C0nJ7TnmpfSOfS0sNspIDPzid9Ht
	9T1eV3MShJQozcD3AUDN/pZsMSIiAJ9JickKABTdCWtQF6bLInWzz2s0gmOgsFigMOOr6iZviWD
	iGhALlKpL5ITWcnAIp/+/iy54hiP1mRIUviXA7kKcobsFBwBF8vtvN/A5F+paXAg4tr7LwBfO11
	OOHPAZ2gZf73fcxw5IbwmmRcuBzZLsI4ec4WBHf6EVDNkelF2QmFDKT0OJbAhyIfwxZzqOG/8ci
	0AAnNDRAlTL89/m7LtpgtLL2prfmZeLJNTCueg7lYh6tCAQEvPPOsEg9KhUE1hiVipNGu7LMPK1
	OYTK8HFH7j3ABR/au7/oUhqseljtREpVVM2Jqz7zsVu12YuxMKfzCfYAk=
X-Received: by 2002:a05:6102:d8a:b0:6c1:6ef9:db9d with SMTP id ada2fe7eead31-760eab487cemr6109089137.3.1786403175316;
        Mon, 10 Aug 2026 16:06:15 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-979f303b72bsm3928686241.8.2026.08.10.16.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 16:06:14 -0700 (PDT)
Sender: Javier Tia <j.tia@peridio.com>
From: Javier Tia <javier@peridio.com>
X-Google-Original-From: Javier Tia <floss@jetm.me>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <achender@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/6] xfs: fix filesystem shutdown from parent pointer reservation underflow
Date: Mon, 10 Aug 2026 17:06:12 -0600
Message-ID: <20260810230611.2859909-8-floss@jetm.me>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9954; i=floss@jetm.me; h=from:subject; bh=kf7VqWSdxbfDgBwP6U8abX+Emf6uFjHmvlQvz0R9ONs=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqelljl0NiWyC8yqOS7ASxlu8zzCPdCiMvDL03E +F2TJ1UXL6JAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCanpZYwAKCRC17sMLqGd3 H604DAC72y2x8yQLvKAFAuitCQ0VT7wKl+J6rVimKVcOS29xTexxI+hp1ShCurmETaePTKSXU2n yQ6bUukRaOiqwCu2mAGbn889eo5IPw7KHhkooTGyxIkJyfgdGjE0Hep3J7Pi7nVH1RyBBb/zk9K vWaaUcwS/GIKycwN4e8TU9ux69d4Kg5hxabMyyzp9RX639IFKMtDpGZKoKbKRlxnj+8h0URnWFG F/69S9bavWj0nVq+38KvTZer1hKjj5OU1eIUBLJJ68a6HsqhrU5+8ICPtlCRI6NyzD3tu94TzTg a0OIux5qRhzmR9gyyzsLpzUOa2tSoL2w3uyBj6jocw4RXaPGIHbSj8PfF+QFSk6dMXO038VjgSA 3L+mf4hgdNogd6gfg0AeWl+h1shAnrypkDpyVW5Wv1aZndm/yQHMS1/qteQa93ZoTNP/9Y6yIBB f0FNNS7a7HN0xf9z6D819QEmcC48yNGZO+y4vCL91p3twS5W2HsjzD1AGxqTrmp5KDP38=
X-Developer-Key: i=floss@jetm.me; a=openpgp; fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
Content-Transfer-Encoding: 8bit

The first parent pointer update that has to grow the attribute fork
twice in one operation can shut the filesystem down with

    XFS (loop0): Corruption of in-memory data (0x8) detected at
    xfs_defer_finish_noroll+0x29a/0x4b0 (fs/xfs/libxfs/xfs_defer.c:721)

The message names in-core corruption, but nothing is corrupt.  The
deferred work that failed is a block allocation that returned a bare
-ENOSPC on a filesystem with hundreds of gigabytes free, and
xfs_defer_finish_noroll() treats any non-EAGAIN error as fatal.

xfs_parent_da_args_init() builds an xfs_da_args from a zeroed
xfs_parent_args (kmem_cache_zalloc), so a runtime parent pointer update
reaches the block allocator with args->total == 0.  That field is not a
constant.  xfs_da_grow_inode_int() treats it as a running remainder and
subtracts from it, and xfs_da_args.total is an xfs_extlen_t (uint32_t),
so subtracting the first block the attr fork gains wraps it to
0xffffffff.  It reaches the minimum-free-space test in
xfs_alloc_space_available() as (int)max(args->total, alloc_len), where
the cast turns ~0U back into -1 and the test can no longer fail.
Execution falls into the clamp below it, args->maxlen = available, and
when available is 0 the result is maxlen == 0.  Both ASSERTs guarding
that clamp are compiled out without CONFIG_XFS_DEBUG.
xfs_alloc_vextent_check_args() then rejects minlen(1) > maxlen(0) with
-ENOSPC, and the filesystem goes down.

The log recovery path already does this correctly, which is the
clearest statement that the runtime path is wrong.
xfs_attri_recover_work() does args->total = xfs_attr_calc_size(args,
&local) for PPTR_SET and PPTR_REPLACE, so replaying a parent pointer
insert from the log runs with a correct total while performing the same
insert at runtime runs with zero.  Patch 5 sets the field the same way,
in the add and replace paths that can grow the fork.

One detail is worth stating because it is not obvious from the diff.
In the captured trace total changes from 0xffffffff to 1 one step
before the failure: xfs_bmap_btalloc_low_space() sets args->total =
ap->minlen before its last-ditch sweep of every AG.  Nothing resets
args->maxlen, so the clamped zero survives into check_args.  The
fallback that exists to rescue an over-large reservation cannot rescue a
clamped maxlen.

Two conditions have to coincide, which is why the bug looks rare.  The
first is two xfs_da_grow_inode() calls sharing one xfs_da_args; that
happens whenever a leaf-to-node conversion is followed by a node split
in the same operation, which is ordinary rather than a corner case.
The second is an AG at the later growth whose available block count,
pagf_freeblks + agflcount - reservation - min_free - minleft, is exactly
zero.  At available == -1 the same code takes a different path and at
available >= 1 the allocation succeeds; only the exact-zero coincidence
is fatal.  The underflow itself is common and usually harmless.  In one
capture an earlier link() carried total 4294967295 with maxlen 1 and
allocated successfully a few hundred milliseconds before the fatal one.

I reproduced this deterministically on the same machine, same script,
only the kernel differing.  Unpatched, the filesystem shuts down within
0.2 s of link activity and eight "total 4294967295" allocator events are
recorded; patched, 400 steps and 25,024 links complete clean with zero
such events.  The attr fork counter goes 0 -> 4294967295 unpatched and
25 -> 24 patched, while the data fork counter goes 78 -> 77 in both:
that last row is the control, the same subtraction happening correctly
and unchanged by the patch.  A second machine on different hardware, on
its own unpatched kernel, produced a byte-identical event distribution.
The patched kernel has since carried ordinary Yocto build load for eight
days with no filesystem shutdown; before the patch the same machine died
within five to seven minutes once the triggering conditions coincided.

I ran ./check -g parent -g attr on the patched kernel, 53 of 55 passing.
The two failures are environmental, a setfattr deprecation warning newer
than the golden output and an O_TMPFILE EOVERFLOW in the harness, and
neither mentions parent pointers, allocation or ENOSPC.  I have not run
the same tests against an unpatched kernel, so I am not claiming those
two are unrelated to this series.  A dedicated regression test is posted
separately to fstests as tests/xfs/842; it fails on an unpatched kernel
and passes on a patched one.

The workload that first hit this is a Yocto/BitBake do_package run, which
hardlinks one file into many package staging directories so that every
link() writes another parent pointer, on a 1.9 TB filesystem with 862
GiB free.

Related work is in flight.  On 2026-07-29 Dave Chinner posted an RFC,
"XFS: Atomic multi-extent operations via rolling transactions"
(20260729100629.1943710-1-dgc@kernel.org), which is not merged.  Its
patch 18, "xfs: add block reservation renewal to xfs_defer_finish",
touches fs/xfs/libxfs/xfs_defer.c, which patches 1 to 3 here also
modify; the hunks are unrelated, so if it lands first this series needs
a rebase rather than a redesign.  The overlap is also conceptual, and
worth naming because a reviewer will see it anyway: that RFC addresses a
transaction reservation carried forward by xfs_trans_dup() and depleted
over successive rolls even though each iteration needs the same amount.
This bug is the same shape one level down, with xfs_da_args.total
depleting across the xfs_da_grow_inode_int() calls that span one of
those rolls.  The two are independent, and patch 5 stands whether or not
the RFC is merged.

Changes since v2:
- Patch 3: shortened the commit message and reworded the shutdown log
  line to name the operation ("deferred agfl_free work failed ...", or
  "deferred chain work failed ..." for the roll and create-intents
  paths) (Darrick J. Wong).
- Collected Reviewed-by from Darrick J. Wong on patches 5 and 6.

Changes since v1:
- Patch 5: set args->total only in the add and replace paths rather than
  unconditionally in the shared init, so removals and lookups leave it
  alone, matching the xfs_attri_recover_work() switch (Darrick J. Wong).
- New patch 6: assert in xfs_da_grow_inode_int() that the remaining
  reservation still covers each fork growth, so this underflow class
  trips in debug builds instead of wrapping silently (suggested by
  Darrick J. Wong).
- Patch 5: added Cc: stable # v6.10 (Darrick J. Wong).
- Trimmed the patch 1, 4 and 5 commit messages (Darrick J. Wong).
- Collected Reviewed-by from Darrick J. Wong on patches 1, 2 and 4.

Link to v2:
https://lore.kernel.org/linux-xfs/20260810164312.960721-8-floss@jetm.me/
Link to v1:
https://lore.kernel.org/linux-xfs/20260808234016.246054-7-floss@jetm.me/

Only patch 5 is the fix.  The other five are independent and a
maintainer can take them separately:

  1. xfs: initialise error in xfs_defer_finish_one() is a separate bug.
     error is used uninitialised on the item-less barrier path reachable
     via xfs_defer_add_barrier() under CONFIG_XFS_ONLINE_REPAIR, so a
     successful barrier can be reported as corruption depending on stack
     contents.  It carries a Fixes: tag and Cc: stable.
  2. xfs: give the deferred barrier op type a name fills the only
     xfs_defer_op_type with a NULL .name.
  3. xfs: report the error that made deferred work shut down the fs moves
     the tracepoint ahead of the shutdown and logs the errno and the
     remaining reservation, so the failure is diagnosable from the log
     alone.  This is the patch that would have saved most of this
     investigation.
  4. xfs: correct the parent pointer space reservation comment.
  6. xfs: assert the reservation covers each da fork growth is the
     debug-build guard suggested during v1 review.

For anyone who wants to watch it happen.  Root required; it creates and
destroys a 512 MiB loop filesystem under /var/tmp.  If fs.xfs.panic_mask
is non-zero the shutdown becomes a BUG() and the machine reboots instead
of reporting, so lower it for the run.

    truncate -s 512M /var/tmp/pptr.img
    mkfs.xfs -q -f -m crc=1 -n parent=1 -d agcount=2 /var/tmp/pptr.img
    mkdir -p /mnt/pptr && mount -o loop /var/tmp/pptr.img /mnt/pptr

    mkdir /mnt/pptr/d
    dd if=/dev/urandom of=/mnt/pptr/src bs=4096 count=1 status=none

    # Fill to within ~460 free blocks, then walk that margin down one
    # block per step, hardlinking with 240-byte names so the attr fork
    # leaves shortform quickly.
    free=$(stat -f -c '%a' /mnt/pptr)
    fallocate -l $(( (free - 464) * 4096 )) /mnt/pptr/ballast
    name=$(printf 'x%.0s' $(seq 1 240))

    for step in $(seq 0 400); do
        fallocate --punch-hole --keep-size -o $((step * 4096)) -l 4096 \
            /mnt/pptr/ballast
        for i in $(seq 1 64); do
            ln /mnt/pptr/src "/mnt/pptr/d/${step}_${i}_$name" \
                2>/dev/null || break
        done
        rm -f /mnt/pptr/d/* 2>/dev/null
        touch /mnt/pptr/.alive 2>/dev/null \
            || { echo "shut down at step $step"; break; }
    done

Javier Tia (6):
  xfs: initialise error in xfs_defer_finish_one()
  xfs: give the deferred barrier op type a name
  xfs: report the error that made deferred work shut down the fs
  xfs: correct the parent pointer space reservation comment
  xfs: initialise args->total for parent pointer updates
  xfs: assert the reservation covers each da fork growth

 fs/xfs/libxfs/xfs_da_btree.c    |  1 +
 fs/xfs/libxfs/xfs_defer.c       | 18 ++++++++++++++++--
 fs/xfs/libxfs/xfs_parent.c      | 12 ++++++++++--
 fs/xfs/libxfs/xfs_trans_space.c | 19 +++++++++++++++++--
 4 files changed, 44 insertions(+), 6 deletions(-)


base-commit: 155b42bec9cbb6b8cdc47dd9bd09503a81fbe493
-- 
Javier Tia

