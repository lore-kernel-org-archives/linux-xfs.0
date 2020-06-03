Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 827A5C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 14:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 613AE207D5
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 14:57:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A+dYuH67"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgFCO54 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 10:57:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48996 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725930AbgFCO54 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 10:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591196274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ADR1haksbkT8yq+yYyUB6udc/bFbx+slzlJFGT/96Hw=;
        b=A+dYuH67Oe2FNVHYAOhvD74Iw99bIVwSlfNAcsoMAgE63fIQHaJgrj/HVVYRGhIXlBlY2B
        Hikosk4M9+c1hbl43V2q+NiWbebnVnLZ3gGIEHN34188tduY/hVgjCoPll1953j4C+jQ4T
        sAQJI85sdRTO4fVlQiEy5PY5Q36rFGc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-WVtTc8MjO6a0OMmVRpDN3Q-1; Wed, 03 Jun 2020 10:57:52 -0400
X-MC-Unique: WVtTc8MjO6a0OMmVRpDN3Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDD8064AD0;
        Wed,  3 Jun 2020 14:57:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 93A3410013D5;
        Wed,  3 Jun 2020 14:57:51 +0000 (UTC)
Date:   Wed, 3 Jun 2020 10:57:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/30] xfs: mark inode buffers in cache
Message-ID: <20200603145749.GA12332@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-5-david@fromorbit.com>
 <20200602164535.GD7967@bfoster>
 <20200602212918.GF2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602212918.GF2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 03, 2020 at 07:29:18AM +1000, Dave Chinner wrote:
> On Tue, Jun 02, 2020 at 12:45:35PM -0400, Brian Foster wrote:
> > On Tue, Jun 02, 2020 at 07:42:25AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Inode buffers always have write IO callbacks, so by marking them
> > > directly we can avoid needing to attach ->b_iodone functions to
> > > them. This avoids an indirect call, and makes future modifications
> > > much simpler.
> > > 
> > > This is largely a rearrangement of the code at this point - no IO
> > > completion functionality changes at this point, just how the
> > > code is run is modified.
> > > 
> > 
> > Ok, I was initially thinking this patch looked incomplete in that we
> > continue to set ->b_iodone() on inode buffers even though we'd never
> > call it. Looking ahead, I see that the next few patches continue to
> > clean that up to eventually remove ->b_iodone(), so that addresses that.
> > 
> > My only other curiosity is that while there may not be any functional
> > difference, this technically changes callback behavior in that we set
> > the new flag in some contexts that don't currently attach anything to
> > the buffer, right? E.g., xfs_trans_inode_alloc_buf() sets the flag on
> > inode chunk init, which means we can write out an inode buffer without
> > any attached/flushed inodes.
> 
> Yes, it can happen, and it happens before this patch, too, because
> the AIL can push the buffer log item directly and that does not
> flush dirty inodes to the buffer before it writes back(*).
> 

I was thinking more about cases where there are actually no inodes
attached.

> As it is, xfs_buf_inode_iodone() on a buffer with no inode attached
> if functionally identical to the existing xfs_buf_iodone() callback
> that would otherwise be done. i.e. it just runs the buffer log item
> completion callback. Hence the change here rearranges code, but it
> does not change behaviour at all.
> 

Right. That's indicative from the code, but doesn't help me understand
why the change is made. That's all I'm asking for...

> (*) this is a double-write bug that this patch set does not address.
> i.e. buffer log item flushes the buffer without flushing inodes, IO
> compeletes, then inode flush to the buffer and we do another IO to
> clean them.  This is addressed by a follow-on patchset that tracks
> dirty inodes via ordered cluster buffers, such that pushing the
> buffer always triggers xfs_iflush_cluster() on buffers tagged
> _XBF_INODES...
> 

Ok, interesting (but seems beyond the scope of this series).

> > Is the intent of that to support future
> > changes? If so, a note about that in the commit log would be helpful.
> 
> That's part of it, as you can see from the (*) above. But the commit
> log already says "..., and makes future modifications much simpler."
> Was that insufficient to indicate that it will be used later on?
> 

That's a rather vague hint. ;P I was more hoping for something like:
"While this is largely a refactor of existing functionality, broaden the
scope of the flag to beyond where inodes are explicitly attached because
<some actual reason>. This has the effect of possibly invoking the
callback in cases where it wouldn't have been previously, but this is
not a functional change because the callback is effectively a no-op when
inodes are not attached."

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

