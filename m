Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8504CC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jun 2022 15:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244928AbiFGPFi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jun 2022 11:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343904AbiFGPFS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jun 2022 11:05:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2539F5FF8
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 08:05:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B22E0616B6
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 15:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E10DC341CC
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 15:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654614317;
        bh=1/SbG5g9eMlWftKOmhn0QiJo7P9Cs9dIYRWVXfzRm3o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=s2VE6WbQz1xnupbzcSy+IuVVbg/Z32kB1Tzlm5m5MiC/zZZw214Ja21GTeIDj1ewb
         tX48nd81BPamifE6W5nD3QaL9AbPRTkeQfCPK+8aYoeDKqRiqwNOj91hlWPjm5kNmS
         qpxR3/LE9hNAt+3mR0MVYDQjfdhI6q7os4V1ZAHTs9WkTBq5Dhr3mo6sJQZDSG88kq
         hidGiYG9fZ2krZg0oX87Su/3Xk78XCyznsJ368ONGo47L0OCW+iPOIExouI1orBocZ
         H522cnJQg2WGYQgEv2oMuoEGOxq7PSDDRbVjeMODLD3b9LncLwmsYfkuW2wnxsMqSA
         lJbs3H5+1O+uQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0D3C4C05FD4; Tue,  7 Jun 2022 15:05:17 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Tue, 07 Jun 2022 15:05:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: agordeev@linux.ibm.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: akpm@linux-foundation.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216073-201763-snYTLCtV3h@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216073-201763@https.bugzilla.kernel.org/>
References: <bug-216073-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216073

--- Comment #4 from agordeev@linux.ibm.com ---
On Mon, Jun 06, 2022 at 03:13:12PM -0700, Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).

Hi Zorro,

Unfortunately, I am not able to reproduce the issue. Could you please
clarify your test environment details and share your xfstests config?

Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
