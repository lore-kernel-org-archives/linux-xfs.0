Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9802C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B6B564F58
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhBCTUq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 14:20:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45255 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231622AbhBCTUq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 14:20:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612379958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ks+kG2Oz7xkKSThIbGO9NHc+NDNrgYjXEcoexJHLMr0=;
        b=UW3Gm34fLZbjiGvRMrtdxlCG9tRZOeI1n/EmRrlEww5tkoBjg+ZddIo/JWPMP8ZaDcnyXr
        T4ZbqE4S57z1scZMkz2qybAJP3v+nB36COUJyQUTYxyS9vBgqu5c4c5FBa79/RJmvZ8CvA
        q9wzIPaX5AFBHx5V720hcaf8FSxMNRo=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-60CYl_E6O9iR6andUFW6MA-1; Wed, 03 Feb 2021 14:19:17 -0500
X-MC-Unique: 60CYl_E6O9iR6andUFW6MA-1
Received: by mail-pg1-f198.google.com with SMTP id z6so323359pgg.17
        for <linux-xfs@vger.kernel.org>; Wed, 03 Feb 2021 11:19:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ks+kG2Oz7xkKSThIbGO9NHc+NDNrgYjXEcoexJHLMr0=;
        b=r/2p6tdIBBTk/jqHr81ELPSGVC2LPSl3YaEq/GZDjFh/Pf0hEvDqQlE/VZZrpM29Q/
         tONJJIQUk4DfprsjILZckqHV2k8tFUu7HOT6f+j8KGWc+SotIoFMp+G2BLpMLHprH4Fy
         QxSuTyARfjAYwe9aZBNo06kKfj7RyJmGYtQok+Rb6OgfFujjYVGq1NciIuGHOaPphLL0
         iWBkxLRJgSA2lSPIDbX89+dvwNBm4swXWGgqwdoZpPqzIGG1Fb/qHgJ6PPx7hc0ur1fV
         whVHx3QVVF2pg1l2HwO+wgjwAPCotq0MLF8Ozx7PkJnJK1P7W7B8n36lHKLRV0poz0vd
         AN7A==
X-Gm-Message-State: AOAM532WcmQHyG+Cu81bRLavJdt6AtvhCW7iAFFBjIsU6z7DFQ3PwLc6
        ThOEoFzUf8LmehLg8IG9NAtcKbZZ173owDJtAAy5TIDfZ95MSSYamYPfQ3xMAXjzLdLRZXLoOeM
        QRoVY5Tks4MlZvZVuej1O
X-Received: by 2002:aa7:87d9:0:b029:1b7:1c6c:56e0 with SMTP id i25-20020aa787d90000b02901b71c6c56e0mr4377295pfo.25.1612379956439;
        Wed, 03 Feb 2021 11:19:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzsl573ggf/TiRVV5V18ara3JRtHp2NXut6seys+/w5pJMwmCEIUXjcJLfcYXH5+6Kdfaf07w==
X-Received: by 2002:aa7:87d9:0:b029:1b7:1c6c:56e0 with SMTP id i25-20020aa787d90000b02901b71c6c56e0mr4377275pfo.25.1612379956148;
        Wed, 03 Feb 2021 11:19:16 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k31sm3700857pgi.5.2021.02.03.11.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 11:19:15 -0800 (PST)
Date:   Thu, 4 Feb 2021 03:19:04 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 6/7] xfs: support shrinking unused space in the last AG
Message-ID: <20210203191904.GB20513@xiangao.remote.csb>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-7-hsiangkao@redhat.com>
 <20210203142337.GB3647012@bfoster>
 <20210203145146.GA935062@xiangao.remote.csb>
 <20210203181211.GZ7193@magnolia>
 <20210203190217.GA20513@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210203190217.GA20513@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 04, 2021 at 03:02:17AM +0800, Gao Xiang wrote:
> Hi Darrick,
> 
> On Wed, Feb 03, 2021 at 10:12:11AM -0800, Darrick J. Wong wrote:
> > On Wed, Feb 03, 2021 at 10:51:46PM +0800, Gao Xiang wrote:
> 
> ...
> 
> > > > 
> > > > > +		}
> > > > > +
> > > > >  		if (error)
> > > > >  			goto out_trans_cancel;
> > > > >  	}
> > > > > @@ -137,15 +157,15 @@ xfs_growfs_data_private(
> > > > >  	 */
> > > > >  	if (nagcount > oagcount)
> > > > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> > > > > -	if (nb > mp->m_sb.sb_dblocks)
> > > > > +	if (nb != mp->m_sb.sb_dblocks)
> > > > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
> > > > >  				 nb - mp->m_sb.sb_dblocks);
> > > > 
> > > > Maybe use delta here?
> > > 
> > > The reason is the same as above, `delta' here was changed due to 
> > > xfs_resizefs_init_new_ags(), which is not nb - mp->m_sb.sb_dblocks
> > > anymore. so `extend` boolean is used (rather than just use delta > 0)
> > 
> > Long question:
> > 
> > The reason why we use (nb - dblocks) is because growfs is an all or
> > nothing operation -- either we succeed in writing new empty AGs and
> > inflating the (former) last AG of the fs, or we don't do anything at
> > all.  We don't allow partial growing; if we did, then delta would be
> > relevant here.  I think we get away with not needing to run transactions
> > for each AG because those new AGs are inaccessible until we commit the
> > new agcount/dblocks, right?
> > 
> > In your design for the fs shrinker, do you anticipate being able to
> > eliminate all the eligible AGs in a single transaction?  Or do you
> > envision only tackling one AG at a time?  And can we be partially
> > successful with a shrink?  e.g. we succeed at eliminating the last AG,
> > but then the one before that isn't empty and so we bail out, but by that
> > point we did actually make the fs a little bit smaller.
> 
> Thanks for your question. I'm about to sleep, I might try to answer
> your question here.
> 
> As for my current experiement / understanding, I think eliminating all
> the empty AGs + shrinking the tail AG in a single transaction is possible,
> that is what I'm done for now;
>  1) check the rest AGs are empty (from the nagcount AG to the oagcount - 1
>     AG) and mark them all inactive (AGs freezed);

Add some words, there might raise up some additional assistance
transactions (e.g. if we'd like to confirm bmbt has the only one extent
rather than just do some basic math to confirm the whole AG is empty)
we might need to put all AGFL free blocks from AGFL to bmbt as well. Yet
that process is independent from the main shrinking transaction. And
in principle have no visible impact to users.

I'll reply the rest suggestions tomorrow, thanks for the review again!

Thanks,
Gao Xiang

>  2) consume an extent from the (nagcount - 1) AG;
>  3) decrease the number of agcount from oagcount to nagcount.
> 
> Both 2) and 3) can be done in the same transaction, and after 1) the state
> of such empty AGs is fixed as well. So on-disk fs and runtime states are
> all in atomic.
> 
> > 
> > There's this comment at the bottom of xfs_growfs_data() that says that
> > we can return error codes if the secondary sb update fails, even if the
> > new size is already live.  This convinces me that it's always been the
> > case that callers of the growfs ioctl are supposed to re-query the fs
> > geometry afterwards to find out if the fs size changed, even if the
> > ioctl itself returns an error... which implies that partial grow/shrink
> > are a possibility.
> > 
> 
> I didn't realize that possibility but if my understanding is correct
> the above process is described as above so no need to use incremental
> shrinking by its design. But it also support incremental shrinking if
> users try to use the ioctl for multiple times.
> 
> If I'm wrong, kindly point out, many thanks in advance!
> 
> Thanks,
> Gao Xiang
> 

