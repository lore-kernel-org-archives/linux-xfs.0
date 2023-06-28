Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F2BEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 21:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjF1V6n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 17:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjF1V6m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 17:58:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324E32103
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 14:58:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5FDC61479
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 21:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24D65C43391
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 21:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687989521;
        bh=SWJMXDN9AIGKdQx3JbAhXVd0Xxq9onqgKBEUHYoobQE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=euFPHkIf0sPI5yCWHP6A++KPba0leUPueEDWy6lId8RWpEVM3QUpYjEckXD5cC2MQ
         RHCAX5SZcRl200PxxPEYfQRQnSq0dMd18qxMiPnrmOgPNqAr7iofqhiVYnEibqdc/o
         zIp1xU91XWDnXC36R4dPZdPRj4HAlv1HtbrA62SvDa0lZhy4Y0/spm/fD81jk7PPTX
         4/PufgduTAGCz2kcqgvTTxQvb4WQ6KFOrBniZlunrFwJCIE0kkTgHhqtci2I+OGnGu
         C0oYId3+NRR+9grui1PZF14AJS7OmAxnAs6uizImyp8ECUPTR4tCISAnXewGB0mMyG
         0EN/b/mc9sSzg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 13AD1C53BD5; Wed, 28 Jun 2023 21:58:41 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217604] Kernel metadata repair facility is not available, but
 kernel has XFS_ONLINE_REPAIR=y
Date:   Wed, 28 Jun 2023 21:58:40 +0000
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
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217604-201763-eLoFWuNm3U@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217604-201763@https.bugzilla.kernel.org/>
References: <bug-217604-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217604

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Wed, Jun 28, 2023 at 08:50:43AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217604
>=20
>             Bug ID: 217604
>            Summary: Kernel metadata repair facility is not available, but
>                     kernel has CONFIG_XFS_ONLINE_REPAIR=3Dy
>            Product: File System
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: j.fikar@gmail.com
>         Regression: No
>=20
> Hi,
>=20
> I'm trying the new xfs_scrub and I get this error:
>=20
> $ sudo xfs_scrub /mnt/xfs
> EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
> Error: /mnt/xfs: Kernel metadata repair facility is not available.  Use -=
n to
> scrub.
> Info: /mnt/xfs: Scrub aborted after phase 1.
> /mnt/xfs: operational errors found: 1

We haven't merged all the online repair code yet so it is not yet
available to use. Please close the bug and monitor the upstream XFS
list to find out when the repair code is fully merged and enabled
at runtime.

FWIW, it is far better to send a message to the mailing list
(linux-xfs@vger.kernel.org) to find out what the status of something
is than it is to raise a bug just to ask a question about support...

-Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
