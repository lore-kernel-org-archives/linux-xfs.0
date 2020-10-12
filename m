Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF16C43467
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 14:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BA9A2076E
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 14:18:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ATNeK2QT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgJLOSS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 10:18:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726724AbgJLOSS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 10:18:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602512296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FTcofmlVYGyT/M/cIZ/BYhsWlqOnGBDRG3wmRpyAc40=;
        b=ATNeK2QTx3JDByDSn453BRyPVQyWTg7ir8AtZM9DZ2Ql5kC6yX6nVrfA123kVFRy03fCMi
        jt9HqwjBPamlCScxdBR/0PjcleoSqjDofzu+HkEYBaxPzvPLftL9ev/VnbDFRZIzFRlMLd
        WjI2WSRfdjZlfMFDeeu6umZTLfqNdpY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-2LsJlbLVMtuR_n_9biAc7g-1; Mon, 12 Oct 2020 10:18:14 -0400
X-MC-Unique: 2LsJlbLVMtuR_n_9biAc7g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B110803F60;
        Mon, 12 Oct 2020 14:17:28 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0024410013BD;
        Mon, 12 Oct 2020 14:17:22 +0000 (UTC)
Date:   Mon, 12 Oct 2020 10:17:20 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfs: introduce xfs_validate_stripe_factors()
Message-ID: <20201012141720.GF917726@bfoster>
References: <20201009050546.32174-1-hsiangkao@redhat.com>
 <20201012130524.GD917726@bfoster>
 <20201012135536.GA614@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012135536.GA614@xiangao.remote.csb>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 12, 2020 at 09:55:36PM +0800, Gao Xiang wrote:
> Hi Brian,
> 
> On Mon, Oct 12, 2020 at 09:05:24AM -0400, Brian Foster wrote:
> > On Fri, Oct 09, 2020 at 01:05:46PM +0800, Gao Xiang wrote:
> > > Introduce a common helper to consolidate stripe validation process.
> > > Also make kernel code xfs_validate_sb_common() use it first.
> > > 
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> 
> ...
> 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index 5aeafa59ed27..cb2a7aa0ad51 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > ...
> > > @@ -1233,3 +1230,49 @@ xfs_sb_get_secondary(
> > >  	*bpp = bp;
> > >  	return 0;
> > >  }
> > > +
> > > +/*
> > > + * sunit, swidth, sectorsize(optional with 0) should be all in bytes,
> > > + * so users won't be confused by values in error messages.
> > > + */
> > > +bool
> > > +xfs_validate_stripe_factors(
> > 
> > xfs_validate_stripe_geometry() perhaps?
> 
> Thanks for the review!
> 
> Ok, I'm fine with the naming, since I had no better name
> about it at that time :)
> 
> > 
> > > +	struct xfs_mount	*mp,
> > > +	__s64			sunit,
> > > +	__s64			swidth,
> > > +	int			sectorsize)
> > > +{
> > > +	if (sectorsize && sunit % sectorsize) {
> > > +		xfs_notice(mp,
> > > +"stripe unit (%lld) must be a multiple of the sector size (%d)",
> > > +			   sunit, sectorsize);
> > > +		return false;
> > > +	}
> > > +
> > > +	if (sunit && !swidth) {
> > > +		xfs_notice(mp,
> > > +"invalid stripe unit (%lld) and stripe width of 0", sunit);
> > > +		return false;
> > > +	}
> > > +
> > > +	if (!sunit && swidth) {
> > > +		xfs_notice(mp,
> > > +"invalid stripe width (%lld) and stripe unit of 0", swidth);
> > > +		return false;
> > > +	}
> > 
> > Seems like these two could be combined into one check that prints
> > something like:
> > 
> > 	invalid stripe width (%lld) and stripe unit (%lld)
> 
> Hmm, that was in response to Darrick's previous review... see,
> https://lore.kernel.org/linux-xfs/20201007222942.GH6540@magnolia
> 
> so I'd like to know further direction of this...
> 

Oh, Ok. No problem, I don't feel strongly about it. It just looked like
a potential code reduction.

> > 
> > > +
> > > +	if (sunit > swidth) {
> > > +		xfs_notice(mp,
> > > +"stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
> > > +		return false;
> > > +	}
> > > +
> > > +	if (sunit && (swidth % sunit)) {
> > > +		xfs_notice(mp,
> > > +"stripe width (%lld) must be a multiple of the stripe unit (%lld)",
> > > +			   swidth, sunit);
> > > +		return false;
> > > +	}
> > > +	return true;
> > > +}
> > > +
> > 
> > Trailing whitespace here.
> 
> That is trailing newline (I personally prefer that),
> yeah, I will remove it in the next version.
> 

git (at least my configuration) tends to show this as a whitespace
error. I.e., it's highlighted in red and stands out similar to other
whitespace errors (such as tab after space, etc.). I thought that was a
fairly common config and thus something we tried to avoid, but could be
mistaken.

Brian

> Thanks,
> Gao Xiang
> 
> > 
> > Otherwise looks reasonable outside of those nits.
> > 
> > Brian
> 

