Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7988C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 08:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344459AbiEEIzF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 04:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiEEIyz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 04:54:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A34546179
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 01:51:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8E8F61DCC
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 08:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B09DC385A8
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 08:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651740675;
        bh=MiHUi0eEhm9SfTIqLxWSPME5+ADZ06cargbxKSklUbs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gRUHzbfYWjASiwUHh1PgHc0fbzi7/18vJxCQ9jq7Of3IO9e76ey9GfRuktJATGRuW
         UrBoEth0PIISkR48AEfY4AorSJlvaaAm5WMzDDs4Vfd6CMOrz3FJXCtAp0w7rA3mNv
         RUTsUg8MSHd7Q2uglkvjkK8H+cR7rNA7+lfUX+uxrjwqdlx4xBEye73OSi4wfTMrJo
         ACKvUToGFxL8V0KUZm6MQltuNC8va2qBfvCLgYczxRlHZw4B7GaAMUbEz6g/Nk0PHh
         79IkbbIAN25etgCU+zcuOwTy5+6g36CeVQrAr1aLn22HCQqqVUkbUgZR9oWCjDQ2Q4
         mPIs5iUdbsSHw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 3956CCC13B0; Thu,  5 May 2022 08:51:15 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215927] kernel deadlock when mounting the image
Date:   Thu, 05 May 2022 08:51:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215927-201763-fENS5Es82G@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215927-201763@https.bugzilla.kernel.org/>
References: <bug-215927-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215927

--- Comment #5 from Dave Chinner (david@fromorbit.com) ---
On Thu, May 05, 2022 at 05:46:45AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215927
>=20
> --- Comment #3 from Artem S. Tashkinov (aros@gmx.com) ---
> XFS maintainers? This looks like a serious issue.

A fix has already been written and pushed into the upstream tree.

It's not a real world problem - exposing this issue requires
significant malicious tampering with multiple filesystem structures.
We can't (and have never tried to) defend against such a threat
model - our verification mechanisms are intended to defend against
known storage corruption vectors and software bugs, not malicious
actors.

If anyone wants credit for discovering fuzzer induced bugs like
this, then they need to be responsible in how they report them and
perform some initial triage work to determine the scope of the issue
they have discovered before they report it.  Making potentially
malicious reproducer scripts public without any warning does not win
any friends or gain influence.

We're tired of having to immediately jump to investigate issues
found by format verification attack tools that have been dumped in
public with zero analysis, zero warning and, apparently, no clue
of how serious the problem discovered might be.

The right process for reporting issues found by format verification
attacks is called "responsible disclosure". This is the process that
reporting any issue that has potential system security impacts
should use.

-Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
