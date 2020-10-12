Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7BFC433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 13:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA73D2073A
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 13:07:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d4hOHme3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgJLNHF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 09:07:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43576 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387424AbgJLNHE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 09:07:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602508023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fAICtiI9nS+QDJ0qtxCo4fxPWePGa4lanMTVu2Vc0wQ=;
        b=d4hOHme3wMPnvR3UzO6uS6TL33P5u9JoBdngf4uGSM+VCvuzE9eb36GifFNiQz3XBpOhoH
        DuIGZAPAD6GrAqUWbwzqLAzantOfIMEmjxRwIHIihwBeqeAb3fo5kUvN9gOBD4WVyugUMC
        QBudUv0opn1R9tIw2EDQ/NAb83/NUq0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-6ch2jqxrPlWxasEWO8yXYw-1; Mon, 12 Oct 2020 09:07:01 -0400
X-MC-Unique: 6ch2jqxrPlWxasEWO8yXYw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93B308030A6;
        Mon, 12 Oct 2020 13:07:00 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A6176EF79;
        Mon, 12 Oct 2020 13:06:53 +0000 (UTC)
Date:   Mon, 12 Oct 2020 09:06:51 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 3/3] mkfs: make use of xfs_validate_stripe_factors()
Message-ID: <20201012130651.GE917726@bfoster>
References: <20201009052421.3328-1-hsiangkao@redhat.com>
 <20201009052421.3328-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009052421.3328-4-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 09, 2020 at 01:24:21PM +0800, Gao Xiang wrote:
> Check stripe numbers in calc_stripe_factors() by using
> xfs_validate_stripe_factors().
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  libxfs/libxfs_api_defs.h |  1 +
>  mkfs/xfs_mkfs.c          | 23 +++++++----------------
>  2 files changed, 8 insertions(+), 16 deletions(-)
> 
...
> @@ -2344,11 +2334,12 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
>  
>  	/* if no stripe config set, use the device default */
>  	if (!dsunit) {
> -		/* Ignore nonsense from device.  XXX add more validation */
> -		if (ft->dsunit && ft->dswidth == 0) {
> +		/* Ignore nonsense from device report. */
> +		if (!libxfs_validate_stripe_factors(NULL, BBTOB(ft->dsunit),
> +						    BBTOB(ft->dswidth), 0)) {

The logic seems fine and from the previous comment it sounds like we're
lacking validation in this particular scenario, but do we want to print
more error noise from the validation helper in scenarios where failure
is not a fatal error?

Brian

>  			fprintf(stderr,
> -_("%s: Volume reports stripe unit of %d bytes and stripe width of 0, ignoring.\n"),
> -				progname, BBTOB(ft->dsunit));
> +_("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\n"),
> +				progname, BBTOB(ft->dsunit), BBTOB(ft->dswidth));
>  			ft->dsunit = 0;
>  			ft->dswidth = 0;
>  		} else {
> -- 
> 2.18.1
> 

