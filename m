Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D360DC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 04:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345176AbiEZEFD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 00:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241137AbiEZEE4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 00:04:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B306AC0397
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 21:04:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 626DFB81F3B
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 04:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 115FAC3411D
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 04:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653537892;
        bh=lgtsEHQ375RPs8EcJGa7sZBpmtC/Qi8RLF51nhLgPRM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZuDOG5LQQtQR4eHW2LdtGTequL2GDVPNsRPOho9bPnJ2rQyw2sEdtEJCeQJJBcfAq
         6DYBukfKRpiM0gf63SAYk4UYoXKDKbimGkyEuNJEVmJZJBPfqm4npNfkqtho5PXMrV
         V5tPeI31/RlQPIywmLqaHoGbkZuU1JReV+knExU9XlqwCXRYP8EULAePK8MspXzAJU
         gBtGOhbEqKYVLmbDcPsqHtjC+VG3yhtLDJqh2EYEBDdxyvE3KfwyItNYiI6WFm2xXS
         y5CGA4NyJLAGOUDdTUwXKKox4ZnONVL83tkx0E6lfEuGH9Oq+TwDHZRgEpDwlx5aB6
         pacuG36IUONGA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id F2233C05FD4; Thu, 26 May 2022 04:04:51 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Thu, 26 May 2022 04:04:51 +0000
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
Message-ID: <bug-216007-201763-SLu295iEvz@https.bugzilla.kernel.org/>
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

--- Comment #19 from Peter Pavlisko (bugzkernelorg8392@araxon.sk) ---
(In reply to Mel Gorman from comment #18)
> Created attachment 301044 [details]
> Patch to always allocate at least one page
>=20
> Hi Peter,
>=20
> Could you try the attached patch against 5.18 please? I was unable to
> reproduce the problem but I think what's happening is that an array for
> receiving a bulk allocation is partially populated and the bulk allocator=
 is
> returning without allocating at least one page. Allocating even one page
> should hit the path where kswapd is woken.

Hi Mel,

I tried this patch and it does indeed work with 5.18.0-rc7. Without the pat=
ch
it freezes, after I apply the patch the archive extracts flawlessly.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
