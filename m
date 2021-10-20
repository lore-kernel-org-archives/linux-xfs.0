Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE748C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 18:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B810660FF2
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 18:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhJTSbW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 14:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229998AbhJTSbW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Oct 2021 14:31:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 73B2B61212
        for <linux-xfs@vger.kernel.org>; Wed, 20 Oct 2021 18:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634754547;
        bh=KWanMda2PQGbAbKdEvFGr4h1rGqBkzJawzoOclBKSh0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=MfkxKgkNcbcdbvWUo3HxwOtuA7Z+X7qZakl4RGBTrQTCL6yIn4nwe8pGZGh3/79sf
         8DwaaP97UWkZE6teMlsVzP283oJ7dtXkOpqUpE1RlmjqypzuBSE9L5x6J9hsyppVtQ
         ka2KDts9H0J1WiD1rhwt3n1hF5tslGYP5pRgPjn57veKxjFK4LoT2BpRP769LzQh4R
         SCkYUs1t0qMHRxLuFbeRc/dihC5zafBYROiZjap4DVWE6lw7UqTz8CFy3LOqy2uD5u
         gfIEYkwT39nfuRr17s0vzAkLMR5VQa54ntG5GpjSSYTCb3DBgcPNh0ytmF7NRpk9wv
         kuJnJxemJ6feg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Wed, 20 Oct 2021 18:29:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ct@flyingcircus.io
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214767-201763-OsTcd5XnKF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214767-201763@https.bugzilla.kernel.org/>
References: <bug-214767-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214767

--- Comment #4 from Christian Theune (ct@flyingcircus.io) ---
Another thing I noticed: it always hangs the nix-daemon (nixos.org) which d=
oes
some dance around managing an overlay read-only mount that gets re-mounted =
rw
for a short period while changing things in there. Here is what it looks li=
ke
normally:

/dev/vda1 on / type xfs
(rw,relatime,attr2,inode64,logbufs=3D8,logbsize=3D32k,noquota)
/dev/vda1 on /nix/store type xfs
(ro,relatime,attr2,inode64,logbufs=3D8,logbsize=3D32k,noquota)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
