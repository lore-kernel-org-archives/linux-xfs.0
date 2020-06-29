Return-Path: <SRS0=2z4t=AK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2E7C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 18:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECC88204EC
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 18:45:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PT3vgVBf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgF2Spf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 14:45:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60996 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729041AbgF2SpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jun 2020 14:45:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593456310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C8p+g/bhhWgJJpsjfpg/BDWzFyh4M4c6HCRnxTXHtTc=;
        b=PT3vgVBfQJ5E8cgTuPCZNjgk95OUYXha7ngqrHd6YRfglJvyFIvlRpc/gHDHv5+Z1rTtPP
        IK4kjl9I3M/Qi1XbT9gQQ8kNdfwSnXGeoEMWDTHCj7Tg437fxN7dKmoV0q0G1nM08l5Ant
        6VYBwyj3K1ARXE54VP1pN5Lt4uJnSFY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-NcQ64LAZMp6uZxzZQhG4IA-1; Mon, 29 Jun 2020 09:43:29 -0400
X-MC-Unique: NcQ64LAZMp6uZxzZQhG4IA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC20080572D;
        Mon, 29 Jun 2020 13:43:27 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 00B4810013C1;
        Mon, 29 Jun 2020 13:43:24 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05TDhOV0013363;
        Mon, 29 Jun 2020 09:43:24 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05TDhNGN013360;
        Mon, 29 Jun 2020 09:43:24 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Mon, 29 Jun 2020 09:43:23 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Dave Chinner <david@fromorbit.com>
cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/6] Overhaul memalloc_no*
In-Reply-To: <20200629003550.GJ2005@dread.disaster.area>
Message-ID: <alpine.LRH.2.02.2006290918030.11293@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200625113122.7540-1-willy@infradead.org> <alpine.LRH.2.02.2006261058250.11899@file01.intranet.prod.int.rdu2.redhat.com> <20200626230847.GI2005@dread.disaster.area> <alpine.LRH.2.02.2006270848540.14350@file01.intranet.prod.int.rdu2.redhat.com>
 <20200629003550.GJ2005@dread.disaster.area>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On Mon, 29 Jun 2020, Dave Chinner wrote:

> On Sat, Jun 27, 2020 at 09:09:09AM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Sat, 27 Jun 2020, Dave Chinner wrote:
> > 
> > > On Fri, Jun 26, 2020 at 11:02:19AM -0400, Mikulas Patocka wrote:
> > > > Hi
> > > > 
> > > > I suggest to join memalloc_noio and memalloc_nofs into just one flag that 
> > > > prevents both filesystem recursion and i/o recursion.
> > > > 
> > > > Note that any I/O can recurse into a filesystem via the loop device, thus 
> > > > it doesn't make much sense to have a context where PF_MEMALLOC_NOFS is set 
> > > > and PF_MEMALLOC_NOIO is not set.
> > > 
> > > Correct me if I'm wrong, but I think that will prevent swapping from
> > > GFP_NOFS memory reclaim contexts.
> > 
> > Yes.
> > 
> > > IOWs, this will substantially
> > > change the behaviour of the memory reclaim system under sustained
> > > GFP_NOFS memory pressure. Sustained GFP_NOFS memory pressure is
> > > quite common, so I really don't think we want to telling memory
> > > reclaim "you can't do IO at all" when all we are trying to do is
> > > prevent recursion back into the same filesystem.
> > 
> > So, we can define __GFP_ONLY_SWAP_IO and __GFP_IO.
> 
> Uh, why?
> 
> Exactly what problem are you trying to solve here?

This:

1. The filesystem does a GFP_NOFS allocation.
2. The allocation calls directly a dm-bufio shrinker.
3. The dm-bufio shrinker sees that there is __GFP_IO set, so it assumes 
   that it can do I/O. It selects some dirty buffers, writes them back and 
   waits for the I/O to finish.
4. The dirty buffers belong to a loop device.
5. The loop device thread calls the filesystem that did the GFP_NOFS 
   allocation in step 1 (and that is still waiting for the allocation to 
   succeed).

Note that setting PF_MEMALLOC_NOIO on the loop thread won't help with this 
deadlock.

Do you argue that this is a bug in dm-bufio? Or a bug in the kernel? Or 
that it can't happen?

> > I saw this deadlock in the past in the dm-bufio subsystem - see the commit 
> > 9d28eb12447ee08bb5d1e8bb3195cf20e1ecd1c0 that fixed it.
> 
> 2014?
> 
> /me looks closer.
> 
> Hmmm. Only sent to dm-devel, no comments, no review, just merged.
> No surprise that nobody else actually knows about this commit. Well,
> time to review it ~6 years after it was merged....
> 
> | dm-bufio tested for __GFP_IO. However, dm-bufio can run on a loop block
> | device that makes calls into the filesystem. If __GFP_IO is present and
> | __GFP_FS isn't, dm-bufio could still block on filesystem operations if it
> | runs on a loop block device.
> 
> OK, so from an architectural POV, this commit is fundamentally
> broken - block/device layer allocation should not allow relcaim
> recursion into filesystems because filesystems are dependent on
> the block layer making forwards progress. This commit is trying to
> work around the loop device doing GFP_KERNEL/GFP_NOFS context
> allocation back end IO path of the loop device. This part of the
> loop device is a block device, so needs to run under GFP_NOIO
> context.

I agree that it is broken, but it fixes the above deadlock.

Mikulas

