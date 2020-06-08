Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C487C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 16:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C6E2206A4
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 16:44:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="azt+uxYD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbgFHQog (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 12:44:36 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34009 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730588AbgFHQoe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 12:44:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591634671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZXsxEPO2dqtsN1V/zw6WIiQckgi+26vTDHT84mTWxQI=;
        b=azt+uxYDXG9ybxVO7LkRB3IHTyQ8lNKYpY5Tovjl5EiLUc0q5hlPWWhRzxPGGFC66mE59n
        P0fvPXitDHTF4PfYZgiHI0buFWiPsnHeI21rEOj4Q2Kiyh4+dYULm8521aS5llRo2BQKtJ
        342h/V7yrKHLJKs00lL7m92RoipacKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-DWHJlRPzP6uaP_NUKSfsFw-1; Mon, 08 Jun 2020 12:44:21 -0400
X-MC-Unique: DWHJlRPzP6uaP_NUKSfsFw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E6AB8014D4;
        Mon,  8 Jun 2020 16:44:20 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B9DDD768AE;
        Mon,  8 Jun 2020 16:44:19 +0000 (UTC)
Date:   Mon, 8 Jun 2020 12:44:17 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/30] xfs: allow multiple reclaimers per AG
Message-ID: <20200608164417.GA36278@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-20-david@fromorbit.com>
 <20200605162611.GC23747@bfoster>
 <20200605210746.GC2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605210746.GC2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 06, 2020 at 07:07:46AM +1000, Dave Chinner wrote:
> On Fri, Jun 05, 2020 at 12:26:11PM -0400, Brian Foster wrote:
> > On Thu, Jun 04, 2020 at 05:45:55PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Inode reclaim will still throttle direct reclaim on the per-ag
> > > reclaim locks. This is no longer necessary as reclaim can run
> > > non-blocking now. Hence we can remove these locks so that we don't
> > > arbitrarily block reclaimers just because there are more direct
> > > reclaimers than there are AGs.
> > > 
> > > This can result in multiple reclaimers working on the same range of
> > > an AG, but this doesn't cause any apparent issues. Optimising the
> > > spread of concurrent reclaimers for best efficiency can be done in a
> > > future patchset.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/xfs_icache.c | 31 ++++++++++++-------------------
> > >  fs/xfs/xfs_mount.c  |  4 ----
> > >  fs/xfs/xfs_mount.h  |  1 -
> > >  3 files changed, 12 insertions(+), 24 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index 74032316ce5cc..c4ba8d7bc45bc 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > ...
> > > @@ -1298,11 +1293,9 @@ xfs_reclaim_inodes_ag(
> > >  
> > >  		} while (nr_found && !done && *nr_to_scan > 0);
> > >  
> > > -		if (trylock && !done)
> > > -			pag->pag_ici_reclaim_cursor = first_index;
> > > -		else
> > > -			pag->pag_ici_reclaim_cursor = 0;
> > > -		mutex_unlock(&pag->pag_ici_reclaim_lock);
> > > +		if (done)
> > > +			first_index = 0;
> > > +		WRITE_ONCE(pag->pag_ici_reclaim_cursor, first_index);
> > 
> > I thought the [READ|WRITE]_ONCE() macros had to do with ordering, not
> > necessarily atomicity. Is this write safe if we're running a 32-bit
> > kernel, for example? Outside of that the broader functional change seems
> > reasonable.
> 
> They are used for documenting intentional data races now, too.
> That's what these are - we don't care about serialisation, but there
> are static checkers that will now spew "data race" warnings because
> multiple threads can race reading and writing unserialised
> variables.
> 

I wasn't aware of that. I'm not sure how widely known that is so it
might be worth a one liner comment to ensure these are preserved (if
they survive the end of the series).

> It is safe on 32 bit machines because these variables are 32 bit on
> 32 bit machines, and reads/writes of 32 bit variables on 32 bit
> machines are atomic (though not serialised).
> 

Ah, right. I was thinking they were always 64-bit but that is not the
case. With that:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

