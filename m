Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CCAC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 02:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiLTCQ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 21:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiLTCQZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 21:16:25 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D271126
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 18:16:24 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso2239900pjp.4
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 18:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W5Yz3lAUazOMSQo0GFNTX2jFYE/QiLRMNjJTcXm5KQI=;
        b=1rFnAlyTAl+ODNFWprk3Fd75wXRxmfWB/fFN774G8GaecEGWt1PyOny5ID1IIzBQwq
         yvNdR463XCApHdItES+gDF8TXq5/WoB7XbNy4N7r3ZgmQO3jMXp4kYmTs+kuDDLN0xme
         dtI1aqEB6pHUgjjW6yjo6kr0msY0qj0DV4STifc3Xx81KLgErU1+JtjVIlyg4ntgd+vH
         UdQlYyyOfB2wsScYvTZ7RzelBC9f5tAebNZwM5prCbl7ouaBufa7CMpL2u5T9jS6Gvyu
         Wn5clV7D64sJ7clZm0scXBPX0o8fNF4ZjlfcubpzDqqvwLMp4X3oN3C7RZo6hUVjfaje
         q5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W5Yz3lAUazOMSQo0GFNTX2jFYE/QiLRMNjJTcXm5KQI=;
        b=Ozq7waKdkIKvjqgkFD6n7LPL4tzckd8oFzQd1qU/D6u5/fZEHwmkT5AQP8JzT3PXbT
         pOqaul1xUjM1o3nlFC+F7S9uxJpZ7jsFa2FEOqWwFUcI5CGzwnLyt6vGp3M4IO0Rol7o
         +B6kARPxYWPU1qfphulEWAN2rSGrN/iiief+g8AebBTetBZOW5dsYgq/K+8sOwU3s11Q
         QxJb+82w4nIEpdIyOZChb2SjXH5uuhOKgRwhitVZoKuxzt/707uPSZxblao7XcO/Jm7E
         HQwsHR4hz7d/CR/wYWNhq/i/pJ9eFqgygnSGSo7fQkg9bHyf+Nf6m+fEK15ClLHj291i
         HXuw==
X-Gm-Message-State: ANoB5plui5bVGtSlKw/Sc+JqBiiDyQW9fcQpZ0RJacNpwDB73wM8N+zI
        Y58hbIe0VE9jwUpwzT/qmxv1/g==
X-Google-Smtp-Source: AA0mqf6EO43czadE67CNklf0V1C0aw8Kv3f7cM+TnTBj7F0izvoFqaREuqaiwEdl/dQlhdgY+bZGXQ==
X-Received: by 2002:a17:902:efc7:b0:189:812f:48a8 with SMTP id ja7-20020a170902efc700b00189812f48a8mr42048509plb.63.1671502583301;
        Mon, 19 Dec 2022 18:16:23 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id w8-20020a170902e88800b0016f196209c9sm7893172plg.123.2022.12.19.18.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 18:16:22 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p7SB1-00AXIF-3M; Tue, 20 Dec 2022 13:16:19 +1100
Date:   Tue, 20 Dec 2022 13:16:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Terence Kelly <tpkelly@eecs.umich.edu>
Cc:     Suyash Mahar <smahar@ucsd.edu>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Suyash Mahar <suyash12mahar@outlook.com>
Subject: Re: XFS reflink overhead, ioctl(FICLONE)
Message-ID: <20221220021619.GF1971568@dread.disaster.area>
References: <CACQnzjuhRzNruTm369wVQU3y091da2c+h+AfRED+AtA-dYqXNQ@mail.gmail.com>
 <Y5i0ALbAdEf4yNuZ@magnolia>
 <CACQnzjua_0=Nz_gyza=iFVigceJO6Wbzn4X86E2y4N_Od3Yi0g@mail.gmail.com>
 <20221215001944.GC1971568@dread.disaster.area>
 <alpine.DEB.2.22.394.2212151910210.1790310@email.eecs.umich.edu>
 <20221218014649.GE1971568@dread.disaster.area>
 <alpine.DEB.2.22.394.2212180125330.2578935@email.eecs.umich.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.22.394.2212180125330.2578935@email.eecs.umich.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 18, 2022 at 06:40:54PM -0500, Terence Kelly wrote:
