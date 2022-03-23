Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF11C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240826AbiCWVDy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238959AbiCWVDx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:03:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B51580FA
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:02:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E2C0B820BD
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0454AC340F7
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648069341;
        bh=KzEx8oY58ON6HFGvZ3lp4qh4uwHGs1tKIyQUaI6g9aI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fZwp/aKIoLk25fpXvfDmJdBcdZndsqyyhwg3Xlkj/hCMfe0YpUj+z/xr/SDcypObW
         RoUx/Fou7ff1uzro9X7j/i1TSaxSftQeUFNLjjWwVV3+3ldpDWIgQ8ZVQn4xYX1jf4
         HIEs/R8GicTJBEp0Qr3k2oRmORz0JjzLb5aO046XV8bX+GGQat9l8so5rMoiFUMRwA
         0IRH21r95Yu1AgXSgphkDQYmE22kUrLLtUkWqfJDWlz+B+6pvDZ67zJMjG9kTBr26O
         k1BEi0lzDRLYmthbi0nnyhPc74Z25ZdgwYMKqupa5tEJie9kQXw3N3PrAuKY7iv5b0
         ifn0mhSDNSCSQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E8DABC05FD4; Wed, 23 Mar 2022 21:02:20 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: =?UTF-8?B?W0J1ZyAyMTU3MzFdIFNlcmlhbCBwb3J0IGNvbnRpbnVvdXNseSBv?=
 =?UTF-8?B?dXRwdXRzIOKAnFhGUyAoZG0tMCk6IE1ldGFkYXRhIGNvcnJ1cHRpb24gZGV0?=
 =?UTF-8?B?ZWN0ZWTigJ0=?=
Date:   Wed, 23 Mar 2022 21:02:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lists@nerdbynature.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215731-201763-HySy5GPMA7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215731-201763@https.bugzilla.kernel.org/>
References: <bug-215731-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215731

Christian Kujau (lists@nerdbynature.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lists@nerdbynature.de

--- Comment #1 from Christian Kujau (lists@nerdbynature.de) ---
This is the kernel bug tracker. What's the kernel bug here? From the log ab=
ove
it's unclear what lead to these corruptions. There should be messages prece=
ding
the above, maybe something is wrong with the underlying disk device.

According to the message one should "unmount and run xfs_repair" -- did you=
 try
that?[0]. Did it help?

For further assistance, maybe the mailing list[1] can be consulted, but the
folks over there will possibly need more details also: which kernel version,
what kind of file system setup, what happened before these errors, etc.

[0] Be sure to do have a (block level) backup before running xfs_repair.
[1] https://xfs.org/index.php/XFS_email_list_and_archives

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
