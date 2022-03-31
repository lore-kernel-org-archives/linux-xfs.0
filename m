Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C637C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Mar 2022 21:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241881AbiCaVhg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 17:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbiCaVhf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Mar 2022 17:37:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D9322FD80
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 14:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7BD261BA0
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 21:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40059C34113
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 21:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648762546;
        bh=m3m5ePkPCWgcrZq4avYvUynKbRwlbSkPY26CgcKMe8g=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=H6/T6UFVXOXOOgTVzzG4tFQaMzsqKROgotF5Tv4EQTQYhrGnA4eGHSlvrV6u6rGE5
         aZJ/A3JOwUCYlt0t5hifSxCKjYKmRWQAZzclm9n0DrhS7iFHBPEfVVpxieMhPYR4Bi
         ep7FdhUe4ENVx4CG+yT+zX0qKsvBvmg9KtQ3wyKeEtDST8STFOcnuJVBf8ytSaeMwz
         OH2INVVepp+sq/nadgddXPKLcC3i8tS9wqRcEiBsqVV7Ssn1jrkaYe9j/gOk+sTUz4
         B9UDpK/FuQiD9Jzn6kI7NKTM5pGnpPEqEfynh664Dfb8jO7vRTgTsAVjZuPS70dZ7x
         4knNvb5AwUGlA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2BF41C05FD6; Thu, 31 Mar 2022 21:35:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215783] kernel NULL pointer dereference and general protection
 fault in fs/xfs/xfs_buf_item_recover.c: xlog_recover_do_reg_buffer() when
 mount a corrupted image
Date:   Thu, 31 Mar 2022 21:35:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215783-201763-b5Tn4yr3RU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215783-201763@https.bugzilla.kernel.org/>
References: <bug-215783-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215783

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Thu, Mar 31, 2022 at 08:07:08PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215783
> - Overview=20
> kernel NULL pointer dereference and general protection fault in
> fs/xfs/xfs_buf_item_recover.c:xlog_recover_do_reg_buffer() when mount a
> corrupted image, sometimes cause kernel hang
>=20
> - Reproduce=20
> tested on kernel 5.17.1, 5.15.32
>=20
> $ mkdir mnt
> $ unzip tmp7.zip
> $ ./mount.sh xfs 7  ##NULL pointer derefence
> or
> $ sudo mount -t xfs tmp7.img mnt ##general protection fault
>=20
> - Kernel dump

You've now raised 4 bugs that all look very similar and are quite
possibly all caused by the same corruption vector.
Please do some triage on the failure to identify the
source of the corruption that trigger this failure.

If you are going to run some scripted tool to randomly corrupt the
filesystem to find failures, then you have an ethical and moral
responsibility to do some of the work to narrow down and identify
the cause of the failure, not just throw them at someone to do all
the work.

You can automate this - track the corruptions you add to the
filesystem image, then when you have an image that reproduces a
problem, iterate over it removing corruptions until you have just
the minimum set of changes in the image that reproduce the issue.
Then you can cull all the images that trip over the same corruptions
and only report the actual corruption that causes the problem.

Then list those corruptions in the bug report so that we don't have
to do all this triage ourselves to weed out all the duplicates and
noise that all the random corruptions that don't cause crashes
induce.

-Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
