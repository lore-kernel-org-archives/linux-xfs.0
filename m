Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A93C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 10:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiEZK1B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 06:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiEZK1A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 06:27:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96E6C5E70
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 03:26:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ED6161149
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 10:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41A99C3411F
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 10:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653560815;
        bh=fplu98nAgi5nmIv3qNrYN0GFfU7wQlAk2Es85vLhB6Y=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZOhIbTgo6YUAmsWtqUbnGihZxRE87E9LWcAJwzahLabqVi9CJp1STGsm5zu+LwfZa
         B7TNfGOwC1mOteoxpSNXtsrjARna3exKKBfIMNoFwcpWue2UykLT+6mqAhcTi8bvG7
         GTKhtpLY24GgmNJyKJmSvzH9iiFvT236SwXi/SPQ5ElDDywW1rX9/ux9NGZ/yHHFYK
         PozJ0AkoVlSDArrxfqz9FE4p3k0D2v7X8tyab0BTfH1M3z2kVYs2AYmbFB/OyGGucX
         tQC7A9AKmPIQvcPhwAsB/dWm/WLsv05QVJi9WFdK3/naawx3ItnNtfXvPqUUmDDVrN
         qFkdaHdzbTXJA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2F116C05FF5; Thu, 26 May 2022 10:26:55 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Thu, 26 May 2022 10:26:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mgorman@suse.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216007-201763-cSoWm7t2fM@https.bugzilla.kernel.org/>
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

--- Comment #22 from Mel Gorman (mgorman@suse.de) ---
(In reply to Mel Gorman from comment #20)
> (In reply to Peter Pavlisko from comment #19)
> > (In reply to Mel Gorman from comment #18)
> > > Created attachment 301044 [details]
> > > Patch to always allocate at least one page
> > >=20
> > > Hi Peter,
> > >=20
> > > Could you try the attached patch against 5.18 please? I was unable to
> > > reproduce the problem but I think what's happening is that an array f=
or
> > > receiving a bulk allocation is partially populated and the bulk alloc=
ator
> > is
> > > returning without allocating at least one page. Allocating even one p=
age
> > > should hit the path where kswapd is woken.
> >=20
> > Hi Mel,
> >=20
> > I tried this patch and it does indeed work with 5.18.0-rc7. Without the
> > patch it freezes, after I apply the patch the archive extracts flawless=
ly.
>=20
> Thanks Peter, I'll prepare a proper patch and post it today. You won't be
> cc'd as I only have the bugzilla email alias for you but I'll post a
> lore.kernel.org link here.

https://lore.kernel.org/all/20220526091210.GC3441@techsingularity.net/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
