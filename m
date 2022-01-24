Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C1C4C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 15:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbiAXPGp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 10:06:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27451 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230516AbiAXPGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 10:06:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643036804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+3UY4M9TiHeqF4ulBLiFHpYUN9C3uj9E8bS4L68K4no=;
        b=L0keUXAMwhZvXV9jUO9h6fj9f3eMiuRBlNzcNj7qQUk0opA+IxUf5f2CC3ZoYSCQqlEu3C
        rAtTbEe4r5bGqGFLJGdhnR5aXyGUu9Nkuu45ZvHSdf9Gk0gRkmF5S0k+s7x7modhWpR5kK
        NYsKpFBwBZpDZgZgdIGaRvtipUco0Cs=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-EU1L700sPXalQ_h4iyTflg-1; Mon, 24 Jan 2022 10:06:43 -0500
X-MC-Unique: EU1L700sPXalQ_h4iyTflg-1
Received: by mail-qt1-f198.google.com with SMTP id w29-20020ac84d1d000000b002d006e69594so1305240qtv.18
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 07:06:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+3UY4M9TiHeqF4ulBLiFHpYUN9C3uj9E8bS4L68K4no=;
        b=fymaNSvp9Og1NLp8e+/XFLaEg9qAY+3k9VAPfWquOc0G0WUI8o1OaR4GNgIrpefmWG
         ViwBWc6x4fI4hKUTArJ6U8dQquv6L2pOPz1C7tGo3h0XdYn9fJNYRM4yv7CNwUDdNu9q
         T2unis0YmOb26oBtdFmks9R32CaoFZ5rxgJtqHI6/fgxM2hyIEl2yENPxij17howbcbP
         9X3oGyZSxzqCTmCnmbI7rCxFFww0q5t52goouGPa2F8g5YHol5/pYAQL4xIctTs6AtG4
         lroT/2ipD6tdHwxkQEd5t5ALbWSlmCzLfgLCq1XnNubYE8D5qyygP2YsyGWq1mwqF4Ou
         9Iww==
X-Gm-Message-State: AOAM532TMUWA/mOgk9T4Qv3MaEM8cvuQ74Nsvj6BLpE7LPNeGgO+vLUk
        Nn+T3mBPVEJnAOQstS3n8CmV8T6vKITwL0lW6vSPRwGGXy+mVVVZLxYbIeK2MO8lb+zp9GKREAW
        xWe4jC2Hg9glxtN5yz1My
X-Received: by 2002:ac8:5e0c:: with SMTP id h12mr12863210qtx.65.1643036802841;
        Mon, 24 Jan 2022 07:06:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2mzsJQY8kdVplVLLoqewmMafFey5ohNR7PXoFDBFv9i22xEZO+iOglLMmm+uQoPd80nHt8Q==
X-Received: by 2002:ac8:5e0c:: with SMTP id h12mr12863142qtx.65.1643036802163;
        Mon, 24 Jan 2022 07:06:42 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id h6sm7383392qkk.125.2022.01.24.07.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 07:06:41 -0800 (PST)
Date:   Mon, 24 Jan 2022 10:06:40 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <Ye7AgAfr6xq8VWVh@bfoster>
References: <20220121142454.1994916-1-bfoster@redhat.com>
 <20220123224346.GJ59729@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123224346.GJ59729@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 24, 2022 at 09:43:46AM +1100, Dave Chinner wrote:
