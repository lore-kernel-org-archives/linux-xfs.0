Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0C8737F3F
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 08:12:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EDCF28F8035
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 06:12:36 -0700 (PDT)
Received: from mail-yh0-f43.google.com (mail-yh0-f43.google.com
	[209.85.213.43]) by cuda.sgi.com with ESMTP id rjMLYjFRQhFIv5Q2
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Aug 2014 06:12:35 -0700 (PDT)
Received: by mail-yh0-f43.google.com with SMTP id 29so4437748yhl.16
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 06:12:34 -0700 (PDT)
Message-ID: <53F1FBBC.8000903@gmail.com>
Date: Mon, 18 Aug 2014 09:12:28 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: xfsdump completes very prematurely in low RAM, commit found
References: <53F15EEF.4090308@gmail.com> <20140818024114.GK20518@dastard>
In-Reply-To: <20140818024114.GK20518@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 08/17/14 22:41, Dave Chinner wrote:
> On Sun, Aug 17, 2014 at 10:03:27PM -0400, Michael L. Semon wrote:
>> Hi!  I had some phantom issues that are chasing me through this 3.17
>> merge window period.  While chasing those issues, I decided to do an
>> xfsdump of a v5/finobt XFS system rescued from PEBKAC issues.  The
>> xfsdump completed rather prematurely, ending like this test case
>> output...
>>
>> xfsdump: dumping special file ino 4194523 mode 0x21b0
>> xfsdump: dumping special file ino 4194524 mode 0x21b0
>> xfsdump: dumping special file ino 4194525 mode 0x21b0
>> xfsdump: dumping special file ino 4194526 mode 0x21b0
>> xfsdump: dumping special file ino 4194527 mode 0x21b0
>> xfsdump: ending media file
>> xfsdump: media file size 4512992 bytes
>> xfsdump: ending stream: 23 seconds elapsed
>> xfsdump: dump size (non-dir files) : 4452088 bytes
>> xfsdump: dump complete: 23 seconds elapsed
>> xfsdump: Dump Summary:
>> xfsdump:   stream 0 /mnt/xfstests-scratch/blah.0.dump OK (success)
>> xfsdump: Dump Status: SUCCESS
>>
>> That looks fine for a lack of obvious error messages.  However, it
>> should end like this:
>>
>> xfsdump: dumping regular file ino 13653551 offset 0 to offset 12154 (size 12154)
>> xfsdump: dumping regular file ino 13653555 offset 0 to offset 16554 (size 16554)
>> xfsdump: dumping regular file ino 13653556 offset 0 to offset 185 (size 185)
>> xfsdump: dumping regular file ino 13653557 offset 0 to offset 471 (size 471)
>> xfsdump: dumping special file ino 13653558 mode 0xa1ff
>> xfsdump: ending media file
>> xfsdump: media file size 1999127056 bytes
>> xfsdump: ending stream: 465 seconds elapsed
>> xfsdump: dump size (non-dir files) : 1963549104 bytes
>> xfsdump: dump complete: 465 seconds elapsed
>> xfsdump: Dump Summary:
>> xfsdump:   stream 0 /mnt/xfstests-scratch/blah.0.dump OK (success)
>> xfsdump: Dump Status: SUCCESS
>
> What's the inode number progression of a successful dump at the
> point at which the incomplete dump ends? i.e. around inode 4194527?
> That number is one inode chunk short of 2^22, which implies that
> there is a failure or some kind moving from one AG to the next.
> The progrssion of inode numbers will tell me whether this is the
> case or not...

It is this, run a bit longer to show xfsdump start to dump regular
files again:

