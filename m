Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0452FC76188
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 11:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237633AbjDELCN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 07:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237510AbjDELCM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 07:02:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067E52691
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 04:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680692484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BoHgQZFE6GmfSeys+DR2W7oxw4hgWtoFTpySQ2VkKFk=;
        b=ia9dXxyGsDRuDMarLkZZZc2zcfIpTyTPcnTDFBoxStOoDr8EAEt6+o2dPnIWDspl3/hmtD
        wh39BYntE2/TISnUk/1197DR2ztLJP2La4wzDS8D/UbMsLKn+i/8G4NFgi1i0eWlny7J1A
        EQivuramo1yAWbz7ZYxrUsh+gPgGtsA=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-7tXwQhqgPw2NaOXk5UG2aQ-1; Wed, 05 Apr 2023 07:01:23 -0400
X-MC-Unique: 7tXwQhqgPw2NaOXk5UG2aQ-1
Received: by mail-qk1-f197.google.com with SMTP id s190-20020ae9dec7000000b00746b7fae197so4723438qkf.12
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2023 04:01:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680692482;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BoHgQZFE6GmfSeys+DR2W7oxw4hgWtoFTpySQ2VkKFk=;
        b=mC1RUknc3fSNycY3igI55uqVk11atjmgoohjep42sN+9OJimG9qJXb8413LJrAExuJ
         5flMzorh3JaSdbVvFoY42ToJqRTTb7lWRLe9fdg4Y66WZPyIWtUCV/BmvRHM0MaWwszQ
         R7YcapxkbldQG/51MURZjKdKYrsw5/SaqpuIk4extJjIMLeUE7OpVDaz4qfOjDDYZOdS
         2XlF+j50zxrsyMi1EGr6WsJiZ+hXsIdzqoY/qw1mDT1E9QnVuX0HIuwyA7qquYgCY/eY
         LU3fbqLx+vhUGNVS7TjGNKmHnk3JFo+97o5bcoi/2Y4MQPEaJdo/rNRGrhOKq201u5+w
         6TaA==
X-Gm-Message-State: AAQBX9dxOEBP98Oorx28j9VGC4sxlurCsjmYaOQP6WroqO84nIWMsNBU
        IqB9QTuCD2HIWG7yiiDR9ycJwB+vXhtQq0V3pu0sMSK28b/T/USBHbPWpUB6XY2ZZ8+wEqhH+Rt
        FOvXn2zrlsGfVzHT634FJr5S0bfqDKQ==
X-Received: by 2002:a05:6214:4001:b0:5ca:f6dd:f3b6 with SMTP id kd1-20020a056214400100b005caf6ddf3b6mr8310662qvb.16.1680692482366;
        Wed, 05 Apr 2023 04:01:22 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZN5rxyt4g78lpjs6te5NjsBmYN83L29u8HXb3VRNmLRZGiyzEv7hgqJmGPE20fJY6cuY/SPQ==
X-Received: by 2002:a05:6214:4001:b0:5ca:f6dd:f3b6 with SMTP id kd1-20020a056214400100b005caf6ddf3b6mr8310617qvb.16.1680692482068;
        Wed, 05 Apr 2023 04:01:22 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id om30-20020a0562143d9e00b005dd8b934576sm4136208qvb.14.2023.04.05.04.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 04:01:21 -0700 (PDT)
Date:   Wed, 5 Apr 2023 13:01:16 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     djwong@kernel.org, dchinner@redhat.com, ebiggers@kernel.org,
        linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
        rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com
Subject: Re: [PATCH v2 09/23] iomap: allow filesystem to implement read path
 verification
Message-ID: <20230405110116.ia5wv3qxbnpdciui@aalbersh.remote.csb>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
 <20230404145319.2057051-10-aalbersh@redhat.com>
 <ZCxEHkWayQyGqnxL@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCxEHkWayQyGqnxL@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph,

On Tue, Apr 04, 2023 at 08:37:02AM -0700, Christoph Hellwig wrote:
> >  	if (iomap_block_needs_zeroing(iter, pos)) {
> >  		folio_zero_range(folio, poff, plen);
> > +		if (iomap->flags & IOMAP_F_READ_VERITY) {
> 
> Wju do we need the new flag vs just testing that folio_ops and
> folio_ops->verify_folio is non-NULL?

Yes, it can be just test, haven't noticed that it's used only here,
initially I used it in several places.

> 
> > -		ctx->bio = bio_alloc(iomap->bdev, bio_max_segs(nr_vecs),
> > -				     REQ_OP_READ, gfp);
> > +		ctx->bio = bio_alloc_bioset(iomap->bdev, bio_max_segs(nr_vecs),
> > +				REQ_OP_READ, GFP_NOFS, &iomap_read_ioend_bioset);
> 
> All other callers don't really need the larger bioset, so I'd avoid
> the unconditional allocation here, but more on that later.

Ok, make sense.

> 
> > +		ioend = container_of(ctx->bio, struct iomap_read_ioend,
> > +				read_inline_bio);
> > +		ioend->io_inode = iter->inode;
> > +		if (ctx->ops && ctx->ops->prepare_ioend)
> > +			ctx->ops->prepare_ioend(ioend);
> > +
> 
> So what we're doing in writeback and direct I/O, is to:
> 
>  a) have a submit_bio hook
>  b) allow the file system to then hook the bi_end_io caller
>  c) (only in direct O/O for now) allow the file system to provide
>     a bio_set to allocate from

I see.

> 
> I wonder if that also makes sense and keep all the deferral in the
> file system.  We'll need that for the btrfs iomap conversion anyway,
> and it seems more flexible.  The ioend processing would then move into
> XFS.
> 

Not sure what you mean here.

> > @@ -156,6 +160,11 @@ struct iomap_folio_ops {
> >  	 * locked by the iomap code.
> >  	 */
> >  	bool (*iomap_valid)(struct inode *inode, const struct iomap *iomap);
> > +
> > +	/*
> > +	 * Verify folio when successfully read
> > +	 */
> > +	bool (*verify_folio)(struct folio *folio, loff_t pos, unsigned int len);
> 
> Why isn't this in iomap_readpage_ops?
> 

Yes, it can be. But it appears to me to be more relevant to
_folio_ops, any particular reason to move it there? Don't mind
moving it to iomap_readpage_ops.

-- 
- Andrey

