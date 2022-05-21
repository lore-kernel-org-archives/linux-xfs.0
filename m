Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ABEEC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 21 May 2022 05:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbiEUFOm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 May 2022 01:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235444AbiEUFOk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 May 2022 01:14:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA1E18DAEB
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 22:14:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4E4EB82E26
        for <linux-xfs@vger.kernel.org>; Sat, 21 May 2022 05:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70239C34115
        for <linux-xfs@vger.kernel.org>; Sat, 21 May 2022 05:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653110076;
        bh=994dwo6xSMyVft7dzXEsBs78bJlTGdYK+dTwIPfM4vU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=VUnNCyw83x60kAi4bltjOP0wbQVoj35YV6VUH45gQ/u9qbR7iUo6zKFKsN9Ubm+Sk
         i0k2s5EGbgMOL8TDJ38apAmdW74kqve5NBtoOTqeEntpS4FlKOm7Ik6jLBHSTbPOZU
         kYxprw1gXufgTCg3KSc7q107bxQCGdVhgISu2h2qwDDWVOdALbqHxuHgUhuHfQMwn7
         p7Vmywg0DGzrYbfc89OFcAHEB8T1usWfuofxlUSYFaGdF/ABTXdKxHz4gtjHEhtVnj
         yUWi2dqfFPu5A/rWiI0wdigzq3xhhVx2anNJoR9RO3HZhqBaRBQ+0ULW69Owg4DvAw
         C6VEHG5GTZujQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 60C6DCC13B4; Sat, 21 May 2022 05:14:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Sat, 21 May 2022 05:14:36 +0000
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
Message-ID: <bug-216007-201763-l8R3pKFzHP@https.bugzilla.kernel.org/>
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

--- Comment #4 from Peter Pavlisko (bugzkernelorg8392@araxon.sk) ---
> What sort of storage subsystem does this machine have? If it's a spinning
> disk then you've probably just filled memory

Yes, all the disks are classic spinning CMR disks. But, out of all file sys=
tems
tried, only XFS is doing this on the test machine. I can trigger this behav=
ior
every time. And kernels from 5.10 and bellow still work, even with my
non-standard .config.

Here is the memory situation when it is stuck:

ftp-back ~ # free
               total        used        free      shared  buff/cache=20=20
available
Mem:         3995528      175872       69240         416     3750416=20=20=
=20=20
3763584
Swap:        2097084           0     2097084

I will try to put together another test machine on Monday, without using an=
y of
the components from this one, just to rule out a hardware bug.

This may not be a XFS bug, but so far only XFS seems to suffer from it.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
