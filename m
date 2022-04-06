Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086F2C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 15:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbiDFPlK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 11:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbiDFPlB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 11:41:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78D82BE95B
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 05:57:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50B3EB8234E
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 12:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC704C385AB
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 12:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649249846;
        bh=OPc8/3zATkGm/OSgP70xTuhQgQ/+gujlwdgWkZzu0mw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KEk+tH7wuZFDdWtLYgKv+FHQbhZv5mOAbu+BCVhW55eSPErQoybiXahGec9YOQsCX
         gLZCGMKyR26NIvK5n1WKfjrhncDilQiCHmrzVPxEsZL+mra5zeE5KY0qWSwITW3lDF
         0TBqrWvMA8cXLziGDeebATJWWeSOec+WeyjOIKzcF9z73O1ti8gVRzc0RI41697YSx
         1HIQ8LKGZJaq3u4QPv9nMoBibTWxxQRy3+2mbNvoZ0UGJ7PuQGzaaMinXsEK9wVHV4
         EZ2VqBCP4eYJnxHXAaTh+8RMdjflRWF3M3jvcludwRmATWMPzxEzdPVJDwjlg71YFQ
         4B/odMQn88rDw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D7C8ACC13AD; Wed,  6 Apr 2022 12:57:25 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215804] [xfstests generic/670] Unable to handle kernel paging
 request at virtual address fffffbffff000008
Date:   Wed, 06 Apr 2022 12:57:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: matthew@wil.cx
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc attachments.created
Message-ID: <bug-215804-201763-v8HAwpaX64@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215804-201763@https.bugzilla.kernel.org/>
References: <bug-215804-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215804

Matthew Wilcox (matthew@wil.cx) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |matthew@wil.cx

--- Comment #9 from Matthew Wilcox (matthew@wil.cx) ---
Created attachment 300704
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300704&action=3Dedit
Proposed fix

Please test on arm64; generic/670 passes on x86-64 with this patch, but the=
n it
passed before.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
