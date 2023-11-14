Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA5BC07545
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 23:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjKNXqL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 18:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbjKNXqK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2023 18:46:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1286DF
        for <linux-xfs@vger.kernel.org>; Tue, 14 Nov 2023 15:46:07 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58EECC433CD
        for <linux-xfs@vger.kernel.org>; Tue, 14 Nov 2023 23:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700005567;
        bh=XZJWaBK0GAHndcRqtr+cgd/d7FTEC7bWlY/r7oh1JRM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rGo5nRNzQlvUoodkRlbQM5grIJBCkvWl3PNV02hReN+EGRaYmeNoSmU5QLt5TLzfh
         EvGIqn57oiznCdYJwmv1B1y/Zzf6smsAhOosRUtGp29b//sTK2n//N/N4I0G7j1DQr
         SG9kr7rnJLjMr9A3iDWTaHsH7aWg44HxZsi4f229Z/BO1d8rgjjKLjWQhLpvscRv/e
         SvVd21Xddi7KNOTpUGhsDym5cyxoivSgLnHKu3VtQi7GCL9vhanvatQOwwVe3i2tTK
         ykjqBM7J8g55c7UIIoQFShBI1Nmmf+i+7LOiBaPiqk/NIDksv1LFlMcZR0WOcw8QCR
         HYHavXsq88D0w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 46E30C53BD5; Tue, 14 Nov 2023 23:46:07 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Tue, 14 Nov 2023 23:46:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: djwong@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217769-201763-5gEVnJRFUZ@https.bugzilla.kernel.org/>
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

--- Comment #18 from Darrick J. Wong (djwong@kernel.org) ---
On Tue, Nov 14, 2023 at 03:57:06PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217769
>=20
> Grant Millar (grant@cylo.net) changed:
>=20
>            What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>                  CC|                            |grant@cylo.net
>=20
> --- Comment #17 from Grant Millar (grant@cylo.net) ---
> We're experiencing the same bug following a data migration to new servers.
>=20
> The servers are all running a fresh install of Debian 12 with brand new
> hardware.
>=20
> So far in the past 3 days we've had 2 mounts fail with:
>=20
> [28797.357684] XFS (sdn): Internal error xfs_trans_cancel at line 1097 of
> file
> fs/xfs/xfs_trans.c.  Caller xfs_rename+0x61a/0xea0 [xfs]
> [28797.488475] XFS (sdn): Corruption of in-memory data (0x8) detected at
> xfs_trans_cancel+0x146/0x150 [xfs] (fs/xfs/xfs_trans.c:1098).  Shutting d=
own
> filesystem.
> [28797.488595] XFS (sdn): Please unmount the filesystem and rectify the
> problem(s)
>=20
> Both occurred in the same function on separate servers:
> xfs_rename+0x61a/0xea0
>=20
> Neither mounts are the root filesystem.

This should be fixed in 6.6, could you try that and report back?

(See "xfs: reload entire unlinked bucket lists")

--D

>=20
> versionnum [0xbcf5+0x18a] =3D
>
> V5,NLINK,DIRV2,ATTR,QUOTA,ALIGN,LOGV2,EXTFLG,SECTOR,MOREBITS,ATTR2,LAZYSB=
COUNT,PROJID32BIT,CRC,FTYPE,FINOBT,SPARSE_INODES,REFLINK,INOBTCNT,BIGTIME
>=20
> meta-data=3D/dev/sdk               isize=3D512    agcount=3D17, agsize=3D=
268435455
> blks
>          =3D                       sectsz=3D4096  attr=3D2, projid32bit=
=3D1
>          =3D                       crc=3D1        finobt=3D1, sparse=3D1,=
 rmapbt=3D0
>          =3D                       reflink=3D1    bigtime=3D1 inobtcount=
=3D1
>          nrext64=3D0
> data     =3D                       bsize=3D4096   blocks=3D4394582016, im=
axpct=3D50
>          =3D                       sunit=3D0      swidth=3D0 blks
> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
> log      =3Dinternal log           bsize=3D4096   blocks=3D521728, versio=
n=3D2
>          =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-co=
unt=3D1
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
>=20
> Please let me know if I can provide more information.
>=20
> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are watching the assignee of the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