> 
> 
> On Sun, 18 Dec 2022, Dave Chinner wrote:
> 
> > > https://www.usenix.org/system/files/conference/fast15/fast15-paper-verma.pdf
> > 
> > Ah, now I get it. You want *anonymous ephemeral clones*, not named
> > persistent clones.  For everyone else, so they don't have to read the
> > paper and try to work it out:
> > 
> > The mechanism is a hacked the O_ATOMIC path ...
> 
> No.  To be clear, nobody now in 2022 is asking for the AdvFS features of the
> FAST 2015 paper to be implemented in XFS (or BtrFS or any other FS).
> 
> The current XFS/BtrFS/Liunux ioctl(FICLONE) is perfect for my current and
> foreseeable needs, except for performance.
> 
> I cited the FAST 2015 paper simply to show that I've worked with a
> clone-based mechanism in the past and it delighted me in every way.  It's
> simply an existence proof that cloning can be delightful for crash
> tolerance.

Sure, you're preaching to the choir. But the context was quoting a
paper as an example of the cloning performance you expected from XFS
but weren't getting. You're still talking about how XFS clones are
too slow for you needs, but now you are saying you don't want
clones for fault tolerance as implemented in advfs

> > Hence the difference in functionality is that FICLONE provides
> > persistent, unrestricted named clones rather than ephemeral clones.
> 
> For the record, the AdvFS implementation of clone-based crash tolerance ---
> the moral equivalent of failure-atomic msync(), which was the topic of my
> EuroSys 2013 paper --- involved persistent files on durable storage; the
> files were hidden and were discarded when their usefulness was over but the
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This is the very definition of an ephemeral filesystem object.

The clones are temporary filesystem objects that exist only within
the context of an active file descriptor, users doesn't know they
exist, users cannot discover their existence, and they get cleaned
up automatically by the filesystem when they are no longer useful.

Yes, there is some persistent state needed to implement the required
garbage collection semantics of the ephemeral object (just like
O_TMPFILE!), but that doesn't change the fact that users don't know
(or care) that the internal filesystem objects even exist.

Really, I can't think of a better example of an ephemeral object
than this, regardless of whether the paper's authors used that term
or not.

> hidden files were not "ephemeral" in the sense of a file in a DRAM-backed
> file system (/tmp/ or /dev/shm/ or whatnot).  AdvFS crash tolerance survived
> real power failures.  But this is a side issue of historical interest only.
>
> I mainly want to emphasize that nobody is asking for the behavior of AdvFS
> in that FAST 2015 paper.

OK, so what are you asking us to do, then?

[....]

> > > https://dl.acm.org/doi/pdf/10.1145/3400899.3400902
> > 
> > Heh. You're still using hardware to do filesystem power fail testing? We
> > moved away from needing hardware to do power fail testing of filesystems
> > several years ago.
> > 
> > Using functionality like dm-logwrites, we can simulate the effect of
> > several hundred different power fail cases with write-by-write replay
> > and recovery in the space of a couple of minutes.
> 
> Cool.  I assume you're familiar with a paper on a similar technique that my
> HP Labs colleagues wrote circa 2013 or 2014:  "Torturing Databases for Fun
> and Profit."

Nope, but it's not a new or revolutionary technique so I'm not
surprised that other people have done similar things. There's been
plenty of research based on model checking over the past 2-3 decades
- the series of Iron Filesystem papers is a good example of this.
What we have in fstests is just a version of these concepts that
simplifies discovering and debugging previously undiscovered write
ordering issues...

> > Not only that, failures are fully replayable and so we can actually
> > debug every single individual failure without having to guess at the
> > runtime context that created the failure or the recovery context that
> > exposed the failure.
> > 
> > This infrastructure has provided us with a massive step forward for
> > improving crash resilence and recovery capability in ext4, btrfs and
> > XFS.  These tests are built into automated tests suites (e.g. fstests)
> > that pretty much all linux fs engineers and distro QE teams run these
> > days.
> 
> If you think the world would benefit from reading about this technique and
> using it more widely, I might be able to help.  My column in _Queue_
> magazine reaches thousands of readers, sometimes tens of thousands.  It's
> about teaching better techniques to working programmers.

