Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620ACC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 11:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbiEXLVj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 07:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbiEXLVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 07:21:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEBE344C1
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 04:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10AA1B8172F
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 11:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8D88C3411C
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 11:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653391295;
        bh=F06+s7KEzw3IYgfd/0RX8BIykMj55zWFdNJIsqyzudE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FaeHKGGQdsfP6ar0Dmcue6vhKWgjqvcin/zPBNUeiEXNQ83i45yUgvLypZH9TBYzt
         GM3KWdcg2/52zR7MPiiIEBkDc7UNIiVd9RORDwe3twweNDbtgCXbvS9Wue7kZYPWqx
         AvFD2SHPvywrsiZjNWWNCvF7wUQIGWiSmyID0S5MmdMYoo+nzphNzS4+lFZHhdOzO1
         t4uYqa96p3uFc5VzfCq6r0SarOyd00LJ/l0ROnDkuhNB6rED2fIuyyW3ikcyHSczD4
         tICmkjpxvsYUL8nTUcQOmeNBOJph4+aR6gt2DDMaokLpZLMwp8Em+X5kSsn0flrppN
         1P2dyk1iW5BzA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B61B5C05FD2; Tue, 24 May 2022 11:21:35 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Tue, 24 May 2022 11:21:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bugzkernelorg8392@araxon.sk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216007-201763-7gF932tVYI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216007-201763@https.bugzilla.kernel.org/>
References: <bug-216007-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216007

--- Comment #15 from Peter Pavlisko (bugzkernelorg8392@araxon.sk) ---
(In reply to Holger Hoffst=C3=A4tte from comment #9)
> Shot in the dark: can you try the latest plain 5.15.x + 9a5280b312e2
> aka:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/fs/
> xfs?id=3D9a5280b312e2e7898b6397b2ca3cfd03f67d7be1
>=20
> I suspect your stack traces are not really representative of what's
> going on..

I just tried commit 9a5280b312e2 (5.18.0-rc2+). The bug is still there.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
