Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D52C43334
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 07:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiFFHtT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 03:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiFFHtS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 03:49:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8B8A7E20
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 00:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE51A611B4
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 07:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23B12C341CE
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 07:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654501756;
        bh=AMSBTi655T0bxYeoM9MH0JCDzj8ps8q/UYTRZfBVDhE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OTfdXGbLEKr0YZRr7cgB9uOkpCy2Z4QJIGb9YwryoQoe8E+qx8FaaAxFNr4765Mno
         uZMx5EQ3gZEuJUuwD5Con/L0lHdNZGG2U9kAmWLP3vYFgn+9gvRyuRTlQMuAhjZoqp
         R4qgmETprfA83721qikdGO0EWcU7CD8g4015jij/JA9z/IRnRpbjO3S3jEslRhRWjE
         e9Flq+WJUqkz3y/4h+ZwkoSJi1My5IVmjgrH9b4m10a5TdJOYphUPcTR+idaaU8y3g
         RkmV5sZWplIiXGqoexc+qAVEFS6HQ/ip/uQyMd784tmg1DG/5hSM0FmQHjiWeYlWUo
         +Cpxynyf9QKkw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0F948CC13B3; Mon,  6 Jun 2022 07:49:16 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Mon, 06 Jun 2022 07:49:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jack@suse.cz
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216007-201763-cgbGek90Mp@https.bugzilla.kernel.org/>
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

Jan Kara (jack@suse.cz) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #26 from Jan Kara (jack@suse.cz) ---
Jordi, this is a very different issue (different filesystem, different
stacktrace). Please don't hijack bugs like this. For all I can see your
stacktraces look very standard and we are just waiting for the disk to comp=
lete
the IO. If the IO does not progress, please file a separate bug against ext=
4.
Thanks!

And I'm closing this bug as it is already fixed.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
