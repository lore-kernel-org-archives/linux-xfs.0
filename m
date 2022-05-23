Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B8FC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 08:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiEWIbc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 04:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiEWIba (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 04:31:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADB7FDA
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 01:31:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DDE6B80F1A
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 08:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FEADC3411A
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 08:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653294681;
        bh=EZIo25xVbnKBOrPa293k4JIFLqar+9GY/zZbpnpUxZA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mwcGsYWhf7tN5EGHTQh/+Y4odSs78FFbHcn2SK+LYB8njA3ICCQm73WqxQXfhH/sq
         uIab9bntVAeF0BsdcDGKOkWQnDDvmtnUM1XzuXeYqOwi16l8PkfglnERQ31sMMX17c
         LSCVRdTPgmy3o3eP5LP3vh6JnrtwdH9LX3lrgieVE0YIgDkdcIcq42SdSqagnZWnO+
         6/v+xSj5c/WDg38nhMpu6xQKStKw+pEIYm+qmLcpApQbSylzWJUcHe4wcEuhtJUGd2
         IemxW8elrFLwl6B+Mh0bE+J4lme2aJgSFpdNZrNQxbmteWj/lnjS0aIQGwjXIlZayw
         25ujlgwlGDlpQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2F39CC05FD2; Mon, 23 May 2022 08:31:21 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Mon, 23 May 2022 08:31:20 +0000
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
Message-ID: <bug-216007-201763-POvICfAJxy@https.bugzilla.kernel.org/>
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

--- Comment #7 from Peter Pavlisko (bugzkernelorg8392@araxon.sk) ---
Furthermore, I was able to do a git bisect on this repository:

git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git

The offending commit is this one:

9ba0889e2272294bfbb5589b1b180ad2e782b2a4 is the first bad commit
commit 9ba0889e2272294bfbb5589b1b180ad2e782b2a4
Author: Dave Chinner <david@fromorbit.com>
Date:   Tue Jun 8 09:19:22 2021 -0700

    xfs: drop the AGI being passed to xfs_check_agi_freecount

    From: Dave Chinner <dchinner@redhat.com>

    Stephen Rothwell reported this compiler warning from linux-next:

    fs/xfs/libxfs/xfs_ialloc.c: In function 'xfs_difree_finobt':
    fs/xfs/libxfs/xfs_ialloc.c:2032:20: warning: unused variable 'agi'
[-Wunused-variable]
     2032 |  struct xfs_agi   *agi =3D agbp->b_addr;

    Which is fallout from agno -> perag conversions that were done in
    this function. xfs_check_agi_freecount() is the only user of "agi"
    in xfs_difree_finobt() now, and it only uses the agi to get the
    current free inode count. We hold that in the perag structure, so
    there's not need to directly reference the raw AGI to get this
    information.

    The btree cursor being passed to xfs_check_agi_freecount() has a
    reference to the perag being operated on, so use that directly in
    xfs_check_agi_freecount() rather than passing an AGI.

    Fixes: 7b13c5155182 ("xfs: use perag for ialloc btree cursors")
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    Signed-off-by: Darrick J. Wong <djwong@kernel.org>

 fs/xfs/libxfs/xfs_ialloc.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
