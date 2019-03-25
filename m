Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:42333 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729728AbfCYR4p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Mar 2019 13:56:45 -0400
MIME-Version: 1.0
References: <CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com>
 <20190325001044.GA23020@dastard> <CAOQ4uxhu=Qtme9RJ7uZXYXt0UE+=xD+OC4gQ9EYkDC1ap8Hizg@mail.gmail.com>
 <20190325154731.GT1183@magnolia>
In-Reply-To: <20190325154731.GT1183@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 25 Mar 2019 19:56:33 +0200
Message-ID: <CAOQ4uxjh2w3PeyftwJS5djndVp0kSRwf9ki1FUMRqCU9H+uDTg@mail.gmail.com>
Subject: Re: [QUESTION] Long read latencies on mixed rw buffered IO
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

[...]

> > > i.e. XFS was designed with the intent that buffered writes are
> > > atomic w.r.t. to all other file accesses. That's not to say we can't
> > > change it, just that it has always been different to what linux
> > > native filesystems do. And depending on which set of application
> > > developers you talk to, you'll get different answers as to whether
> > > they want write()s to be atomic....
> > >
> >
> > All right. I am reading the above as no prior objection to adding
> > an XFS mount option and/or preadv2() flag to opt out of this
> > behavior
>
> Reads and writes are not the only thing xfs uses i_rwsem to synchronise.
> Reflink remap uses it to make sure everything's flushed to disk and that
> page cache contents remain clean while the remap is ongoing.  I'm pretty
> sure pnfs uses it for similar reasons when granting and committing write
> leases.
>

OK. If it wasn't clear, I wasn't suggesting to remove i_rwsem around
buffered writes. All fs must take exclusive i_rwsem around write_begin()
and write_end() and for fs that call generic_file_write_iter()  i_rwsem
is held throughout the buffered write.

What I said is that no other fs holds a shared i_rwsem around
generic_file_read_iter(), so this shared lock could perhaps be removed
without implications beyond atomic rd/wr and sync with dio.

FWIW, I ran a sanity -g quick run with 1k and 4k block sizes without
the shared i_rwsem lock around  generic_file_read_iter() and it did not
barf.

> > and align with the reckless behavior of the other local
> > filesystems on Linux.
> > Please correct me if I am wrong and I would like to hear what
> > other people thing w.r.t mount option vs. preadv2() flag.
> > It could also be an open flag, but I prefer not to go down that road...
>
> I don't like the idea of adding a O_BROKENLOCKINGPONIES flag because it
> adds more QA work to support a new (for xfs) violation of the posix spec
> we (supposedly) fulfill.
>

Surely, there is no reason for you to like a larger test matrix, but
if it turns up that there is no magic fix, I don't see an alternative.
Perhaps application opt-in via RWF_NOATOMIC would have the least
impact on test matrix. It makes sense for applications that know
they handle IO concurrency on higher level, or applications that
know they only need page size atomicity.

> If rw_semaphore favors writes too heavily, why not fix that?
>

Sure, let's give that a shot. But allow me to stay skeptical, because
I don't think there is a one-size-fits-all solution.
If application doesn't need >4K atomicity and xfs imposes file-wide
read locks, there is bound to exist a workload where ext4 can guaranty
lower latencies than xfs.

Then again, if we fix rw_semaphore to do a good enough job for my
workload, I may not care about those worst case workloads...

Thanks,
Amir.
