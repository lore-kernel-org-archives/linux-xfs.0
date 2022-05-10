Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2DD6C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 05:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbiEJFO6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 01:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbiEJFO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 01:14:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9F61A068
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 22:10:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E5F861794
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 05:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED12AC385C0;
        Tue, 10 May 2022 05:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652159458;
        bh=yKf7rj5Qfo3K24uQUIO/oW/uAmFJJJ2ZN7tGJ9FaOVE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qEielhZKCzlibbAdyMZjBhq68MG+IZAEsvQ5rc3CuLyVPgsGp/3H4P0E1KWiTb89Z
         /U3VHA9GM1TbZS0Er3ZewjfBuDjQl13W/FAM2rmVmHhQEjWu8bYPPxjKaLUiomREle
         JkwPoiSwGnuBv4qZ0AUkQjB7WRTgP8QFO5AEmhOjMM5aWLpR1rD+/U9WhQ0DKS5K1c
         C+uN68Zf19Adhx6J3/qO5u0AxWVeOh69BKBRirYkctQyrkDxQ+IMFT8dibtiHiVSll
         Y65506ow4+CnG5BOKAa5ETYvRuwqQzkXCYDidmdJlJNTqFa7KoPc2qh5//YaSBYjNA
         iXW2dBkCuEtkA==
Date:   Mon, 9 May 2022 22:10:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Chris Dunlop <chris@onthe.net.au>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: Highly reflinked and fragmented considered harmful?
Message-ID: <20220510051057.GY27195@magnolia>
References: <20220509024659.GA62606@onthe.net.au>
 <20220509230918.GP1098723@dread.disaster.area>
 <CAOQ4uxgf6AHzLM-mGte_L-A+piSZTRsbdLMBT3hZFNhk-yfxZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgf6AHzLM-mGte_L-A+piSZTRsbdLMBT3hZFNhk-yfxZQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 07:07:35AM +0300, Amir Goldstein wrote:
> On Tue, May 10, 2022 at 2:25 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Mon, May 09, 2022 at 12:46:59PM +1000, Chris Dunlop wrote:
> > > Hi,
> > >
> > > Is it to be expected that removing 29TB of highly reflinked and fragmented
> > > data could take days, the entire time blocking other tasks like "rm" and
> > > "df" on the same filesystem?
> > >
> [...]
> > > The story...
> > >
> > > I did an "rm -rf" of a directory containing a "du"-indicated 29TB spread
> > > over maybe 50 files. The data would have been highly reflinked and
> > > fragmented. A large part of the reflinking would be to files outside the dir
> > > in question, and I imagine maybe only 2-3TB of data would actually be freed
> > > by the "rm".
> >
> > But it's still got to clean up 29TB of shared extent references.
> > Assuming worst case reflink extent fragmentation of 4kB filesystem
> > blocks, 29TB is roughly 7 *billion* references that have to be
> > cleaned up.
> >
> > TANSTAAFL.
> >
> [...]
> >
> > IOWs, the problem here is that  you asked the filesystem to perform
> > *billions* of update operations by running that rm -rf command and
> > your storage simply isn't up to performing such operations.
> >
> > What reflink giveth you, reflink taketh away.

And here I was expecting "...and rmapbt taketh away." ;)

> When I read this story, it reads like the filesystem is to blame and
> not the user.
> 
> First of all, the user did not "ask the filesystem to perform
> *billions* of updates",
> the user asked the filesystem to remove 50 huge files.
> 
> End users do not have to understand how filesystem unlink operation works.
> But even if we agree that the user "asked the filesystem to perform *billions*
> of updates" (as is the same with rm -rf of billions of files), If the
> filesystem says
> "ok I'll do it" and hogs the system for 10 days,
> there might be something wrong with the system, not with the user.
> 
> Linux grew dirty page throttling for the same reason - so we can stop blaming
> the users who copied the movie to their USB pen drive for their system getting
> stuck.

(Is the default dirty ratio still 20% of DRAM?)

> This incident sounds like a very serious problem - the sort of problem that
> makes users leave a filesystem with a door slam, never come back and
> start tweeting about how awful fs X is.
> 
> And most users won't even try to analyse the situation as Chris did and
> write about it to xfs list before starting to tweet.
> 
> From a product POV, I think what should have happened here is that
> freeing up the space would have taken 10 days in the background, but
> otherwise, filesystem should not have been blocking other processes
> for long periods of time.

Indeed.  Chris, do you happen to have the sysrq-w output handy?  I'm
curious if the stall warning backtraces all had xfs_inodegc_flush() in
them, or were there other parts of the system stalling elsewhere too?
50 billion updates is a lot, but there shouldn't be stall warnings.

The one you pasted into your message is an ugly wart of the background
inode gc code -- statfs (and getquota with root dqid) are slow-path
summary counter reporting system calls, so they call flush_workqueue to
make sure the background workers have collected *all* the garbage.

I bet, however, that you and everyone else would rather have somewhat
inaccurate results than a load average of 4700 and a dead machine.

What I really want is flush_workqueue_timeout(), where we kick the
workers and wait some amount of time, where the amount is a large number
(say hangcheck_timeout-5) if we're near ENOSPC and a small one if not.
IOWS, we'll try to have statfs return reasonably accurate results, but
if it takes too long we'll get impatient and just return what we have.

> Of course, it would have been nice if there was a friendly user interface
> to notify users of background cg work progress.
> 
> All this is much easier said than done, but that does not make it less true.
> 
> Can we do anything to throttle background cg work to the point that it
> has less catastrophic effect on end users? Perhaps limit the amount of
> journal credits allowed to be consumed by gc work? so "foreground"
> operations will be less likely to hang?

...that said, if foreground writers are also stalling unacceptably,
then we ought to throttle the background too.  Though that makes the
"stuck in statfs" problem worse.  But I'd want to know that foreground
threads are getting crushed before I started fiddling with that.

--D

> I am willing to take a swing at it, if you point me at the right direction.
> 
> Thanks,
> Amir.
