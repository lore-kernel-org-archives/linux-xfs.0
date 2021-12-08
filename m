Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BB4C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Dec 2021 16:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhLHQLn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Dec 2021 11:11:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57696 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236528AbhLHQLn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Dec 2021 11:11:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638979690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=orvh4kyOfiq4+hN2BN3vGPj6BnjNTCRMi4s8B8HbBSk=;
        b=Sjo87J0VqvIijl7fp0QKSQ0W8BCrn5XyCZeavpNOLvczqr97IMsgrWl51ec+PJrsrQTy+b
        zH71Gxe9Z2MROdLcgtb93VtgDVeSCmp8EMPM3lN3UvJGGMPLL1nRWmIETa08NUOe5p3zK1
        3XDoMoBilmwYkCs4jDzstdhVQEsO6ZI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-NzjXtLJzOsmA1mlydwvDnw-1; Wed, 08 Dec 2021 11:08:09 -0500
X-MC-Unique: NzjXtLJzOsmA1mlydwvDnw-1
Received: by mail-qk1-f200.google.com with SMTP id o4-20020a05620a2a0400b0046dbce64beaso3700604qkp.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Dec 2021 08:08:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=orvh4kyOfiq4+hN2BN3vGPj6BnjNTCRMi4s8B8HbBSk=;
        b=mpazEz6vsPPiinuY5YnhnPXw5Al+LAIwjHR/kAQ/puztF0aEvNtq3mNwWeJF2WRi8D
         MNYxoz6kBXmgvlYaohtBdwPdvBFRvX5tU7vUhtBQzo4AbKj6Ph4hmlfDl//7koVmaMsJ
         YjG4O5KaMtMYUXN21QMXIUNC6nW3LG2LP/HRta79zpmv9WyAiSq82L0mXAnGcxiXYxeT
         9F03Ps/YpoIUFZ3nvKkObh45dEelKd2b1VRiM6aM88BHHnSD0dDQIFD39t5ZS4mzVc1o
         ReMc7Qr0VsqXya5eU6h9FuPZOxPNw1QOmgtw5M/Z9DL6QxQcyTpdf5SiE+4VYZt7gs0b
         PKdQ==
X-Gm-Message-State: AOAM533IW4JRwys6h+nTW35qoLbZEJ4QYxNKiqU37tZtGQTA3/K8g7VH
        q+49UCC4LCJLzn7MxEL3wNnoEBWHYMBzXkdGVDAd5OgBmbA57BtmzCFj0lkb0uJTlBLHpK+Xal2
        wt0uHfMJkI85Bxti1HNqA
X-Received: by 2002:a0c:f992:: with SMTP id t18mr8718141qvn.37.1638979688915;
        Wed, 08 Dec 2021 08:08:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyHmI60KtpfiQOjxS9uDDkVijnV21dVkLeg9xtg2+C9XWVTnsT0QL/bdk2RQrne4XwtJ0W9ZQ==
X-Received: by 2002:a0c:f992:: with SMTP id t18mr8718092qvn.37.1638979688523;
        Wed, 08 Dec 2021 08:08:08 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id 9sm1573772qkm.5.2021.12.08.08.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 08:08:08 -0800 (PST)
Date:   Wed, 8 Dec 2021 11:08:06 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Gonzalo Siero Humet <gsierohu@redhat.com>
Subject: Re: [RFD] XFS inode reclaim (inactivation) under fs freeze
Message-ID: <YbDYZsE8fY5y6KjF@bfoster>
References: <Ya5IeB3iBBcpD1z+@bfoster>
 <20211206215143.GI449541@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206215143.GI449541@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 07, 2021 at 08:51:43AM +1100, Dave Chinner wrote:
> On Mon, Dec 06, 2021 at 12:29:28PM -0500, Brian Foster wrote:
> > Hi,
> > 
> > We have reports on distro (pre-deferred inactivation) kernels that inode
> > reclaim (i.e. via drop_caches) can deadlock on the s_umount lock when
> > invoked on a frozen XFS fs. This occurs because drop_caches acquires the
> > lock and then blocks in xfs_inactive() on transaction alloc for an inode
> > that requires an eofb trim. Unfreeze blocks on the same lock and thus
> > the fs is deadlocked (in a frozen state). As far as I'm aware, this has
> > been broken for some time and probably just not observed because reclaim
> > under freeze is a rare and unusual situation.
> >     
> > With deferred inactivation, the deadlock problem actually goes away
> > because ->destroy_inode() will never block when the filesystem is
> > frozen. There is new/odd behavior, however, in that lookups of a pending
> > inactive inode spin loop waiting for the pending inactive state to
> > clear. That won't happen until the fs is unfrozen.
> 
> That's existing behaviour for any inode that is stuck waiting for
> inactivation, regardless of how it is stuck. We've always had
> situations where lookups would spin waiting on indoes when there are
> frozen filesystems preventing XFS_IRECLAIMABLE inodes from making
> progress.
> 
> IOWs, this is not new behaviour - accessing files stuck in reclaim
> during freeze have done this for a couple of decades now...
> 

