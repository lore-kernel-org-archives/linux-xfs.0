Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47A0EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 09:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbjF1JBt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 05:01:49 -0400
Received: from dfw.source.kernel.org ([139.178.84.217]:52440 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbjF1Iup (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 04:50:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05A1261272
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 08:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28CADC433CC
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 08:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687942244;
        bh=v7T4WN68VRP40mQOeiUPVN9WiSKjHI5gpWQmzcebCbw=;
        h=From:To:Subject:Date:From;
        b=suDGphfpd4DyLV+q3DvUKNs/cIrMg3F0hV51QCZbc02XcJAbONh3PidHSalqNryH+
         BU6lu5SvqnDbBzN9k4BS3XFGEj6FPxH+XoMAuEGGaC/V5xfhdK0gKVJdTDqnpsyn6a
         Syew/NkUYni3XXiCJnehSlVxspnFYbt0fS0+bDP+P8UWIy5WHzrB0GfYZLiBQDOzUx
         I1zsWs0lwSEd7quREjjeC8Fxm547+6700tSn4hF37FwhNOaP+k9IU23B/tVQg0CKwF
         /Ubw/P9/ykHZUW09Vv48vkaww5zTJUGCKXkHT1N6h7S58gDil4wKgMCPvrsb1Vp0Sh
         1daEjo+VO18mQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 15747C4332E; Wed, 28 Jun 2023 08:50:44 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217604] New: Kernel metadata repair facility is not available,
 but kernel has CONFIG_XFS_ONLINE_REPAIR=y
Date:   Wed, 28 Jun 2023 08:50:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: j.fikar@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-217604-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217604

            Bug ID: 217604
           Summary: Kernel metadata repair facility is not available, but
                    kernel has CONFIG_XFS_ONLINE_REPAIR=3Dy
           Product: File System
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: j.fikar@gmail.com
        Regression: No

Hi,

I'm trying the new xfs_scrub and I get this error:

$ sudo xfs_scrub /mnt/xfs
EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
Error: /mnt/xfs: Kernel metadata repair facility is not available.  Use -n =
to
scrub.
Info: /mnt/xfs: Scrub aborted after phase 1.
/mnt/xfs: operational errors found: 1

But the XFS_ONLINE_SCRUB and XFS_ONLINE_REPAIR are enabled in my kernel:

$ zcat /proc/config.gz | grep XFS
CONFIG_XFS_FS=3Dy
CONFIG_XFS_SUPPORT_V4=3Dy
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=3Dy
# CONFIG_XFS_RT is not set
CONFIG_XFS_ONLINE_SCRUB=3Dy
CONFIG_XFS_ONLINE_REPAIR=3Dy
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_VXFS_FS is not set

I'm on kernel 6.3.8 and xfsprogs 6.3.0. Do I need to enable XFS_DEBUG as we=
ll?

xfs_scrub -n seems to run fine.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
