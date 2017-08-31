Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18656 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750908AbdHaUgT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Aug 2017 16:36:19 -0400
Date: Thu, 31 Aug 2017 16:36:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: remove experimental tag for reflinks
Message-ID: <20170831203613.GB25053@bfoster.bfoster>
References: <20170830145400.3681-1-hch@lst.de>
 <20170831064033.GF3775@magnolia>
 <20170831124321.GA21939@bfoster.bfoster>
 <20170831133019.GA5468@lst.de>
 <20170831153148.GJ3775@magnolia>
 <20170831155923.GG21939@bfoster.bfoster>
 <20170831200936.GO3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831200936.GO3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>

On Thu, Aug 31, 2017 at 01:09:36PM -0700, Darrick J. Wong wrote:
> On Thu, Aug 31, 2017 at 11:59:24AM -0400, Brian Foster wrote:
> > On Thu, Aug 31, 2017 at 08:31:48AM -0700, Darrick J. Wong wrote:
> > > On Thu, Aug 31, 2017 at 03:30:19PM +0200, Christoph Hellwig wrote:
> > > > On Thu, Aug 31, 2017 at 08:43:21AM -0400, Brian Foster wrote:
> > > > > FWIW, I don't really have a strong opinion. To me, removing experimental
> > > > > means we feel the code has stabilized long enough in principle, there
> > > > > are no significant problems (i.e., corruption/crash vectors) that we are
> > > > > aware of and the feature is complete (full userspace tool support, etc).
> > > > > The in-core extent list thing seems like more of a general problem to me
> > > > 
> > > > Agreed so far.
> > > 
> > > <nod> Dave?  Eric?  Any perspective you'd like to offer? :)
> > > 
> > > > > That aside, shouldn't we consider the rmapbt experimental tag first, or
> > > > > at least at the same time? It's been around for slightly longer.
> > > > 
> > > > I've not done much testing on that or have experience with it in general,
> > > > nor do I have a customer with a big QA team beating it hard, so I can't
> > > > really comment on that one.
> > > 
> > > rmapbt will remain EXPERIMENTAL because I still have more patches to
> > > send to finish the feature for realtime devices.  Speaking of which,
> > > it's now been 53 weeks since the last dump of that, so I'll go do that
> > > now. :P
> > > 
> > > FWIW I /also/ run rmapbt everywhere and haven't had any trouble with it
> > > since adding the per-AG reservations.
> > > 
> > 
> > My question then is do we want to encourage users to run reflink without
> > rmapbt because of the latter being experimental, and only so because of
> > a lack of realtime support? *shrug* Maybe it doesn't really matter.
> 
> Probably not, I think realtime users are fairly infrequent and
> especially so on v5.  The only reasons I can think of to extend our new
> features to rt are (a) to avoid screwing over the existing usecases and
> (b) I guess you could build a hybrid xfs between an SSD and a SMR drive
> wherein we always CoW from one end of the disk to the other.  (That's
> crazy, but hey.)
> 

Yeah, the only use cases I've really heard wrt to realtime any time in
the recent past has been these kind of future facing experiments as
opposed to traditional use. Not to say there aren't users out there, but
I also can't recall seeing any bug reports or anything of that nature
either any time recently. Maybe it's just perfect code. ;)

I think Dave has thought about the SMR+RT thing in the past. Somebody
else mentioned some other thing they were trying to do using RT to me at
Vault, to which I suggested to post some rfc code for discussion (which
obviously hasn't happened), but I honestly can't remember what that
experiment even was.

> > But realistically, how likely is it that the stability of forthcoming
> > rmapbt+realtime code has any bearing on making rmapbt non-experimental
> > in general?
> 
> The biggest code churn to add realtime rmap is reworking the btree code
> to support putting btree records in an inode fork.  The rmap code itself
> is relatively unchanged aside from widening rm_startblock/rm_blockcount
> to 64 bits.
> 
> > I suspect we're not going to leave it experimental for another however
> > many months just to let the rt code sit around. I also suspect not
> > many people will be actually using/testing that code outside of some
> > of us, but maybe there are real users out there and I'm just not aware
> > of them..? (This all coming from somebody who has CONFIG_XFS_RT
> > disabled on his configs. ;)
> 
> /me has it enabled and (occasionally) runs with realtime to see what
> breaks. :)
> 

Heh, I think I did that once in the past. That about sums up my
experience with rt. :)

> > If realtime is the only barrier, ISTM we could remove the experimental
> > rmapbt status and just disable rmapbt+rt for now. Then re-enable
> > EXPERIMENTAL just for rmapbt+rt when that code goes in (which seems like
> > the most likely end result to me anyways).
> 
> It's already disabled.  I suppose it's not /that/ big of a deal if old
> kernels reject certain feature combinations...
> 

Er, right. :P That seems reasonable to me. Again, I don't feel terribly
strongly about whether to remove the tag or not for rmapbt in general.
It just seems a bit strange to me to open up reflink and not rmapbt just
because we don't support the latter on realtime yet.

> ...by the way, we can't add a rt device to an already-mounted
> filesystem, right?
> 

I thought it was a mkfs time thing, but I could be mistaken...

Brian

> --D
> 
> > 
> > Brian
> > 
> > > --D
> > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
