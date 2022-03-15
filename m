Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25AD5C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 08:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345925AbiCOIcD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 04:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345943AbiCOIcB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 04:32:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9FA4C42E
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 01:30:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5CFC614AD
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 08:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 330F9C340F7
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 08:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647333045;
        bh=7MeivwngdvQPa6497fKrkjpdH+KEanodRxsoYThAYzE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jEXfw3oEPqMUUIctC+/m4n/QMVTgPuoJw8MMybq0BpyWNGkXEwjNKyTqa0vlON+nK
         tIYNSHkdSgoj5Tz6QVLYWUeRW5UKxQ8lLxfDJ11u2CiETiHBf6xJd5SlpDsxuQWc37
         W6XZu4sDfFEaCKAHCuAdU1N3G4La3kFhnWlqAe7Okzx5zqWfBRCMR8w3TnRCT3YQ/R
         4/J3e8LZnEGlBnKBne1RXTGgiJeigq3Rro0RD1ri/c1Dx1XKRBxiKvuA/Wp2/luQM/
         5BDhJgyrLbC1cdRtK7Wj9UWTR1ZBMiXIC1IjwQEP/WDOg+2kkKrrDnKepBeZxjoV3X
         xp1bb/LwN1fKw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 165F5CC13AF; Tue, 15 Mar 2022 08:30:45 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215687] chown behavior on XFS is changed
Date:   Tue, 15 Mar 2022 08:30:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215687-201763-kbkLH78Owo@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215687-201763@https.bugzilla.kernel.org/>
References: <bug-215687-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215687

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
Oh, looks like the failures come from below testing:

expect 0 mkdir ${n0} 0755
expect 0 chown ${n0} 65534 65533
expect 0 chmod ${n0} 06555
expect 06555 lstat ${n0} mode
expect 0 -u 65534 -g 65533,65532 chown ${n0} 65534 65532
case "${os}:${fs}" in
Linux:glusterfs)
        expect "0555,65534,65532|06555,65534,65532" lstat ${n0} mode,uid,gid
        ;;
Linux:xfs)
        expect 0555,65534,65532 lstat ${n0} mode,uid,gid
        ;;
Linux:*)
        expect 06555,65534,65532 lstat ${n0} mode,uid,gid
        ;;
*)
        expect 0555,65534,65532 lstat ${n0} mode,uid,gid
        ;;
esac

If a directory has S_ISUID(04000) and S_ISGID(02000) permission bits, XFS w=
ill
lost these 2 bits after chown the group of the directory. But now it keeps
these two bits:

# mkdir dir
# chown 65534:65533 dir
# chmod 06555 dir
# ls -ld dir
dr-sr-sr-x. 2 nobody 65533 6 Mar 15 16:26 dir
# chown 65534:65532 dir
# ls -ld dir
dr-sr-sr-x. 2 nobody 65532 6 Mar 15 16:26 dir


Hmm... please help to make sure if this's an expected behavior change, or an
unexpected regression? Thanks.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
