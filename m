Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C97C61DA4
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Feb 2023 22:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjBFW4Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Feb 2023 17:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBFW4X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2023 17:56:23 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AE228201
        for <linux-xfs@vger.kernel.org>; Mon,  6 Feb 2023 14:56:21 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id u75so2669940pgc.10
        for <linux-xfs@vger.kernel.org>; Mon, 06 Feb 2023 14:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FqeHaS5K9COcgGAPisE/CGKYz3PNQIPyKi7KnPUAn1o=;
        b=3I24GlpN/jiX2plDE6mbqwdJhVKem4kkM1NKwLbIR7qKpjjukTCAeB+oXxcZ3vNU9P
         JNdYGqtcHG+G69cykJv/BRKAWR/VIqt7WvJLEg0AOdP2kK+gWkFQ4kMdj87oLbPfdeZ/
         kDxs99xRE9pnk5n5OZ/QYKcpg4ywRwba8JYJxKom0M9E+onyFqb6xZXpEZq19ELqg5+S
         1Y7b46RhZ1K171Gm7ccuLQvJ2PrgL+FAiQbr4NPolcOXK42AHG+Cyhy+1BcoDKVeCITv
         oEksRAXYb5nHJl6bvM6EM/5vEXSTBaXpLv2KKCmmCaWLEUQdt9DsvMg2BxUvKnVb06Zx
         /ahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FqeHaS5K9COcgGAPisE/CGKYz3PNQIPyKi7KnPUAn1o=;
        b=5eODN5Xr3GnAltQQ5XetiG8LWDRIao5uQv/QB+NG1V/oT2RAFK+3azVpcKRGhMI8QW
         EThh/Yx3NYtCwztE8a7qT72sffGA2VgZY0vFzTG7AFbmrJjTpqTCC23CyRPU38NYv/tq
         n6Z/DMgm1/UA24N9D1zKRQqrpHiCP2Mp6zRLPnUz62QEFzWecGbUYp1LkFQDagZ93TI7
         LeVerjmO18f7d4PPHfIg8o8B0YDwOMdg+KjIoUuVHlCu3nSBwJH1jvpujfl6/GUYT9/9
         sYHfJZWaTPNvclnJENVMvekNTKsYUYR+Aoo0SD/vYM3TiIHtehGDufBlnLhUWCfbL3Ni
         dUjg==
X-Gm-Message-State: AO0yUKWmVNLFFzB4I1zLIHMY+86FRytbimuT6mWlZKscBGqNakRxJo01
        UClu0qgVtcgmHQY8LkOkX/G4UA==
X-Google-Smtp-Source: AK7set/mwmIxTeZhQInbphm7zb7iEcQmYcYxUQXSbb1tJnEN78aqD/F/I1vMreSlQjmdiVnwY/jlSw==
X-Received: by 2002:a62:1709:0:b0:593:b115:e2ca with SMTP id 9-20020a621709000000b00593b115e2camr878708pfx.9.1675724180935;
        Mon, 06 Feb 2023 14:56:20 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id m12-20020a056a00080c00b005931a44a239sm7635459pfk.112.2023.02.06.14.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 14:56:20 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pPAPJ-00CDio-6N; Tue, 07 Feb 2023 09:56:17 +1100
Date:   Tue, 7 Feb 2023 09:56:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/42] xfs: active perag reference counting
Message-ID: <20230206225617.GV360264@dread.disaster.area>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-8-david@fromorbit.com>
 <Y9q4xeAzQ7gxO68M@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9q4xeAzQ7gxO68M@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 01, 2023 at 11:08:53AM -0800, Darrick J. Wong wrote:
