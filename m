Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD18C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 05:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243874AbiEEFu3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 01:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243869AbiEEFu0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 01:50:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE433344CC
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 22:46:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CE9C61B7A
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 05:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB4CFC385B2
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 05:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651729605;
        bh=pztfyRlch0qUqYcYBEQpEMlGl24ZiMyP03IS0JFMF34=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fOk3vs+RZmGeBQkxLJojgmhQnE+LWhqUXLRc6hdgm+yeZqAWcZnLQ6ErDCb8/cLsg
         jT3npoN42EvK0mxk772tuE9spuoH4bOoBTKR4LLemGrHia/Jf4arGzpoYX3cv9z/u1
         cOm+o930SjzbKODNOArel5v01XFmGEsd3Rl7ME9BKF/eqmQVXpvKZTTA+4nUURQhoQ
         X5UOCaWLVXeUN6elJlIb8t+F7d+MNAerJYfD7lfkakCFZ3LnP/7hd5IPkG/zRVBJ1/
         n15aYzbbyoh7ACQ0HWBx9rN4Lt0s64eHanKlVv//gbWiJXpeCOFt9FjcEe0ZeNQ0Tn
         spKvR4VM2N8aw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C1F22C05FD2; Thu,  5 May 2022 05:46:45 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215927] kernel deadlock when mounting the image
Date:   Thu, 05 May 2022 05:46:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215927-201763-qVJPAGrN3y@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215927-201763@https.bugzilla.kernel.org/>
References: <bug-215927-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215927

--- Comment #3 from Artem S. Tashkinov (aros@gmx.com) ---
XFS maintainers? This looks like a serious issue.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
