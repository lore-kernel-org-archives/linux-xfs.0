Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FAADC43457
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 13:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14F3E2080D
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 13:56:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VUaYUVfK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389387AbgJLN4x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 09:56:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390066AbgJLNzv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 09:55:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602510949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aGHS81cbs2sTXoTmYn48Pr8mPttYm6ZK9bri52ax/jc=;
        b=VUaYUVfKHey0m7R2Iyc+du+5WPkim0PvDWcdvoVaIy/ULnHpZea5TIgyg80Jy+3aZkY5MH
        CVNPfTxcUs1YnQuUjdIjPh0jR856bWbtLLqYVNx3vY3zqJ+cfz/WMz/CwZQ52pNR9bI7VK
        jmGVthinogisaHcN3Op9KhOiDw+pq4s=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-SzlUVpICNlyo1Yt1T12_Yg-1; Mon, 12 Oct 2020 09:55:47 -0400
X-MC-Unique: SzlUVpICNlyo1Yt1T12_Yg-1
Received: by mail-pl1-f198.google.com with SMTP id d16so11909634pll.21
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 06:55:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aGHS81cbs2sTXoTmYn48Pr8mPttYm6ZK9bri52ax/jc=;
        b=kQAJEnkpl/SWHKT9J44mpbT3WDKh05tK8JcDhbq2hV1JKxCPbjVyZ4qvWvqqoiKM0i
         dNWNNdgKdHGoN2PnFLFjbzZ3cCMUmFeHoiPUMgbAZxyKCepoH1vvtL4AMQVB7dYTh2fd
         /w3Qg0HdC7JNh39r9mnUrHqbuhBwbyr358yl0iChbuCiottmOfOSbfF4/75tfBPUwGID
         W//U5OT+4GrFar9EoT/fC/OVhEzT8RDIGIQBMxdHo2vGtUR/m6Ghxo+G0HjgXdJVVHFj
         3FYTcDvAAIRPI3r04pB78rBPrZl8AKYyCCxpEEgyBM6u8EPJ7rZOMHU7AqjccegHZHsY
         uNbw==
X-Gm-Message-State: AOAM530JOlaJ0rwBxgCRIDfu32kHtm4KAMOu24FUnfbAdMjTU+a+PQae
        nOf0G/dR1o/n3CyhXZKYTwvNYwckz0+Vp4LPHebyzJD9bIZ6PDoXvSUvDupUk4arXZvQQdg0i4E
        5JNrEI9vzA2Vru5kvAlkq
X-Received: by 2002:a05:6a00:22d5:b029:155:c72b:50ce with SMTP id f21-20020a056a0022d5b0290155c72b50cemr9196281pfj.65.1602510946834;
        Mon, 12 Oct 2020 06:55:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw//IOyKVZO6EzhSmQadyCB0oCVZ6tXi7QX+y3CMTYR3x6l6vknoxins+qp8EpHj84wBcVJAg==
X-Received: by 2002:a05:6a00:22d5:b029:155:c72b:50ce with SMTP id f21-20020a056a0022d5b0290155c72b50cemr9196260pfj.65.1602510946506;
        Mon, 12 Oct 2020 06:55:46 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a1sm24066816pjh.2.2020.10.12.06.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:55:45 -0700 (PDT)
Date:   Mon, 12 Oct 2020 21:55:36 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfs: introduce xfs_validate_stripe_factors()
Message-ID: <20201012135536.GA614@xiangao.remote.csb>
References: <20201009050546.32174-1-hsiangkao@redhat.com>
 <20201012130524.GD917726@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012130524.GD917726@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Mon, Oct 12, 2020 at 09:05:24AM -0400, Brian Foster wrote:
> On Fri, Oct 09, 2020 at 01:05:46PM +0800, Gao Xiang wrote:
> > Introduce a common helper to consolidate stripe validation process.
> > Also make kernel code xfs_validate_sb_common() use it first.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---

...

> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 5aeafa59ed27..cb2a7aa0ad51 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> ...
> > @@ -1233,3 +1230,49 @@ xfs_sb_get_secondary(
> >  	*bpp = bp;
> >  	return 0;
> >  }
> > +
> > +/*
> > + * sunit, swidth, sectorsize(optional with 0) should be all in bytes,
> > + * so users won't be confused by values in error messages.
> > + */
> > +bool
> > +xfs_validate_stripe_factors(
> 
> xfs_validate_stripe_geometry() perhaps?

Thanks for the review!

Ok, I'm fine with the naming, since I had no better name
about it at that time :)

> 
> > +	struct xfs_mount	*mp,
> > +	__s64			sunit,
> > +	__s64			swidth,
> > +	int			sectorsize)
> > +{
> > +	if (sectorsize && sunit % sectorsize) {
> > +		xfs_notice(mp,
> > +"stripe unit (%lld) must be a multiple of the sector size (%d)",
> > +			   sunit, sectorsize);
> > +		return false;
> > +	}
> > +
> > +	if (sunit && !swidth) {
> > +		xfs_notice(mp,
> > +"invalid stripe unit (%lld) and stripe width of 0", sunit);
> > +		return false;
> > +	}
> > +
> > +	if (!sunit && swidth) {
> > +		xfs_notice(mp,
> > +"invalid stripe width (%lld) and stripe unit of 0", swidth);
> > +		return false;
> > +	}
> 
> Seems like these two could be combined into one check that prints
> something like:
> 
> 	invalid stripe width (%lld) and stripe unit (%lld)

Hmm, that was in response to Darrick's previous review... see,
https://lore.kernel.org/linux-xfs/20201007222942.GH6540@magnolia

so I'd like to know further direction of this...

> 
> > +
> > +	if (sunit > swidth) {
> > +		xfs_notice(mp,
> > +"stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
> > +		return false;
> > +	}
> > +
> > +	if (sunit && (swidth % sunit)) {
> > +		xfs_notice(mp,
> > +"stripe width (%lld) must be a multiple of the stripe unit (%lld)",
> > +			   swidth, sunit);
> > +		return false;
> > +	}
> > +	return true;
> > +}
> > +
> 
> Trailing whitespace here.

That is trailing newline (I personally prefer that),
yeah, I will remove it in the next version.

Thanks,
Gao Xiang

> 
> Otherwise looks reasonable outside of those nits.
> 
> Brian

