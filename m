Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E17DC28D13
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Aug 2022 02:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbiHWCBJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 22:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiHWCBI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 22:01:08 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 65FD048EBF
        for <linux-xfs@vger.kernel.org>; Mon, 22 Aug 2022 19:01:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-4-169.pa.nsw.optusnet.com.au [49.195.4.169])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2DE8B10E8B40;
        Tue, 23 Aug 2022 12:01:04 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oQJDz-00GOEN-BG; Tue, 23 Aug 2022 12:01:03 +1000
Date:   Tue, 23 Aug 2022 12:01:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: background AIL push targets physical space, not
 grant space
Message-ID: <20220823020103.GN3600936@dread.disaster.area>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-4-david@fromorbit.com>
 <YwPSMwmcyAZfIe3M@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwPSMwmcyAZfIe3M@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=630434e1
        a=FOdsZBbW/tHyAhIVFJ0pRA==:117 a=FOdsZBbW/tHyAhIVFJ0pRA==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Uf4aMK6grLAu5KhTSnoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 22, 2022 at 12:00:03PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 10, 2022 at 09:03:47AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently the AIL attempts to keep 25% of the "log space" free,
> > where the current used space is tracked by the reserve grant head.
> > That is, it tracks both physical space used plus the amount reserved
> > by transactions in progress.
> > 
> > When we start tail pushing, we are trying to make space for new
> > reservations by writing back older metadata and the log is generally
> > physically full of dirty metadata, and reservations for modifications
> > in flight take up whatever space the AIL can physically free up.
> > 
> > Hence we don't really need to take into account the reservation
> > space that has been used - we just need to keep the log tail moving
> > as fast as we can to free up space for more reservations to be made.
> > We know exactly how much physical space the journal is consuming in
> > the AIL (i.e. max LSN - min LSN) so we can base push thresholds
> > directly on this state rather than have to look at grant head
> > reservations to determine how much to physically push out of the
> > log.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Makes sense, I think.  Though I was wondering about the last patch --
> pushing the AIL until it's empty when a trans_alloc can't find grant
> reservation could take a while on a slow storage.

The push in the grant reservation code is not a blocking push - it
just tells the AIL to start pushing everything, then it goes to
sleep waiting for the tail to move and space to come available. The
AIL behaviour is largely unchanged, especially if the application is
running under even slight memory pressure as the inode shrinker will
repeatedly kick the AIL push-all trigger regardless of consumed
journal/grant space.

> Does this mean that
> we're trading the incremental freeing-up of the existing code for
> potentially higher transaction allocation latency in the hopes that more
> threads can get reservation?  Or does the "keep the AIL going" bits make
> up for that?

So far I've typically measured slightly lower worst case latencies
with this mechanism that with the existing "repeatedly push to 25%
free" that we currently have. It's not really significant enough to
make statements about (unlike cpu usage reductions or perf
increases), but it does seem to be a bit better...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