You're welcome to do so - the source code is all there, there's a
mailing list for fstests where you can ask questions about it, etc.
If you think it's valuable for people outside the core linux fs
developer community, then you don't need to ask our permission to
write an article on it....

> > > I'm surprised that in XFS, cloning alone *without* fsync() pushes
> > > data down to storage.  I would have expected that the implementation
> > > of cloning would always operate upon memory alone, and that an
> > > explicit fsync() would be required to force data down to durable
> > > media. Analogy:  write() doesn't modify storage; write() plus
> > > fsync() does. Is there a reason why copying via ioctl(FICLONE) isn't
> > > similar?
> > 
> > Because FICLONE provides a persistent named clone that is a fully
> > functioning file in it's own right.  That means it has to be completely
> > indepedent of the source file by the time the FICLONE operation
> > completes.  This implies that there is a certain order to the operations
> > the clone performances - the data has to be on disk before the clone is
> > made persistent and recoverable so that both files as guaranteed to have
> > identical contents if we crash immediately after the clone completes.
> 
> I thought the rule was that if an application doesn't call fsync() or
> msync(), no durability of any kind is guaranteed.

No durability of any kind is guaranteed, but that doesn't preclude
the OS and/or filesystem actually performing an operation in a way
that guarantees persistence....

That said, the FICLONE API doesn't guarantee persistence. The
application still have to call fdatasync() to ensure that all the
metadata changes that FICLONE makes are persisted all the way down
to stable storage.

> I thought modern file
> systems did all their work in DRAM until an explicit fsync/msync or other
> necessity compelled them to push data down to durable media (in the right
> order etc.).

Largely, they do. But some operations have dependencies and require
data/metadata update synchronisation, and at that point we have
ordering constraints. TO an outside observer, that may look like
the filesystem is trying to provide durability, but in fact it is
doing nothing of the sort...

I suspect you've seen the data writeback in FICLONE and thought this
is because it needs to provide a durability guarantee.

For XFS, this is an ordering constrain - we have to ensure the right
thing happens with delayed allocation and resolve pending COW
operations on a file before we clone the extent map to a new file.
We do this by running writeback to process these pending extent map
operations we deferred at write() time. Once those deferred
operations have been resolved, we can run the transactions to clone
the extent map.

However, if FICLONE is acting on files containing only data at rest,
then it can run without doing a single data IO, and the whole clone
can be lost on crash if fdatasync() is not run once it is complete.

IOWs, the FICLONE API provides no persistence guarantees.
fdatasync/O_DSYNC is still required.

> Also, we might be using terminology differently:
> 
> I use "persistent" in the sense of "outlives processes".  Files in /tmp/ and
> /dev/shm/ are persistent, but not durable.

Yeah, different terminology - you seem to have different frames of
reference for the terms you are using.

The frame of reference I'm using for terminology is filesystem
objects rather than processes or storage.  Stuff that exists purely
in memory (such as tmpfs or shm files) is always considered
"volatile" - they are lost if the system crashes or shuts down.
Volatile storage also include caches like dirty data in the page
cache and storage devices with DRAM based caches.

Persistent refers to ensuring filesystem objects are not volatile;
they do not get lost during shutdown or abnormal termination because
they have been guaranteed to exist on a stable, permanent storage
media. 

> I use "durable" to mean "written to non-volatile media (HDD or SSD) in such
> a way as to guarantee that it will survive power cycling."

Sure. We typically refer to non-volatile storage media as "stable
storage" because the hardware can be durable in the short term but
volatile in the long term. e.g. battery backed RAM is considered
"stable" if the battery backup lasts longer than 72 hours, but
over long periods it will not retain it's contents. Hence calling it
"non-volatile media" isn't really correct - the contents are only
stable over a fixed timeframe.

Regardless of terminology, "persisting objects to stable
storage" is effectively the same thing as "making durable".

> I expect *persistence* from ioctl(FICLONE) but I didn't expect a
> *durability* guarantee without fsync().  If I'm understanding you correctly,
> cloning in XFS gives us durability whether we want it or not.

See above. We provide no guarantees about persistence, but in some
cases we can't perform the FICLONE operation correctly without
performing most of the operations needed to provide persistence of
the source file.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
