Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3685C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 18:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjCPSaX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 14:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjCPSaW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 14:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F5C1B54D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 11:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11720620E0
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 18:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A5B1C433AA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 18:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678991420;
        bh=P2AATFUTxBcggF5jq9XwBK08dyGmHcSH6ublRNb1h4o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=cu2aL6ZvBN0bTb9f88peZA8NpmXpVdaS+Q6fpKtd5AWNR6ylzRx6UY0NBZqGHvLV6
         7HIcu9hV5ejkAsVoaGlgIAyCLAWaEkD+YGroS2GTGacfnIb7qVxNqS2AvefFxVKstx
         ZqE0h1OCFrn1HRhq/5WHeGuszyD/V78fUwxioZOoFj57IcMx6o3dolBJwhNSdukVR9
         nqGcWNI/WmA/hlFrvfJhGcUhExT2tR64q9wCK1Cgt/dMPKzlgfJ8Z1dIroPhohmGd6
         3yABvifqb5S+rpIvL/lcpGtxe139BKl5TWj3yqltWpqQiGgdABXyaumD3UdMIuvM0g
         taEox158oe/oQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 51E3BC43142; Thu, 16 Mar 2023 18:30:20 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 207053] fsfreeze deadlock on XFS (the FIFREEZE ioctl and
 subsequent FITHAW hang indefinitely)
Date:   Thu, 16 Mar 2023 18:30:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bobbysmith013@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-207053-201763-kNZdM59lt4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207053-201763@https.bugzilla.kernel.org/>
References: <bug-207053-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D207053

bobbysmith013@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bobbysmith013@gmail.com

--- Comment #11 from bobbysmith013@gmail.com ---
I'm trying to figure out which kernel version this bug is fixed in. I see
references to a patch above, but am having trouble tracking down when it was
added into the baseline.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
