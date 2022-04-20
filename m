Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C260DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 23:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383286AbiDTXxY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 19:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241097AbiDTXxX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 19:53:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5AC2FE77
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 16:50:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7843B8222B
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 23:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 874F6C385AA
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 23:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650498632;
        bh=aEXcArm2YsOXsemKKFllLQ6HKV36T+Z+o92vNLFB5pw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LQdOyeOfuMNcgp2OydssdjcKqz6EWbzeqS+tc3Aw1WZhIL3fBYiCHtV7n4Pro12G1
         STH+ySZfXI/SiKw9wdk1vP7jdcacnNd/sxjN/IFbRP3WDy28+BabuFhatQpGM/MIBb
         GSL0xdoTS9AtUyk37AIeBFCnubOPcD3iCFFISltTtbVNk7lRcyyyFBJxW1c80vCCNT
         uycp+1GovpsMJT6X3tOyF061xRXg/ofrKnHqmrQxJmOOckkwdrt26Ox6OHC5mfurVL
         FG6qz7NvBD9rvPHSpr4WuTa/BfpEKyTXNKD2IQN66uP12sSscV0Nf1+pQS9fYVlJAE
         NNX3xxUahE7qg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 73562C05FD0; Wed, 20 Apr 2022 23:50:32 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215851] gcc 12.0.1 LATEST: -Wdangling-pointer= triggers
Date:   Wed, 20 Apr 2022 23:50:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215851-201763-9VJc49Zsyb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215851-201763@https.bugzilla.kernel.org/>
References: <bug-215851-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215851

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Mon, Apr 18, 2022 at 08:02:41AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215851
>=20
>             Bug ID: 215851
>            Summary: gcc 12.0.1 LATEST: -Wdangling-pointer=3D triggers
>            Product: File System
>            Version: 2.5
>     Kernel Version: 5.17.3
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: Erich.Loew@outlook.com
>         Regression: No
>=20
> Date:    20220415
> Kernel:  5.17.3
> Compiler gcc.12.0.1
> File:    linux-5.17.3/fs/xfs/libxfs/xfs_attr_remote.c
> Line:    141
> Issue:   Linux kernel compiling enables all warnings, this has consequnce=
s:
>          -Wdangling-pointer=3D triggers because assignment of an address
>          pointing
>          to something inside of the local stack=20
>          of a function/method is returned to the caller.
>          Doing such things is tricky but legal, however gcc 12.0.1 compla=
ins
>          deeply on this.
>          Mitigation: disabling with pragmas temporarily inlined the compi=
ler
>          triggered advises.
> Interesting: clang-15.0.0 does not complain.
> Remark: this occurence is reprsentative; the compiler warns at many places

The actual warning message is this:

fs/xfs/libxfs/xfs_attr_remote.c: In function =E2=80=98__xfs_attr3_rmt_read_=
verify=E2=80=99:
fs/xfs/libxfs/xfs_attr_remote.c:140:35: warning: storing the address of loc=
al
variable =E2=80=98__here=E2=80=99 in =E2=80=98*failaddr=E2=80=99 [-Wdanglin=
g-pointer=3D]
  140 |                         *failaddr =3D __this_address;
In file included from ./fs/xfs/xfs.h:22,
                 from fs/xfs/libxfs/xfs_attr_remote.c:7:
./fs/xfs/xfs_linux.h:133:46: note: =E2=80=98__here=E2=80=99 declared here
  133 | #define __this_address  ({ __label__ __here; __here: barrier();
&&__here; })
      |                                              ^~~~~~
fs/xfs/libxfs/xfs_attr_remote.c:140:37: note: in expansion of macro
=E2=80=98__this_address=E2=80=99
  140 |                         *failaddr =3D __this_address;
      |                                     ^~~~~~~~~~~~~~
./fs/xfs/xfs_linux.h:133:46: note: =E2=80=98failaddr=E2=80=99 declared here
  133 | #define __this_address  ({ __label__ __here; __here: barrier();
&&__here; })
      |                                              ^~~~~~
fs/xfs/libxfs/xfs_attr_remote.c:140:37: note: in expansion of macro
=E2=80=98__this_address=E2=80=99
  140 |                         *failaddr =3D __this_address;
      |                                     ^~~~~~~~~~~~~~

I think this is a compiler bug. __here is declared as a *label*, not
a local variable:

#define __this_address ({ __label__ __here; __here: barrier(); &&__here; })

and it is valid to return the address of a label in the code as the
address must be a constant instruction address and not a local stack
variable. If the compiler is putting *executable code* on the stack,
we've got bigger problems...

We use __this_address extensively in XFS (indeed, there
are 8 separate uses in __xfs_attr3_rmt_read_verify() and
xfs_attr3_rmt_verify() alone) and it is the same as _THIS_IP_ used
across the rest of the kernel for the same purpose. The above is the
only warning that gets generated for any of (the hundreds of) sites
that use either _THIS_IP_ or __this_address is the only warning that
gets generated like this, it points to the problem being compiler
related, not an XFS problem.

Cheers,

Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
