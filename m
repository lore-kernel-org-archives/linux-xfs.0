Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B318AC433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 15:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ABA120665
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 15:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgINP2S convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 11:28:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbgINP14 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Sep 2020 11:27:56 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209243] [regression] fsx IO_URING reading get BAD DATA
Date:   Mon, 14 Sep 2020 15:27:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: axboe@kernel.dk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209243-201763-fSiPHg5cIx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209243-201763@https.bugzilla.kernel.org/>
References: <bug-209243-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209243

--- Comment #8 from Jens Axboe (axboe@kernel.dk) ---
No problem, that's what I ended up doing. Can you try the patch I replied on
the list with?

https://lore.kernel.org/io-uring/9d3c38bc-302c-5eb6-c772-7072a75eaf74@kernel.dk/T/#m669bfdc265c53e165bc2bfd4c3484243fa0ac33d

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
