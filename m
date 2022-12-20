Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38561C4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 03:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiLTDGX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 22:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbiLTDGW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 22:06:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF9BE58
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 19:06:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54FA0B80B4A
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 03:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0761C433D2;
        Tue, 20 Dec 2022 03:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671505577;
        bh=UEtDpqnd/sK2y1hSkcTfEUNQv7SIXFA99fT3otbULew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rFqA4w7L8YYnn0nvarHN+hpzGQ0mN7QFb4g6S0HWSWDhVA7vdzik81d2RjREUiMGY
         h4K715akxpQNxiADqRSwtgQ81f8XpPd9FWmWfKXAJmChHQEaINYan14ZkbWUq2O1Ev
         RhyWwxgf6tgYUqrEBdniA22oa7melrcKziHxL84w6eIv2NTMRlNiDUe+4XxETdqP77
         dFQJbyh6IZRcBijhBAGvFTNEvMQw8fR/lHBC5afBtLcXE+dNB6r+vZld+dNBQYoi3G
         UdxWhHrmFxOBdbYpHYqYYH1YPq3WgpGtlCQ+NoZuWXOQnxg7a3XNl73cGqdJQbojQc
         Gn0rb4PWKHaYA==
Date:   Mon, 19 Dec 2022 19:06:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Suyash Mahar <smahar@ucsd.edu>
Cc:     Dave Chinner <david@fromorbit.com>,
        Terence Kelly <tpkelly@eecs.umich.edu>,
        linux-xfs@vger.kernel.org, Suyash Mahar <suyash12mahar@outlook.com>
Subject: Re: XFS reflink overhead, ioctl(FICLONE)
Message-ID: <Y6EmqMD9v7J3R2k1@magnolia>
References: <CACQnzjuhRzNruTm369wVQU3y091da2c+h+AfRED+AtA-dYqXNQ@mail.gmail.com>
 <Y5i0ALbAdEf4yNuZ@magnolia>
 <CACQnzjua_0=Nz_gyza=iFVigceJO6Wbzn4X86E2y4N_Od3Yi0g@mail.gmail.com>
 <20221215001944.GC1971568@dread.disaster.area>
 <alpine.DEB.2.22.394.2212151910210.1790310@email.eecs.umich.edu>
 <20221218014649.GE1971568@dread.disaster.area>
 <CACQnzjtPXY=8nj0H+x+qdR7B=f+m4xgvFzc2LST+=KcMQkL9bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACQnzjtPXY=8nj0H+x+qdR7B=f+m4xgvFzc2LST+=KcMQkL9bg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Dec 17, 2022 at 08:47:45PM -0800, Suyash Mahar wrote:
> Thank you for the detailed response. This does confirm some of our
> observations that the overhead is mainly from the software layer. We
> did see better performance from optimization in the transaction code
> moving from kernel v5.4 to v5.18.
> 
> -Suyash
> 
> Le sam. 17 déc. 2022 à 17:46, Dave Chinner <david@fromorbit.com> a écrit :
> >
> > On Thu, Dec 15, 2022 at 08:06:18PM -0500, Terence Kelly wrote:
> > >
> > > Hi Dave,
> > >
> > > Thanks for your quick and detailed reply.  More inline....
> > >
> > > On Thu, 15 Dec 2022, Dave Chinner wrote:
> > >
> > > > > Regardless of the block device (the plot includes results for optane
> > > > > and RamFS), it seems like the ioctl(FICLONE) call is slow.
> > > >
> > > > Please define "slow" - is it actually slower than it should be (i.e. a
> > > > bug) or does it simply not perform according to your expectations?
> > >
> > > I was surprised that on a DRAM-backed file system the ioctl(FICLONE) took
> > > *milli*seconds right from the start, and grew to *tens* of milliseconds.
> > > There's no slow block storage device to increase latency; all of the latency
> > > is due to software.  I was expecting microseconds of latency with DRAM
> > > underneath.
> >
> > Ah - slower than expectations then, and you have unrealistic
> > expectations about how "fast" DRAM is.
> >
> > From a storage engineer's perspective, DRAM is slow compared to nvme
> > based flash storage - DRAM has better access latency, but on all
> > other aspects of storage performance and capability, it falls way
> > behind pcie attached storage because the *CPU time* is the limiting
> > factor in storage performance these days, not storage device speed.
> >
> > The problem with DRAM based storage (and DAX in general) is that
> > data movement is run by the CPU - it's synchronous storage.
> > Filesystems like XFS are built around highly concurrent pipelined
> > asynchronous IO hardware. Filesystems are capable of keeping
> > thousands of IOs in flight *per CPU*, but on synchronous storage
> > like DRAM we can only have *1 IO per CPU* in flight at any given
> > time.
> >
> > Hence when we compare synchronous write performance, DRAM is fast
> > compared to SSDs. When we use async IO (AIO+DIO or io_uring), the
> > numbers go the other way and SSDs come out further in front the more
> > of them you attach to the system. DRAM based IO doesn't get any
> > faster because it still can only process one IO at a time, whilst
> > *each SSD* can process 100+ IOs at a time.
> >
> > IOWs, for normal block based storage we only use the CPU to marshall
> > the data movement in the system, and the hardware takes care of the
> > data movement. i.e. DMA-based storage devices are a hardware offload
> > mechanism. DRAM based storage relies on the CPU to move data, and so
> > we use all the time that the CPU could be sending IO to the hardware
> > to move data in DRAM from A to B.
> >
> >
> > Put simply: DRAM can only be considered fast if your application
> > does (or is optimised for) synchronous IO. For all other uses, DRAM
> > based storage is a poor choice.

