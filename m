Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 831ACECAAD5
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Aug 2022 23:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbiHZXto (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Aug 2022 19:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbiHZXtn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Aug 2022 19:49:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87A5E42EE
        for <linux-xfs@vger.kernel.org>; Fri, 26 Aug 2022 16:49:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FDBE61BE7
        for <linux-xfs@vger.kernel.org>; Fri, 26 Aug 2022 23:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFD3C433D7;
        Fri, 26 Aug 2022 23:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661557781;
        bh=w5kuVd7wl/Jp4cNaooPenFrAiURUohxTzgF1oIbiN3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ro4xSxg6AgYlHNPZeRbP4d3uOCl9yQr/m/B8O6sr5JZqSgGiDU4/ZslxncVB2u2Cq
         PwmWpKc6U5VCnpWJO07PqeNbAibixvHLsC4vx5JjKRBuiL78318aloRVat1hH0X/qv
         3w1xu986w/94p6zE5D70660WgH4QteaDFj0MzyPYQxVzQRBPqcLEBW+H/tE2hQS69P
         c7FG4lEl+f61zj3+Gi630i3dQe1TkBEvEc6ljZLAyGzIiAAaM+KVIDBRqwb0y3ruO8
         730pNX2En++Bq8jwHrbld35B7DUmpOyUtgchuf8ipiO01eip15jt+Sv9hxbjBwaugg
         Dj/JvcnAaUVng==
Date:   Fri, 26 Aug 2022 16:49:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: background AIL push targets physical space, not
 grant space
Message-ID: <YwlcFRSiKvqn2rGD@magnolia>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-4-david@fromorbit.com>
 <YwPSMwmcyAZfIe3M@magnolia>
 <20220823020103.GN3600936@dread.disaster.area>
 <YwjrFwUGdhHlvfaU@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwjrFwUGdhHlvfaU@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 26, 2022 at 08:47:35AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 23, 2022 at 12:01:03PM +1000, Dave Chinner wrote:
> > On Mon, Aug 22, 2022 at 12:00:03PM -0700, Darrick J. Wong wrote:
> > > On Wed, Aug 10, 2022 at 09:03:47AM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Currently the AIL attempts to keep 25% of the "log space" free,
> > > > where the current used space is tracked by the reserve grant head.
> > > > That is, it tracks both physical space used plus the amount reserved
> > > > by transactions in progress.
> > > > 
> > > > When we start tail pushing, we are trying to make space for new
> > > > reservations by writing back older metadata and the log is generally
> > > > physically full of dirty metadata, and reservations for modifications
> > > > in flight take up whatever space the AIL can physically free up.
> > > > 
> > > > Hence we don't really need to take into account the reservation
> > > > space that has been used - we just need to keep the log tail moving
> > > > as fast as we can to free up space for more reservations to be made.
> > > > We know exactly how much physical space the journal is consuming in
> > > > the AIL (i.e. max LSN - min LSN) so we can base push thresholds
> > > > directly on this state rather than have to look at grant head
> > > > reservations to determine how much to physically push out of the
> > > > log.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Makes sense, I think.  Though I was wondering about the last patch --
> > > pushing the AIL until it's empty when a trans_alloc can't find grant
> > > reservation could take a while on a slow storage.

Now that I've had a chance to see where we're going...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> > 
> > The push in the grant reservation code is not a blocking push - it
> > just tells the AIL to start pushing everything, then it goes to
> > sleep waiting for the tail to move and space to come available. The
> > AIL behaviour is largely unchanged, especially if the application is
> > running under even slight memory pressure as the inode shrinker will
> > repeatedly kick the AIL push-all trigger regardless of consumed
> > journal/grant space.
> 
> Ok.
> 
> > > Does this mean that
> > > we're trading the incremental freeing-up of the existing code for
> > > potentially higher transaction allocation latency in the hopes that more
> > > threads can get reservation?  Or does the "keep the AIL going" bits make
> > > up for that?
> > 
> > So far I've typically measured slightly lower worst case latencies
> > with this mechanism that with the existing "repeatedly push to 25%
> > free" that we currently have. It's not really significant enough to
> > make statements about (unlike cpu usage reductions or perf
> > increases), but it does seem to be a bit better...
> 
> <nod>
> 
> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
