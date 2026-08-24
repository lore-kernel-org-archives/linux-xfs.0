Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2663DDDDD
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 05:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787550621; cv=none; b=Nigig67kpeqFc0Ka9Qg7e3KAtWlX2GDCWF0i1z5Rm8yFRkeUL+Vksv8pWRBIaCCpsvwdn4FJk137eyj1akLIcEP5hNEXv2QF6d8x0GJQJGvuYaOG+xyHrS5fs/2UZC0R/g5775uoY8t0Ao6h68NNCXegln//AnSGDAvf//Mnxo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787550621; c=relaxed/simple;
	bh=F4dt3a3hTy4WPr/Nf6lZBE8AUGZVPCaEpX8/jKyuy4Y=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=E1G6R71QBt/NX6NANwCjoQwI4uEwpxtR4DbOlXITickSZe4xFZeW3JCli2CnJiTrEVTmba2Mwxq8cGKYNGPMnVS5oDzaJNxeg3Oof61td8h65LWrB2E1Lr62pEcT4FuFuW6HALqKdBZ/dACtcXx2Ggvpxcsaby3bmVWAp3H8jss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fwiijHFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fwiijHFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD4AFC2BCFC
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 05:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787550620;
	bh=F4dt3a3hTy4WPr/Nf6lZBE8AUGZVPCaEpX8/jKyuy4Y=;
	h=From:To:Subject:Date:From;
	b=fwiijHFJNxxRmscJ/NNRKHLVsppmcK5sOqwlB7eULqVakmCkGgvFSzZZzfa1q98qi
	 Hnq+HB+vGYC7TkgRQMa5VYxKp88SoXca+kGs/ZYcuxQlABd10wRuM9EpgpanOFyBma
	 dHAb3gqRAZMvjkn7o6dhZp5vFExn4zklGYQktXsMzhG4P9cdbZyQvM1V/QG8IKZe7Z
	 +ddEmLMzNgjzavkCk3t7xvxowCrYNP5sWTWSWrC9VX7YVMtiqwXcdwCNSeA48RYyBR
	 8/Kxoie0evw+Ng4ktv6SNgTU4uGiE9BFY0a0R2X8buVMILAXl4xggA9IofBGNnIL1g
	 SxWVFGryzKW8A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A4868C53BC5; Mon, 24 Aug 2026 05:50:20 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 221915] New: XFS: oversized xattr transaction causes unkillable
 hang in xlog_grant_head_check
Date: Mon, 24 Aug 2026 05:50:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: 2855020996@qq.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-221915-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D221915

            Bug ID: 221915
           Summary: XFS: oversized xattr transaction causes unkillable
                    hang in xlog_grant_head_check
           Product: File System
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: 2855020996@qq.com
        Regression: No

Created attachment 310718
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D310718&action=3Dedit
submit

Linux mainline 7.2-rc7 still contains a reproducible XFS hang in the log gr=
ant
reservation path.

While fuzzing current mainline with syzkaller, I reproduced an old class of
hang previously reported by syzbot as:

```text
INFO: task hung in xlog_grant_head_check
```

The issue can be reduced to mounting a crafted XFS filesystem image with a
small log and issuing a single large `security.ima` xattr operation.

The minimized syzkaller sequence is approximately:

```text
syz_mount_image$xfs(..., "./file0", ..., image)

setxattr$security_ima("./file0", "security.ima",
                     {sha1, ...}, 0xfffe, 0)
```

The task then becomes permanently blocked:

