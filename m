Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF37C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 08:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA77F2065F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 08:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgHYIsN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 04:48:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:40314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728124AbgHYIsL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Aug 2020 04:48:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C25A0AC58;
        Tue, 25 Aug 2020 08:48:39 +0000 (UTC)
Date:   Tue, 25 Aug 2020 10:48:08 +0200
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/6] xfsprogs: blockdev dax detection and warnings
Message-ID: <20200825084808.GC3357@technoir>
References: <20200824203724.13477-1-ailiop@suse.com>
 <20200824225533.GA12131@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824225533.GA12131@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 08:55:33AM +1000, Dave Chinner wrote:
> On Mon, Aug 24, 2020 at 10:37:18PM +0200, Anthony Iliopoulos wrote:
> > Hi all,
> > 
> > This short series adds blockdev dax capability detection via libblkid,
> > and subsequently uses this bit to warn on a couple of incompatible
> > configurations during mkfs.
> > 
> > The first patch adds the detection capability to libtopology, and the
> > following two patches add mkfs warnings that are issued when the fs
> > block size is not matching the page size, and when reflink is being
> > enabled in conjunction with dax.
> 
> This makes the assumption that anyone running mkfs on a dax capable
> device is going to use DAX, and prevents mkfs from running if the
> config is not DAX compatible.
> 
> The issue here is that making a filesystem that is not DAX
> compatible on a DAX capable device is not a fatal error. The
> filesystem will work just fine using buffered and direct IO, and
> there are definitely workloads where we want to use buffered IO on
> pmem and not DAX. Why? Because existing pmem is terribly slow for
> write intensive applications compared to page cache based mmap().
> And even buffered writes are faster than DAX direct writes because
> the slow writeback is done in the background via async writeback.
> 
> Also, what happens if you have a 64kB page size? mkfs defaults to
> 4kB block size, so with these changes mkfs will refuse to run on a
> dax capable device unless the user specifically directs it to do
> something different. That's not a good behaviour for the default
> config to have....
> 
> Hence I don't think that preventing mkfs from running unless the config
> is exactly waht DAX requires or the "force" option is set is the
> right policy here.
> 
> I agree that mkfs needs to be aware of DAX capability of the block
> device, but that capability existing should not cause mkfs to fail.
> If we want users to be able to direct mkfs to to create a DAX
> capable filesystem then adding a -d dax option would be a better
> idea. This would direct mkfs to align/size all the data options to
> use a DAX compatible topology if blkid supports reporting the DAX
> topology. It would also do things like turn off reflink (until that
> is supported w/ DAX), etc.

I do like the idea of adding an explicit dax option, but I'm not sure
what the right policy would be:

1. -d dax option specified, set dax-compatible parameters irrespective
   of dax capability (blkid detection not strictly required)

2. -d dax option specified, set dax-compatible parameters only if
   blockdev is dax capable; fallback to default params otherwise

3. autodetect dax capability and automatically set dax-compatible
   params, irrespective of if the option is specified or not
   (potentially also needs an explicit override option e.g. -d dax=0).

I'd be inclined to go with the second option which should lead to the
least amount of surprises for users.

Still, this doesn't address the exact thing I was trying to do (see
below).

> i.e. if the user knows they are going to use DAX (and they will)
> then they can tell mkfs to make a DAX compatible filesystem.

So I've been trying to prevent cases where users create a filesystem
with the default params, go on to populate it, and at some later point
of time find themselves wanting to mount it with dax only to realize
that this is not possible without mkfs (most commonly due to the
mismatch of the 64kB page size on ppc64). We could potentially just
issue the warning and not force mkfs to bail out, but I'm afraid that
warnings aren't very discernible and are easily missed. I do agree
though that requiring an override may not be the best model here.

Would it make sense to simply emit the warnings and drop the bail-out
and override logic altogether?

Alternatively the third option above (autodetection), would take care of
those cases at the expense of overriding otherwise potentially desirable
options (e.g. switching off reflink), which will come as a surprise to
users that don't intent to use dax. I don't think this would be a good
default policy.

> > The next patch adds a new cli option that can be used to override
> > warnings, and converts all warnings that can be forced to this option
> > instead the overloaded -f option. This avoids cases where forcing a
> > warning may also be implicitly forcing overwriting an existing
> > partition.
>
> I don't want both an "ignore warnings" and a "force" CLI option.
> They both do the same thing - allow the user to override things that
> are potentially destructive or result in an unusable config - so why
> should we add the complexity of having a different "force" options
> for every different possible thing that can be overridden?

The rationale here was to only make a distinction between destructive
and (conditionally) unusable, otherwise we would indeed need an override
toggle per warning - which I totally agree is an overkill. If implicitly
suppressing the destructive operation confirmation isn't a concern, then
I'd definitely drop this patch.

Thanks for the feedback!

Anthony
