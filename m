Return-Path: <SRS0=4IRk=BR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D3BC433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Aug 2020 03:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30A0722CAF
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Aug 2020 03:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgHGDMF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Aug 2020 23:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgHGDMF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Aug 2020 23:12:05 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
Date:   Fri, 07 Aug 2020 03:12:03 +0000
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
Message-ID: <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
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

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Thu, Aug 06, 2020 at 04:57:58AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=208827
> 
>             Bug ID: 208827
>            Summary: [fio io_uring] io_uring write data crc32c verify
>                     failed
>            Product: File System
>            Version: 2.5
>     Kernel Version: xfs-linux xfs-5.9-merge-7 + v5.8-rc4
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: zlang@redhat.com
>         Regression: No
> 
> Description of problem:
> Our fio io_uring test failed as below:
> 
> # fio io_uring.fio
> uring_w: (g=0): rw=randwrite, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB,
> (T)
> 64.0KiB-64.0KiB, ioengine=io_uring, iodepth=16
> uring_sqt_w: (g=0): rw=randwrite, bs=(R) 64.0KiB-64.0KiB, (W)
> 64.0KiB-64.0KiB,
> (T) 64.0KiB-64.0KiB, ioengine=io_uring, iodepth=16
> uring_rw: (g=0): rw=randrw, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB, (T)
> 64.0KiB-64.0KiB, ioengine=io_uring, iodepth=16
> uring_sqt_rw: (g=0): rw=randrw, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB,
> (T) 64.0KiB-64.0KiB, ioengine=io_uring, iodepth=16
> fio-3.21-39-g87622
> Starting 4 threads
> uring_w: Laying out IO file (1 file / 256MiB)
> uring_sqt_w: Laying out IO file (1 file / 256MiB)
> uring_rw: Laying out IO file (1 file / 256MiB)
> uring_sqt_rw: Laying out IO file (1 file / 256MiB)
> crc32c: verify failed at file /mnt/fio/uring_rw.0.0 offset 265289728, length
> 65536 (requested block: offset=265289728, length=65536)
>        Expected CRC: e8f1ef35
>        Received CRC: 9dd0deae
> fio: pid=46530, err=84/file:io_u.c:2108, func=io_u_queued_complete,

This looks like it's either a short read or it's page cache
corruption. I've confirmed that the data on disk is correct when the
validation fails, but the data in the page cache is not correct.

That is, when the fio verification fails, the second 32kB of the
64kB data block returned does not match the expected data to be
returned. Using the options:

verify_fatal=1
verify_dump=1

and getting rid of the "unlink=1" option from the config file
confirms that reading the data using xfs_io -c "pread -v <off> 64k"
returns the bad data.

Unmounting the filesystem and mounting it again (or using direct IO
to bypass the page cache), and repeating the xfs_io read returns
64kB of data identical to the expected data dump except for 16 bytes
in the block header that have some minor differences. I'm not sure
this is expected or not, but we can ignore it to begin with because
it is clear that there's exactly 8 pages of bad data in the page
cache in this range.

So, add:

verify=pattern
verify_pattern=%o

to have the buffer stamped with file offset data rather than random
data, and it turns out that the bad half of the buffer has an
incorrect file offset, but the offset in the entire range on disk is
correct.

Ok, so now I have confirmed that the data is valid on disk, but
incorrect in cache. That means the buffered write did contain
correct data in the cache, and that it was written to disk
correctly. So some time between the writeback completing and the
data being read, we've ended up with stale data in the page
cache....

This corruption only appears to happen with io_uring based buffered
IO - syscall based buffered IO and buffered IO with AIO doesn't
trigger it at all. Hence I suspect there is bug somewhere in the
io_uring code or in a code path that only the io_uring code path
tickles.

I can't really make head or tail of the io_uring code and there's no
obvious way to debug exactly what the user application is asking the
filesystem to do or what the kernel it returning to the filesytsem
(e.g. strace doesn't work). Hence I suspect that this needs the
io_uring folk to look at it and isolate it down to the operation
that is corrupting the page cache. I'd love to know how we are
can triage issues like this in the field given the tools we
normally use to triage and debug data corruption issues seem to be
largely useless...

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
