Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B683BC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 10:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbiEXKtQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 06:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbiEXKtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 06:49:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10D260059
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 03:49:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FE3C61370
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 10:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9F8EC3411D
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 10:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653389354;
        bh=b0u65amKclN2LJ/SAcWQHBWtgk2noKbOOLhiCWvODPE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JjNosXRel2nvO2qUrDGRTDSf/ckckddhcH00tTtp/CKiGt+7DRvtcWPMXoRPhEC7u
         WpXC1wUxhYBjcNhgjTVLSkyFSl1JAPFJ4xDIUj4Lq8IwWM9cKF4eMWJr93jVOjr0hf
         SLI8dOms3qtfSES4DPi6r+kblTQORhUoB7KS1nnI8XT1OmtZyWzUMfeh3QGhgKOv73
         o/ENAakipeNZYt05y+SPrtPTftCGC03EMW4Ttu0ymY0OrVZLRzGMt82LKCrniupdHX
         ilToeyhDuoa0VCZ8Y/VHZW5Nh4uniZHTqLxRsfk7KlHkmVwoNXjnU1JcqSpkRwC5x+
         Ztt9ZiEaNWjAQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C40C3C05FF5; Tue, 24 May 2022 10:49:14 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Tue, 24 May 2022 10:49:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jack@suse.cz
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216007-201763-IukPGkQ5ds@https.bugzilla.kernel.org/>
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
                 CC|                            |mgorman@suse.de

--- Comment #12 from Jan Kara (jack@suse.cz) ---
Interesting. Looks like a bug in the bulk allocator that it is not able to =
make
progress when reclaim is needed? From a quick look I don't see kswapd being
kicked or direct reclaim happening from the bulk allocator so that could be=
 the
reason. Adding Mel to CC, maybe he has some ideas.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
