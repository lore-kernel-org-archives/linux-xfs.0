Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F00C7C4338F
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 15:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3A6360ED6
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 15:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239253AbhHDQAH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 12:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239291AbhHDQAF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 12:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9311860ED6;
        Wed,  4 Aug 2021 15:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628092792;
        bh=6XLzMssljuCwoHd0ZFZy8l8RlLsPc7UVSyWHOBOTvf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ke4dJ8mi/mya6myaB/SXTkKRf6FFMY+Hod8p4gL5EbnoIbZ95PKw9r9fsl64ChJd+
         rbyVXQXSZ6ty7LK22DCQPs5vww8/xEg2YP2XeB+KuCWUT7iykiUNGhsWGzJLL5F+NV
         Ubk4Z/4rGBLPXEchWndoiLJNeaNGVTvYEuw5EOotT0gc3lMuZ88LA9WZDQ36Cwn9/h
         kq72nQ4VjQhV7RwBvOf7ATwVrIJtVwNKqid8ZpUzFHshyKHVYWzvqvwb1QuJ8RqOke
         8NSlwu3EfFrgcsNne1O/f8ysBmOUB83BZHV4R1Q49a49D6yt5Qo7IrAGYlTXBWtbXR
         t2XMRMUKovyWw==
Date:   Wed, 4 Aug 2021 08:59:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH, alternative v2] xfs: per-cpu deferred inode inactivation
 queues
Message-ID: <20210804155952.GN3601466@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210803083403.GI2757197@dread.disaster.area>
 <20210804032030.GT3601443@magnolia>
 <20210804110916.GM2757197@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804110916.GM2757197@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 04, 2021 at 09:09:16PM +1000, Dave Chinner wrote:
> On Tue, Aug 03, 2021 at 08:20:30PM -0700, Darrick J. Wong wrote:
> > For everyone else following along at home, I've posted the current draft
> > version of this whole thing in:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=deferred-inactivation-5.15
> 
> Overall looks good - fixes to freeze problems I hit are found
> in other replies to this.
> 
> I omitted the commits:
> 
> xfs: queue inodegc worker immediately when memory is tight
> xfs: throttle inode inactivation queuing on memory reclaim
> 
> in my test kernel because I think they are unnecessary.
> 
> I think the first is unnecessary because reclaim of inodes from the
> VFS is usually in large batches and so early triggers aren't
> desirable when we're getting thousands of inodes being evicted by
> the superblock shrinker at a time. If we've only got a handful of
> inodes queued, then inactivating them early isn't going to make much
> of an impact on free memory. I could be wrong, but so far I have no
> evidence that expediting inactivation is necessary.

I think this was a lot more necessary under the old design because I let
the number of tagged inodes grow quite large before triggering gc work,
much less throttling anything.  256 is low enough that it should be
manageable.

Does it matter that we no longer inactivate inodes in inode number
order?  I guess it could be nice to be able to dump inode cluster
buffers as soon as practicable, but OTOH I suspect that only matters for
the case of mass deletion, in which case we'll probably catch up soon
enough?

Anyway, I'll try turning both of these off with my silly deltree
exerciser and see what happens.

> The second patch is the custom shrinker. Again, I just don't think
> this is necessary because if there is any amount of inactivation of
> evicted inodes needed due to reclaim, we'll already be triggering it
> to run via the deferred queue flush thresholds. Hence we don't
> really need any mechanism to tell us that there is memory pressure;
> the deferred work reacts to eviction from reclaim in exactly the
> same way it reacts to eviction from unlink....

Yep.  I came to the same conclusion last night; it looks like my fast
fstests setup for that passed.

> I've been running the patchset without these two patches on my 512MB
> test VM, and the only OOM kill I get from fstests is g/531. This is
> the "many open-but-unlinked" test, which creates 50,000 open
> unlinked files per CPU. So for this test VM which has 4 CPUs, that's
> 200,000 open, dirty iunlinked inodes and a lot of pinned inode
> cluster buffers. At ~2kB of memory per unlinked inode (ignoring the
> cluster buffers) this would consume about 400MB of the 512MB of RAM
> the VM has. It OOM kills the test programs that hold the open files
> long before it gets to 200,000 files, so this test never passed
> before this patchset on this machine...

Yeah... I actually tried running fstests on a 512M VM and whooeee did I
see a lot of OOM kills.  Clearly we've all gotten spoiled by cheap DRAM.

> I have a couple of extra patches to set up per-cpu hotplug
> infrastructure before the deferred inode inactivation patch - I'll
> post them after I finish this email. I'm going to leave it running
> tests overnight.

Ok, I'll jam those on the front end of the series.

> Darrick, I'm pretty happy with the way the patchset is behaving now.
> If you want to fold in the bug fixes I've posted and add in
> the hotplug patches, then I think it's ready to be posted in full
> again (if it all passes your testing) for review.

It's probably about time for that.  Now that we do percpu thingies, I
think it might also be time for a test that runs fstests while plugging
and unplugging the non-bsp processors.

[narrator: ...and thus he unleashed another terrifying bug mountain]

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
