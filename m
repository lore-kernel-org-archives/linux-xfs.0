Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBF0C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Nov 2023 15:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjKBP2m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Nov 2023 11:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjKBP2m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2023 11:28:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64FB121
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 08:28:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71EF0C43397
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 15:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698938919;
        bh=jvkLVhzMDU3XY3vnjsy/voHaEvGeLiuoyrD9zKok3cY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=C2QYssVxR2JFwTSSmmjycNbvAQtvsS4UFjSg11CgWxyVw63ecjep3Mo9gRhr46fux
         cdUzxy6MgAaE3eGC9OxWUkcrzIwDt1UEQAyctVY/4XI1h2wWVClsklrObYLKXNx9lJ
         vElh7gYfflyJ3BOG9myCtoh5xk++99XD3RjJvW1ncWyhTRYYaueZMiXj0ZZSkTLydI
         h52RHzitKzy8ZtBW5idB5NNdmNh0jVgM8schXvfqm6axycnAhh7tmUHIhOTThLqlXJ
         ysJ9kt1gWPqca91ZoxgNXWS/16XlCr8cHjYpFDHsTWFGvbqBx5d5vUPiUR/IWYT/bO
         8hh3G+tNudxHw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 621F7C53BD1; Thu,  2 Nov 2023 15:28:39 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Thu, 02 Nov 2023 15:28:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ct@flyingcircus.io
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: component product
Message-ID: <bug-217572-201763-V5c6iPxFev@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217572-201763@https.bugzilla.kernel.org/>
References: <bug-217572-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217572

Christian Theune (ct@flyingcircus.io) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|XFS                         |Other
            Product|File System                 |Memory Management

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
