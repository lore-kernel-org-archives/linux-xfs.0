Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8857C2BB41
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 08:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiHPIvt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 04:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbiHPIvS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 04:51:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AD6B5A71
        for <linux-xfs@vger.kernel.org>; Mon, 15 Aug 2022 23:56:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7042B81623
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 06:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AE47C43141
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 06:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660632986;
        bh=6Y0iD89Rtxuku92D6SJFlF6RKSZcva/SAIf2W+9+Gec=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hAHW+Gyc3PYzyvzDqSQLSXxzYEtTREqAhMHVU2s8v3CAi1fyocQFh8VToTu6O0Cis
         NrUfb+Lcm1IpwvDEdg1BFHG0+Sp9AVUE/WW5Om+Lcfa+Q9ujda+8U6kBcHWIIdSH7v
         8zUl65W3huGSf0jbAdmhuDYg8Q/+SRPHLqwHmnN9yktdtK7MzhAT8IqvQbT+7PZzKX
         6g9MmAoWtUfDoMijnzFLZuqzfj/KDB3JdoECXQnXrXxdJpylFNvgmWIiaSxr3E/+HX
         qMMsD4sy9JJjtNeboUzaHy7ZasoxjkuovtwDfDJVrU+cAZ23KY0Xx8ynUc1ekUNqt9
         yjNChh7/t8Z3g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 77C42C433E4; Tue, 16 Aug 2022 06:56:26 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216343] XFS: no space left in xlog cause system hang
Date:   Tue, 16 Aug 2022 06:56:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zhoukete@126.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216343-201763-5uNVb4ysij@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216343-201763@https.bugzilla.kernel.org/>
References: <bug-216343-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216343

--- Comment #3 from zhoukete@126.com ---
(In reply to Amir Goldstein from comment #2)
>=20
> I don't think so.
> I think this buffer write is in-flight.

But how to explain the XFS_DONE flag is set.Is XFS_DONE flag means the io h=
ad
been done=EF=BC=9F


>=20
> Not sure if space cannot be released or just takes a lot of time.

crash> ps -m 2006840
[0 14:35:38.418] [UN]  PID: 2006840  TASK: ffff035f80de8f80  CPU: 51  COMMA=
ND:
"onestor-peon"=20

pid 2006840 hang 14 hours. It is waiting for the xfs buf io finish.
So I  think it is =E2=80=98cannot be released=E2=80=99 not take a lot of ti=
me.

crash> bt 2006840
PID: 2006840  TASK: ffff035f80de8f80  CPU: 51  COMMAND: "onestor-peon"
 #0 [ffff80002a873580] __switch_to at ffff800010016dec
 #1 [ffff80002a8735b0] __schedule at ffff800010a99d60
 #2 [ffff80002a873650] schedule at ffff800010a9a1cc
 #3 [ffff80002a873670] schedule_timeout at ffff800010a9ee00
 #4 [ffff80002a873710] __down at ffff800010a9d2ec
 #5 [ffff80002a8737a0] down at ffff8000100ea30c
 #6 [ffff80002a8737c0] xfs_buf_lock at ffff800008f5bd4c [xfs]
 #7 [ffff80002a8737f0] xfs_buf_find at ffff800008f5c3f0 [xfs]
 #8 [ffff80002a8738b0] xfs_buf_get_map at ffff800008f5c7d4 [xfs]
 #9 [ffff80002a873930] xfs_buf_read_map at ffff800008f5cf10 [xfs]
#10 [ffff80002a8739a0] xfs_trans_read_buf_map at ffff800008f9c198 [xfs]
#11 [ffff80002a873a20] xfs_da_read_buf at ffff800008f2b51c [xfs]
#12 [ffff80002a873aa0] xfs_da3_node_read at ffff800008f2b5a4 [xfs]
#13 [ffff80002a873ac0] xfs_da3_node_lookup_int at ffff800008f2c778 [xfs]
#14 [ffff80002a873b60] xfs_dir2_node_removename at ffff800008f38964 [xfs]
#15 [ffff80002a873c30] xfs_dir_removename at ffff800008f2fc6c [xfs]
#16 [ffff80002a873c90] xfs_remove at ffff800008f77f70 [xfs]
#17 [ffff80002a873d00] xfs_vn_unlink at ffff800008f72744 [xfs]
#18 [ffff80002a873d50] vfs_unlink at ffff8000103264e8
#19 [ffff80002a873d90] do_unlinkat at ffff80001032ad44
#20 [ffff80002a873e20] __arm64_sys_unlinkat at ffff80001032ae30=20

> There are several AIL/CIL improvements in upstream kernel and
> none of them are going to land in 5.10.y.
> The reported kernel version 5.10.38 has almost no upstream fixes
> at all, but I don't think that any of the fixes in 5.10.y are relevant for
> this case anyway.
>=20
> If this hang happens often with your workload, I suggest using
> a newer kernel and/or formatting xfs with a larger log to meet
> the demands of your workload.
>=20

It is just happens only once.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
