Return-Path: <SRS0=7MVS=IG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15017C433E6
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 07:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0A87651FC
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 07:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbhCHHFA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 02:05:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232653AbhCHHEg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 02:04:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5B742651F6
        for <linux-xfs@vger.kernel.org>; Mon,  8 Mar 2021 07:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615187076;
        bh=z/ZXEJHH2opAk6TPYqId+Tb72P6XJrMg63N28HfdL6M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Uh+MEPnQEHh5eQn81rmTHQR/tM25OgZSULmfHUqXRkytZKRkbfs3kHa61i/liTwkK
         ttU6MYQLrTa/RZ57vGneRADkgFPnXvOAJKp1RCs9rh8vVOSlF3/CSFm0ygTekUHiGi
         hT9nL2k11pX4Edca60E72/6Tk7tgJX50w6cfMOG+XLHE+UM8OvaSXvsnYb8U88527/
         i6E4Pjfk70KBWCGnf4G8DE+aNLUh0Ti7QFBLwKBqQQCwkJ/vvHR6tD/a/PxS6dLtRY
         3mxR9zBFY8Rp0VFAdOp4XpKFN5rgNlqEcrrt2izUhkY5OlGncwXaphT8oWDemB2JS4
         miYVvY5+XPE2g==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211605] Re-mount XFS causes "attr2 mount option is deprecated"
 warning
Date:   Mon, 08 Mar 2021 07:04:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: matthias@bodenbinder.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-211605-201763-5YRPvIZ0C4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211605-201763@https.bugzilla.kernel.org/>
References: <bug-211605-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211605

matthias@bodenbinder.de changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |matthias@bodenbinder.de

--- Comment #8 from matthias@bodenbinder.de ---
I have the same issue. I am using Arch Linux too.

Even if I do not use "defaults" for xfs in /etc/fstab I still find the attr2
mount option in /proc/mounts:

fstab:
UUID=3Dxxx-xxx-xxx / xfs  rw,noatime,inode64,logbufs=3D8,logbsize=3D32k,noq=
uota 0 1

/proc/mounts:
/dev/nvme0n1p2 / xfs rw,noatime,attr2,inode64,logbufs=3D8,logbsize=3D32k,no=
quota 0
0

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