> On Thu, Jan 19, 2023 at 09:44:30AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We need to be able to dynamically remove instantiated AGs from
> > memory safely, either for shrinking the filesystem or paging AG
> > state in and out of memory (e.g. supporting millions of AGs). This
> > means we need to be able to safely exclude operations from accessing
> > perags while dynamic removal is in progress.
> > 
> > To do this, introduce the concept of active and passive references.
> > Active references are required for high level operations that make
> > use of an AG for a given operation (e.g. allocation) and pin the
> > perag in memory for the duration of the operation that is operating
> > on the perag (e.g. transaction scope). This means we can fail to get
> > an active reference to an AG, hence callers of the new active
> > reference API must be able to handle lookup failure gracefully.
> > 
> > Passive references are used in low level code, where we might need
> > to access the perag structure for the purposes of completing high
> > level operations. For example, buffers need to use passive
> > references because:
> > - we need to be able to do metadata IO during operations like grow
> >   and shrink transactions where high level active references to the
> >   AG have already been blocked
> > - buffers need to pin the perag until they are reclaimed from
> >   memory, something that high level code has no direct control over.
> > - unused cached buffers should not prevent a shrink from being
> >   started.
> > 
> > Hence we have active references that will form exclusion barriers
> > for operations to be performed on an AG, and passive references that
> > will prevent reclaim of the perag until all objects with passive
> > references have been reclaimed themselves.
> 
> This is going to be fun to rebase the online fsck series on top of. :)
> 
> If I'm understanding correctly, active perag refs are for high level
> code that wants to call down into an AG to do some operation
> (allocating, freeing, scanning, whatever)?  So I think online fsck
> uniformly wants xfs_perag_grab/rele, right?

That depends. For scrubbing, yes, active references are probably
going to be needed. For repair of AG structures where the AG needs
to be taken offline, we will likely have to take the AG offline to
prevent allocation from being attempted in them. Yes, we currently
use the AGF/AGI lock to prevent that, but this results in blocking
user applications during allocation until repair is done with the
AG. We really want application allocation to naturally skip AGs
under repair, not block until the repair is done....

As such, I think the answer is scrub should use active references as
it scans, but repair needs to use passive references once the AG has
had it's state changed to "offline" as active references will only
be available on "fully online" AGs.

> Passive refs are (I think) for lower level code that's wants to call up
> into an AG to finish off something that was already started? 

Yes, like buffers carrying a passive reference to pin the perag
while there are cached buffers indexed by the perag buffer hash.
Here we only care about the existence of the perag structure, as we
need to do IO to the AG metadata regardless of whether the perag is
active or not.

> And
> probably by upper level code?  So the amount of code that actually wants
> a passive reference is pretty small?

I don't think it's "small" - all the back end code that uses the
perag as the root of indexing structures will likely need passive
references.

The mental model I'm using is that active references are for
tracking user-facing and user-data operations that require perag
access.  That's things like inode allocation, data extent
allocation, etc which will need to skip over AGs that aren't
available for storing new user data/metadata at the current time.

Anything that is internal (e.g. metadata buffers, inode cache walks
for reclaim) that needs to run regardless of user operation just
needs an existence guarantee over the life of the object. This is
what passive references provide - the perag cannot be freed from
memory while there are still passive references to it.

Hence I'm looking at active references as a mechanism that can
provide an access barrier/drain for serialising per-ag operational
state changes, not to provide per-ag existence guarantees. Passive
references provide low level existence guarantees, active references
allow online/offline/no-alloc/shrinking/etc operational state
changes to be made safely.

> > This patch introduce xfs_perag_grab()/xfs_perag_rele() as the API
> > for active AG reference functionality. We also need to convert the
> > for_each_perag*() iterators to use active references, which will
> > start the process of converting high level code over to using active
> > references. Conversion of non-iterator based code to active
> > references will be done in followup patches.
> 
> Is there any code that iterates perag structures via passive references?
> I think the answer to this is 'no'?

I think the answer is yes - inode cache walking is a good example of
this. That will (eventually) have to grab a passive reference to the
perag and check the return - if it fails the perag has just been
torn down so we need to skip it. If it succeeds then we have a
reference that pins the perag in memory and we can safely walk the
inode cache structures in that perag.

Some of the operations that the inode cache walks perform (e.g.
block trimming) might need active references to per-ags to perform
their work (e.g. because a different AG is offline being repaired
and so we cannot free the post-eof blocks without blocking on that
offline AG). However, we don't want to skip inode cache walks just
because an AG is not allowing new allocations to be made in it....

> The code changes look all right.  If the answers to the above questions
> are "yes", "yes", "yes", and "no", then:
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

The answers are a whole lot more nuanced than that, unfortunately.
Which means that some of the repair infrastructure will need to be
done differently as the state changes for shrink are introduced. I
don't think there's any show-stoppers here, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