Oh, it's worse than that -- since you're using 5.18 with reflink
enabled, DAX will always yield to reflink.  IOWs, the random writes are
done to the pagecache, so the implied fdatasync in the FICLONE
preparation also has to *copy* the dirty pagecache to the pmem.

It would at least be interesting (a) to bump to 6.2, and (b) stuff an
fsync(src_fd) call in before you start timing the FICLONE to see what
proportion of the clone time was actually just pagecache maneuvers.

> > > Performance matters because cloning is an excellent crash-tolerance
> > > mechanism.
> >
> > Guaranteeing filesystem and data integrity is our primary focus when
> > building infrastructure that can be used for crash-tolerance
> > mechanisms...
> >
> > > Applications that maintain persistent state in files --- that's
> > > a huge number of applications --- can make clones of said files and recover
> > > from crashes by reverting to the most recent successful clone.
> >
> > ... and that's the data integrity guarantee that the filesystem
> > *must* provide the application.
> >
> > > In many
> > > situations this is much easier and better than shoe-horning application data
> > > into something like an ACID-transactional relational database or
> > > transactional key-value store.
> >
> > Of course. But that doesn't mean the need for ACID-transactional
> > database functionality goes away.  We've just moved that
> > functionality into the filesystem to implement FICLONE
> > functionality.
> >
> > > But the run-time cost of making a clone
> > > during failure-free operation can't be excessive.
> >
> > Define "excessive".
> >
> > Our design constraints were that FICLONE had to be faster than
> > copying the data, and needed to have fixed cost per shared extent
> > reference modification or better so that it could scale to millions
> > of extents without bringing the filesystem, storage and/or system
> > to it's knees when someone tried to do that.
> >
> > Remember - extent sharing and clones were retrofitted to XFS 20
> > years after it was designed. We had to make lots of compromises
> > just to make it work correctly, let alone acheive the performance
> > requirements we set a decade ago.
> >
> > > Cloning for crash
> > > tolerance usually requires durable media beneath the file system (HDD or
> > > SSD, not DRAM), so performance on block storage devices matters too.  We
> > > measured performance of cloning atop DRAM to understand how much latency is
> > > due to block storage hardware vs. software alone.
> >
> > Cloning is a CPU intensive operation, not an IO intensive operation.
> > What you are measuring is *entirely* the CPU overhead of doing all
> > the transactions and cross-referencing needed to track extent
> > sharing in a manner that is crash consistent, atomic and fully
> > recoverable.
> >
> > > My colleagues and I started working on clone-based crash tolerance
> > > mechanisms nearly a decade ago.  Extensive experience with cloning and
> > > related mechanisms in the HP Advanced File System (AdvFS), a Linux port of
> > > the DEC Tru64 file system, taught me to expect cloning to be *faster* than
> > > alternatives for crash tolerance:
> >
> > Cloning files on XFSi and btrfs is still much faster than the
> > existing safe overwrite mechanism of {create a whole new data copy,
> > fysnc, rename, fsync}. So I'm not sure what you're actually
> > complaining about here.
> >
> >
> > > https://urldefense.com/v3/__https://www.usenix.org/system/files/conference/fast15/fast15-paper-verma.pdf__;!!Mih3wA!AwAzZFK3qihFyPfIfwMf5quwRDqABL90i9zLcTfSWLBfwrxWyzUNT1Hj49btqv4v1RtiOx_IkjbSIg$
> >
> > Ah, now I get it. You want *anonymous ephemeral clones*, not named
> > persistent clones.  For everyone else, so they don't have to read
> > the paper and try to work it out:
> >
> > The mechanism is a hacked the O_ATOMIC path to instantiate a whole
> > new cloned inode which is linked into a hidden namespace in the
> > filesystem so the user can't see it but so it is present after a
> > crash.
> >
> > It doesn't track the cloned extents in a persistent index, the
> > hidden file simply shares the same block map on disk and the sharing
> > is tracked in memory. After a crash, nothing is done with this until
> > the original file is instantiated in memory. At this point, the
> > hidden clone file(s) are then accessed and the shared state is
> > recovered in memory and decisions are made about which contains the
> > most recent data are made.
> >
> > The clone is only present while the fd returned by the
> > open(O_ATOMIC) is valid. On close(), the clone is deleted and all
> > the in-memory and hidden on-disk state is torn down. Effectively,
> > the close() operation becomes an unlink().
> >
> > Further, a new syscall (called syncv()) takes a vector of these
> > O_ATOMIC cloned file descriptors is added. THis syscall forces the
> > filesystem to make the inode -metadata- persistent without requiring
> > data modifications to be persistent. This allows the ephemeral
> > clones to be persisted without requiring the data in the original
> > file to be writtent to disk. At this point, we have a hidden clone
> > with a matching block map that can be used for crash recovery
> > purposes.
> >
> > This clone mechanism in advfs is limited by journal size - 256
> > clones per 128MB journal space due to reservation space needed for
> > clone deletes.
> >
> > ----
> >
> > So my reading of this paper is that the "file clone operation"
> > essentially creates an ephemeral clone rather than a persistent named
> > clones. I think they are more equivalent to ephemeral tmp files
> > than FICLONE. That is, we use open(O_TMPFILE) to create an
> > ephemeral temporary file attached to a file descriptor instead of
> > requiring userspace to create a /tmp/tmp.xxxxxxxxx filei and then
> > unlinking it and holding the fd open or relying on /tmp being
> > volatile or cleaned at boot to remove tmpfiles on crash.
> >
> > Hence the difference in functionality is that FICLONE provides
> > persistent, unrestricted named clones rather than ephemeral clones.
> >
> >
> > We could implement ephemeral clones in XFS, but nobody has ever
> > mentioned needing or wanting such functionality until this thread.
> > Darrick already has patches to provide an internal hidden
> > persistent namespace for XFS filesystems, we could add a new O_CLONE
> > open flag that provides ephemeral clone behaviour, we could add a
> > flag to the inode to indicate it has ephemeral clones that need
> > recovery on next acces, add in-memory tracking of ephemeral shared extents to trigger
> > COW instead of overwrite in place, etc. It's just a matter of time
> > and resources.