Sorry, I know you pointed this out already.. To try and be more clear, I
think the question is more whether we've increased the scope of this
scenario such that users are more likely to hit it and subsequently
complain. IOW, we historically blocked the inactivating task until
unfreeze, whereas now the task is free to continue potentially
evicting/queuing as many more inodes as it needs to. The historical
behavior is obviously broken so this is a step in the right direction,
but the scope of the spin looping thing has certainly changed enough to
warrant more thought beyond "lookup could always block."

Of course, this is all balanced against the fact that the reclaim under
freeze situation seems to be historically rare in the first place, so
maybe we don't care now that the deadlock is gone and we can just leave
things as is.

> > Also, the deferred inactivation queues are not consistently flushed on
> > freeze. I've observed that xfs_freeze invokes an xfs_inodegc_flush()
> > indirectly via xfs_fs_statfs(), but fsfreeze does not.
> 
> Userspace does not need to flush the inactivatin queues on freeze -
> - the XFS kernel side freeze code has a full queue flush in it. It's
> a bit subtle, but it is there.
> 
> > Therefore, I
> > suspect it may be possible to land in this state from the onset of a
> > freeze based on prior reclaim behavior. (I.e., we may want to make this
> > flush explicit on freeze, depending on the eventual solution.)
> 
> xfs_inodegc_stop() does a full queue flush and it's called during
> freeze from xfs_fs_sync_fs() after the page faults have been frozen
> and waited on. i.e. it does:
> 
> 	xfs_inodegc_queue_all()
> 	for_each_online_cpu(cpu) {
> 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
> 		cancel_work_sync(&gc->work);
> 	}
> 
> xfs_inodegc_queue_all() queues works all the pending non-empty per
> cpu queues, then we run cancel_work_sync() on them.
> cancel_work_sync() runs __flush_work() internally, and so
> it is almost the same as running { flush_work(); cancel_work(); }
> except that it serialises against other attemps to queue/cancel as
> it marks the work as having a cancel in progress.
> 

I don't think that is how this works: On 5.16.0-rc2:

           <...>-997     [000] .....   204.883864: xfs_destroy_inode: dev 253:3 ino 0x83 iflags 0x240
           <...>-997     [000] .....   204.883903: xfs_inode_set_need_inactive: dev 253:3 ino 0x83 iflags 0x240
        fsfreeze-998     [000] .....   204.916239: xfs_inodegc_stop: dev 253:3 m_features 0x1bf6a9 opstate (clean|blockgc) s_flags 0x70810000 caller xfs_fs_sync_fs+0x1b0/0x2d0 [xfs]

	<time passes>

           <...>-999     [000] .....   210.514662: xfs_inodegc_start: dev 253:3 m_features 0x1bf6a9 opstate (clean|inodegc|blockgc) s_flags 0x70810000 caller xfs_fs_unfreeze+0x8c/0xb0 [xfs]
           <...>-459     [000] .....   210.515669: xfs_inodegc_worker: dev 253:3 shrinker_hits 0
           <...>-459     [000] .....   210.515695: xfs_inode_inactivating: dev 253:3 ino 0x83 iflags 0x2640

I do occasionally see the worker run before the freeze, but it's racy. I
suspect the earlier loop in __cancel_work_timer() is where the caller
can either acquire/isolate a pending work item or busy loop on it if
executing or cancelling (and thus the documented "pending" return
value). (But yes, I understand there is intent to flush here and this is
probably a bug.)

> > Some internal discussion followed on potential improvements in response
> > to the deadlock report. Dave suggested potentially preventing reclaim of
> > inodes that would require inactivation, keeping them in cache, but it
> > appears we may not have enough control in the local fs to guarantee this
> > behavior out of the vfs and shrinkers (Dave can chime in on details, if
> > needed).
> 
> My idea was to check for inactivation being required in ->drop_inode
> and preventing linked inodes from being immediately reclaimed and
> hence inactivated by ensuring they always remain in the VFS cache.
> 
> This does not work because memory pressure will run the shrinkers
> and the inode cache shrinker does not give us an opportunity to say
> "do not reclaim this inode" before it evicts them from cache. Hence
> we'll get linked inodes that require inactivation work through the
> shrinker rather than from iput_final.
> 
> > He also suggested skipping eofb trims and sending such inodes
> > directly to reclaim.
> 
> This is what we do on read-only filesystems. This is exactly what
> happens if a filesystem is remounted RO with open files backed by
> clean inodes that have post-eof speculative preallocation attached
> when the remount occurs. This would just treat frozen filesystems
> the same as we currently treat remount,ro situations.
> 

