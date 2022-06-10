Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92523C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jun 2022 14:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235814AbiFJOpQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 10:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245589AbiFJOoI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 10:44:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340691DE2E1
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 07:44:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BF5761F00
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 14:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9EA5CC341C4
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 14:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654872246;
        bh=3dk4gK1JqUa3CXBqf8n2UZJi49fmDoNUCTdONhW+kTA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=c4/78iVDcV/VdD0iQDscuTkktpp0/q66EQcI40tlKFaIBvPARLBLkNXSq09idWMSr
         JhWOGGNlrQ+r8RHVePA15titeitll3uBpGpf9TD6DEWx65PbG69/5dzOWrfimbUsqn
         vdxVcgEm5qsCLOC9e6h0QzZHCKyTONatTDtAzzByGFvMq1nbL3buB4dI/hNy5EPwke
         wAH55WYIUQ6InEg5RQnwvjN4YxRNm6UEwtwFGW5ZyRCOox+/1tjAhN2UUd/k1kdfx+
         J3wTr/l2rcRZkE5cbR4PJ8m+NHIj8F2H44NUb2y8SKCv1pAxZv/3xSeyibh33WZZ2P
         f6K1hdP+U03Ig==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 89A78CC13B3; Fri, 10 Jun 2022 14:44:06 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216110] rmdir sub directory cause i_nlink of parent directory
 down from 0 to 0xffffffff
Date:   Fri, 10 Jun 2022 14:44:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: hexiaole1994@126.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216110-201763-izolBy8Dy8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216110-201763@https.bugzilla.kernel.org/>
References: <bug-216110-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216110

--- Comment #3 from hexiaole (hexiaole1994@126.com) ---
in section 2., and subsection (2), the description "the number of the sub
directoryes might be 4294967109" has some mistakes, the corrected is "the
number of the sub directoryes should be 4294967107".

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
