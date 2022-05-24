Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A175FC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 11:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbiEXLt3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 07:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236269AbiEXLt2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 07:49:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4132A709
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 04:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18145614FB
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 11:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A387C3411C
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 11:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653392966;
        bh=eFLdRrWdUxFA7HwpLJ4lI+TlCD+ZMDzFhIwcSBI5/Tw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=sxvWskBIaLFAd9aiF6udNL4bqP8e8ww7DAeU0qo8tMEdhGNPRQXIjEDDeBNWAbLdW
         Et2VbyhBoh/FyomIpQ4ZzzzAbANhxNQJRsdC5YXbAJqoRpTtaHAWdfedwRqwCz/7vb
         fXZSm2Pd4C1KrM2LvbPpMfZlrdjfRSReqoZ5RriEDXyZSG4YW+UhQD2nvafFcHuIjE
         nkK8jcK8CC+yDBOnde4pL0mEc4HEg2X+4OBaljNyRRfnzJrjLQ4V8Cts+TBq70V9Hf
         peuHmvvzDGN8ZDYaevse4Vk1T2awU6Khv8Ng1m8ogUWBp3HIGr1jJU5CrqCHKuijjm
         8mfMFwKlt4kug==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 69195CC13B6; Tue, 24 May 2022 11:49:26 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Tue, 24 May 2022 11:49:25 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216007-201763-MeOe1X5EAu@https.bugzilla.kernel.org/>
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

--- Comment #17 from Peter Pavlisko (bugzkernelorg8392@araxon.sk) ---
Created attachment 301027
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301027&action=3Dedit
.config file of a kernel unaffected by this bug

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
