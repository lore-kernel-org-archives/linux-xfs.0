Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EF3C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 12:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345119AbiCXMwC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 08:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbiCXMwC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 08:52:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC84D55BE1
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 05:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 931E4B8239C
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 12:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D4ADC340F8
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 12:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648126228;
        bh=tqdLc4clUOJ0lImGZI6+rvyG8sk/Tsi7Ky6XuVz6zmk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ha1R5C6Th9K9Hf8gl4g1+AYISw7hwDX1UKIiD3AZqzLhd5cc+6b0qxcPEldiySO07
         UTePZhCRvXdiqEh6Me7dfrhbHyxGtsH0n5GF51EGPB3OBc3oszKrsNEQiG4cGEea9T
         SqJqgb0d26RLM2q5LYlRk6hDk6hJWss4C8qdNY3sldte6iaYCZnU2rnyDGKppIAR+T
         VPpXNzsuWuBagMbm8zjZ412Nz5HcOE5D5Hbx1Y5QGSKA6oPHQuK02FurILQu5Rh4hk
         FAByW/rjZwDjo3Q5dr1rc0usxLLVjpGaPththTJDXnvclsxmI8SM5XhzI1SjMcdTNo
         GSW7ds//sqctw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4D000C05FD0; Thu, 24 Mar 2022 12:50:28 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215687] chown behavior on XFS is changed
Date:   Thu, 24 Mar 2022 12:50:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215687-201763-hQWUpm1mpn@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215687-201763@https.bugzilla.kernel.org/>
References: <bug-215687-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215687

--- Comment #5 from The Linux kernel's regression tracker (Thorsten Leemhui=
s) (regressions@leemhuis.info) ---
On 24.03.22 11:22, Thorsten Leemhuis wrote:
> On 15.03.22 09:12, bugzilla-daemon@kernel.org wrote:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D215687
>>
>>            Summary: chown behavior on XFS is changed
>=20
> Darrick, what's up with this bug reported more than ten days ago?=20

Ahh, Zorro Lang replied in the ticket, seems things are okay now after
your discussed this on IRC, so let me remove this from the regression
tracking; if somebody really complains we ca start to track this again.

#regzbot invalid: seems reporter is okay with the changed behavior after
discussing this with the maintainer
https://bugzilla.kernel.org/show_bug.cgi?id=3D215687#c4

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