I see an eofb scan on remount,ro:

           mount-1021    [000] .....   233.106239: xfs_blockgc_stop: dev 253:3 m_features 0x1bf6a9 opstate (clean|inodegc) s_flags 0x70810000 caller xfs_fs_reconfigure+0x255/0x7d0 [xfs]
           mount-1021    [000] .N...   233.106276: xfs_blockgc_free_space: dev 253:3 flags 0x0 uid 0 gid 0 prid 0 minsize 0 scan_limit 0 caller xfs_fs_reconfigure+0x25f/0x7d0 [xfs]
           mount-1021    [000] .....   233.107577: xfs_inode_clear_eofblocks_tag: dev 253:3 ino 0x83 iflags 0x240
           mount-1021    [000] .....   233.107760: xfs_inodegc_flush: dev 253:3 m_features 0x1bf6a9 opstate (clean|inodegc) s_flags 0x70810000 caller xfs_blockgc_free_space+0x159/0x220 [xfs]
           mount-1021    [000] .....   233.108061: xfs_inodegc_stop: dev 253:3 m_features 0x1bf6a9 opstate (clean) s_flags 0x70810000 caller xfs_fs_reconfigure+0x272/0x7d0 [xfs]

This was historically a cowblocks scan and looks like it was changed in
commit b943c0cd5615 ("xfs: hide xfs_icache_free_cowblocks"). So we've
had that scan there for almost a year now it looks like and I've not
heard of any issues.

That aside, the caveat to skipping only eofb inodes is that freeze still
has to queue inactivation of cowblocks inodes (and eofb inodes that
might still have delalloc blocks or also have cowblocks), thus we're
susceptible to the same behavior in general as if we just continue to
queue both.

> > My current preference is to invoke an inodegc flush
> > and blockgc scan during the freeze sequence so presumably no pending
> > inactive but potentially accessible (i.e. not unlinked) inodes can
> > reside in the queues for the duration of a freeze. Perhaps others have
> > different ideas or thoughts on these.
> 
> We have xfs_blockgc_flush_all() to do such a scan. We only do that
> at hard ENOSPC right now because it's an expensive, slow operation,
> especially if we have large caches and the system is under heavy CPU
> load. I'm not sure we really want to force such an operation to be
> performed during a freeze - freeze is supposed to put the filesystem
> into a consistent state on disk as fast as possible with minimum
> system-wide interruption. Doing stuff like force-trimming all
> post-eof speculative prealloc is not necessary to make the on-disk
> format consistent. Hence force-trimming seems more harmful to me
> than just treating the frozen state like a temporary RO state in
> terms of blockgc....
> 

We only did that at -ENOSPC because that was the only place that
originally needed such a mechanism. The purpose was obviously because we
need to return preallocated blocks to the free space pool to potentially
allow the operation to proceed. For example, this -ENOSPC dance is also
the only situation we call xfs_flush_inodes() to basically sync the
entire fs, and freeze already essentially does that, so..?

I think that there are enough tradeoffs here that we don't need to
pontificate about the performance impact of an eofb trim on freeze.
freeze is not currently implemented to be fast enough that that an eofb
trim is a show stopper without actual numbers demonstrating so. The
scanner is already running in the background (5m by default), so the
impact of a scan is going to be somewhat limited by that. It won't be
free, but it's generally comparable to several things freeze already
does (including some subset of the blockgc work on previously evicted
inodes via the inactive queue flush) and has for some time. So if we
really think an explicit scan could be a problem we can just measure it
and see if wanted to go that direction.

ISTM some of the objective caveats with either skipping trims on reclaim
or doing an explicit scan are:

- An explicit scan will lose extent contiguity for further extending
writes to impacted inodes. Subsequent writes should acquire new
preallocation, but frequent freezes with a sync -> eofb scan pattern
could contribute to free space fragmentation.

- A scan will have some non-zero, but thus far unsubstantiated cost at
freeze time. This is potentially mitigated by the background scanner,
but should be quantified.

- Conversely, skipping eofb scans leaves those post-eof blocks attached
to associated inodes, so even a subsequent -ENOSPC scan may not be
able to reclaim those blocks if the inodes are reclaimed and not written
to again. This could potentially account for a lot of space (8GB per
inode IIRC), and can potentially propagate to snapshots, etc. There is
similar behavior for cowblocks, but only in that log recovery of the
snapshot is required to clean up all the leftover cowblocks with no
inode owner.

- We still have some subset of "blockgc" inodes we'd have to queue
regardless. So if we wanted to minimize the scope of the lookup
stalling behavior for cowblocks inodes, or make it so a snapshot doesn't
have to do cowblocks recovery (both open questions), then ISTM we don't
have much other choice atm other than to reclaim those blocks up front.

Maybe there are other tradeoffs, but those seem the most obvious to me.
And of course there's always the option to just wait and see if the
current behavior causes problems for users in any way, collect data from
the associated use case and revisit from there. It's not like the
previous behavior wasn't in place for a fairly long time and the current
behavior is now at least recoverable on unfreeze. I just wanted to make
sure the behavior was at least discussed since we did ultimately receive
a bug report on the older bits and there are some options to consider...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