```text
INFO: task syz.0.17:10462 blocked for more than 143 seconds.

Call Trace:
 __schedule+0x12e4/0x64e0
 schedule+0xe7/0x2d0
 xlog_grant_head_wait+0x13f/0xd00 fs/xfs/xfs_log.c:217
 xlog_grant_head_check+0x48f/0x4e0 fs/xfs/xfs_log.c:279
 xfs_log_reserve+0x2d2/0x850 fs/xfs/xfs_log.c:387
 xfs_trans_reserve fs/xfs/trans.c:174 [inline]
 xfs_trans_alloc+0x3c5/0xd40 fs/xfs/xfs_trans.c:256
 xfs_trans_alloc_inode+0x198/0x3b0 fs/xfs/xfs_trans.c:1080
 xfs_attr_set+0x40b/0x10f0 fs/xfs/libxfs/xfs_attr.c:1184
 xfs_attr_change+0x379/0x500 fs/xfs/xfs_xattr.c:128
 ...
 __x64_sys_setxattr+0xc6/0x140 fs/xattr.c:764
```

## Trigger

The reproducer uses:

```text
- a crafted XFS v5 filesystem image
- a relatively small XFS log
- one approximately 64 KB security.ima xattr value
```

The large xattr causes XFS to request a transaction reservation that appear=
s to
be larger than the amount of log space that can ever become available on the
crafted filesystem.

The task enters:

```text
xfs_log_reserve()
  -> xlog_grant_head_check()
     -> xlog_grant_head_wait()
```

and does not return.

The wait does not appear to resolve even after log tail progress, and the
blocked task is effectively unkillable while waiting in D state.

Eventually the kernel reports the task through the hung-task detector. With
`hung_task_panic=3D1`, this can also result in a kernel panic.

## Suspected cause

My current hypothesis is that XFS can enter `xlog_grant_head_wait()` for a
transaction reservation that is impossible to satisfy.

For this crafted filesystem, the requested transaction reservation appears =
to
exceed the usable size of the XFS log.

Normally, `xlog_grant_head_wait()` waits for log tail movement to free
sufficient reservation space. However, if:

```text
requested reservation > maximum usable log space
```

then no amount of log tail pushing can ever make the reservation satisfiabl=
e.

The task therefore waits indefinitely.

This suggests that the reservation path may be missing a sanity check rejec=
ting
transactions whose requested reservation exceeds the maximum amount of log
space that can ever be granted.

Another possible fix would be for the xattr path to split sufficiently large
operations into smaller transactions.

This analysis has not yet been fully proven, but it is consistent with the
minimized reproducer and the observed permanent wait.

## Expected behavior

A userspace operation that requires a transaction larger than the filesystem
log can accommodate should fail cleanly, for example with an appropriate er=
ror
such as `-ENOSPC` or another reservation failure.

It should not result in an indefinitely blocked and unkillable task.

## Actual behavior

A single large `setxattr()` can cause the task to block indefinitely in:

```text
xlog_grant_head_wait()
```

The operation never returns, and the kernel eventually reports:

```text
INFO: task ... blocked for more than 143 seconds
```

## Reproducer

The complete syzkaller reproducer consists of the crafted XFS image and the
two-operation program described above.

```text
1. Mount crafted XFS image.
2. setxattr("security.ima", ..., size=3D0xfffe)
3. Wait for the task to become permanently blocked in
   xlog_grant_head_wait().
```

The full syzkaller reproducer, filesystem image, kernel configuration, and
console log can be attached to this report.

## Environment

```text
Kernel:
7.2.0-rc7-00232-gdcb68831eac7

Tree:
stock mainline

Filesystem:
XFS v5

Configuration:
syzkaller upstream KASAN configuration

Architecture:
x86-64
```

## Previous report

A similar syzbot report existed in 2018 under the title:

```text
INFO: task hung in xlog_grant_head_check
```

The tracker has been dormant for several years and the previous cause
analysis/bisection did not result in a confirmed fix.

The issue is still reproducible on current mainline 7.2-rc7 with a very sma=
ll
reproducer.

References:

https://lwn.net/Articles/755633/

https://lkml.org/lkml/2018/5/22/1056

Found-by: syzkaller on linux-7.2.0-rc7-00232-gdcb68831eac7

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
