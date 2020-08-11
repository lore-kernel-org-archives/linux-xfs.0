Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A693C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 23:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B2D320782
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 23:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgHKXBA convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 19:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHKXA7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Aug 2020 19:00:59 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
Date:   Tue, 11 Aug 2020 23:00:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208827-201763-iEw5iMp7hj@https.bugzilla.kernel.org/>
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

--- Comment #20 from Dave Chinner (david@fromorbit.com) ---
On Wed, Aug 12, 2020 at 07:59:13AM +1000, Dave Chinner wrote:
> On Tue, Aug 11, 2020 at 07:10:30AM -0600, Jens Axboe wrote:
> > What job file are you running? It's not impossible that I broken
> > something else in fio, the io_u->verify_offset is a bit risky... I'll
> > get it fleshed out shortly.
> 
> Details are in the bugzilla I pointed you at. I modified the
> original config specified to put per-file and offset identifiers
> into the file data rather than using random data. This is
> "determining the origin of stale data 101" stuff - the first thing
> we _always_ do when trying to diagnose data corruption is identify
> where the bad data came from.
> 
> Entire config file is below.

Just as a data point: btrfs fails this test even faster than XFS.
Both with the old 3.21 fio binary and the new one.

Evidence points to this code being very poorly tested. Both
filesystems it is enabled on fail validation with the tool is
supposed to exercise and validate io_uring IO path behaviour.

Regardless of whether this is a tool failure or a kernel code
failure, the fact is that nobody ran data validation tests on this
shiny new code. And for a storage API that is reading and writing
user data, that's a pretty major process failure....

Improvements required, Jens.

-Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
