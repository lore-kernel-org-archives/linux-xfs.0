Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E48DC433E7
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 14:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB964247C0
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 14:07:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IyPfxi8I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388375AbgJMOHl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 10:07:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388361AbgJMOHl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 10:07:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602598060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2D0CgrqM01BAasfI9zLQCUq2mokhVmiKHklOke9EM9o=;
        b=IyPfxi8I3hrqDssZE/uFarY9RoJqmJ7NXjvtjftDGKSR0mnK//8wPLt7cIYLINldLsdnxI
        f1NX5Vlk62SdR6h9Po/BDj7cxI3H1F8P+gi1SIUj3xFIQnyA96jMMDGN4+BC7vXnZG5LTS
        BZVPUt6XVs28RpMoxcmonArrdAyLxwI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-O1xHf1OxN7CWjBw9hcFG2Q-1; Tue, 13 Oct 2020 10:07:38 -0400
X-MC-Unique: O1xHf1OxN7CWjBw9hcFG2Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32B6A1084C82;
        Tue, 13 Oct 2020 14:07:37 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E55910027A5;
        Tue, 13 Oct 2020 14:07:28 +0000 (UTC)
Date:   Tue, 13 Oct 2020 10:07:26 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: introduce xfs_validate_stripe_geometry()
Message-ID: <20201013140726.GH966478@bfoster>
References: <20201013034853.28236-1-hsiangkao@redhat.com>
 <20201013134411.GE966478@bfoster>
 <20201013135537.GB12025@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013135537.GB12025@xiangao.remote.csb>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 13, 2020 at 09:55:37PM +0800, Gao Xiang wrote:
> Hi Brian,
> 
> On Tue, Oct 13, 2020 at 09:44:11AM -0400, Brian Foster wrote:
> > On Tue, Oct 13, 2020 at 11:48:53AM +0800, Gao Xiang wrote:
> > > Introduce a common helper to consolidate stripe validation process.
> > > Also make kernel code xfs_validate_sb_common() use it first.
> > > 
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > > v1: https://lore.kernel.org/r/20201009050546.32174-1-hsiangkao@redhat.com
> > > 
> > > changes since v1:
> > >  - rename the helper to xfs_validate_stripe_geometry() (Brian);
> > >  - drop a new added trailing newline in xfs_sb.c (Brian);
> > >  - add a "bool silent" argument to avoid too many error messages (Brian).
> > > 
> > >  fs/xfs/libxfs/xfs_sb.c | 70 +++++++++++++++++++++++++++++++++++-------
> > >  fs/xfs/libxfs/xfs_sb.h |  3 ++
> > >  2 files changed, 62 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index 5aeafa59ed27..9178715ded45 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -360,21 +360,18 @@ xfs_validate_sb_common(
> > >  		}
> > >  	}
> > >  
> > > -	if (sbp->sb_unit) {
> > > -		if (!xfs_sb_version_hasdalign(sbp) ||
> > > -		    sbp->sb_unit > sbp->sb_width ||
> > > -		    (sbp->sb_width % sbp->sb_unit) != 0) {
> > > -			xfs_notice(mp, "SB stripe unit sanity check failed");
> > > -			return -EFSCORRUPTED;
> > > -		}
> > > -	} else if (xfs_sb_version_hasdalign(sbp)) {
> > > +	/*
> > > +	 * Either (sb_unit and !hasdalign) or (!sb_unit and hasdalign)
> > > +	 * would imply the image is corrupted.
> > > +	 */
> > > +	if (!sbp->sb_unit ^ !xfs_sb_version_hasdalign(sbp)) {
> > 
> > This can be simplified to drop the negations (!), right?
> 
> Thanks for the suggestion.
> 
> yet nope, honestly I don't think so, the reason is that sbp->sb_unit is
> an integer here rather than a boolean, so negations cannot be
> simplified and I think it's simpliest now... (some boolean algebra...)
> 

Oh, right. So you'd actually need something like (!!sunit ^ hasdalign())
to avoid the bit operation.

Brian

> > 
> > >  		xfs_notice(mp, "SB stripe alignment sanity check failed");
> 
> ...
> 
> > > +	if (sectorsize && sunit % sectorsize) {
> > > +		if (!silent)
> > > +			xfs_notice(mp,
> > > +"stripe unit (%lld) must be a multiple of the sector size (%d)",
> > > +				   sunit, sectorsize);
> > > +		return false;
> > > +	}
> > > +
> > > +	if (sunit && !swidth) {
> > > +		if (!silent)
> > > +			xfs_notice(mp,
> > > +"invalid stripe unit (%lld) and stripe width of 0", sunit);
> > > +		return false;
> > > +	}
> > > +
> > > +	if (!sunit && swidth) {
> > > +		if (!silent)
> > > +			xfs_notice(mp,
> > > +"invalid stripe width (%lld) and stripe unit of 0", swidth);
> > > +		return false;
> > > +	}
> > > +
> > > +	if (sunit > swidth) {
> > > +		if (!silent)
> > > +			xfs_notice(mp,
> > > +"stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
> > > +		return false;
> > > +	}
> > > +
> > > +	if (sunit && (swidth % sunit)) {
> > 
> > It might be good to use (or not) params consistently. I.e., the
> > sectorsize check earlier in the function has similar logic structure but
> > drops the params.
> 
> Yeah, that is due to the line was copied from somewhere else... so...
> Anyway, I can resend a quick fix for this if needed. Wait a sec
> for some potential feedback...
> 
> Thanks,
> Gao Xiang
> 
> > 
> > Those nits aside:
> > 
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > 
> 

