Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54158 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbeBZR0I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Feb 2018 12:26:08 -0500
Date: Mon, 26 Feb 2018 09:26:01 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Reflink (cow) copy of busy files
Message-ID: <20180226172601.GC19312@magnolia>
References: <20180224220757.GC30854@dastard>
 <711dd96e3c4b3e92d3fb38a01e77dc64@assyoma.it>
 <20180225024727.GD30854@dastard>
 <25ebcdb42650430d83d283435053efed@assyoma.it>
 <20180225211309.GF30854@dastard>
 <d105d0000652be75774cc1f5f23eae68@assyoma.it>
 <20180226002533.GG30854@dastard>
 <6eacd8faae2779b8dfb62fb0d65a9411@assyoma.it>
 <CAOQ4uxixAP6F8f6hT5VENQLD0o_3Bym6pkAJhXva5b99BhE9Eg@mail.gmail.com>
 <73ef828837683073feb1c49e3405dd6a@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73ef828837683073feb1c49e3405dd6a@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Feb 26, 2018 at 09:26:14AM +0100, Gionatan Danti wrote:
> Hi Amir,
> 
> Il 26-02-2018 08:58 Amir Goldstein ha scritto:
> >
> >Gionatan,
> >
> >First of all, the answer to your question is "just" faster copy.
> >reflinkning a file is much faster than copy, but it is not O(1).
> >I believe cp --reflink can result in cloning part of the file if the
> >system
> >crashes mid operation, so in any case, the operation is not *atomic*
> >in that sense.
> >
> >But your questions about quiescence the filesystem and your question
> >about the *atomic* nature of the clone operation are two very different
> >questions.
> 
> can this result on out-of-order writes from the cloned file's point of view?
> I mean:
> - take a 10-extents file;
> - a vm/db/whatever is writing to the file;
> - a cp --reflink is executed;
> - extents are cloned one-by-one, with extents 1-4 alredy cloned, 5 is in
> progress;
> - the vm/db writes to extent n.1 - this write will *not* be present on the
> cloned file;
> - application writes to extent n.6 which will be cloned shortly;
> - the cloned file ends with the later write to extent n.6 but not the
> previous on extent n.1;
> - bad things happen!
> 
> If the above is true, than cp --reflink can't be used even for
> relaxed-consistency backup/clones.
> 
> >What you seem to *think* xfs reflink does, it does not actually do.
> >xfs reflink does NOT reflink the file in-memory data.
> >xfs reflink "only" reflinks the file on-disk data.
> >Right now, if you write a large file without fsync and clone it, you
> >might as well get a clone of unallocated or partly fallocated file with
> >zero or stale data.
> 
> Oh, I absolutely do not expect for reflink/clone to works on in-memory data.
> I *surely* expect for dirty, not commited data to be lost: this is the very
> reason I wrote about crash-consistent backup.
> 
> In short: is cloning/reflink the same as "pulling the plug" for the cloned
> file? I mean:
> - a successfull clone (so, a non-interruped/crashed one) is akin to an
> atomic process for the cloned file;
> - async writes/dirty data are lost;
> - fsynced writes are preserved;
> - writes are not reordered/commited out of order.
> 
> Maybe the entire discussion is skewed by the fact that, in some cases, I am
> willing to relax my consistency model to include a crash-consistent backup
> option. Fact is, in the virtualization world there are many backup
> utilities/applications which *use* this model, and I wondered if a cp
> --reflink would give similar results without the hassle.
> 
> Maybe the entire crash-vs-application consistency is out of place in a
> filesystem mailing list, where you (rightfully!!!) strive for
> perfect/maximum data consistency (and I *really* appreciate that). Hoewever,
> given the recent reflinking works on XFS, I wonder if I can put this to
> "good use" when it is considered stable.

The way reflink is supposed to work wrt consistency is:

1. lock out all new io/fallocate activity on both inodes (iolock/mmaplock)
2. wait for all directio to complete
3. fsync both files (write all the dirty pagecache to disk)
4. lock both inodes (ilock)
5. clone each extent atomically
6. unlock ilock
7. unlock iolock/mmaplock

So at least in theory the cloned file will match whatever the host saw
on disk and page cache at the time the reflink call was initiated.
I say 'in theory' because there could be bugs.

Whatever dirty state is in the guest VM stays in that VM, which means
that if you only cp --reflink on the host, the clone you get will
reflect the virtual disk state as if you'd kill -9'd the VM, cloned the
VM disk, and restarted the VM.  Upon restart the log recovers whatever
metadata made it out of the VM.

However, if you tell the guest to freeze the fs before cloning (as Dave
suggested earlier) the guest will flush all its state to the upper level
(the host) and the host will push all that out to disk before cloning.
The snapshot you create should be cleaner because you're effectively
prepaying the recovery costs by flushing everything before taking the
snapshot.

Also note that if the host goes down before returning from the syscall,
the log will continue on with whichever extent was being cloned at the
time in order to preserve metadata integrity, but the destination file
will reflect a partial copy.

--D

> >Going forward, I think there is an intention to "clone" the file in-memory
> >data as well by sharing the READONLY cache pages between cloned files,
> >but I don't think dirty pages are going be shared between clones anyway,
> >so you are back to square one - need to get the data on-disk before
> >cloning
> >the file.
> 
> Great - I think this would do wonders for cache efficiency...
> 
> >
> >Cheers,
> >Amir.
> 
> Thanks.
> 
> PS: sorry if I rephrase the question in different terms. English is not my
> primary language, please bear with me :p
> 
> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
