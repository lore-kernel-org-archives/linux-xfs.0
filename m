Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2873AC001DB
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 19:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjHGTvF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 15:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjHGTvD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 15:51:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507F01FCB
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 12:50:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 408D6621D3
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 19:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9EDBC433D9
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 19:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691437219;
        bh=7whPmEwf2ueyVPExPKy7El4ks1NR+VsIUhoW6eKv9w4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GA4mVkaPNmVMuVRLSDQ0jakBeT1ZCalF6Ja69cPYuCEhSg0KUVJiESw0fDN626CKF
         Son0xOGOPBVtI5fcLaaIZrJ3PnECyVn1TTRS+hAIVxFAuO4mMhiKCVZreO4D6CQ+tM
         Gyj51RAWnO0WezuGyuMRdZSA79n2JtbafEHZ21I1TGL7OrJx52hmbaSaMVB2rJnq+4
         2gXeKpgAOzWz8KyMNZ3cmFALb+BOfzUly3zc5uherEwlERdO6/SXNlnE9H+6fciyZV
         /Pt2WsA6uTCzyqxHhgLk3W5ef3+p4n8uOqExVAb4rSk2SUozMmKS0Fgkoy40qOHXln
         Tn2Z7CW5w1kSg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9901FC53BD1; Mon,  7 Aug 2023 19:40:19 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Mon, 07 Aug 2023 19:40:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: xani666@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217769-201763-LxHh5FH5Kj@https.bugzilla.kernel.org/>
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

--- Comment #4 from Mariusz Gronczewski (xani666@gmail.com) ---
> It's essentially an unexpected/inconsistent in-memory state, as opposed t=
o an
> on-disk structure that was found to be corrupt.

Shouldn't that also set filesystem as "dirty" ? The problem is that this
*basically* makes system unbootable without intervention; OS thinks it is c=
lean
so it doesn't run xfs_repair, then driver crashes without marking it unclea=
n,
reboot and process repeats. The crash also blows every mounted XFS system w=
hich
means even if log partition doesn't have that problem none of logs will
persist. I had to reformat /var/log in ext4 to even gather them on my laptop

> I presume that it boots ok now post-repair?

Yes

> Do you know if this was the root or /boot filesystem or something else? I=
t's
> still a mystery about how filesystems get into this state; we should never
> have a clean filesystem that requires no log recovery, but with unlinked
> inodes ... recovery is supposed to clear that.

It was root in both cases, we keep /boot on ext4

So far (well, we got few hundred more machines to upgrade) I've only seen t=
hat
on old ones, might be some bug that was fixed but left the mark on filesyst=
em ?

> It may have persisted on this filesystem for a very long time and it's ju=
st
> recent code changes that have started tripping over it, but I've always h=
ad a
> hunch that /boot seems to show the problem more often.

That would track, I only saw that on old machines (I think they were format=
ted
around 4.9 kernel release, some even earlier). I just had another case on
machine but this time reading certain files triggered it.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