> On Fri, Jan 21, 2022 at 09:24:54AM -0500, Brian Foster wrote:
> > The XFS inode allocation algorithm aggressively reuses recently
> > freed inodes. This is historical behavior that has been in place for
> > quite some time, since XFS was imported to mainline Linux. Once the
> > VFS adopted RCUwalk path lookups (also some time ago), this behavior
> > became slightly incompatible because the inode recycle path doesn't
> > isolate concurrent access to the inode from the VFS.
> > 
> > This has recently manifested as problems in the VFS when XFS happens
> > to change the type or properties of a recently unlinked inode while
> > still involved in an RCU lookup. For example, if the VFS refers to a
> > previous incarnation of a symlink inode, obtains the ->get_link()
> > callback from inode_operations, and the latter happens to change to
> > a non-symlink type via a recycle event, the ->get_link() callback
> > pointer is reset to NULL and the lookup results in a crash.
> > 
> > To avoid this class of problem, isolate in-core inodes for recycling
> > with an RCU grace period. This is the same level of protection the
> > VFS expects for inactivated inodes that are never reused, and so
> > guarantees no further concurrent access before the type or
> > properties of the inode change. We don't want an unconditional
> > synchronize_rcu() event here because that would result in a
> > significant performance impact to mixed inode allocation workloads.
> > 
> > Fortunately, we can take advantage of the recently added deferred
> > inactivation mechanism to mitigate the need for an RCU wait in most
> > cases. Deferred inactivation queues and batches the on-disk freeing
> > of recently destroyed inodes, and so significantly increases the
> > likelihood that a grace period has elapsed by the time an inode is
> > freed and observable by the allocation code as a reuse candidate.
> > Capture the current RCU grace period cookie at inode destroy time
> > and refer to it at allocation time to conditionally wait for an RCU
> > grace period if one hadn't expired in the meantime.  Since only
> > unlinked inodes are recycle candidates and unlinked inodes always
> > require inactivation, we only need to poll and assign RCU state in
> > the inactivation codepath.
> 
> I think this assertion is incorrect.
> 
> Recycling can occur on any inode that has been evicted from the VFS
> cache. i.e. while the inode is sitting in XFS_IRECLAIMABLE state
> waiting for the background inodegc to run (every ~5s by default) a
> ->lookup from the VFS can occur and we find that same inode sitting
> there in XFS_IRECLAIMABLE state. This lookup then hits the recycle
> path.
> 

See my reply to Darrick wrt to the poor wording. I'm aware of the
eviction -> recycle case, just didn't think we needed to deal with it
here.

> In this case, even though we re-instantiate the inode into the same
> identity, it goes through a transient state where the inode has it's
> identity returned to the default initial "just allocated" VFS state
> and this transient state can be visible from RCU lookups within the
> RCU grace period the inode was evicted from. This means the RCU
> lookup could see the inode with i_ops having been reset to
> &empty_ops, which means any method called on the inode at this time
> (e.g. ->get_link) will hit a NULL pointer dereference.
> 

Hmm, good point.

> This requires multiple concurrent lookups on the same inode that
> just got evicted, some which the RCU pathwalk finds the old stale
> dentry/inode pair, and others that don't find that old pair. This is
> much harder to trip over but, IIRC, we used to see this quite a lot
> with NFS server workloads when multiple operations on a single inode
> could come in from multiple clients and be processed in parallel by
> knfsd threads. This was quite a hot path before the NFS server had an
> open-file cache added to it, and it probably still is if the NFS
> server OFC is not large enough for the working set of files being
> accessed...
> 
> Hence we have to ensure that RCU lookups can't find an evicted inode
> through anything other than xfs_iget() while we are re-instantiating
> the VFS inode state in xfs_iget_recycle().  Hence the RCU state
> sampling needs to be done unconditionally for all inodes going
> through ->destroy_inode so we can ensure grace periods expire for
> all inodes being recycled, not just those that required
> inactivation...
> 

Yeah, that makes sense. So this means we don't want to filter to
unlinked inodes, but OTOH Paul's feedback suggests the RCU calls should
be fairly efficient on a per-inode basis. On top of that, the
non-unlinked eviction case doesn't have such a direct impact on a mixed
workload the way the unlinked case does (i.e. inactivation populating a
free inode record for the next inode allocation to discover), so this is
probably less significant of a change.

Personally, my general takeaway from the just posted test results is
that we really should be thinking about how to shift the allocation path
cost away into the inactivation side, even if not done from the start.
This changes things a bit because we know we need an rcu sync in the
iget path for the (non-unlinnked) eviction case regardless, so perhaps
the right approach is to get the basic functional fix in place to start,
then revisit potential optimizations in the inactivation path for the
unlinked inode case. IOW, a conditional, asynchronous rcu delay in the
inactivation path (only) for unlinked inodes doesn't remove the need for
an iget rcu sync in general, but it would still improve inode allocation
performance if we ensure those inodes aren't reallocatable until a grace
period has elapsed. We just have to implement it in a way that doesn't
unreasonably impact sustained removal performance. Thoughts?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

