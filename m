Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3F8F87F83
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 07:31:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F3A6304059
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 05:31:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sKalsXBE8mtwGxW8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Aug 2014 05:30:59 -0700 (PDT)
Date: Tue, 5 Aug 2014 08:30:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/6] xfs: consolidate superblock logging functions
Message-ID: <20140805123050.GA53538@bfoster.bfoster>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
	<1406791995-14723-3-git-send-email-david@fromorbit.com>
	<20140801143929.GC3582@laptop.bfoster>
	<20140804080930.GY20518@dastard>
	<20140804124836.GA4049@bfoster.bfoster>
	<20140804221526.GZ20518@dastard>
	<20140805000333.GA27760@bfoster.bfoster>
	<20140805003440.GB20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140805003440.GB20518@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 05, 2014 at 10:34:40AM +1000, Dave Chinner wrote:
> On Mon, Aug 04, 2014 at 08:03:33PM -0400, Brian Foster wrote:
> > On Tue, Aug 05, 2014 at 08:15:26AM +1000, Dave Chinner wrote:
> > > On Mon, Aug 04, 2014 at 08:48:36AM -0400, Brian Foster wrote:
> > > > On Mon, Aug 04, 2014 at 06:09:30PM +1000, Dave Chinner wrote:
> > > > > On Fri, Aug 01, 2014 at 10:39:29AM -0400, Brian Foster wrote:
> > > > Fair point, an sb modification is something that should stand out. I
> > > > think the characteristic of the new api is somewhat subtle, however.
> > > 
> > > Which is why there's a comment explaining it. Is there anything I
> > > can add to that comment to make it clearer?
> > > 
> > 
> > I would change this:
> > 
> > /*
> >  * ...
> >  *
> >  * Note this code can be called during the process of freezing, so
> >  * we may need to use the transaction allocator which does not
> >  * block when the transaction subsystem is in its frozen state.
> >  */
> > 
> > ... to something like:
> > 
> > /*
> >  * ...
> >  *
> >  * Note that the caller is responsible for checking the frozen state of
> >  * the filesystem. This procedure uses the non-blocking transaction
> >  * allocator and thus will allow modifications to a frozen fs. This is
> >  * required because this code can be called during the process of
> >  * freezing where use of the high-level allocator would deadlock.
> >  */
> 
> OK, I can do that.
> 
> > > > > > I'm not sure of the mechanics behind that, but I'm
> > > > > > guessing some kind of reference remains on the sb of a frozen fs and a
> > > > > > subsequent umount/mount is purely namespace magic. Point being... this
> > > > > > appears to be implicit and confusing. IMO, using an _xfs_sync_sb()
> > > > > > variant that allocates a nonblocking tp if one isn't provided as a
> > > > > > parameter (for example) and using that only in the contexts we know it's
> > > > > > Ok to avoid freeze interaction issues might be more clear.
> > > > > 
> > > > > Well, it was pretty clear to me that the code paths were free of
> > > > > freeze interactions. Looking at this - especially the quota on/off
> > > > > paths - I guess it's not as obvious as I thought it was... :/
> > > > > 
> > > > 
> > > > My point was more geared towards future use. E.g., we have frozen fs
> > > > management built into transaction management, which is nice and clean
> > > > and easy to understand.
> > > 
> > > Actually, it's nowhere near as clean as you think. :/
> > > 
> > > e.g. did you know that the xfs_fs_writable() check in
> > > xfs_log_sbcount() is to prevent it from writing anything when
> > > unmounting a fully frozen filesystem? i.e. xfs_log_sbcount needs to
> > > succeed while a freeze is in progress, but fail when a freeze is
> > > fully complete?
> > > 
> > 
> > Hmm, so freeze_super() sets s_frozen to SB_FREEZE_FS before it calls
> > into the fs. Given the xfs_fs_writable() logic, how is that going to
> > differentiate a freezing fs from a frozen fs? It makes sense that this
> > would avoid blocking on umount of a frozen fs, but it seems like we'd
> > skip out just the same during the freeze sequence. Maybe I'm missing
> > something...
> 
> Hmmm - that means we broke it at some point. xfs_attr_quiesce is
> supposed to make the metadata uptodate on disk, so if it's not
> updating the superblock (i.e. syncing all the counters) then it's
> not doing the right thing - the sb counters on disk while the fs is
> frozen are not uptodate and hence correct behaviour if we crash with
> a frozen fs is dependent on log recovery finding a dirty log. That's
> a nasty little landmine and needs to be fixed, even though it's not
> causing issues at the moment (because we dirty the log after
> quiescing the filesystem).
> 

I'm wondering if that even helps in the case of a crash. It looks like
we would skip the counter sync and subsequent action of logging the sb
entirely.

Oh, according to the lazy sb counter commit log description we do some
kind of counter rebuild across the AGI/AGF structures and log the result
of that. So I take it that should a crash occur while in the frozen
state, the simple act of causing a log recovery to occur on subsequent
mount should rebuild everything correctly.

> Did I mention this code is not at all obvious? :/
> 

Heh. :P From what I can see, it looks like this has been the case since
commit 92821e2b, which introduced xfs_log_sbcount(). That goes way
back... there's a vfs_test_for_freeze() macro (xfs_vfs.h) used by
xfs_fs_writable() that looks like this:

#define vfs_test_for_freeze(vfs)        ((vfs)->vfs_super->s_frozen)

... and SB_FREEZE_TRANS is set before a ->write_super_lockfs() call into
the fs. The mechanism looks to have changed quite a bit since then,
though.

Perhaps xfs_log_sbcount() requires an open coded s_frozen check a la
the _xfs_trans_alloc() logic. E.g., skip out of SB_FREEZE_COMPLETE,
proceed otherwise..?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