<cough> The bits needed for atomic file commits have been out for review
on fsdevel since **before the COVID19 pandemic started**.  It's buried
in the middle of the online repair featureset.

Summary of the usage model:

fd = open(sourcefile...)
tmp_fd = open(..., O_TMPFILE)

ioctl(tmp_fd, FICLONE, fd);	/* clone data to temporary file */

/* write whatever you want to the temporary file */

ioctl(fd, FIEXCHANGE_RANGE, {tmp_fd, file range...}) /* durable commit */

close(tmp_fd)

True, this isn't an ephemeral file -- for such a thing, we could just
duplicate the in-memory data fork and never commit it to disk.  But that
said, I've been trying to get the parts I /have/ built merged for three
years.

I'm planning to push the whole giant thing to the list on Thursday.

--D

> > If you've got resources available to implement this, I can find the
> > time to help design and integrate it into the VFS and XFS....
> >
> > > The point I'm trying to make is:  I'm a serious customer who loves cloning
> > > and my performance expectations aren't based on idle speculation but on
> > > experience with other cloning implementations.  (AdvFS is not open source
> > > and I'm no longer an HP employee, so I no longer have access to it.)
> > >
> > > More recently I torture-tested XFS cloning as a crash-tolerance mechanism by
> > > subjecting it to real whole-system power interruptions:
> > >
> > > https://urldefense.com/v3/__https://dl.acm.org/doi/pdf/10.1145/3400899.3400902__;!!Mih3wA!AwAzZFK3qihFyPfIfwMf5quwRDqABL90i9zLcTfSWLBfwrxWyzUNT1Hj49btqv4v1RtiOx_th521GQ$
> >
> > Heh. You're still using hardware to do filesystem power fail
> > testing?  We moved away from needing hardware to do power fail
> > testing of filesystems several years ago.
> >
> > Using functionality like dm-logwrites, we can simulate the effect of
> > several hundred different power fail cases with write-by-write
> > replay and recovery in the space of a couple of minutes.
> >
> > Not only that, failures are fully replayable and so we can actually
> > debug every single individual failure without having to guess at the
> > runtime context that created the failure or the recovery context
> > that exposed the failure.i
> >
> > This infrastructure has provided us with a massive step forward for
> > improving crash resilence and recovery capability in ext4, btrfs and
> > XFS.  These tests are built into automated tests suites (e.g.
> > fstests) that pretty much all linux fs engineers and distro QE teams
> > run these days.
> >
> > IOWs, hardware based power fail testing of filesystems is largely
> > obsolete these days....
> >
> > > I'm surprised that in XFS, cloning alone *without* fsync() pushes data down
> > > to storage.  I would have expected that the implementation of cloning would
> > > always operate upon memory alone, and that an explicit fsync() would be
> > > required to force data down to durable media.  Analogy:  write() doesn't
> > > modify storage; write() plus fsync() does.  Is there a reason why copying
> > > via ioctl(FICLONE) isn't similar?
> >
> > Because FICLONE provides a persistent named clone that is a fully
> > functioning file in it's own right.  That means it has to be
> > completely indepedent of the source file by the time the FICLONE
> > operation completes.  This implies that there is a certain order to
> > the operations the clone performances - the data has to be on disk
> > before the clone is made persistent and recoverable so that both
> > files as guaranteed to have identical contents if we crash
> > immediately after the clone completes.
> >
> > > Finally I understand your explanation that the cost of cloning is
> > > proportional to the size of the extent map, and that in the limit where the
> > > extent map is very large, cloning a file of size N requires O(N) time.
> > > However the constant factors surprise me.  If memory serves we were seeing
> > > latencies of milliseconds atop DRAM for the first few clones on files that
> > > began as sparse files and had only a few blocks written to them.  Copying
> > > the extent map on a DRAM file system must be tantamount to a bunch of
> > > memcpy() calls (right?),
> >
> > At the IO layer, yes, it's just a memcpy.
> >
> > But we can't just copy a million extents from one in-memory btree to
> > another. We have to modify the filesystem metadata in an atomic,
> > transactional, recoverable way. Those transactions work one extent
> > at a time because each extent might require a different set of
> > modifications. Persistent clones require tracking of the number of
> > times a given block on disk is shared so that we know when extent
> > removals result in the extent no longer being shared and/or
> > referenced. A file that has been cloned a million times might have
> > a million extents each shared a different number of times. When we
> > remove one of those clones, how do we know which blocks are now
> > unreferenced and need to be freed?
> >
> > IOWs, named persistent clones are *much more complex* than ephemeral
> > clones. The overhead you are measuring is the result of all the
> > persistent cross referencing and reference counting metadata we need
> > to atomically update on each extent sharing operation ensure long
> > term persistent clones work correctly.
> >
> > If we were to implement ephemeral clones as per the mechanism you've
> > outlined in the papers above, then we could just copy the in-memory
> > extent list btree with a series of memcpy() operations because we
> > don't need persistent on-disk shared reference counting to implement
> > it....
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
