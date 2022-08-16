Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 731B6C2BB41
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 14:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiHPOcT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiHPOcS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 10:32:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11248BBA4C
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 07:32:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1F296104A
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 14:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0615EC43141
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 14:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660660337;
        bh=isb6U0cuyK66idIpL4bCxsabaNUmedhqf9hwSxiuDRs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Om4d7EEF4zZ5jfGBipHZ+K3ELgfSU5HO+8B5zK9ZHnPqHs0I3v2hEjzjPh59+BAcm
         wEeka2BT5gkduIbSkHocLEXMbmC97hAbZlki1EoDRuSHxUMvz3vgtDimW7fEDHMISQ
         forOHPdDjd2C5jRZYablVaTzHULcziiSjt21yHvSG6613QNCUDEk1po66zQiNPoEYp
         9FM2FeSwYloBlT9xFIH4C0hEyYb3rFsxsdLbBxAuCyCtt5GBXTANP5/xgCpTXOrRyl
         x0QT6IXuLpDf6HDJgFf49dLB/n45kRsjDCQIahJJbE1sDIIFZwfVfApSIQ0QD9h0BV
         Qdlo8/TzRZa3w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E8FA4C433E9; Tue, 16 Aug 2022 14:32:16 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216343] XFS: no space left in xlog cause system hang
Date:   Tue, 16 Aug 2022 14:32:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: amir73il@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216343-201763-JrsyNQUNfI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216343-201763@https.bugzilla.kernel.org/>
References: <bug-216343-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216343

--- Comment #4 from Amir Goldstein (amir73il@gmail.com) ---
On Tue, Aug 16, 2022 at 11:57 AM <bugzilla-daemon@kernel.org> wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216343
>
> --- Comment #3 from zhoukete@126.com ---
> (In reply to Amir Goldstein from comment #2)
> >
> > I don't think so.
> > I think this buffer write is in-flight.
>
> But how to explain the XFS_DONE flag is set.Is XFS_DONE flag means the io=
 had
> been done=EF=BC=9F
>

According to xfs_trans_dirty_buf() I think it could mean uptodate and
dirty buffer.

>
> >
> > Not sure if space cannot be released or just takes a lot of time.
>
> crash> ps -m 2006840
> [0 14:35:38.418] [UN]  PID: 2006840  TASK: ffff035f80de8f80  CPU: 51=20
> COMMAND:
> "onestor-peon"
>
> pid 2006840 hang 14 hours. It is waiting for the xfs buf io finish.
> So I  think it is =E2=80=98cannot be released=E2=80=99 not take a lot of =
time.

Maybe the hardware never returned with a response?
Hard to say. Maybe someone else has ideas.

Thanks,
Amir.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
