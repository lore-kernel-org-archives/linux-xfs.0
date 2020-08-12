Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD29BC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 15:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE7FE20838
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 15:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgHLPOH convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 11:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726503AbgHLPOD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Aug 2020 11:14:03 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
Date:   Wed, 12 Aug 2020 15:14:02 +0000
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
Message-ID: <bug-208827-201763-YI18BADrUv@https.bugzilla.kernel.org/>
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

--- Comment #22 from Jens Axboe (axboe@kernel.dk) ---
On 8/11/20 4:09 PM, Dave Chinner wrote:
> On Tue, Aug 11, 2020 at 04:56:37PM -0400, Jeff Moyer wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>>
>>> So it seems to me like the file state is consistent, at least after the
>>> run, and that this seems more likely to be a fio issue with short
>>> read handling.
>>
>> Any idea why there was a short read, though?
> 
> Yes. See:
> 
>
> https://lore.kernel.org/linux-xfs/20200807024211.GG2114@dread.disaster.area/T/#maf3bd9325fb3ac0773089ca58609a2cea0386ddf
> 
> It's a race between the readahead io completion marking pages
> uptodate and unlocking them, and the io_uring worker function
> getting woken on the first page being unlocked and running the
> buffered read before the entire readahead IO completion has unlocked
> all the pages in the IO.
> 
> Basically, io_uring is re-running the IOCB_NOWAIT|IOCB_WAITQ IO when
> there are still pages locked under IO. This will happen much more
> frequently the larger the buffered read (these are only 64kB) and
> the readahead windows are opened.
> 
> Essentially, the io_uring buffered read needs to wait until _all_
> pages in the IO are marked up to date and unlocked, not just the
> first one. And not just the last one, either - readahead can be
> broken into multiple bios (because it spans extents) and there is no
> guarantee of order of completion of the readahead bios given by the
> readahead code....

Yes, it would ideally wait, or at least trigger on the last one. I'll
see if I can improve that. For any of my testing, the amount of
triggered short reads is minimal. For the verify case that we just ran,
we're talking 8-12 ios out of 820 thousand, or 0.001% of them. So
nothing that makes a performance difference in practical terms, though
it would be nice to not hand back short reads if we can avoid it. Not
for performance reasons, but for usage reasons.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
