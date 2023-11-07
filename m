Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8BFC4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 10:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjKGKLt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 05:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjKGKLt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 05:11:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE851F7
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 02:11:46 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 644E3C4339A
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 10:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699351906;
        bh=7lZ7uIo3EM+vDaOhuBmGzCT3Bw9vl7cBLzU/WHXe75Q=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XbiDFWfs4US6DfZbH4iTZ0FuKofFnsvc9+orR4k8r9SohTMENcEYflaLJYKheQy+T
         lwR39S+gc2a8kgrf0UUTwC1ZnqZjDFnonrO40H9DWrzn6zxmK8TLctRHYIoUl4q+mk
         nIm0Mgc0C9A9l9EM67yv7u+UMdlaBbg/Y57q4+lC4RbZ7PLEYO6QP/DPoDjypXBx16
         +eXjmB843PNCwseTiNY0Qi7PzWtI88RxT5ctH1WTFZIxUP5R9LVG4pJ55qfXRitdwR
         TkRgPlCfipvEb6zF2DreRgs61ECaOOxqm0xuUGWdaNfnEcxwQACgUulZxwStqQj1EX
         sGVgCU5yeMllg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 541F7C53BD2; Tue,  7 Nov 2023 10:11:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Tue, 07 Nov 2023 10:11:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
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
Message-ID: <bug-217572-201763-PIiSsAS4Lr@https.bugzilla.kernel.org/>
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

--- Comment #23 from Christian Theune (ct@flyingcircus.io) ---
I'm trying to come up with a reproducer and reviewed our machines. Currently
all the affected machines are running one of our database configurations (M=
ySQL
or PostgreSQL) and one difference is that they are running with increased
readahead (128KiB default on our fleet is being increased to 1 MiB when run=
ning
MySQL or PostgreSQL).

I also reviewed the RedHat bug and all the linked discussions. The RedHat b=
ug
smells like there might be a reproducer as the kernel dumps show uptimes of
less than 30 minutes. Also, there's another database system involved as I've
seen RocksDB (and compactions) mentioned there.

Using the PostgreSQL benchmark did not trigger anything for me in less than=
 1
hour even under memory pressure. I'm going to check out the rocksdb benchma=
rk
now.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
