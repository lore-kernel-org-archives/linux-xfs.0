Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1236C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 868B023102
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbhAMPds (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 10:33:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38255 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726959AbhAMPds (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 10:33:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610551941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+iNY+VTx9CP7idrh77cUdxNr4i8izyGysI0xq/sxqmc=;
        b=cqitFo6UqU7mG/JrKfvJ1TpIVHY3t2qeopg3tZBaFrFuTOCUs3NBU0Aa2rGHAYGyHUAu67
        3ONEnV8m+VXH9qX/DiEqmR72W2wIBXRundUljp21B3HAshSCLhwTyWbeZGEMas5bFHSb4q
        Q7p+oKY9NKUeebLhheOJTzNRmrgoHYU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-Q-i23fK9PrSZOWHvnwlbCw-1; Wed, 13 Jan 2021 10:32:19 -0500
X-MC-Unique: Q-i23fK9PrSZOWHvnwlbCw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70ACF107ACF7;
        Wed, 13 Jan 2021 15:32:18 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E6D410016F7;
        Wed, 13 Jan 2021 15:32:17 +0000 (UTC)
Date:   Wed, 13 Jan 2021 10:32:15 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, avi@scylladb.com
Subject: Re: [PATCH 09/10] iomap: add a IOMAP_DIO_NOALLOC flag
Message-ID: <20210113153215.GA1284163@bfoster>
References: <20210112162616.2003366-1-hch@lst.de>
 <20210112162616.2003366-10-hch@lst.de>
 <20210112232923.GD331610@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112232923.GD331610@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 13, 2021 at 10:29:23AM +1100, Dave Chinner wrote:
> On Tue, Jan 12, 2021 at 05:26:15PM +0100, Christoph Hellwig wrote:
> > Add a flag to request that the iomap instances do not allocate blocks
> > by translating it to another new IOMAP_NOALLOC flag.
> 
> Except "no allocation" that is not what XFS needs for concurrent
> sub-block DIO.
> 
> We are trying to avoid external sub-block IO outside the range of
> the user data IO (COW, sub-block zeroing, etc) so that we don't
> trash adjacent sub-block IO in flight. This means we can't do
> sub-block zeroing and that then means we can't map unwritten extents
> or allocate new extents for the sub-block IO.  It also means the IO
> range cannot span EOF because that triggers unconditional sub-block
> zeroing in iomap_dio_rw_actor().
> 
> And because we may have to map multiple extents to fully span an IO
> range, we have to guarantee that subsequent extents for the IO are
> also written otherwise we have a partial write abort case. Hence we
> have single extent limitations as well.
> 
> So "no allocation" really doesn't describe what we want this flag to
> at all.
> 
> If we're going to use a flag for this specific functionality, let's
> call it what it is: IOMAP_DIO_UNALIGNED/IOMAP_UNALIGNED and do two
> things with it.
> 
> 	1. Make unaligned IO a formal part of the iomap_dio_rw()
> 	behaviour so it can do the common checks to for things that
> 	need exclusive serialisation for unaligned IO (i.e. avoid IO
> 	spanning EOF, abort if there are cached pages over the
> 	range, etc).
> 
> 	2. require the filesystem mapping callback do only allow
> 	unaligned IO into ranges that are contiguous and don't
> 	require mapping state changes or sub-block zeroing to be
> 	performed during the sub-block IO.
> 
> 

Something I hadn't thought about before is whether applications might
depend on current unaligned dio serialization for coherency and thus
break if the kernel suddenly allows concurrent unaligned dio to pass
through. Should this be something that is explicitly requested by
userspace?

That aside, I agree that the DIO_UNALIGNED approach seems a bit more
clear than NOALLOC, but TBH the more I look at this the more Christoph's
first approach seems cleanest to me. It is a bit unfortunate to
duplicate the mapping lookups and have the extra ILOCK cycle, but the
lock is shared and only taken when I/O is unaligned. I don't really see
why that is a show stopper yet it's acceptable to fall back to exclusive
dio if the target range happens to be discontiguous (but otherwise
mapped/written).

So I dunno... to me, I would start with that approach and then as the
implementation soaks, perhaps see if we can find a way to optimize away
the extra cycle and lookup. In the meantime, performance should still be
improved significantly and the behavior fairly predictable. Anyways, I
suspect Dave disagrees so that's just my .02. ;) I'll let you guys find
some common ground and make a pass at whatever falls out...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

