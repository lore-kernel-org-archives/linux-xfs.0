Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A775C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jun 2022 08:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348031AbiFJIel (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 04:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348508AbiFJIeQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 04:34:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B292228A
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 01:32:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B86EB832C7
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 08:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E349C341C7
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 08:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654849919;
        bh=5G4mLQYQRG1g8nmUEYH2PxnUrm8pFCFIVj+7/6PIRH4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GUUu0oO3DBUogyo9sYhWBu/iCv6EB0e11egG43YjYNdyP6msbqL4dqTdBe5nL0p60
         Ih4GyKbyd3pQh+yrI9c0gaMfvpfjAynKxP9NMMnFIVYHnyt9qV2xPxrgp88sdng/s5
         zmwKlVV7pVjlrij6s4w6mlHMaqVEziMjpSzCXmCvq0J/KcXYllsFQvujDIHosuy+Ql
         AjDliWJKQ2jevQub1ywLVSUFCDw12mugPxSLVmCzU7wsAJwVTDsAd/1R2Q5C+tXpxn
         ZQnIWQ0EzxDiKXRJIk3ppsNBcES5a+W5CktJqJCLvO7feJgdTDXJFA/Gwv5WxSg3s+
         MUxnQot/eQoyg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 09DD9C05FD2; Fri, 10 Jun 2022 08:31:59 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216110] rmdir sub directory cause i_nlink of parent directory
 down from 0 to 0xffffffff
Date:   Fri, 10 Jun 2022 08:31:58 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216110-201763-0Flqs4lD70@https.bugzilla.kernel.org/>
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

--- Comment #2 from hexiaole (hexiaole1994@126.com) ---
Created attachment 301147
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301147&action=3Dedit
dmesg file

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
