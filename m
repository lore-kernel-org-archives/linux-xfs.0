Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0DBC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbjKNP5K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjKNP5K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2023 10:57:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9160F12F
        for <linux-xfs@vger.kernel.org>; Tue, 14 Nov 2023 07:57:07 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C80FC43395
        for <linux-xfs@vger.kernel.org>; Tue, 14 Nov 2023 15:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699977427;
        bh=cXSlmKWy9PtSZN2teGGG7G3IJbU2xf38XfPYK+LEod8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Q2fe01Lk5uW/NBSlwF2Ps9avKWj7ohaj1Cmz8+e0EALl4JFrFziaaDUWm3HDPYVJw
         GEn5HvOlFMBwq7qz83DASqwWtDxF343Jpofig+aTnsz8us2EMdA3DNPJBFczPS4fSx
         meZd61EDAGqT40vsy6Vlw4UjuvEmg1BxinnKqoMt15pQ6koT0NSFgi42Mluok58ZXH
         UTf3LHXceuVsQSU+NF7cPOoLsk+zdaxbjUwQ+QZKgUuygU8qPE7H6IlRPcgiIHtxLl
         m19c8tVqd5AtzIzggEkLAyv02x3wybGgIfNf0QXrP9h+adpAsDsEiu1Z7gQOUUrQIW
         +UUHdoUERQMxA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1A30FC53BD4; Tue, 14 Nov 2023 15:57:07 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Tue, 14 Nov 2023 15:57:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: grant@cylo.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217769-201763-cky9OQi6cj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217769-201763@https.bugzilla.kernel.org/>
References: <bug-217769-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217769

Grant Millar (grant@cylo.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |grant@cylo.net

--- Comment #17 from Grant Millar (grant@cylo.net) ---
We're experiencing the same bug following a data migration to new servers.

The servers are all running a fresh install of Debian 12 with brand new
hardware.

So far in the past 3 days we've had 2 mounts fail with:

[28797.357684] XFS (sdn): Internal error xfs_trans_cancel at line 1097 of f=
ile
fs/xfs/xfs_trans.c.  Caller xfs_rename+0x61a/0xea0 [xfs]
[28797.488475] XFS (sdn): Corruption of in-memory data (0x8) detected at
xfs_trans_cancel+0x146/0x150 [xfs] (fs/xfs/xfs_trans.c:1098).  Shutting down
filesystem.
[28797.488595] XFS (sdn): Please unmount the filesystem and rectify the
problem(s)

Both occurred in the same function on separate servers: xfs_rename+0x61a/0x=
ea0

Neither mounts are the root filesystem.

versionnum [0xbcf5+0x18a] =3D
V5,NLINK,DIRV2,ATTR,QUOTA,ALIGN,LOGV2,EXTFLG,SECTOR,MOREBITS,ATTR2,LAZYSBCO=
UNT,PROJID32BIT,CRC,FTYPE,FINOBT,SPARSE_INODES,REFLINK,INOBTCNT,BIGTIME

meta-data=3D/dev/sdk               isize=3D512    agcount=3D17, agsize=3D26=
8435455 blks
         =3D                       sectsz=3D4096  attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D0
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D=
1 nrext64=3D0
data     =3D                       bsize=3D4096   blocks=3D4394582016, imax=
pct=3D50
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D521728, version=
=3D2
         =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

Please let me know if I can provide more information.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
