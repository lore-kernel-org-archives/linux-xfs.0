Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50580 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932462AbcKNTxE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Nov 2016 14:53:04 -0500
Date: Mon, 14 Nov 2016 14:53:01 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS_WANT_CORRUPTED_GOTO
Message-ID: <20161114195301.GC37689@bfoster.bfoster>
References: <004eca882d70d671bce9dff6f25633cc.squirrel@mail2.postbox.xyz>
 <20161114125654.GA37689@bfoster.bfoster>
 <25b69ec53ba731ddd2f04d4e70341bdd.squirrel@mail2.postbox.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25b69ec53ba731ddd2f04d4e70341bdd.squirrel@mail2.postbox.xyz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris <chris2014@postbox.xyz>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 14, 2016 at 07:39:03PM +0100, Chris wrote:
> Dear Brian,
> 
> thank you for your detailed answer.
> 
> Brian Foster wrote:
> > On Sat, Nov 12, 2016 at 11:52:02AM +0100, Chris wrote:
> >> I tried XFS-repair, but it couldn't find the first or second super block
> >> after four hours.
> >>
> >
> > That sounds like something more significant is going on either with the
> > fs, the storage or xfs_repair has been pointed in the wrong place. The
> > above issue should at worst require zeroing the log, dealing with the
> > resulting inconsistency and rebuilding the fs btrees accurately.
> 
> Well, did it crash, because I called
> 
> xfs_db -c "freespc -s" /dev/...
> 
> while it was still in this unmount-loop?
> 

I don't think that should affect anything. Not prevent repair from
finding superblocks, at least.

> > I suspect it's too late to inspect what's going on there if you have
> > already restored from backup. In the future, you can use xfs_metadump to
> > capture a metadata only image of a broken fs to share with us and help
> > us diagnose what might have gone wrong.
> 
> OK.
> 
> > I'd suggest to run "xfs_repair -n" on those as soon as possible to see
> > if they are affected by the same problem. It might also be a good idea
> > to run it against the fs you've restored from backup to see if it
> > returns and possibly get an idea on what might have caused the problem.
> 
> On those filesystems, that aren't in use now, xfs_repair hasn't found any
> problems.
> 
> Thanks again for your help. Next time, I'll do a metadump.
> 

Sounds good.

Brian

> - Chris
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
