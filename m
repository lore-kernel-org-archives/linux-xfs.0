Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC21C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 12:35:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEBFD64F53
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 12:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbhBDMer (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 07:34:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27461 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235988AbhBDMel (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 07:34:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612441994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zl75WjoOI06nS3MfeS1g0ailTFxLOM4nhD5jPhdRvrY=;
        b=HOYcaMLt1WIH9OWhH072hJJBEsbPsLNGrG2I5h3gD7kqFVQs9ELbi1qkjk4k24VsGeuXFV
        UuUyJoFaHEAZIiuGcMYv3lDN5TQ+IhaEgqF4uo/6CCNTAonF60ybuW8UvEOf6y4THybE1m
        K2Ic90jbxGobkg9IzyflnkynpeH2t7U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-D_gA7OgXOMyDhF6BGxauxg-1; Thu, 04 Feb 2021 07:33:12 -0500
X-MC-Unique: D_gA7OgXOMyDhF6BGxauxg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3A1F8030B1;
        Thu,  4 Feb 2021 12:33:09 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB79660C5F;
        Thu,  4 Feb 2021 12:33:05 +0000 (UTC)
Date:   Thu, 4 Feb 2021 07:33:03 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 6/7] xfs: support shrinking unused space in the last AG
Message-ID: <20210204123303.GA3716033@bfoster>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-7-hsiangkao@redhat.com>
 <20210203142337.GB3647012@bfoster>
 <20210203145146.GA935062@xiangao.remote.csb>
 <20210203181211.GZ7193@magnolia>
 <20210203190217.GA20513@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203190217.GA20513@xiangao.remote.csb>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

This was one of the things I wondered about on an earlier versions of
this work; whether we wanted to shrink to be deliberately incremental or
not. I suspect that somewhat applies to even this version without AG
truncation because technically we could allocate as much as possible out
of end of the last AG and shrink by that amount. My initial thought was
that if the implementation is going to be opportunistic (i.e., we
provide no help to actually free up targeted space), perhaps an
incremental implementation is a useful means to allow the operation to
make progress. E.g., run a shrink, observe it didn't fully complete,
shuffle around some files, repeat, etc. 

IIRC, one of the downsides of that sort of approach is any use case
where the goal is an underlying storage device resize. I suppose an
underlying device resize could also be opportunistic, but it seems more
likely to me that use case would prefer an all or nothing approach,
particularly if associated userspace tools don't really know how to
handle a partially successful fs shrink. Do we have any idea how other
tools/fs' behave in this regard (I thought ext4 supported shrink)? FWIW,
it also seems potentially annoying to ask for a largish shrink only for
the tool to hand back something relatively tiny.

Based on your design description, it occurs to me that perhaps the ideal
outcome is an implementation that supports a fully atomic all-or-nothing
shrink (assuming this is reasonably possible), but supports an optional
incremental mode specified by the interface. IOW, if we have the ability
to perform all-or-nothing, then it _seems_ like a minor interface
enhancement to support incremental on top of that as opposed to the
other way around. Therefore, perhaps that should be the initial goal
until shown to be too complex or otherwise problematic..?

Brian

> If I'm wrong, kindly point out, many thanks in advance!
> 
> Thanks,
> Gao Xiang
> 

