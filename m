Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15A4C001E0
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 21:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjHHVyW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Aug 2023 17:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbjHHVyL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2023 17:54:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A962103
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 14:54:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAAC062D87
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 21:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F87CC433D9
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 21:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691531645;
        bh=vgf3G+cQ9jIG3jPmPy7v3PxvhmH6iLrogoDMBPRyZ3Y=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZzXj1TMPPp/efzSD67SLneaAvt74AFl0IcaLay/iUTM+LKoGW/+8mSr7AVSGNVidD
         dNgWaNmkTi0BVPXd1vcRp9WGAFCmughfR0HKQYomSSMX79uDwIRszl9gSHBkprhLfN
         Jamr+VTWm/iJauRRCIa1s39qsO25jIQMPGI4EyQzvfHGFxT/jIFIu4MoE9Wg8ehjOL
         b15zsnmf+oSCvHPVWiUkEcvi6yuREtNC1fgyl+ZTVxr0+/v0YMcxLX0Kc2SsFGSTce
         7XiFA90SjmE/WpEBEHJzPLID/YHJX6NL3Onxnj+xvF6en1B0clGiMck0+okV2SiJuD
         303ffofBIG0Fg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2FF2AC4332E; Tue,  8 Aug 2023 21:54:05 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Tue, 08 Aug 2023 21:54:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sandeen@sandeen.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217769-201763-kage670nOp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217769-201763@https.bugzilla.kernel.org/>
References: <bug-217769-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217769

--- Comment #11 from Eric Sandeen (sandeen@sandeen.net) ---
Another question - Did the systems repeatedly fail to boot, or fail once and
then succeed?

If anything at all had happened on the filesystem prior to encountering the
problem, I think that the next boot should have seen a dirty log, and clean=
ed
up the problem as a result.

But if the first action on the fs was to create a tmpfile or unlink a file,=
 we
might shut down before the log ever gets dirty and requires replay.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
