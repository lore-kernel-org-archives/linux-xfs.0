Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C260C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 20:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA4512076C
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 20:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHKU4r convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 16:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgHKU4r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Aug 2020 16:56:47 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
Date:   Tue, 11 Aug 2020 20:56:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jmoyer@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208827-201763-wNy2KPJoXN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208827-201763@https.bugzilla.kernel.org/>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208827

--- Comment #17 from Jeff Moyer (jmoyer@redhat.com) ---
Jens Axboe <axboe@kernel.dk> writes:

> So it seems to me like the file state is consistent, at least after the
> run, and that this seems more likely to be a fio issue with short
> read handling.

Any idea why there was a short read, though?

-Jeff

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
