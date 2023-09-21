Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86416E7D0A2
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 18:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjIUSNL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 14:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjIUSM3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 14:12:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152937B450
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 10:37:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36B7EC433B6
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 06:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695279501;
        bh=Pr0DMg7Lh61qe+3TuRotggdJdsEMRfza5qa5KJupZgo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dgsO2rshNgnYlf3SIwAAbdr9FSZavQxt6xRtpz7slZLHPpsrfOj5PtyKodAs2qMpS
         zDoskNzNB+dph/4mNEfTLbHTGq7wxlkmqLyuGSHt+Mo3Mpq/aDMkFDlnxWY9P3xZqB
         n2O57HlKjaFXUvJAdMLqs0gzLLyUfkQnnf1ZOhXCEg3eMkGQ0FQVByRiceyQjAxeBa
         +Jg+kSrTX3XXeZoPKciWF1MaTK8/QCwLRKyRA5bOW/u91z60V1ysjaykHcLQpeV6Mq
         E5LAhSBcBBIMaY9bO04+iY66+U1RpkjjhwiiEwmmtIvsqDMCL8CrE+ArQ18pHjW8Sc
         mF6gaA086qiWQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2549DC4332E; Thu, 21 Sep 2023 06:58:21 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216343] XFS: no space left in xlog cause system hang
Date:   Thu, 21 Sep 2023 06:58:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zhoukete@126.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216343-201763-MJUjuOCBqw@https.bugzilla.kernel.org/>
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

--- Comment #8 from zhoukete@126.com ---
I have found the cause of the problem. By applying the patch
d43aaf1685aa471f0593685c9f54d53e3af3cf3f , the problem can be solved.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
