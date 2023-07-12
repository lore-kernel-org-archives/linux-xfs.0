Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1235EEB64DC
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 01:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjGLBOC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 21:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjGLBN7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 21:13:59 -0400
Received: from smtp2.onthe.net.au (smtp2.onthe.net.au [203.22.196.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9E141717
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 18:13:57 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp2.onthe.net.au (Postfix) with ESMTP id 204CF891;
        Wed, 12 Jul 2023 11:13:57 +1000 (AEST)
Received: from smtp2.onthe.net.au ([10.200.63.13])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10024)
        with ESMTP id IwVOJn7SndoB; Wed, 12 Jul 2023 11:13:57 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp2.onthe.net.au (Postfix) with ESMTP id F3D9A883;
        Wed, 12 Jul 2023 11:13:56 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=onthe.net.au;
        s=default; t=1689124437;
        bh=e5jXvpuQKz5c241s8gwT82dYSDyOCrR8YrlSZPMRJdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aixsA1d8o1c4cq8qrXdy248EIMjrW/qqTns+xn14KQcYTN3ZxMCSdXuAHFHoVI6sn
         B+3W/EWT1AY4UkvDUWc+CHTLD4bnPdCkNQHavSzvOmYailHTFscnwt22pKrVmrs8Qm
         b3qPFNV7aChHK+E5CZckmLB1qChLG/wcgV+wC0tmYx6vEHkunISzAyUjRWzveHV9Vt
         GlXGozdx+Cgaszjv/5El+5oVVjfJvaKB4MUx9QV4Vw/UFm/FQ9+uIJA5baOfEkY7wj
         ayliRzy9wE/dQQOpSQELISUv95PTM3T2xc+ymj4sUy4d9qjXpzRjpZXo/vz6gyNwQs
         zvnb/ge8O7Pyg==
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id D65EC68061B; Wed, 12 Jul 2023 11:13:56 +1000 (AEST)
Date:   Wed, 12 Jul 2023 11:13:56 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: rm hanging, v6.1.35
Message-ID: <20230712011356.GB886834@onthe.net.au>
References: <20230710215354.GA679018@onthe.net.au>
 <20230711001331.GA683098@onthe.net.au>
 <20230711015716.GA687252@onthe.net.au>
 <ZKzIE6m+iCEd+ZWk@dread.disaster.area>
 <20230711070530.GA761114@onthe.net.au>
 <ZK3V1wQ6jQCxtTZJ@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZK3V1wQ6jQCxtTZJ@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 08:21:11AM +1000, Dave Chinner wrote:
> On Tue, Jul 11, 2023 at 05:05:30PM +1000, Chris Dunlop wrote:
>> On Tue, Jul 11, 2023 at 01:10:11PM +1000, Dave Chinner wrote:
>
>> More on the problem topic below, and apologies for the aside, but 
>> this is my immediate concern: post the reboot into v5.15.118 I have 
>> one of the filesystems failing to mount with:
...
> I would suggest that this indicates a torn write of some kind. Given
> the state of the system when you rebooted, and all the RAID 5/6
> writes in progress, this is entirely possible...
...
> It's probably safest to just zero the log and run repair at this
> point.

Thanks. I did that last night (after taking a snapshot) - 'xfs_repair 
-v' is still running but there's a LOT of nasty output so it's not 
looking good.

...oh. It finished whilst I've been writing this. If you're interested 
in the log:

https://file.io/XOGokgxgttEX

The directory structure looks sane, I'll start running checks on the 
data.

>>> I don't see anything indicating a filesystem problem here. This
>>> looks like a massively overloaded RAID 5 volume. i.e. the fast
>>> storage that makes up the write cache has filled, and now everything
>>> is stuck waiting for the fast cache to drain to the slow backing
>>> store before new writes can be made to the fast cache. IOWs,
>>> everything is running as RAID5 write speed and there's a huge
>>> backlog of data being written to the RAID 5 volume(s) keeping them
>>> 100% busy.

Oddly, of the 56 similarly configured filesystems (writecache/lvm/rbd) 
on this box, with maybe 10 actively sinking writes at any time, that 
one above is the only one that had any trouble on reboot. If it had 
been a general problem w/ the cache device I would have thought more 
of the active writers would have similar issues. Maybe I just got 
lucky - and/or that demonstrates how hard xfs tries to keep your data 
sane.

>> This had never been an issue with v5.15. Is it possible the upgrade 
>> to v6.1 had a hand in this or that's probably just coincidence?
>
> It could be a dm-writecache or md raid regression, but it could be
> just "luck".

Ugh. Sigh. I guess at some point I'm going to have to bite the bullet 
again, and next time watch the cache device like a hawk. I'll keep an 
eye out for dm-writecache and md raid problems and patches etc. so see 
what might come up.

Is there anything else that occurs to you that I might monitor prior 
to and during any future recurrance of the problem?

>> In particular, could "5e672cd69f0a xfs: non-blocking inodegc 
>> pushes" cause a significantly greater write load on the cache?
>
> No.
>
>> I note that there's one fs (separate to the corrupt one above) 
>> that's still in mount recovery since the boot some hours ago. On 
>> past experience that indicates the inodegc stuff is holding things 
>> up, i.e. it would have been running prior to the reboot - or at 
>> least trying to.
>
> I only found one inodegc working running in the trace above - it was
> blocked on writecache doing a rmapbt block read removing extents. It
> may have been a long running cleanup, but it may not have been.

Probably was a cleanup: that's the reason for the update to v6.1, 
every now and again the box was running into the problem of getting 
blocked on the cleanup. The extent of the problem is significantly 
reduced by moving from one large fs where any extended cleanup would 
block everything, to multiple small-ish fs'es (500G-15T) where the 
blast radius of an extended cleanup is far more constrained. But the 
problem was still pretty annoying when it hits.

Hmmm, maybe I can just carry a local backport of "non-blocking inodegc 
pushes" in my local v5.15. That would push back my need to move do 
v6.1.

Or could / should it be considered for an official backport?  Looks 
like it applies cleanly to current v5.15.120.

> As it is, mount taking a long time because there's a inode with a
> huge number of extents that need freeing on an unlinked list is
> *not* related to background inodegc in any way - this has -always-
> happened with XFS; it's simply what unlinked inode recovery does.
>
> i.e. background inodegc just moved the extent freeing from syscall
> exit context to an async worker thread; the filesystem still has
> exactly the same work to do. If the system goes down while that work
> is in progress, log recovery has always finished off that cleanup
> work...

Gotcha. I'd mistakenly thought "non-blocking inodegc pushes" queued up 
the garbage collection for background processing. My further mistaken 
hand-wavy thought was that, if the processing that was previously 
foreground was now punted to background (perhaps with different 
priorities) maybe the background processing was simply way more 
efficient, enough to swamp the cache with metadata updates.

But with your further explanation and actually reading the patch 
(should have done that first) shows the gc was already queued, the 
update was to NOT wait for the queue to be flushed.

Hmmm, then again... might it be possible that, without the patch, at 
some point after a large delete, further work was blocked whilst 
waiting for the queue to be flushed, limiting the total amount of 
work, but with the patch, the further work (e.g. more deletes) is able 
to be queued - possibly to the point of swamping the cache device?

>> There's been no change to the cache device over the reboot, and it
>> currently looks busy, but it doesn't look completely swamped:
> ....
>
> About 150 1MB sized reads, and about 1000-1500 much smaller
> writes each second, with an average write wait of near 10ms.
> Certainly not a fast device, and it's running at about 50%
> utilisation with an average queue depth of 10-15 IOs.

That's hopefully the cache working as intended: sinking small 
continuous writes (network data uploads) and aggregating them into 
larger blocks to flush out to the bulk storage (i.e. reads from the 
cache to write to the bulk).

>> It should be handling about the same load as prior to the reboot.
>
> If that's the typical sustained load, I wouldn't expect it to have
> that much extra overhead given small writes on RAID 6 volumes have
> the worse performance characteristics possible. If the write cache
> starts flushing lots of small discontiguous writes, I'd expect to
> see that device go to 100% utilisation and long write wait times for
> extended periods...

There shouldn't be many small discontigous writes in the data: it's 
basically network uploads to sequential files in the 100s MB to multi 
GB range. But there's also a bunch of reflinking, not to mention 
occasionally removing highly reflinked multi-TB files, so these 
metadata updates might count as "lots of small discontiguous writes"?


Thanks for your help,

Chris
