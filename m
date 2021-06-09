Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC97AC4743D
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Jun 2021 00:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C668061352
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Jun 2021 00:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbhFIA1f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 20:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233937AbhFIA1f (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jun 2021 20:27:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B915C61375;
        Wed,  9 Jun 2021 00:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623198341;
        bh=4qzWEcRD+w43bg2RDUKIqklgn/7c7X+F3e6d418jMwE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A9DEUCmovkFz+vnatx6oUojSPIaAEs53GzU4cgE9O9x0ntVbGC7F5qjAtwMD258PD
         z6+EV3X6WmntvlgVZkSpLbmYybGJxfZAC8SHWtL/urUbjDH6KEXbl8ShijxPunsZz6
         y8worL2PJl0qiWeuHLdEGo+ntuzHtk/0riTmlKIXO04Py0QEHQYRuFkF0x6rjLGT4p
         PCtD8kloF1Sqb0qn9pCJjbcp0uE3sf7xjZXWcFcH5qBNg0eXKxDxn06EXrpKbe1V9J
         AB1oJnJcXg2lPXBHFGtImNwWD+VT/Iua7iLh8VGAJu8yajIX24lWonw+h00ehTUQtC
         rgkJo1x++NfGw==
Date:   Tue, 8 Jun 2021 17:25:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 5/9] xfs: force inode garbage collection before fallocate
 when space is low
Message-ID: <20210609002541.GU2945738@locust>
References: <162310469340.3465262.504398465311182657.stgit@locust>
 <162310472140.3465262.3509717954267805085.stgit@locust>
 <20210608012605.GI664593@dread.disaster.area>
 <YL9Y9YM6VtxSnq+c@bfoster>
 <20210608153204.GS2945738@locust>
 <20210608215542.GL664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608215542.GL664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 09, 2021 at 07:55:42AM +1000, Dave Chinner wrote:
> On Tue, Jun 08, 2021 at 08:32:04AM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 08, 2021 at 07:48:05AM -0400, Brian Foster wrote:
> > > users/workloads that might operate under these conditions? I guess
> > > historically we've always recommended to not consistently operate in
> > > <20% free space conditions, so to some degree there is an expectation
> > > for less than optimal behavior if one decides to constantly bash an fs
> > > into ENOSPC. Then again with large enough files, will/can we put the
> > > filesystem into that state ourselves without any indication to the user?
> > > 
> > > I kind of wonder if unless/until there's some kind of efficient feedback
> > > between allocation and "pending" free space, whether deferred
> > > inactivation should be an optimization tied to some kind of heuristic
> > > that balances the amount of currently available free space against
> > > pending free space (but I've not combed through the code enough to grok
> > > whether this already does something like that).
> > 
> > Ooh!  You mentioned "efficient feedback", and one sprung immediately to
> > mind -- if the AG is near full (or above 80% full, or whatever) we
> > schedule the per-AG inodegc worker immediately instead of delaying it.
> 
> That's what the lowspace thresholds in speculative preallocation are
> for...
> 
> 20% of a 1TB AG is an awful lot of freespace still remaining, and
> if someone is asking for a 200GB fallocate(), they are always going
> to get some fragmentation on a used, 80% full filesystem regardless
> of deferred inode inactivation.
> 
> IMO, if you're going to do this, use the same thresholds we already
> use to limit preallocation near global ENOSPC and graduate it to be
> more severe the closer we get to global ENOSPC...

Ok.  I'll just crib the same 5/4/3/2/1% thresholds like prealloc, then.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
