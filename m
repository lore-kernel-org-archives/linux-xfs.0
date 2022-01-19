Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0FFEC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jan 2022 07:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352004AbiASHZ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 02:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352028AbiASHZV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 02:25:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BCCC061574
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jan 2022 23:25:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EC96B8185A
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 07:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5F9AC340E9
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 07:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642577116;
        bh=18UYq4aI7SaHcXOpPvvKR306OrymMFkHSsRHN+CnUq4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Uz8DnpEb4bYvHYQnwkScdt4yXEtQpS7mvSH2/MiRTV7vdAE3/64lbOj1zOwlqN48S
         DZo+BfIwOtJB78x++RR7J4yBzjjDcq9Ig3txkj94nP4+P6uAfi2jCRlAMYCZjnTCrw
         ArRJRa3S2gowmv3LYyVgdNPvT/Dgv96mUD66RCuNnU+1CPkt3aVvdTJlkG6Ru3eMYS
         8iZZliHblmCmPavhFRCMiw+17t+i/fqHIEYtna8G0BsyF7zUuGS0A4YbTQMX6/JnHS
         /8TWdCbpIAMm5IxvDnUduBVvaWjU552FrxxirmFW7TaGSQvOTwVyExh/hzs8Wk+H+g
         8inwKcQk/tuLQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C3A46CC13B4; Wed, 19 Jan 2022 07:25:16 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215506] Internal error !ino_ok at line 200 of file
 fs/xfs/libxfs/xfs_dir2.c.  Caller xfs_dir_ino_validate+0x5d/0xd0 [xfs]
Date:   Wed, 19 Jan 2022 07:25:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yanming@tju.edu.cn
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-215506-201763-ZUfkhLir4B@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215506-201763@https.bugzilla.kernel.org/>
References: <bug-215506-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215506

bughunter (yanming@tju.edu.cn) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |ANSWERED

--- Comment #2 from bughunter (yanming@tju.edu.cn) ---
Thank you for reply! I will learn what you have suggested.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
