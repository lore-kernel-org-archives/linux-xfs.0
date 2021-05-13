Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD49C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 11:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39B86613CB
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 11:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhEMLRK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 May 2021 07:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233277AbhEMLQp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 May 2021 07:16:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 43ABD6144B
        for <linux-xfs@vger.kernel.org>; Thu, 13 May 2021 11:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620904536;
        bh=YhqjUusED+bDEgmjAV6hzvubRXIQ3ZF1D5+VUpdOoJQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mAur6tMdUUmiBmhm/4kbp/1r5oVVcoiRoSJTWfG4tvC9MgwhFitQtT6+hgU6iHJGm
         rIzOmzst9/zj74caAg8XHOCU8VFG6lyEN1qtw4vQwCGsHKukMvmD++BUfrVY1LdcPY
         7o2NrugERiYKHd/G/t9HrBKxSLwHl48nwqZ6H/mO4uAwtU77hzo6dHQTFhi2YMZlAf
         vA4rW9oT0uXtMai2JpE6CfhQwkwyi5i8OjreQOSYCeJxNOE3XiIKIq27CmNPK4ZKrH
         cqftKYre6aks4zK43GP131/quzKmUqy+dujmlK3FF+LOG54K1yoYdI3yvjOX7URCCz
         Rl3YCf0GgpcWg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211605] Re-mount XFS causes "attr2 mount option is deprecated"
 warning
Date:   Thu, 13 May 2021 11:15:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: victor03303@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-211605-201763-CRvtFdWZL9@https.bugzilla.kernel.org/>
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

victor03303 (victor03303@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |victor03303@gmail.com

--- Comment #12 from victor03303 (victor03303@gmail.com) ---
I have the same issue.

Kernel in use: 5.11.0-17-generic
O.S.: Lubuntu 21.04

fstab file:
UUID=3Dxxxx-xxxx                            /boot/efi      vfat    umask=3D=
0077 0 2
UUID=3Dxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx swap           swap    defaults=
   0 0
UUID=3Dxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /              xfs     defaults=
   0 1
/swapfile                                 swap           swap    defaults  =
 0 0
LABEL=3DCrucial2,5" /mnt/Crucial2,5" auto nosuid,nodev,nofail,x-gvfs-show 0=
 0

What's the current status of this bug?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
