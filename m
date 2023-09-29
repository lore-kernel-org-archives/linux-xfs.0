Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 894ECE743E9
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Sep 2023 04:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjI2Eyp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 00:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjI2Eyo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2023 00:54:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC541A2
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 21:54:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 974FFC43395
        for <linux-xfs@vger.kernel.org>; Fri, 29 Sep 2023 04:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695963282;
        bh=mapscmWNX8hvcDaK742O23MlPcXIUgQWadpEoxrKVtc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bRNFP4hukYSjS94OsG+6Ha/31NHo4/cS3wBvZc2lweMrdDN4+N31obay0okkzGP0C
         IM+KyhoZOyI0tBbRaJwQPqx1AmvplbiVThNV84kREJEqEEKAbV4j/JXL3IgSjy5Wu6
         qfjK5E0UIWk8Bmup7k7SyGzXaigkrEJ9W5lUWWoxhMBpFEkuuNDWRgRcMvfH+2+Hss
         yOmZfjT6kUTAuTIo/5eJ9vrROXjy9yfT9DvXeDcdYfQ5qjbJvdPaWJWCy+Hq01kb/C
         PlJnPYrSA6J+4Uz9DLC6BFTVrhX/eYHopbBxM1OLXU4XPDiLwgby88GkwbtVHa+7EF
         hI3RPjyJMbyTA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 869F9C53BD2; Fri, 29 Sep 2023 04:54:42 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Fri, 29 Sep 2023 04:54:42 +0000
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
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217572-201763-ZLCPCN4zPG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217572-201763@https.bugzilla.kernel.org/>
References: <bug-217572-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217572

--- Comment #13 from Christian Theune (ct@flyingcircus.io) ---
Hi,

sorry for picking up on the XFS end again =E2=80=93 that was a brain fart o=
n my side
... ;)

Unfortunately, I still can't (reliably) trigger the issue yet, but I've see=
n it
twice in 3 months now.

I'll check the commit you mentioned. According to the LKML this has only ma=
de
it into the unreleased 6.6 series. I could backport it to 6.1, ask a mainta=
iner
or it might be on its way to 6.5 already?

I'm undecided what the best option for  trying the commit is because both
machines that were affected are in production use with customers.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
