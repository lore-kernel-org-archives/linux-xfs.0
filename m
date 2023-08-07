Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA96C04A6A
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 17:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjHGRSk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 13:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjHGRSO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 13:18:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31AD210A
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 10:17:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEDE46202C
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 17:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 273B1C433D9
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 17:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691428656;
        bh=Nj8J92dAog8uTjUq3odE7tF90knxaVLBe55/90V0kr8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XAEyMm706HtaXdh55EKzt2LZPRp7KfPILg+rP0jycZTnNPOBlABzdqpvLjg7c2uOM
         6MP8F/FcRwooitq7GPjay+k9ngWMk2hGh12fRQuMK2Hb5iyl9dXEnHhWmeXevzevMO
         VIW3MjZ+W1aRJu4phliiIWrpt2jJBK5p0VKAQ5iSmVidYJfB0U2sEBFqul7C6DEbtG
         9YbnRdA2pjxywoaj+gS7Un+0r9neIMbZESXJnhPQ54eNKp7MBG8o/fF1mQ5qRI1lUz
         1n26i1RQbMxsWvbkByLFz7Cgc6XQuDguk7Hxm5NC/Hc5zhtYXc1bnJF8Ezo8FjBlaG
         MfdidTW1memGQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 13A71C53BD1; Mon,  7 Aug 2023 17:17:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Mon, 07 Aug 2023 17:17:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sandeen@sandeen.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217769-201763-RaUunGXllU@https.bugzilla.kernel.org/>
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

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@sandeen.net

--- Comment #1 from Eric Sandeen (sandeen@sandeen.net) ---
Please try running xfs_repair on the filesystems in question, and capture t=
he
output. (you can use xfs_repair -n to do a dry run if you prefer, it will y=
ield
the same basic information.)

My guess is that you will find complaints about unlinked inodes - please le=
t us
know.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
