Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91C8C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 18 May 2021 11:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A237061209
	for <linux-xfs@archiver.kernel.org>; Tue, 18 May 2021 11:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242024AbhERLjZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 May 2021 07:39:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55535 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241431AbhERLjZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 May 2021 07:39:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621337887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8NOnGlKyeDMx84mYZcfDwys4bZLZe31QswMdWkDELEI=;
        b=Y5LBwlTVXgOUrZ/1aqaPyyc+IgGA4rP36ODge7eokzl8BcQw4IWYg07CeX8iPSUAr45jEH
        RbVRjAGhi7gw3CzT4zDOT2mkX7LKghXARh9La0up7zyH0jxt1iDKnQFUWZ2pHr/HbNfvzd
        YFva+NSq7L8ShV1I+pE3zPPyXraL1Sw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-OKXX0k0bP0eDBb3vzX4xoA-1; Tue, 18 May 2021 07:38:05 -0400
X-MC-Unique: OKXX0k0bP0eDBb3vzX4xoA-1
Received: by mail-qk1-f197.google.com with SMTP id d201-20020ae9efd20000b02902e9e9d8d9dcso6905738qkg.10
        for <linux-xfs@vger.kernel.org>; Tue, 18 May 2021 04:38:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8NOnGlKyeDMx84mYZcfDwys4bZLZe31QswMdWkDELEI=;
        b=RdVS8xfNjAwXaRkbPwwgmSPQyihXC7aqBDy5MRSzA83d5zULelzF35JCrrtCMU2Y/2
         4Shooqd+8vMAfvtyBeIYOzRPVRudDfJF6PED++BUTOAlL/HpiRj8fXTOyGj84W5CXXrK
         gQTnIKhABOMVPpxjQhkWQVI92j3rss5+u8uHX6Lw0c8822ETcuokKPny8o/AtIM6Vblx
         n0Z4WNgwQIMit57+n4J1o2FFc6wfk3fCWPPpwVpimrAwEqXXtODJ0kx3JcgRPTrAzIup
         MMqDQDCcG/oY4srV/eR+Cx/dcL/wi8Ai6F9CvH5hFOwIq8HHmUIOBcYD5Qw++3L/elEv
         tefA==
X-Gm-Message-State: AOAM533jxmODsN2ZGH6xcK0YU/fX0rTofPq0AFG4PVI18t3qOrPT9VH0
        ihWGauOSD803VBMJl5jFcWVJ0oqpO+bJAI8MkGOwcG6aOwvijxiKSxa3A/seqj2TNVLtjPSIHqv
        STVA9qkHeUyyPPaPs+CCu
X-Received: by 2002:ac8:5d93:: with SMTP id d19mr4224895qtx.289.1621337884751;
        Tue, 18 May 2021 04:38:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDwYuumCjwzoTt3M/PmN4VHUsWP2WGr8hS9WwBq/RIZ7KEYvlVHSxuBTDxN/+6xYE1Y9wM6Q==
X-Received: by 2002:ac8:5d93:: with SMTP id d19mr4224872qtx.289.1621337884485;
        Tue, 18 May 2021 04:38:04 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id i5sm12500999qki.115.2021.05.18.04.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 04:38:04 -0700 (PDT)
Date:   Tue, 18 May 2021 07:38:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] iomap: resched ioend completion when in
 non-atomic context
Message-ID: <YKOnGSJ9NR+cSRRc@bfoster>
References: <20210517171722.1266878-1-bfoster@redhat.com>
 <20210517171722.1266878-2-bfoster@redhat.com>
 <YKKt2isZwu0qJK/C@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKKt2isZwu0qJK/C@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 17, 2021 at 06:54:34PM +0100, Matthew Wilcox wrote:
> On Mon, May 17, 2021 at 01:17:20PM -0400, Brian Foster wrote:
> > @@ -1084,9 +1084,12 @@ iomap_finish_ioend(struct iomap_ioend *ioend, int error)
> >  			next = bio->bi_private;
> >  
> >  		/* walk each page on bio, ending page IO on them */
> > -		bio_for_each_segment_all(bv, bio, iter_all)
> > +		bio_for_each_segment_all(bv, bio, iter_all) {
> >  			iomap_finish_page_writeback(inode, bv->bv_page, error,
> >  					bv->bv_len);
> > +			if (!atomic)
> > +				cond_resched();
> > +		}
> 
> I don't know that it makes sense to check after _every_ page.  I might
> go for every segment.  Some users check after every thousand pages.
> 

The handful of examples I come across on a brief scan (including the
other iomap usage) have a similar pattern as used here. I don't doubt
there are others, but I think I'd prefer to have more reasoning behind
adding more code than might be necessary (i.e. do we expect additional
overhead to be measurable here?). As it is, the intent isn't so much to
check on every page as much as this just happens to be the common point
of the function to cover both long bio chains and single vector bios
with large numbers of pages.

Brian

