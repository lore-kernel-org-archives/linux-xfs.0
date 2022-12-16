Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D81C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Dec 2022 01:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiLPBGj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Dec 2022 20:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLPBGh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2022 20:06:37 -0500
Received: from newman.eecs.umich.edu (newman.eecs.umich.edu [141.212.113.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3A457B68
        for <linux-xfs@vger.kernel.org>; Thu, 15 Dec 2022 17:06:35 -0800 (PST)
Received: from email.eecs.umich.edu (email.eecs.umich.edu [141.212.113.99] (may be forged))
        by newman.eecs.umich.edu (8.15.2/8.14.4) with ESMTPS id 2BG16IuC2912583
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 15 Dec 2022 20:06:18 -0500
Received: from email.eecs.umich.edu (localhost [127.0.0.1])
        by email.eecs.umich.edu (8.15.2/8.13.0) with ESMTP id 2BG16IhA1842493;
        Thu, 15 Dec 2022 20:06:18 -0500
Received: from localhost (tpkelly@localhost)
        by email.eecs.umich.edu (8.15.2/8.14.4/Submit) with ESMTP id 2BG16IoG1842490;
        Thu, 15 Dec 2022 20:06:18 -0500
Date:   Thu, 15 Dec 2022 20:06:18 -0500 (EST)
From:   Terence Kelly <tpkelly@eecs.umich.edu>
To:     Dave Chinner <david@fromorbit.com>
cc:     Suyash Mahar <smahar@ucsd.edu>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Suyash Mahar <suyash12mahar@outlook.com>
Subject: Re: XFS reflink overhead, ioctl(FICLONE)
In-Reply-To: <20221215001944.GC1971568@dread.disaster.area>
Message-ID: <alpine.DEB.2.22.394.2212151910210.1790310@email.eecs.umich.edu>
References: <CACQnzjuhRzNruTm369wVQU3y091da2c+h+AfRED+AtA-dYqXNQ@mail.gmail.com> <Y5i0ALbAdEf4yNuZ@magnolia> <CACQnzjua_0=Nz_gyza=iFVigceJO6Wbzn4X86E2y4N_Od3Yi0g@mail.gmail.com> <20221215001944.GC1971568@dread.disaster.area>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Hi Dave,

Thanks for your quick and detailed reply.  More inline....

On Thu, 15 Dec 2022, Dave Chinner wrote:

>> Regardless of the block device (the plot includes results for optane 
>> and RamFS), it seems like the ioctl(FICLONE) call is slow.
>
> Please define "slow" - is it actually slower than it should be (i.e. a 
> bug) or does it simply not perform according to your expectations?

I was surprised that on a DRAM-backed file system the ioctl(FICLONE) took 
*milli*seconds right from the start, and grew to *tens* of milliseconds. 
There's no slow block storage device to increase latency; all of the 
latency is due to software.  I was expecting microseconds of latency with 
DRAM underneath.

Performance matters because cloning is an excellent crash-tolerance 
mechanism.  Applications that maintain persistent state in files --- 
that's a huge number of applications --- can make clones of said files and 
recover from crashes by reverting to the most recent successful clone. 
In many situations this is much easier and better than shoe-horning 
application data into something like an ACID-transactional relational 
database or transactional key-value store.  But the run-time cost of 
making a clone during failure-free operation can't be excessive.  Cloning 
for crash tolerance usually requires durable media beneath the file system 
(HDD or SSD, not DRAM), so performance on block storage devices matters 
too.  We measured performance of cloning atop DRAM to understand how much 
latency is due to block storage hardware vs. software alone.

My colleagues and I started working on clone-based crash tolerance 
mechanisms nearly a decade ago.  Extensive experience with cloning and 
related mechanisms in the HP Advanced File System (AdvFS), a Linux port of 
the DEC Tru64 file system, taught me to expect cloning to be *faster* than 
alternatives for crash tolerance:

https://www.usenix.org/system/files/conference/fast15/fast15-paper-verma.pdf

https://web.eecs.umich.edu/~tpkelly/papers/HPL-2015-103.pdf

The point I'm trying to make is:  I'm a serious customer who loves cloning 
and my performance expectations aren't based on idle speculation but on 
experience with other cloning implementations.  (AdvFS is not open source 
and I'm no longer an HP employee, so I no longer have access to it.)

More recently I torture-tested XFS cloning as a crash-tolerance mechanism 
by subjecting it to real whole-system power interruptions:

https://dl.acm.org/doi/pdf/10.1145/3400899.3400902

I performed these correctness tests before making any performance 
measurements because I don't care how fast a mechanism is if it doesn't 
correctly tolerate crashes.  XFS passed the power-fail tests with flying 
colors.  Now it's time to consider performance.

I'm surprised that in XFS, cloning alone *without* fsync() pushes data 
down to storage.  I would have expected that the implementation of cloning 
would always operate upon memory alone, and that an explicit fsync() would 
be required to force data down to durable media.  Analogy:  write() 
doesn't modify storage; write() plus fsync() does.  Is there a reason why 
copying via ioctl(FICLONE) isn't similar?

Finally I understand your explanation that the cost of cloning is 
proportional to the size of the extent map, and that in the limit where 
the extent map is very large, cloning a file of size N requires O(N) time. 
However the constant factors surprise me.  If memory serves we were seeing 
latencies of milliseconds atop DRAM for the first few clones on files that 
began as sparse files and had only a few blocks written to them.  Copying 
the extent map on a DRAM file system must be tantamount to a bunch of 
memcpy() calls (right?), and I'm surprised that the volume of data that 
must be memcpy'd is so large that it takes milliseconds.

We might be able to take some of the additional measurements you suggested 
during/after the holidays.

Thanks again.

> A few things that you can quantify to answer these questions.
>
> ...

