Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2D6C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 02:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbiDGC4q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 22:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbiDGC4p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 22:56:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA2014B011
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 19:54:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D255261AA5
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 02:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39D92C385AB
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 02:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649300086;
        bh=SwqVfKM2N43pV7MgCRPzcNAVgzyYUW8OXjozyz5Yibo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=CXl6ukY0FDJ9uSDeDCiuU8C/zkXmDLOlkdF7jVxMmaKB3Rwmi6GZpLR6wDRmZ34Ln
         azjEkxRuNDY/CK27D1LqMPP5AwzJFDbEnB2XWG4T7r6oNWqeB/HKyZQ5nc+USeeFFZ
         qy8wcSBwwkbOSq6ku/Drgsc5XqZcZRuuhAil6K3m57km5vlByam3MFpg8d8/nMzKsa
         dTJMR1ak63Dw1U4HWABPishVKZUSdZJ3vgPxKjMHhFWC9m2J4RgEFZ5kkyME/lcZ3Q
         QFFE0u+DXErcVwwMMEixfRK5gt6zvyWxBbtHWche4twq75fk2nsZ6K/OciRrkvQu0Z
         uwoHBKTEm3B3w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 26C2BC05F98; Thu,  7 Apr 2022 02:54:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215804] [xfstests generic/670] Unable to handle kernel paging
 request at virtual address fffffbffff000008
Date:   Thu, 07 Apr 2022 02:54:45 +0000
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
Message-ID: <bug-215804-201763-qDscQVywHd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215804-201763@https.bugzilla.kernel.org/>
References: <bug-215804-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215804

--- Comment #12 from Zorro Lang (zlang@redhat.com) ---
(In reply to Matthew Wilcox from comment #11)
> Ah, the migrate problem.  I have patches already:
>=20
> https://lore.kernel.org/linux-mm/20220404193006.1429250-1-willy@infradead.
> org/

Great! As it's a known issue of upstream, I'm going to cancel my further
testing on it.

I've reproduced this bug on 5.18-rc1, then test passed on 5.18-rc1 with your
patch, with same distro version and arch. If my tier0 regression test won't
find obvious regression, it's a good patch for me :)

Thanks,
Zorro

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
