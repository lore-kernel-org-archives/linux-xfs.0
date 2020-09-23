Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F6DAC4727D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 00:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51D4D2085B
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 00:21:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WjSRt5PZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgIWAVb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 20:21:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727034AbgIWAVb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 20:21:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600820489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6rVynmWErdxpeVW2LyvhwUbRKZsWwGiBTvW76iR5dbo=;
        b=WjSRt5PZ0+THaCfVageuU/qfp0CL/wPPCVKM5fP//qXpmk0uRQ+E+CmVdxyTgBhvTGKMgG
        WjmTmygbHjbrOijbS49ERg/gBnrNYeqhKZq3XrMy5etjSqpjrFDCuTn1HKx9bwUDnMNvFX
        S+wlijZL6jlgKK0NkU4AMHTLPIY2GFg=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-PP2Y1KdIPreCUnGo-ighSw-1; Tue, 22 Sep 2020 20:21:27 -0400
X-MC-Unique: PP2Y1KdIPreCUnGo-ighSw-1
Received: by mail-pf1-f199.google.com with SMTP id 8so12685253pfx.6
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 17:21:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6rVynmWErdxpeVW2LyvhwUbRKZsWwGiBTvW76iR5dbo=;
        b=bPuh21IO/ww9hoNKPxh0ePfDrir32eJWQhDR4pljW/KQ8Mk087Yz3tpv1poEtiMXK3
         tIA9iAt+3y4g4hI+QByDNtgEOtxj8UZkwikDGoJoXz+nj98OO547FaDNrMR5qNNV+ctx
         DwcVfYHlDAVpmnsuWg1w0lfnV7aQF4AXdIMCDkbIMRJAXLiwVLCQ+N8lc6xyM/OY9g3w
         ZACPJBrY9GsDCsrF2nZ7BEMl9E6sowtFN7LVQgTthKRL557UA+3Mg9aLbwvl/selbZFj
         zk3t/cW39URCnrrbcpPEam87Sg8+1CNMQqAxPAOtgcV3tWEUogw098U48FU2Qv1J7oC1
         95+g==
X-Gm-Message-State: AOAM531RYfTsL+RAD4nwwMdq7gZFzc3KMoCjMpSyWppWtLiFw2E2KVVc
        E505Cxujwqfn4v1e67mkcBQ6U3Qb8B9HLv1CYqfe2L0iB36sIiFnA03GjG+qNwA5DvnvRjg/EhU
        2SwQHuUmMskJqR4TPUFZj
X-Received: by 2002:a63:d242:: with SMTP id t2mr5658553pgi.47.1600820486007;
        Tue, 22 Sep 2020 17:21:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIV6MinhT2Hvkel97BDKXUORQgAdIufRzV6WsX4KeNjlh2Oi91IV1bDGUYKd8r4Y4hwlJVHw==
X-Received: by 2002:a63:d242:: with SMTP id t2mr5658532pgi.47.1600820485696;
        Tue, 22 Sep 2020 17:21:25 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z1sm16157258pfq.102.2020.09.22.17.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 17:21:25 -0700 (PDT)
Date:   Wed, 23 Sep 2020 08:21:15 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: drop the obsolete comment on filestream locking
Message-ID: <20200923002115.GB1077@xiangao.remote.csb>
References: <20200922034249.20549-1-hsiangkao.ref@aol.com>
 <20200922034249.20549-1-hsiangkao@aol.com>
 <20200922044428.GA4284@xiangao.remote.csb>
 <20200922160328.GG7955@magnolia>
 <20200922212646.GP12131@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922212646.GP12131@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 23, 2020 at 07:26:46AM +1000, Dave Chinner wrote:
> On Tue, Sep 22, 2020 at 09:03:28AM -0700, Darrick J. Wong wrote:
> > On Tue, Sep 22, 2020 at 12:44:28PM +0800, Gao Xiang wrote:
> > > On Tue, Sep 22, 2020 at 11:42:49AM +0800, Gao Xiang wrote:
> > > > From: Gao Xiang <hsiangkao@redhat.com>
> > > > 
> > > > Since commit 1c1c6ebcf52 ("xfs: Replace per-ag array with a radix
> > > > tree"), there is no m_peraglock anymore, so it's hard to understand
> > > > the described situation since per-ag is no longer an array and no
> > > > need to reallocate, call xfs_filestream_flush() in growfs.
> > > > 
> > > > In addition, the race condition for shrink feature is quite confusing
> > > > to me currently as well. Get rid of it instead.
> > > > 
> > > 
> > > (Add some words) I think I understand what the race condition could mean
> > > after shrink fs is landed then, but the main point for now is inconsistent
> > > between code and comment, and there is no infrastructure on shrinkfs so
> > > when shrink fs is landed, the locking rule on filestream should be refined
> > > or redesigned and xfs_filestream_flush() for shrinkfs which was once
> > > deleted by 1c1c6ebcf52 might be restored to drain out in-flight
> > > xfs_fstrm_item for these shrink AGs then.
> > > 
> > > From the current code logic, the comment has no use and has been outdated
> > > for years. Keep up with the code would be better IMO to save time.
> > 
> > Not being familiar with the filestream code at all, I wonder, what
> > replaced all that stuff?  Does that need a comment?  I can't really tell
> > at a quick glance what coordinates growfs with filestreams.
> 
> The filestream perag state would get trashed by the realloc of the
> perag array that growfs used to do. Hence the filestreams had to be
> flushed before growfs could realloc the array so there was no state
> that could be lost by a grow. The m_peraglock was needed to
> serialise that. Moving to the current perag tree setup meant grow no
> longer reallocated perag structures, so they didn't go away
> transiently and lose state any more, hence none of the flushing or
> perag locking was needed anymore.
> 
> Shrink is a different matter altogether. The shrink context is going
> to have to flush the filestreams itself after it makes sure that new
> filestreams can't be created in that AG.....

Yeah, just the suggestion about this comment.

(And as Darrick also mentioned before, maybe just removing the related
stuff for now to avoid confusion would be better... I'm not sure...)

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

