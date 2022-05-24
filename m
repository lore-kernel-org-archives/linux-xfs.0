Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC6DC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 10:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbiEXKxE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 06:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiEXKxD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 06:53:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4BB4ECD6
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 03:53:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F17F561208
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 10:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67418C3411C
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 10:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653389581;
        bh=ig/3/CNZ3ImCerSsK91IWF44j0G58KcFzhULS9ULFrw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZZA9Swq5hnndI7OcVkbnFJ99Tm0m/mvVDHN3f/Ooym+Npp/Jr8H13L92vvL59EsgU
         muwEnprFx1wPpn1hJ9uiPDr+Tdh2T5mF47IxtNGltFue5PlCw84Xd2GUdihiSpTRoD
         FFu12RR5LtPgZBEio6rCqJpmBSVKqoLXeL8o9aLz+zsdVynkwrUUTFApHl9IG3mTxv
         C/wqqD+CUcXafK8x+CD0xAIvoN8KPA9/IKsu4V89tQO1V5kCbc7k20WzDOkcfVXaZo
         QpDgnNtUYNDgqGRN/WXMOpZ1wmdnNuEvtKWvyG+z3x/pGWaRXSM2fSmRtczP8bgNZE
         Z9Lpofu8LvUcQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 55986C05FD4; Tue, 24 May 2022 10:53:01 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Tue, 24 May 2022 10:53:00 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216007-201763-i7CXf6EKgg@https.bugzilla.kernel.org/>
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

--- Comment #14 from Peter Pavlisko (bugzkernelorg8392@araxon.sk) ---
Created attachment 301026
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301026&action=3Dedit
contents of the /proc/slabinfo

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
