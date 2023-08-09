Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD28CC0015E
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Aug 2023 19:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjHITKG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Aug 2023 15:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjHITKF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2023 15:10:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1CF10DA
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 12:10:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82962644F5
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 19:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E071FC433CC
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 19:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691608203;
        bh=HYblxlBzJgpgvP+lSGw5feDRYTFLClX3VJhwGnkixM0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Th+pnyKy6Q1K9KY64qmcZNTalHYFZ6ci7OeDPTcKDRadZRhpHrHW8oZ1+FlpMdpVv
         2tUPrJtuqzf/NLdRDalbszi/QgDDo2qR3souRcaf33iXZ8iofT19by6i68vsQqyiPg
         lwzyvO2SSOJVQHFJk8CPl/nKu+c7kecH7Llt4SW7aPDyGrpWuBPqVM69h0dXEVVBak
         VhOxv780x/f2vMKtM8xeN4yMf9p0LRw2x99l6hKWllrJTtgxBi2VwU37V4ypdIJdPX
         1BEEWY1/lUnEq5iD+Bip49w/rmLjdeSwdfsfVC6Dj6NU3iRsBDqJZ739fNAzbl+sFZ
         jN/gm4IlPTAow==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CBA78C4332E; Wed,  9 Aug 2023 19:10:03 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Wed, 09 Aug 2023 19:10:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rjones@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217769-201763-6ooKMqk3mb@https.bugzilla.kernel.org/>
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

--- Comment #15 from Richard W.M. Jones (rjones@redhat.com) ---
No problems.  We had a similar bug reported internally that
happens on VMware guests, and I'm just trying to rule out VMware
as a factor.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
