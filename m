Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE22C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 14:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62D0322527
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 14:16:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aXgiiLY/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbfLLOQm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 09:16:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43461 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729578AbfLLOQk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 09:16:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576160198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9lm88BG8NYqaWUyXAwteHFEkkc4gWWJS2mJfJttkcmE=;
        b=aXgiiLY/1t+nCammlVdwCgHgaHEcktBgnS5Ikfi6b/Z0PUSjNOOlRUuHDQRs4Tj5OgXeqc
        5F7mK3BiPZAYZoJs9nuF+joInG/4VUYec8H3+dYGLpBLsmw9J0Toso9rUjccqnXm49Fpm1
        OSb6esSXeFqaOUF8svYDMD9L43EyJFM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-Age8Lml4PTmT7syRDaFmxA-1; Thu, 12 Dec 2019 09:16:36 -0500
X-MC-Unique: Age8Lml4PTmT7syRDaFmxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1DF7801E7A;
        Thu, 12 Dec 2019 14:16:34 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C1A210013A1;
        Thu, 12 Dec 2019 14:16:34 +0000 (UTC)
Date:   Thu, 12 Dec 2019 09:16:34 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: stabilize insert range start boundary to avoid COW
 writeback race
Message-ID: <20191212141634.GA36655@bfoster>
References: <20191210132340.11330-1-bfoster@redhat.com>
 <20191210214100.GB19256@dread.disaster.area>
 <20191211124712.GB16095@bfoster>
 <20191211205230.GD19256@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211205230.GD19256@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 12, 2019 at 07:52:30AM +1100, Dave Chinner wrote:
> On Wed, Dec 11, 2019 at 07:47:12AM -0500, Brian Foster wrote:
> > On Wed, Dec 11, 2019 at 08:41:00AM +1100, Dave Chinner wrote:
> > > On Tue, Dec 10, 2019 at 08:23:40AM -0500, Brian Foster wrote:
> > > I think insert/collapse need to be converted to work like a
> > > truncate operation instead of a series on individual write
> > > operations. That is, they are a permanent transaction that locks the
> > > inode once and is rolled repeatedly until the entire extent listi
> > > modification is done and then the inode is unlocked.
> > > 
> > 
> > Note that I don't think it's sufficient to hold the inode locked only
> > across the shift. For the insert case, I think we'd need to grab it
> > before the extent split at the target offset and roll from there.
> > Otherwise the same problem could be reintroduced if we eventually
> > replaced the xfs_prepare_shift() tweak made by this patch. Of course,
> > that doesn't look like a big problem. The locking is already elevated
> > and split and shift even use the same transaction type, so it's mostly a
> > refactor from a complexity standpoint. 
> 
> *nod*
> 
> > For the collapse case, we do have a per-shift quota reservation for some
> > reason. If that is required, we'd have to somehow replace it with a
> > worst case calculation. That said, it's not clear to me why that
> > reservation even exists.
> 
> I'm not 100% sure, either, but....
> 
> > The pre-shift hole punch is already a separate
> > transaction with its own such reservation. The shift can merge extents
> > after that point (though most likely only on the first shift), but that
> > would only ever remove extent records. Any thoughts or objections if I
> > just killed that off?
> 
> Yeah, I suspect that it is the xfs_bmse_merge() case freeing blocks
> the reservation is for, and I agree that it should only happen on
> the first shift because all the others that are moved are identical
> in size and shape and would have otherwise been merged at creation.
> 
> Hence I think we can probably kill the xfs_bmse_merge() case,
> though it might be wrth checking first how often it gets called...
> 

Ok, but do we need an up-front quota reservation for freeing blocks out
of the bmapbt? ISTM the reservation could be removed regardless of the
merging behavior. This is what my current patch does, at least, so we'll
see if anything explodes. :P

I agree on the xfs_bmse_merge() bit. I was planning to leave that as is
however because IIRC, even though it is quite rare, I thought we had a
few corner cases where it was possible for physically and logically
contiguous extents to track separately in a mapping tree. Max sized
extents that are subsequently punched out or truncated might be one
example. I thought we had others, but I can't quite put my finger on it
atm..

> > > > To address this problem, update the shift preparation code to
> > > > stabilize the start boundary along with the full range of the
> > > > insert. Also update the existing corruption check to fail if any
> > > > extent is shifted with a start offset behind the target offset of
> > > > the insert range. This prevents insert from racing with COW
> > > > writeback completion and fails loudly in the event of an unexpected
> > > > extent shift.
> > > 
> > > It looks ok to avoid this particular symptom (backportable point
> > > fix), but I really think we should convert insert/collapse to be
> > > atomic w.r.t other extent list modifications....
> > > 
> > 
> > Ok, I think that approach is reasonable so long as we do it in two
> > phases as such to minimize backport churn and separate bug fix from
> > behavior change.
> > 
> > Unless there is other feedback on this patch, is there any objection to
> > getting this one reviewed/merged independently?
> 
> Not here. Seems like the right approach to me. SO for the original
> patch:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 

Thanks. FWIW, I whipped up a few patches to hold ilock across insert and
collapse yesterday that survive cursory testing. I'll get them on the
list after more thorough testing..

Brian

> -- 
> Dave Chinner
> david@fromorbit.com
> 

