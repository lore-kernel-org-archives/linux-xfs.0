Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98881C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Feb 2022 14:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbiBROWG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Feb 2022 09:22:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiBROWD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Feb 2022 09:22:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 664021B790
        for <linux-xfs@vger.kernel.org>; Fri, 18 Feb 2022 06:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645194104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i1qt0XjPGiyFgSNjWy0q3dItZEVXxve38MPZGsH1PuQ=;
        b=gLP1te+paJmcct8IMg/YEc4P93gClilbsiIGs+0P5Ms4g/Raar5B8/ByWL0e2tkyT2Z8LV
        0mjYEBT10cxPKVEYBR0Safd8dJWouiVxFgPGWlIYHRJCU6X2AcPxqcgsulJiEBjHVKplTL
        GIodFs81iYb7DN4g/se5on4wYxTYnh4=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-yQtP8JwzMPuVKre3VUz7zA-1; Fri, 18 Feb 2022 09:21:43 -0500
X-MC-Unique: yQtP8JwzMPuVKre3VUz7zA-1
Received: by mail-qv1-f72.google.com with SMTP id l3-20020a0ce503000000b0042c0129c766so8928916qvm.20
        for <linux-xfs@vger.kernel.org>; Fri, 18 Feb 2022 06:21:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i1qt0XjPGiyFgSNjWy0q3dItZEVXxve38MPZGsH1PuQ=;
        b=evcOP5jqvKoa4GhuLn6oY+wkzLXFrSkEmlgoVAVRgYullSAKVqzZSWY1xAEPPUjpGO
         1YEYDKngWG29+CeESAO03mvSOI7l7zsYfkYrb6ndgVecRss4pseSVHVts7iMty2BD5/U
         VUOJkKDJ7g7bUCBin4HlkfuLY6WkXqPPNNbfF8pBubp1Wd/jVm1zgRwKOxXr4WwRW1A1
         QftBWMBp3pZOxU7+TqXlLA3PT1MQEOTIcajwYWAuReiXgTXafJuQwglgbenpCd+kCw+R
         Z+NV9Rd711c9b6l4sQAPuoNeNVS8/ENdV27ddINP/1UWNR7r2okAOhA+ew0NLKJEqfI2
         SUlQ==
X-Gm-Message-State: AOAM530gBXE5Bcj3mEN6rP3eJAFm3jVxZs3yfkf/eGaUjw/ceOPYYEE1
        aRJO47fJ6mXLA0mM8rxsmZ8GGVWHZbfCikuhhI0BpJTm5fPDpw7uWmIWozPg7147bsdfj7ZuZRm
        UyrdrYOQA0WfOBcwhIUlL
X-Received: by 2002:a05:6214:f6f:b0:42c:f230:2c5 with SMTP id iy15-20020a0562140f6f00b0042cf23002c5mr6076378qvb.88.1645194102429;
        Fri, 18 Feb 2022 06:21:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw3+ijxjpb9pr/UOCLyGdgG9pY1z3Gy1uXblcymrI3BJB0t8G+IAQ/DFpeKDRDPduEJb5ileA==
X-Received: by 2002:a05:6214:f6f:b0:42c:f230:2c5 with SMTP id iy15-20020a0562140f6f00b0042cf23002c5mr6076361qvb.88.1645194102174;
        Fri, 18 Feb 2022 06:21:42 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id i18sm5954391qka.80.2022.02.18.06.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 06:21:41 -0800 (PST)
Date:   Fri, 18 Feb 2022 09:21:40 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 3/4] xfs: crude chunk allocation retry mechanism
Message-ID: <Yg+rdFRpvra8U25D@bfoster>
References: <20220217172518.3842951-1-bfoster@redhat.com>
 <20220217172518.3842951-4-bfoster@redhat.com>
 <20220217232033.GD59715@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217232033.GD59715@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 18, 2022 at 10:20:33AM +1100, Dave Chinner wrote:
> On Thu, Feb 17, 2022 at 12:25:17PM -0500, Brian Foster wrote:
> > The free inode btree currently tracks all inode chunk records with
> > at least one free inode. This simplifies the chunk and allocation
> > selection algorithms as free inode availability can be guaranteed
> > after a few simple checks. This is no longer the case with busy
> > inode avoidance, however, because busy inode state is tracked in the
> > radix tree independent from physical allocation status.
> > 
> > A busy inode avoidance algorithm relies on the ability to fall back
> > to an inode chunk allocation one way or another in the event that
> > all current free inodes are busy. Hack in a crude allocation
> > fallback mechanism for experimental purposes. If the inode selection
> > algorithm is unable to locate a usable inode, allow it to return
> > -EAGAIN to perform another physical chunk allocation in the AG and
> > retry the inode allocation.
> > 
> > The current prototype can perform this allocation and retry sequence
> > repeatedly because a newly allocated chunk may still be covered by
> > busy in-core inodes in the radix tree (if it were recently freed,
> > for example). This is inefficient and temporary. It will be properly
> > mitigated by background chunk removal. This defers freeing of inode
> > chunk blocks from the free of the last used inode in the chunk to a
> > background task that only frees chunks once completely idle, thereby
> > providing a guarantee that a new chunk allocation always adds
> > non-busy inodes to the AG.
> 
> I think you can get rid of this simply by checking the radix tree
> tags for busy inodes at the location of the new inode chunk before
> we do the cluster allocation. If there are busy inodes in the range
> of the chunk (pure gang tag lookup, don't need to dereference any of
> the inodes), just skip to the next chunk offset and try that. Hence
> we only ever end up allocating a chunk that we know there are no
> busy inodes in and this retry mechanism is unnecessary.
> 

The retry mechanism exists in this series due to the factoring of the
inode allocation code moreso than whether the fallback is guaranteed to
provide a fully non-busy chunk or not. As the prototype is written, the
inode scan still needs to fall back at least once even with such a
guarantee (see my reply on the previous patch around cleaning up that
particular wart).

With regard to checking busy inode state, that is pretty much what I was
referring to by filtering or hinting the block allocation when we
discussed this on IRC. I'm explicitly trying to avoid that because for
one it unnecessarily spreads concern about busy inodes across layers. On
top of that, it assumes that there will always be some usable physical
block range available without busy inodes, which is not the case. That
means we now need to consider the fact that chunk allocation might fail
for reasons other than -ENOSPC and factor that into the inode allocation
algorithm. IOW, ISTM this just unnecessarily complicates things for
minimal benefit.

The point of background freeing inode chunks was that it makes this
problem go away because then we ensure that inode chunks aren't freed
until all associated busy inodes are cleared, and so we preserve the
historical behavior that an inode chunk allocation guarantees immediate
ability to allocate an inode. I thought we agreed in the previous
discussion that this was the right approach since it seemed to be in the
long term direction for XFS anyways.. hm?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

