Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08467C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Apr 2022 18:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238468AbiDHS43 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Apr 2022 14:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239077AbiDHS42 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Apr 2022 14:56:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900BD3CBE5F
        for <linux-xfs@vger.kernel.org>; Fri,  8 Apr 2022 11:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DED0B826CF
        for <linux-xfs@vger.kernel.org>; Fri,  8 Apr 2022 18:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BDEFFC385AE
        for <linux-xfs@vger.kernel.org>; Fri,  8 Apr 2022 18:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649444060;
        bh=a224TU68LpFs/X7yrbYLCSqStR+94kO7j4L/2fIyS1I=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jJrIcHCk5vKyszqzLlllO+J25kUS1IQGVVD0aURP+DC4k8T3QL+kgepgPghNS9kcb
         mi+U9BLPktTHyJtqwm7quchb+j6eIO9inyTV4uJJ/lJ5igoD3E4v22MPnWDeUxeKU8
         mD/ooN7sxiSEp6DPcpJGfowGsy77TE5VHjZ13McRTpcIxGiTBSDQ7OJiXXVOkSqjQc
         J8FXVKINkVYuiCQdJCOLWWGqmze3WziqJev7nmZQLG+a3dP6ZYhuZED+jJXtn6DAwo
         AT2HdFR5gpw8H4kLAiTK5VduGJZNwkO6jHM7WgvfBh2uTdGB+a1is3PP6GWhEt5TaL
         VC9ltyt8PMDVQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id AA85CCC13B1; Fri,  8 Apr 2022 18:54:20 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215804] [xfstests generic/670] Unable to handle kernel paging
 request at virtual address fffffbffff000008
Date:   Fri, 08 Apr 2022 18:54:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: matthew@wil.cx
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-215804-201763-sRawXKx3Zn@https.bugzilla.kernel.org/>
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
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #13 from Matthew Wilcox (matthew@wil.cx) ---
Linus pulled the fix(es) earlier today

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
