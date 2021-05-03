Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8478FC433ED
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 13:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EC1361157
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 13:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbhECNci (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 May 2021 09:32:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234286AbhECNch (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 May 2021 09:32:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5366961278
        for <linux-xfs@vger.kernel.org>; Mon,  3 May 2021 13:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620048704;
        bh=KkCmjXxCF69xxeQ6SrTTd3RBJl8w+P8J+ahUm8T1jE4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IWZ4/mduvbUQhMQZH+Do9zG+/IReUy6KLJZo8YMG3sX2GZCM3RsFglmJGH/eqpTdh
         5qhw4wTTYYHi2vDJGTUH0akFUiqHgzHv3phuT2dD2AGW2U2Qyucd/i01tEAoPzA0OJ
         eNosou6fvHeH5i2Z01jQLqgEwZMEg0wPCZIsd2jaE9/LwUdI1nNhShbu7SisVh1CLr
         kO4hqbxS2hWydRBuwCyLDLis5sdjX7F1sRVLOwAm3hw2Hrsu43P5tu5SIsPwBfZOAj
         PwM7ipfEN/J9qBjBpfbKCUnsxVBpt9iFzkLIvyRu4syxys8dRg2aCBNO6xdbcewumF
         AwOy8y9/OAp/w==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211605] Re-mount XFS causes "attr2 mount option is deprecated"
 warning
Date:   Mon, 03 May 2021 13:31:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: preichl@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-211605-201763-atFp7Ps5WT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211605-201763@https.bugzilla.kernel.org/>
References: <bug-211605-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211605

Pavel Reichl (preichl@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |preichl@redhat.com

--- Comment #10 from Pavel Reichl (preichl@redhat.com) ---
Hello,

upstream kernel now contains following commits:

92cf7d36384b9 xfs: Skip repetitive warnings about mount options
0f98b4ece18da xfs: rename variable mp to parsing_mp

This should fix the reported problem. Can we close the bug now?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
