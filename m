Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866E0C43457
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 14:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5276620878
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 14:20:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HOoRlqCb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388660AbgJLOUd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 10:20:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388595AbgJLOUd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 10:20:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602512432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GVNQTtLKlNPjdYGOQ5+7mPR+CTcpjFszeLvtGyve2JU=;
        b=HOoRlqCbFo0wISh/a8HZtJul2sSzJ48bY5gakSkgkyw2H8rZNH4AMSs4SiZWIAXnffdZsh
        IitHWQnJvmXQby/YLhGiaaqiH3MQZ9livOEPBOhyvvvYh6e/IxehZ8YrJzRF01RvJwonAs
        GHWR/ggVSAsQBr1lat9QPQb+AsQUjoY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-MfQp6a4TOL61pX7WzW06sg-1; Mon, 12 Oct 2020 10:20:30 -0400
X-MC-Unique: MfQp6a4TOL61pX7WzW06sg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79BC4803654;
        Mon, 12 Oct 2020 14:20:28 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 07B4910013BD;
        Mon, 12 Oct 2020 14:20:22 +0000 (UTC)
Date:   Mon, 12 Oct 2020 10:20:20 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 3/3] mkfs: make use of xfs_validate_stripe_factors()
Message-ID: <20201012142020.GG917726@bfoster>
References: <20201009052421.3328-1-hsiangkao@redhat.com>
 <20201009052421.3328-4-hsiangkao@redhat.com>
 <20201012130651.GE917726@bfoster>
 <20201012140715.GB614@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012140715.GB614@xiangao.remote.csb>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 12, 2020 at 10:07:15PM +0800, Gao Xiang wrote:
> Hi Brian,
> 
> On Mon, Oct 12, 2020 at 09:06:51AM -0400, Brian Foster wrote:
> > On Fri, Oct 09, 2020 at 01:24:21PM +0800, Gao Xiang wrote:
> > > Check stripe numbers in calc_stripe_factors() by using
> > > xfs_validate_stripe_factors().
> > > 
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > >  libxfs/libxfs_api_defs.h |  1 +
> > >  mkfs/xfs_mkfs.c          | 23 +++++++----------------
> > >  2 files changed, 8 insertions(+), 16 deletions(-)
> > > 
> > ...
> > > @@ -2344,11 +2334,12 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
> > >  
> > >  	/* if no stripe config set, use the device default */
> > >  	if (!dsunit) {
> > > -		/* Ignore nonsense from device.  XXX add more validation */
> > > -		if (ft->dsunit && ft->dswidth == 0) {
> > > +		/* Ignore nonsense from device report. */
> > > +		if (!libxfs_validate_stripe_factors(NULL, BBTOB(ft->dsunit),
> > > +						    BBTOB(ft->dswidth), 0)) {
> > 
> > The logic seems fine and from the previous comment it sounds like we're
> > lacking validation in this particular scenario, but do we want to print
> > more error noise from the validation helper in scenarios where failure
> > is not a fatal error?
> 
> Yeah, If I understand correctly, I think that is an open question here,
> so I think you suggested that we could silence for this case by passing
> a "bool silent" argument? or some better idea for this?
> 

Sure, that seems reasonable to me. Maybe others have thoughts. My
concern was primarily based on usability in terms of not potentially
confusing users with spurious error messages.

Brian

> Thanks,
> Gao Xiang
> 
> > 
> > Brian
> > 
> > >  			fprintf(stderr,
> > > -_("%s: Volume reports stripe unit of %d bytes and stripe width of 0, ignoring.\n"),
> > > -				progname, BBTOB(ft->dsunit));
> > > +_("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\n"),
> > > +				progname, BBTOB(ft->dsunit), BBTOB(ft->dswidth));
> > >  			ft->dsunit = 0;
> > >  			ft->dswidth = 0;
> > >  		} else {
> > > -- 
> > > 2.18.1
> > > 
> > 
> 

