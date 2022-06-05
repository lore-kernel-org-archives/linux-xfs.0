Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D956C433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jun 2022 01:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbiFEBBm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 4 Jun 2022 21:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbiFEBBk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Jun 2022 21:01:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAFFAE43
        for <linux-xfs@vger.kernel.org>; Sat,  4 Jun 2022 18:01:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D9B7608CD
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 01:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D46F1C341C7
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 01:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654390898;
        bh=PB0YGaikIOBoRbGk5vLu/YYLD8fP7N5TJQg0xdFIu30=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rCxU/2kevqs1mWVFGyL1JYVz46niJo/RxigHVhTyKPwqtKVKOnmNCWwCFbKP73Yau
         zn2iHaFCq/01h1PywIZQknpRe+R3lEbxFj4YBWFbPETltb+PlCV0Wq+Bf9inNB0gfC
         UpAvRFgG9NKPfC3A8eW5BFHCLJPI3YXWJifreL8iXd7R+/qImq7Lh0Xu6d/Cx2zZc9
         zb3vfeAtfjFRKWU0DMvu9Fcr8o4O+VkC79bZarEUCIOf1PiTW1WVHRWoKAG7z9BBFJ
         5/87Ti9IBGppSrwgEne1d3lGDs9j8CVH9zgQxx/NRcDEPzRWBXghPS5Y5/9WNcTiNy
         ScvkhlP7eLsFw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C3E94CC13B1; Sun,  5 Jun 2022 01:01:38 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Sun, 05 Jun 2022 01:01:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: akpm@linux-foundation.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216073-201763-sS73EIY4GY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216073-201763@https.bugzilla.kernel.org/>
References: <bug-216073-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216073

Zorro Lang (zlang@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |filesystem_xfs@kernel-bugs.
                   |                            |kernel.org

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
CC filesystem_xfs@kernel-bugs.kernel.org

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