xfsdump: dumping special file ino 4194520 mode 0x21b0
xfsdump: dumping special file ino 4194521 mode 0x21b0
xfsdump: dumping special file ino 4194522 mode 0x21b0
xfsdump: dumping special file ino 4194523 mode 0x21b0
xfsdump: dumping special file ino 4194524 mode 0x21b0
xfsdump: dumping special file ino 4194525 mode 0x21b0
xfsdump: dumping special file ino 4194526 mode 0x21b0
xfsdump: dumping special file ino 4194527 mode 0x21b0
xfsdump: dumping special file ino 4194528 mode 0x21b0
xfsdump: dumping special file ino 4194529 mode 0x21b0
xfsdump: dumping special file ino 4194530 mode 0x21b0
xfsdump: dumping special file ino 4194531 mode 0x21b0
xfsdump: dumping special file ino 4194532 mode 0x21b0
xfsdump: dumping special file ino 4194533 mode 0x21b0
xfsdump: dumping special file ino 4194534 mode 0x21b0
xfsdump: dumping special file ino 4194535 mode 0x21b0
xfsdump: dumping special file ino 4194536 mode 0x21b0
xfsdump: dumping special file ino 4194537 mode 0x21b0
xfsdump: dumping special file ino 4194538 mode 0x21b0
xfsdump: dumping special file ino 4194539 mode 0x21b0
xfsdump: dumping special file ino 4194540 mode 0x21b0
xfsdump: dumping special file ino 4194541 mode 0x21b0
xfsdump: dumping special file ino 4194542 mode 0x21b0
xfsdump: dumping special file ino 4194543 mode 0x21b0
xfsdump: dumping special file ino 4194544 mode 0x21b0
xfsdump: dumping special file ino 4194545 mode 0x21b0
xfsdump: dumping special file ino 4194546 mode 0x21b0
xfsdump: dumping special file ino 4194547 mode 0x21b0
xfsdump: dumping special file ino 4194548 mode 0x21b0
xfsdump: dumping special file ino 4194549 mode 0x21b0
xfsdump: dumping special file ino 4194550 mode 0x21b0
xfsdump: dumping special file ino 4194551 mode 0x21b0
xfsdump: dumping special file ino 4194552 mode 0x21b0
xfsdump: dumping special file ino 4194553 mode 0x21b0
xfsdump: dumping special file ino 4194554 mode 0x21b0
xfsdump: dumping special file ino 4194555 mode 0x21b0
xfsdump: dumping special file ino 4194556 mode 0x21b0
xfsdump: dumping special file ino 4194557 mode 0x21b0
xfsdump: dumping special file ino 4194558 mode 0x21b0
xfsdump: dumping special file ino 4194559 mode 0x21b0
xfsdump: dumping special file ino 4194560 mode 0x21b0
xfsdump: dumping special file ino 4194561 mode 0x21b0
xfsdump: dumping special file ino 4194562 mode 0x21b0
xfsdump: dumping special file ino 4194563 mode 0x21b0
xfsdump: dumping special file ino 4194564 mode 0x21b0
xfsdump: dumping special file ino 4194565 mode 0x21b0
xfsdump: dumping special file ino 4194566 mode 0x21b0
xfsdump: dumping special file ino 4194567 mode 0x21b0
xfsdump: dumping special file ino 4194568 mode 0x21b0
xfsdump: dumping special file ino 4194569 mode 0x21b0
xfsdump: dumping special file ino 4194570 mode 0x21b0
xfsdump: dumping special file ino 4194571 mode 0x21b0
xfsdump: dumping special file ino 4194572 mode 0x21b0
xfsdump: dumping special file ino 4194573 mode 0x21b0
xfsdump: dumping special file ino 4194574 mode 0x21b0
xfsdump: dumping special file ino 4194575 mode 0x21b0
xfsdump: dumping special file ino 4194576 mode 0x21b0
xfsdump: dumping special file ino 4194577 mode 0x21b0
xfsdump: dumping special file ino 4194578 mode 0x21b0
xfsdump: dumping special file ino 4194579 mode 0x21b0
xfsdump: dumping special file ino 4194580 mode 0x21b0
xfsdump: dumping special file ino 4194581 mode 0x21b0
xfsdump: dumping special file ino 4194582 mode 0x21b0
xfsdump: dumping special file ino 4194583 mode 0x21b0
xfsdump: dumping special file ino 4194584 mode 0x21b0
xfsdump: dumping special file ino 4194585 mode 0x21b0
xfsdump: dumping special file ino 4194586 mode 0x21b0
xfsdump: dumping special file ino 4194587 mode 0x21b0
xfsdump: dumping special file ino 4194588 mode 0x21b0
xfsdump: dumping special file ino 4194589 mode 0x21b0
xfsdump: dumping special file ino 4194590 mode 0x21b0
xfsdump: dumping special file ino 4194591 mode 0x21b0
xfsdump: dumping special file ino 4194592 mode 0x21b0
xfsdump: dumping special file ino 4194593 mode 0x21b0
xfsdump: dumping special file ino 4194594 mode 0x21b0
xfsdump: dumping special file ino 4194595 mode 0x21b0
xfsdump: dumping special file ino 4194596 mode 0x21b0
xfsdump: dumping special file ino 4194597 mode 0x21b0
xfsdump: dumping special file ino 4194598 mode 0x21b0
xfsdump: dumping special file ino 4194599 mode 0x21b0
xfsdump: dumping special file ino 4194600 mode 0x21b0
xfsdump: dumping special file ino 4194601 mode 0x21b0
xfsdump: dumping special file ino 4194602 mode 0x21b0
xfsdump: dumping special file ino 4194603 mode 0x21b0
xfsdump: dumping special file ino 4194604 mode 0x21b0
xfsdump: dumping special file ino 4194605 mode 0x21b0
xfsdump: dumping special file ino 4194606 mode 0x21b0
xfsdump: dumping special file ino 4194607 mode 0x21b0
xfsdump: dumping special file ino 4194608 mode 0x21b0
xfsdump: dumping special file ino 4194609 mode 0x21b0
xfsdump: dumping special file ino 4194610 mode 0x21b0
xfsdump: dumping special file ino 4194611 mode 0x21b0
xfsdump: dumping special file ino 4194612 mode 0x21b0
xfsdump: dumping special file ino 4194613 mode 0x21b0
xfsdump: dumping special file ino 4194614 mode 0x21b0
xfsdump: dumping special file ino 4194615 mode 0x21b0
xfsdump: dumping special file ino 4194616 mode 0x21b0
xfsdump: dumping special file ino 4194617 mode 0x21b0
xfsdump: dumping special file ino 4194618 mode 0x21b0
xfsdump: dumping special file ino 4194619 mode 0x21b0
xfsdump: dumping special file ino 4194621 mode 0x21b0
xfsdump: dumping special file ino 4194622 mode 0x21b0
xfsdump: dumping special file ino 4194623 mode 0x21b0
xfsdump: dumping special file ino 4194624 mode 0x21b0
xfsdump: dumping special file ino 4194625 mode 0x21b0
xfsdump: dumping special file ino 4194626 mode 0x21b0
xfsdump: dumping special file ino 4194627 mode 0x21b0
xfsdump: dumping special file ino 4194628 mode 0x21b0
xfsdump: dumping special file ino 4194629 mode 0x21b0
xfsdump: dumping special file ino 4194630 mode 0x21b0
xfsdump: dumping special file ino 4194631 mode 0x21b0
xfsdump: dumping special file ino 4194632 mode 0x21b0
xfsdump: dumping special file ino 4194633 mode 0x21b0
xfsdump: dumping special file ino 4194634 mode 0x21b0
xfsdump: dumping special file ino 4194635 mode 0x21b0
xfsdump: dumping special file ino 4194636 mode 0x21b0
xfsdump: dumping special file ino 4194637 mode 0x21b0
xfsdump: dumping special file ino 4194638 mode 0x21b0
xfsdump: dumping special file ino 4194639 mode 0x21b0
xfsdump: dumping special file ino 4194640 mode 0x21b0
xfsdump: dumping special file ino 4194641 mode 0x21b0
xfsdump: dumping special file ino 4194642 mode 0x21b0
xfsdump: dumping special file ino 4194643 mode 0x21b0
xfsdump: dumping special file ino 4194644 mode 0x21b0
xfsdump: dumping special file ino 4194645 mode 0x21b0
xfsdump: dumping special file ino 4194646 mode 0x21b0
xfsdump: dumping special file ino 4194647 mode 0x21b0
xfsdump: dumping special file ino 4194648 mode 0x21b0
xfsdump: dumping special file ino 4194649 mode 0x21b0
xfsdump: dumping special file ino 4194650 mode 0x21b0
xfsdump: dumping special file ino 4194651 mode 0x21b0
xfsdump: dumping special file ino 4194652 mode 0x21b0
xfsdump: dumping special file ino 4194653 mode 0x21b0
xfsdump: dumping special file ino 4194654 mode 0x21b0
xfsdump: dumping special file ino 4194655 mode 0x21b0
xfsdump: dumping special file ino 4194688 mode 0x21b0
xfsdump: dumping special file ino 4194689 mode 0x21b0
xfsdump: dumping special file ino 4194690 mode 0x21b0
xfsdump: dumping special file ino 4194691 mode 0x21b0
xfsdump: dumping special file ino 4194692 mode 0x21b0
xfsdump: dumping special file ino 4194693 mode 0x21b0
xfsdump: dumping special file ino 4194694 mode 0x21b0
xfsdump: dumping special file ino 4194695 mode 0x21b0
xfsdump: dumping special file ino 4194696 mode 0x21b0
xfsdump: dumping special file ino 4194697 mode 0x21b0
xfsdump: dumping special file ino 4194698 mode 0x21b0
xfsdump: dumping special file ino 4194699 mode 0x21b0
xfsdump: dumping special file ino 4194700 mode 0x21b0
xfsdump: dumping special file ino 4194701 mode 0x21b0
xfsdump: dumping special file ino 4194702 mode 0x21b0
xfsdump: dumping special file ino 4194703 mode 0x21b0
xfsdump: dumping special file ino 4194704 mode 0x21b0
xfsdump: dumping special file ino 4194705 mode 0x21b0
xfsdump: dumping special file ino 4194706 mode 0x21b0
xfsdump: dumping special file ino 4194707 mode 0x21b0
xfsdump: dumping special file ino 4194708 mode 0x21b0
xfsdump: dumping special file ino 4194709 mode 0x21b0
xfsdump: dumping special file ino 4194710 mode 0x21b0
xfsdump: dumping special file ino 4194711 mode 0x21b0
xfsdump: dumping special file ino 4194712 mode 0x21b0
xfsdump: dumping special file ino 4194713 mode 0x21b0
xfsdump: dumping special file ino 4194714 mode 0x21b0
xfsdump: dumping special file ino 4194715 mode 0x21b0
xfsdump: dumping special file ino 4194716 mode 0x21b0
xfsdump: dumping special file ino 4194717 mode 0x21b0
xfsdump: dumping regular file ino 4194719 offset 0 to offset 314 (size 314)
xfsdump: dumping regular file ino 4194721 offset 0 to offset 851 (size 851)
xfsdump: dumping regular file ino 4194722 offset 0 to offset 3716 (size 3716)
xfsdump: dumping regular file ino 4194723 offset 0 to offset 1077 (size 1077)
xfsdump: dumping regular file ino 4194724 offset 0 to offset 5568 (size 5568)
xfsdump: dumping regular file ino 4194725 offset 0 to offset 770 (size 770)
xfsdump: dumping regular file ino 4194726 offset 0 to offset 1100 (size 1100)
xfsdump: dumping regular file ino 4194727 offset 0 to offset 1738 (size 1738)
xfsdump: dumping regular file ino 4194728 offset 0 to offset 647 (size 647)
xfsdump: dumping regular file ino 4194730 offset 0 to offset 940 (size 940)
xfsdump: dumping regular file ino 4194731 offset 0 to offset 6747 (size 6747)
xfsdump: dumping regular file ino 4194733 offset 0 to offset 226 (size 226)

Thanks again!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
