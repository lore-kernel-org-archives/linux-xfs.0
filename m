Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8F6C4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 23:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiLRXlO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 18:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiLRXlN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 18:41:13 -0500
Received: from newman.eecs.umich.edu (newman.eecs.umich.edu [141.212.113.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD0D63C3
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 15:41:11 -0800 (PST)
Received: from email.eecs.umich.edu (email.eecs.umich.edu [141.212.113.99] (may be forged))
        by newman.eecs.umich.edu (8.15.2/8.14.4) with ESMTPS id 2BINesIN3080355
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sun, 18 Dec 2022 18:40:54 -0500
Received: from email.eecs.umich.edu (localhost [127.0.0.1])
        by email.eecs.umich.edu (8.15.2/8.13.0) with ESMTP id 2BINesgr2812753;
        Sun, 18 Dec 2022 18:40:54 -0500
Received: from localhost (tpkelly@localhost)
        by email.eecs.umich.edu (8.15.2/8.14.4/Submit) with ESMTP id 2BINesC12812749;
        Sun, 18 Dec 2022 18:40:54 -0500
Date:   Sun, 18 Dec 2022 18:40:54 -0500 (EST)
From:   Terence Kelly <tpkelly@eecs.umich.edu>
To:     Dave Chinner <david@fromorbit.com>
cc:     Suyash Mahar <smahar@ucsd.edu>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Suyash Mahar <suyash12mahar@outlook.com>
Subject: Re: XFS reflink overhead, ioctl(FICLONE)
In-Reply-To: <20221218014649.GE1971568@dread.disaster.area>
Message-ID: <alpine.DEB.2.22.394.2212180125330.2578935@email.eecs.umich.edu>
References: <CACQnzjuhRzNruTm369wVQU3y091da2c+h+AfRED+AtA-dYqXNQ@mail.gmail.com> <Y5i0ALbAdEf4yNuZ@magnolia> <CACQnzjua_0=Nz_gyza=iFVigceJO6Wbzn4X86E2y4N_Od3Yi0g@mail.gmail.com> <20221215001944.GC1971568@dread.disaster.area>
 <alpine.DEB.2.22.394.2212151910210.1790310@email.eecs.umich.edu> <20221218014649.GE1971568@dread.disaster.area>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On Sun, 18 Dec 2022, Dave Chinner wrote:

>> https://www.usenix.org/system/files/conference/fast15/fast15-paper-verma.pdf
>
> Ah, now I get it. You want *anonymous ephemeral clones*, not named 
> persistent clones.  For everyone else, so they don't have to read the 
> paper and try to work it out:
>
> The mechanism is a hacked the O_ATOMIC path ...

No.  To be clear, nobody now in 2022 is asking for the AdvFS features of 
the FAST 2015 paper to be implemented in XFS (or BtrFS or any other FS).

The current XFS/BtrFS/Liunux ioctl(FICLONE) is perfect for my current and 
foreseeable needs, except for performance.

I cited the FAST 2015 paper simply to show that I've worked with a 
clone-based mechanism in the past and it delighted me in every way.  It's 
simply an existence proof that cloning can be delightful for crash 
tolerance.

> Hence the difference in functionality is that FICLONE provides 
> persistent, unrestricted named clones rather than ephemeral clones.

For the record, the AdvFS implementation of clone-based crash tolerance 
--- the moral equivalent of failure-atomic msync(), which was the topic of 
my EuroSys 2013 paper --- involved persistent files on durable storage; 
the files were hidden and were discarded when their usefulness was over 
but the hidden files were not "ephemeral" in the sense of a file in a 
DRAM-backed file system (/tmp/ or /dev/shm/ or whatnot).  AdvFS crash 
tolerance survived real power failures.  But this is a side issue of 
historical interest only.

I mainly want to emphasize that nobody is asking for the behavior of AdvFS 
in that FAST 2015 paper.

> We could implement ephemeral clones in XFS, but nobody has ever 
> mentioned needing or wanting such functionality until this thread.

Nobody needs or wants such functionality, even in this thread.  The 
current ioctl(FICLONE) is perfect except for performance.

>> https://dl.acm.org/doi/pdf/10.1145/3400899.3400902
>
> Heh. You're still using hardware to do filesystem power fail testing? 
> We moved away from needing hardware to do power fail testing of 
> filesystems several years ago.
>
> Using functionality like dm-logwrites, we can simulate the effect of 
> several hundred different power fail cases with write-by-write replay 
> and recovery in the space of a couple of minutes.

Cool.  I assume you're familiar with a paper on a similar technique that 
my HP Labs colleagues wrote circa 2013 or 2014:  "Torturing Databases for 
Fun and Profit."

> Not only that, failures are fully replayable and so we can actually 
> debug every single individual failure without having to guess at the 
> runtime context that created the failure or the recovery context that 
> exposed the failure.
>
> This infrastructure has provided us with a massive step forward for 
> improving crash resilence and recovery capability in ext4, btrfs and 
> XFS.  These tests are built into automated tests suites (e.g. fstests) 
> that pretty much all linux fs engineers and distro QE teams run these 
> days.

If you think the world would benefit from reading about this technique and 
using it more widely, I might be able to help.  My column in _Queue_ 
magazine reaches thousands of readers, sometimes tens of thousands.  It's 
about teaching better techniques to working programmers.

I'd be honored to help pass along to my readers practical techniques that 
you're using to improve quality.

> IOWs, hardware based power fail testing of filesystems is largely 
> obsolete these days....

I don't mind telling the world that my own past work is obsolete.  That's 
what progress is all about.

>> I'm surprised that in XFS, cloning alone *without* fsync() pushes data 
>> down to storage.  I would have expected that the implementation of 
>> cloning would always operate upon memory alone, and that an explicit 
>> fsync() would be required to force data down to durable media. 
>> Analogy:  write() doesn't modify storage; write() plus fsync() does. 
>> Is there a reason why copying via ioctl(FICLONE) isn't similar?
>
> Because FICLONE provides a persistent named clone that is a fully 
> functioning file in it's own right.  That means it has to be completely 
> indepedent of the source file by the time the FICLONE operation 
> completes.  This implies that there is a certain order to the operations 
> the clone performances - the data has to be on disk before the clone is 
> made persistent and recoverable so that both files as guaranteed to have 
> identical contents if we crash immediately after the clone completes.

I thought the rule was that if an application doesn't call fsync() or 
msync(), no durability of any kind is guaranteed.  I thought modern file 
systems did all their work in DRAM until an explicit fsync/msync or other 
necessity compelled them to push data down to durable media (in the right 
order etc.).

Also, we might be using terminology differently:

I use "persistent" in the sense of "outlives processes".  Files in /tmp/ 
and /dev/shm/ are persistent, but not durable.

I use "durable" to mean "written to non-volatile media (HDD or SSD) in 
such a way as to guarantee that it will survive power cycling."

I expect *persistence* from ioctl(FICLONE) but I didn't expect a 
*durability* guarantee without fsync().  If I'm understanding you 
correctly, cloning in XFS gives us durability whether we want it or not.

>> Finally I understand your explanation that the cost of cloning is 
>> proportional to the size of the extent map, and that in the limit where 
>> the extent map is very large, cloning a file of size N requires O(N) 
>> time. However the constant factors surprise me.  If memory serves we 
>> were seeing latencies of milliseconds atop DRAM for the first few 
>> clones on files that began as sparse files and had only a few blocks 
>> written to them.  Copying the extent map on a DRAM file system must be 
>> tantamount to a bunch of memcpy() calls (right?),
>
> At the IO layer, yes, it's just a memcpy.
>
> But we can't just copy a million extents from one in-memory btree to 
> another.  We have to modify the filesystem metadata in an atomic, 
> transactional, recoverable way. Those transactions work one extent at a 
> time because each extent might require a different set of modifications.

Ah, so now I see where the time goes.  This is clear.

> Persistent clones require tracking of the number of times a given block 
> on disk is shared so that we know when extent removals result in the 
> extent no longer being shared and/or referenced. A file that has been 
> cloned a million times might have a million extents each shared a 
> different number of times. When we remove one of those clones, how do we 
> know which blocks are now unreferenced and need to be freed?
>
> IOWs, named persistent clones are *much more complex* than ephemeral 
> clones.

Again, I don't know where you're getting "ephemeral" from; that word does 
not appear in the FAST '15 paper.  The AdvFS clones of the FAST '15 paper 
were both durable and persistent; they were just hidden from the 
user-visible namespace.  A crash (power outage or whatever ) caused a file 
to revert to the most recent hidden clone.  In AdvFS, a hidden clone was 
created by an fsync/msync call.  This is how AdvFS made file updates 
failure-atomic.

Again, we're not asking for the same functionality of the FAST '15 paper.

However if the contrast between what AdvFS did with clones and how XFS 
works illuminates issues like XFS performance, then it might be worth 
understanding AdvFS.

Incidentally, I really appreciate the time & effort you're taking to 
educate me & Suyash.  I hope I'm not being too sluggish a student, though 
sometimes I am.

For the near term, Suyash and I are getting closer to an understanding of 
today's ioctl(FICLONE) that we can pass along to readers in the paper 
we're writing.

> The overhead you are measuring is the result of all the persistent cross 
> referencing and reference counting metadata we need to atomically update 
> on each extent sharing operation ensure long term persistent clones work 
> correctly.

This is clear.  Thanks.

> If we were to implement ephemeral clones as per the mechanism you've 
> outlined in the papers above, then we could just copy the in-memory 
> extent list btree with a series of memcpy() operations because we don't 
> need persistent on-disk shared reference counting to implement it....

We're not on the same page about what AdvFS did.

Of course I'll understand if you don't have time or interest to get on the 
same page; we understand that you're busy with a lot of important work.

Thanks for your help and Happy Holidays!

> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

