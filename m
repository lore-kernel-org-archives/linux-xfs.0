Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DE77C04FF3
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 11:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49C9361289
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 11:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhEXL7E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 May 2021 07:59:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38679 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232110AbhEXL7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 May 2021 07:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621857455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jsnicPGeNuNdO7KsYBksZz7HZLP3nHbQXyRo73rNtFI=;
        b=hjn76jq7Mo431cIMRNdXx4FR5bQLA6QXeA+hQQ+qNlhAQBh7fwqK68uduaHsoTPZqnmYVP
        RXfkMAnnxuya1tR/ebb0I+yzOGlDtYwGMXRCADNSy+KFnN1N3Ixp6cxh/wFIF+h02qT8pm
        T3iGgQhyOCejJq3ZJQ5PCE39E3MVcus=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-YiCh409xP1Kf4xnnZQnH8g-1; Mon, 24 May 2021 07:57:34 -0400
X-MC-Unique: YiCh409xP1Kf4xnnZQnH8g-1
Received: by mail-qv1-f70.google.com with SMTP id v3-20020a0cdd830000b02901efe0c3571eso24474802qvk.5
        for <linux-xfs@vger.kernel.org>; Mon, 24 May 2021 04:57:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jsnicPGeNuNdO7KsYBksZz7HZLP3nHbQXyRo73rNtFI=;
        b=Ng/IgS3FbSReY6bM0AkW6S1uU0CgKsQ6m7kjGLRmAK7sLWLDuoJKtEeKm22od852ky
         WgfScBAedEICD43ZqC+3SyUgdY5Vc1SrQAEQmkUZlqjWinaVcQDE2CUQ+qlceEmhHhO+
         Zqt74GsIBOsVrV8EtCjM23y9GpmrEf9EDKq3HbV8tgFVMisEDwCX3IG62F0nb/XzpQL8
         k/odgWvLyLuuHBQoT/4Gx4Ykd4MRCfPOCGst1VU8aW2tLS0gxvNYPKqQxdh6cEICKgQF
         vNSL0XwqzDnKO86pn5WgsSD+f+jsmX1c81SDYKuhSVLE96v0h0SymMVncdrfm1WjRe5U
         tYzw==
X-Gm-Message-State: AOAM532lZMkLTGpYvzVeXUusG/M8WSw+AJKqagzDZp2jPBNVbCJ+Jm9r
        RKT990HH0GqvxaUVKz7AdrMP4hGJHpx9XM6Qi+36MJdB1EfbzLmkE//PTrGIn8tlzkiux/vhVS7
        SwPxZn5X96ffb4yZvFb81
X-Received: by 2002:ac8:5ac7:: with SMTP id d7mr25849909qtd.173.1621857453557;
        Mon, 24 May 2021 04:57:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXr+5GBB4XKevka1pAvPxe7iPZPXqfmFr24ZdwXUSaZTCHCo2sAtz8uckkTVlEYm19AvMKTw==
X-Received: by 2002:ac8:5ac7:: with SMTP id d7mr25849894qtd.173.1621857453364;
        Mon, 24 May 2021 04:57:33 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id t2sm1369670qkt.135.2021.05.24.04.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 04:57:33 -0700 (PDT)
Date:   Mon, 24 May 2021 07:57:31 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] iomap: resched ioend completion when in
 non-atomic context
Message-ID: <YKuUqzEmt5/yZMt1@bfoster>
References: <20210517171722.1266878-1-bfoster@redhat.com>
 <20210517171722.1266878-2-bfoster@redhat.com>
 <YKKt2isZwu0qJK/C@casper.infradead.org>
 <YKOnGSJ9NR+cSRRc@bfoster>
 <20210520215858.GZ9675@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520215858.GZ9675@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 20, 2021 at 02:58:58PM -0700, Darrick J. Wong wrote:
> On Tue, May 18, 2021 at 07:38:01AM -0400, Brian Foster wrote:
> > On Mon, May 17, 2021 at 06:54:34PM +0100, Matthew Wilcox wrote:
> > > On Mon, May 17, 2021 at 01:17:20PM -0400, Brian Foster wrote:
> > > > @@ -1084,9 +1084,12 @@ iomap_finish_ioend(struct iomap_ioend *ioend, int error)
> > > >  			next = bio->bi_private;
> > > >  
> > > >  		/* walk each page on bio, ending page IO on them */
> > > > -		bio_for_each_segment_all(bv, bio, iter_all)
> > > > +		bio_for_each_segment_all(bv, bio, iter_all) {
> > > >  			iomap_finish_page_writeback(inode, bv->bv_page, error,
> > > >  					bv->bv_len);
> > > > +			if (!atomic)
> > > > +				cond_resched();
> > > > +		}
> > > 
> > > I don't know that it makes sense to check after _every_ page.  I might
> > > go for every segment.  Some users check after every thousand pages.
> > > 
> > 
> > The handful of examples I come across on a brief scan (including the
> > other iomap usage) have a similar pattern as used here. I don't doubt
> > there are others, but I think I'd prefer to have more reasoning behind
> > adding more code than might be necessary (i.e. do we expect additional
> > overhead to be measurable here?). As it is, the intent isn't so much to
> > check on every page as much as this just happens to be the common point
> > of the function to cover both long bio chains and single vector bios
> > with large numbers of pages.
> 
> It's been a while since I waded through the macro hell to find out what
> cond_resched actually does, but iirc it can do some fairly heavyweight
> things (disable preemption, call the scheduler, rcu stuff) which is why
> we're supposed to be a little judicious about amortizing each call over
> a few thousand pages.
> 

It looks to me it just checks some state bit and only does any work if
actually necessary. I suppose not doing that less often is cheaper than
doing it more, but it's not clear to me it's enough that it really
matters and/or warrants more code to filter out calls..

What exactly did you have in mind for logic? I suppose we could always
stuff a 'if (!(count++ % 1024)) cond_resched();' or some such in the
inner loop, but that might have less of an effect on larger chains
constructed of bios with fewer pages (depending on whether that might
still be possible).

Brian

> --D
> 
> > Brian
> > 
> 

