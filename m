Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:37890 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753381AbeEURh3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 13:37:29 -0400
Date: Mon, 21 May 2018 13:37:24 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
Message-ID: <20180521173724.GG11495@kmo-pixel>
References: <686d7df6-c7d1-48a6-b7ff-48dc8aff6a62@kernel.dk>
 <20180521143132.GB19194@redhat.com>
 <2bbeeb1a-8b99-b06a-eb9b-eb8523c16460@kernel.dk>
 <20180521144703.GA19303@redhat.com>
 <4b343aef-e11c-73ba-1d88-7e73ca838cad@kernel.dk>
 <20180521150439.GA19379@redhat.com>
 <61e30dcf-a01c-f47d-087a-12930caf9aef@kernel.dk>
 <20180521151817.GA19454@redhat.com>
 <d01a150a-7752-f6ce-78f2-17a65c1e6fa5@kernel.dk>
 <20180521160907.GA19553@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180521160907.GA19553@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, colyli@suse.de, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com

On Mon, May 21, 2018 at 12:09:14PM -0400, Mike Snitzer wrote:
> On Mon, May 21 2018 at 11:36am -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
> > On 5/21/18 9:18 AM, Mike Snitzer wrote:
> > > On Mon, May 21 2018 at 11:09am -0400,
> > > Jens Axboe <axboe@kernel.dk> wrote:
> > > 
> > >> On 5/21/18 9:04 AM, Mike Snitzer wrote:
> > >>> On Mon, May 21 2018 at 10:52am -0400,
> > >>> Jens Axboe <axboe@kernel.dk> wrote:
> > >>>
> ...
> > >>>> IMHO you're making a big deal out of something that should not be.
> > >>>
> > >>> I raised an issue that had seemingly not been considered at all.  Not
> > >>> making a big deal.  Raising it for others' benefit.
> > >>>
> > >>>> If the dm bits are that sensitive and cache line honed to perfection
> > >>>> already due to previous regressions in that area, then it might
> > >>>> not be a bad idea to have some compile checks for false cacheline
> > >>>> sharing between sensitive members, or spilling of a sub-struct
> > >>>> into multiple cachelines.
> > >>>>
> > >>>> It's not like this was pushed behind your back. It's posted for
> > >>>> review. It's quite possible the net change is a win for dm. Let's
> > >>>> focus on getting it reviewed, rather than pontificate on what
> > >>>> could potentially go all wrong with this.
> > >>>
> > >>> Why are you making this personal?  Or purely about DM?  I'm merely
> > >>> pointing out this change isn't something that can be given a quick
> > >>> blanket "looks good".
> > >>
> > >> I'm not making this personal at all?! You raised a (valid) concern,
> > >> I'm merely stating why I don't think it's a high risk issue. I'm
> > >> assuming your worry is related to dm, as those are the reports
> > >> that would ultimately land on your desk.
> > > 
> > > Then we'll just agree to disagree with what this implies: "It's not like
> > > this was pushed behind your back."
> > 
> > I'm afraid you've lost me now - it was not pushed behind your back,
> > it was posted for review, with you on the CC list. Not trying to
> > be deliberately dense here, I just don't see what our disagreement is.
> 
> You're having an off day ;)  Mondays and all?
> 
> I just raised an alignment concern that needs to be considered during
> review by all stakeholders.  Wasn't upset at all.  Maybe my email tone
> came off otherwise?
> 
> And then you got confused by me pointing out how it was weird for you to
> suggest I felt this stuff was pushed behind my back.. and went on to
> think I really think that.  It's almost like you're a confused hypnotist
> seeding me with paranoid dilutions. ;)

Uh, you came across as upset and paranoid to me too. Chalk it up to email? :)

I personally don't care, I have no horse in this race. This particular patch
series wasn't my idea, Christoph wanted all these conversions done so
bioset_create() could be deleted. If you want us to hold off on the dm patch for
awhile until someone can get around to testing it or whatever (since I don't
have tests for everything I pushed) that would be perfectly fine by me.
