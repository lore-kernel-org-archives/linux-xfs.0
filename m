Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16993C00A89
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 05:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C855922275
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 05:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgKBFbZ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 00:31:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgKBFbZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Nov 2020 00:31:25 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209981] Unable to boot with kernel 5.10-r1
Date:   Mon, 02 Nov 2020 05:31:24 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209981-201763-84dcpox6FY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209981-201763@https.bugzilla.kernel.org/>
References: <bug-209981-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209981

--- Comment #5 from Dave Chinner (david@fromorbit.com) ---
On Mon, Nov 02, 2020 at 05:02:06AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=209981
> 
> --- Comment #4 from Aaron Dominick (aaron.zakhrov@gmail.com) ---
> (In reply to Eric Sandeen from comment #2)
> > Why do you feel this is an xfs bug?  I don't see any indication of xfs
> > problems in your logs.
> 
> I dont think the logs are being captured. Basically after I boot and enter my
> lvm password, the system locks up with a bunch of pending in flight requests.
> Among them are the xfs_buf_ioend_work

Your kernel oopsed trying to load firmware for the iwl driver.
Everything after that is colateral damage. Sort out the firmware
loading problem first because once that problem goes away all the
others should, too.

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
