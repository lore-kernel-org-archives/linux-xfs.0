Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A69C001B0
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 19:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjHGTBQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 15:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjHGTBO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 15:01:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F6F173D
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 12:01:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58E236215A
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 19:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C27EDC43395
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 19:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691434869;
        bh=4m62g8/qaQlX4Fr5P6fd4NANeBnDuE18XpuarSf//sU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hri7uaRS9YUpOUbrqKxXYyVK6tLjfUTss9RUQlx8yzIEuS+DPSjJqktWpghjYtDkE
         thmKuiPB6GcGV/x5gzmcfOeVrG0v4yAjhQKG8/+ijNK9IxjzPFKNqqOMMuY/NYenhu
         xV9ewesOfLdS+wCGMsgtM+OUCyhBYg0TnfygQJHtGSG+OAXMv2rcT4dsbJtxdyIG5H
         7g0X86cQ7KHmoTxdUxNRWXw7HbOywq5F0P1kClGqz8iNszexzo9dvEAJJywyLSQz3X
         oERCMrrxgFMqJPB/Kl87tJXlg8vxgSKClWKCsI9Uj7Slw9AsiElg6eVezB5vSK6tV6
         gOLeGEYynKnuw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B0800C53BD1; Mon,  7 Aug 2023 19:01:09 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Mon, 07 Aug 2023 19:01:09 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217769-201763-rlUaC4Qyh7@https.bugzilla.kernel.org/>
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

--- Comment #3 from Eric Sandeen (sandeen@sandeen.net) ---
It's essentially an unexpected/inconsistent in-memory state, as opposed to =
an
on-disk structure that was found to be corrupt.

I presume that it boots ok now post-repair?

Do you know if this was the root or /boot filesystem or something else? It's
still a mystery about how filesystems get into this state; we should never =
have
a clean filesystem that requires no log recovery, but with unlinked inodes =
...
recovery is supposed to clear that.

It may have persisted on this filesystem for a very long time and it's just
recent code changes that have started tripping over it, but I've always had=
 a
hunch that /boot seems to show the problem more often.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
