Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52492 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750761AbdHaAFV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 20:05:21 -0400
Date: Thu, 31 Aug 2017 02:05:19 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 00/42] mkfs: factor the crap out of the code
Message-ID: <20170831000519.GW27873@wotan.suse.de>
References: <20170829235052.21050-1-david@fromorbit.com>
 <20170830041635.GK27873@wotan.suse.de>
 <20170830054420.GI10621@dastard>
 <20170830221056.GU27873@wotan.suse.de>
 <20170830232216.GM10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830232216.GM10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Thu, Aug 31, 2017 at 09:22:16AM +1000, Dave Chinner wrote:
> On Thu, Aug 31, 2017 at 12:10:56AM +0200, Luis R. Rodriguez wrote:
> > On Wed, Aug 30, 2017 at 03:44:20PM +1000, Dave Chinner wrote:
> > > Maybe you can come up with a way of automating this, but for a
> > > one-off piece of work that affects a point-in-time snapshot of mkfs
> > > functionality, I'm not sure it's worth the effort to try to make a
> > > generic test to do this sort of thing.
> > 
> > In Dave we trust!
> 
> No, definitely don't do that.  Don't trust a damn thing I do - I'm
> full of dangerous ideas, I write shit code and should be kept on a
> short leash at all times.....

Well its great you have a job then!

> > > > > finally, one for config file support),
> > > > > but otherwise the majority of the factoring work is now complete.
> > > > > 
> > > > > Comments, flames, etc all welcome.
> > > > 
> > > > Just one thing, got a git tree I can use? I honestly can't be bothered
> > > > reviewing the delta in between, I just want to move on with life. Thanks
> > > > for cleaning up the manure pile buttress.
> > > 
> > > Nope, not right now. Tag all the patches, save them to an mbox
> > > file, run 'git-am <mbox-file>' to apply them all. Takes all of 20s
> > > to do with mutt....
> > 
> > Turns out mutt re-orders tagged messages
> 
> It does? I've never come across that. I always tag the entire thread
> they've always come out in the correct sent order for me. And I've
> been doing that for many, many years....

Yeah the order also comes out different on the thread on mutt for me,
it turns out I have:

set sort_aux=last-date-received

And you need:

set sort_aux=date

which is the default.

> > in what I think may be the order you got them in so the order on
> > the input output filename may differ from the patch order intent.
> > Even when I manually sort them and apply them, the patches failed
> > on both origin/master and origin/for-next, so I must be doing
> > something wrong or using an incorrect branch or commit ID. What
> > branch and commit ID should I use?
> 
> Applies to:
> 
> $ glo -n 1 origin/for-next
> 3540b418ba48 xfs_db: btdump should avoid eval for push and pop of cursor
> $
> 
> I forgot to update the branch before my last pass over the
> patchset...
> 
> > It also seems I didn't get patch #20 in my inbox, could you
> > resend?
> 
> Probably best in one-off cases like this is to grab it from the
> archive - the whole patchset made it back to me from the list, so it
> should be in the archive. If it's not, then we've got a more general
> list delivery problem rather than it just being a problem somewhere
> in your mail delivery path...

One-off, I definitely don't have that patch but it is in the archive.

For those lazy:

https://gitlab.com/mcgrof/xfsprogs-dev/tree/20170830-dave-mkfs

  Luis
