Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E31E95A9F
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 15:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377607AbjJIPhz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 11:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377685AbjJIPhm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 11:37:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1764C11A
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 08:37:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A36B0C433CC
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 15:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696865827;
        bh=b0ls1iq4eU8kiLxfoOu9Cr77zw4F96xM5zhwxUAXKQw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rx0gKMNhX0cjL8/rzHfDh1fJrevudJk8d1bFkEHUmFwhGR3hfX1Z8u8HAIHwNjBW9
         J6kyp83m3bg62mF9cUh7ChizkjE7ip/VQ8HSpekm1D2g+11ArJeFcVBKVqQvcVqY3D
         LLpZo+DXlHRUmRq+rtY7qnbVIEewJUbjAUsvQp0hTQbKagfaKBKqSaoqq1HXM8bQGk
         Dbd07+P7XkdC5o3wkxL3VwVqabHpiLIPp5Vj46BtzqueLOSq2YwhkpS1pS3u6d6MBV
         WkcSTtbJG4TdgeljpUdH3mCg7uBb0g8KLkBXiOcIZYZyrSaRF3RX+n70aqr4t3Snre
         d3Ff9Ghtkq4sA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8DAE0C53BD4; Mon,  9 Oct 2023 15:37:07 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 205833] fsfreeze blocks close(fd) on xfs sometimes
Date:   Mon, 09 Oct 2023 15:37:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: socketpair@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-205833-201763-gRWgxmYuFQ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205833-201763@https.bugzilla.kernel.org/>
References: <bug-205833-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D205833

=D0=9A=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3 =D0=9C=D0=B0=D1=80=
=D0=BA (socketpair@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |socketpair@gmail.com

--- Comment #5 from =D0=9A=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3 =
=D0=9C=D0=B0=D1=80=D0=BA (socketpair@gmail.com) ---
https://bugzilla.redhat.com/show_bug.cgi?id=3D1474726 the same bug

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
