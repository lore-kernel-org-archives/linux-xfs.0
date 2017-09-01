Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751862AbdIAKqh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Sep 2017 06:46:37 -0400
Date: Fri, 1 Sep 2017 06:46:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170901104635.GC28241@bfoster.bfoster>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com>
 <20170831134722.GA6912@lst.de>
 <CAOQ4uxgrdijqVpFm+rZ4JE_ZY0A_CZdSPHQEb8S1_R_dyJYzSg@mail.gmail.com>
 <20170831163954.GH21939@bfoster.bfoster>
 <CAOQ4uxisPbcoNp8N8Y4yGdWDBfZ=PR7CgkKGbLGS6cbU6bx2rw@mail.gmail.com>
 <20170831201048.GA25053@bfoster.bfoster>
 <CAOQ4uxjv8dJarUaOExk-kvvY16qnC7wvvriJKBQDTGc3hVVPSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjv8dJarUaOExk-kvvY16qnC7wvvriJKBQDTGc3hVVPSg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, "stable [v4.9]" <stable@vger.kernel.org>

On Fri, Sep 01, 2017 at 10:58:43AM +0300, Amir Goldstein wrote:
> On Thu, Aug 31, 2017 at 11:10 PM, Brian Foster <bfoster@redhat.com> wrote:
> > On Thu, Aug 31, 2017 at 10:20:19PM +0300, Amir Goldstein wrote:
> >> On Thu, Aug 31, 2017 at 7:39 PM, Brian Foster <bfoster@redhat.com> wrote:
> ...
> >> > If we do something
> >> > like the above, I wonder if that means we could wait for the submit ==
> >> > complete if we observe submit was bumped since it was initially sampled
> >> > above (rather than issue another flush, which would be necessary if a
> >> > submit hadn't occurred))..?
> >> >
> >> > If we do end up with something like this, I think it's a bit cleaner to
> >> > stuff the counter(s) in the xfs_buftarg structure and update them from
> >> > the generic buffer submit/completion code based on XBF_FLUSH. FWIW, I
> >> > suspect we could also update said counter(s) from
> >> > xfs_blkdev_issue_flush().
> >> >
> >>
> >> I think what you are suggesting is to optimize more cases which are
> >> not optimized now. That is probably possible, but also more complicated
> >> to get right and not sure if the workloads that gain from this are important
> >> enough.
> >>
> >
> > Not necessarily. I'm just suggesting that the code could be factored
> > more generically/elegantly such that the logic is easier to follow. That
> > may facilitate optimizing more cases, but that's a secondary benefit. In
> > practice, the log buffer code is the only place we actually set
> > XBF_FLUSH, for example.
> >
> 
> I guess that makes sense.
> Although it is going to end up with more code, so if we are not going for
> optimization for more cases (i.e. subsequent fdatasync) we should consider
> if the extra code is worth it.
> 

Incrementally more than Christoph's patch. I don't think that's an
issue.

> >
> >> If I am not mistaken the way to fix the current optimization is to record
> >> the last SYNC_DONE lsn (which is sort of what Christoph suggested)
> >> and the last WANY_SYNC|ACTIVE lsn.
> >> After  file_write_and_wait() need to save pre_sync_lsn and before
> >> return need to make sure that post_sync_lsn >= pre_sync_lsn or
> >> issue a flush.
> >>
> >
> > Perhaps, but I'm not quite following what you mean by pre/post LSNs.
> > Note that I believe log buffers can complete out of order, if that is
> > relevant here. Either way, this still seems like underhanded logic
> > IMO...
> >
> > If the requirement is a simple "issue a flush if we can't detect that
> > one has submitted+completed on this device since our writeback
> > completed" rule, why intentionally obfuscate that with internal log
> > buffer state such as log buffer header LSN and log state machine values?
> > Just track flush submission/completions as you suggested earlier and the
> > fsync logic is much easier to follow. Then we don't need to work
> > backwards from the XFS logging infrastructure just to try and verify
> > whether a flush has occurred in all cases. :)
> >
> 
> Your argument makes a lot of sense. I'm just trying to be extra cautious
> and looking for a small step solution. As Darrick wrote.. "safety first" :)
> 

Sure. FWIW, I think your patch suits that purpose as it basically
disables the shady bits of the optimization. It looks like it's already
in Darrick's for-next branch and Cc'd to stable as well.

A cleaner rework of this mechanism can come after, hopefully restore the
full optimization safely and perhaps clean out the whole log_flushed
thing.

Brian

> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
