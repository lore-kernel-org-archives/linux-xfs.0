Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C6DC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 15:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2135D20782
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 15:30:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GcptXlYG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgHYPax (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 11:30:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60218 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726294AbgHYPaw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 11:30:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598369449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KzQNGhys/SQF7rInvKTJzvt8SpOmT4CE9aOvH3kohwo=;
        b=GcptXlYG0PSHt8jFFGhcNJf8AYaOpqBzawjSNgOwPH9qQUJP6Q6aqjkBbCDzyuaDmzj8Qv
        WWDUqYhV6haJFWqHEP8POJFTyd+ls2zdaZtqemBepc3QathsUALx65JQraERLxTtT6ZA2/
        pJhAgsPTAmNfdjrfWSm2hewUSqFhtHw=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-t99xWnirPZS0BOJ92aAxmg-1; Tue, 25 Aug 2020 11:30:48 -0400
X-MC-Unique: t99xWnirPZS0BOJ92aAxmg-1
Received: by mail-pf1-f200.google.com with SMTP id a73so8894149pfa.10
        for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2020 08:30:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KzQNGhys/SQF7rInvKTJzvt8SpOmT4CE9aOvH3kohwo=;
        b=Vn63f7GxD/Xsm/iNvFvVXJmMFGte910AYXn1dJx8AFBUdeB3ushSUZVKmG5hBvHZNU
         nKKxZnWIRY2/rPzHLfnT4JSRQHWyeQL4fvjwsPHLiEAu4gR5agSGVj7GlMr3AOB4LxX+
         jMFMRN5NefYkFaHRn9t2t4EUMteRx+MMg0z0XhEovy8R1iS9ETsoSQfgK84A63Y0AWd+
         kqpVbxvPg1/OotADK9cfuyBsxEV/fBTzSpV+hKKwYUAJMRurEeYXr4lsl0MobaIEI5uz
         +Z4XF+H+CXAP6q1lTejFRciZitRGnFXGjnChzoH1pFfnBkVtOT255VkClN9llbDwPabR
         JSSg==
X-Gm-Message-State: AOAM530WPxZa/Xx9rO6gA8HyZSZdEimz/ewEVatWO5/jNik/tUuT/4Xa
        bThzJwWrwHwaMysDQEuwPYsg8eDB391kYUzA4/elyfmhudXsLjulQLsksNwXyLhTmoJ+TwA26jh
        nKdV19CCM0I8Fagsbrq+a
X-Received: by 2002:a17:90a:2b87:: with SMTP id u7mr2130854pjd.49.1598369446912;
        Tue, 25 Aug 2020 08:30:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvZ6UJKZ9XDreTazDFQtt2HQf7mTHF9GlN1ahhMLu7HVrej9P6QtcvlDr7dMUP0IpWNJyj7g==
X-Received: by 2002:a17:90a:2b87:: with SMTP id u7mr2130820pjd.49.1598369446553;
        Tue, 25 Aug 2020 08:30:46 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j1sm6650172pfg.6.2020.08.25.08.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 08:30:46 -0700 (PDT)
Date:   Tue, 25 Aug 2020 23:30:36 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: use log_incompat feature instead of speculate
 matching
Message-ID: <20200825153036.GA10609@xiangao.remote.csb>
References: <20200824154120.GA23868@xiangao.remote.csb>
 <20200825100601.2529-1-hsiangkao@redhat.com>
 <20200825145458.GC6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825145458.GC6096@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Tue, Aug 25, 2020 at 07:54:58AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 25, 2020 at 06:06:01PM +0800, Gao Xiang wrote:
> > Add a log_incompat (v5) or sb_features2 (v4) feature
> > of a single long iunlinked list just to be safe. Hence,
> > older kernels will refuse to replay log for v5 images
> > or mount entirely for v4 images.
> > 
> > If the current mount is in RO state, it will defer
> > to the next RW (re)mount to add such flag instead.
> 
> This commit log needs to state /why/ we need a new feature flag in
> addition to summarizing what is being added here.  For example,
> 
> "Introduce a new feature flag to collapse the unlinked hash to a single
> bucket.  Doing so removes the need to lock the AGI in addition to the
> previous and next items in the unlinked list.  Older kernels will think
> that inodes are in the wrong unlinked hash bucket and declare the fs
> corrupt, so the new feature is needed to prevent them from touching the
> filesystem."
> 
> (or whatever the real reason is, I'm attending DebConf and LPC and
> wasn't following 100%...)
> 
> Note that the above was a guess, because I actually can't tell if this
> feature is needed to prevent old kernels from tripping over our new
> strategy, or to prevent new kernels from running off the road if an old
> kernel wrote all the hash buckets.  I would've thought both cases would
> be fine...?

To prevent old kernels from tripping over our new strategy.

Images generated by old kernels would be fine.

> 

...

> >  #define	XFS_SB_VERSION2_OKBITS		\
> >  	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
> >  	 XFS_SB_VERSION2_ATTR2BIT	| \
> >  	 XFS_SB_VERSION2_PROJID32BIT	| \
> > -	 XFS_SB_VERSION2_FTYPE)
> > +	 XFS_SB_VERSION2_FTYPE		| \
> > +	 XFS_SB_VERSION2_NEW_IUNLINK)
> 
> NAK on this part; as I said earlier, don't add things to V4 filesystems.
> 
> If the rest of you have compelling reasons to want V4 support, now is
> the time to speak up.

The simple reason is that the current xfs_iunlink() code only generates
unlinked list in the new way but no multiple buckets. So, we must have
a choice for V4 since it's still supported by the current kernel:

 1) add some feature to entirely refuse new v4 images on older kernels;
 2) allow speculate matching so older kernel would bail out as fs corruption
    (but I have no idea if it has any harm);  

> 
> >  /* Maximum size of the xfs filesystem label, no terminating NULL */
> >  #define XFSLABEL_MAX			12
> > @@ -479,7 +481,9 @@ xfs_sb_has_incompat_feature(
> >  	return (sbp->sb_features_incompat & feature) != 0;
> >  }
> >  
> > -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
> > +#define XFS_SB_FEAT_INCOMPAT_LOG_NEW_IUNLINK	(1 << 0)
> > +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL	\
> > +		(XFS_SB_FEAT_INCOMPAT_LOG_NEW_IUNLINK)
> 
> There's a trick here: Define the feature flag at the very start of your
> patchset, then make the last patch in the set add it to the _ALL macro
> so that people bisecting their way through the git tree (with this
> feature turned on) won't unwittingly build a kernel with the feature
> half built and blow their filesystem to pieces.

hmmm... not quite get the point though.
For this specific patch, I think it'll be folded into some patch or
rearranged.

It should not be a followed-up patch (we must do some decision in advance
 -- whether or not add this feature).

> 
> >  #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
> >  static inline bool
> >  xfs_sb_has_incompat_log_feature(
> > @@ -563,6 +567,27 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
> >  		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
> >  }
> >  
> > +static inline bool xfs_sb_has_new_iunlink(struct xfs_sb *sbp)
> > +{
> > +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
> > +		return sbp->sb_features_log_incompat &
> > +			XFS_SB_FEAT_INCOMPAT_LOG_NEW_IUNLINK;
> > +
> > +	return xfs_sb_version_hasmorebits(sbp) &&
> > +		(sbp->sb_features2 & XFS_SB_VERSION2_NEW_IUNLINK);
> > +}
> > +
> > +static inline void xfs_sb_add_new_iunlink(struct xfs_sb *sbp)
> > +{
> > +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
> > +		sbp->sb_features_log_incompat |=
> > +			XFS_SB_FEAT_INCOMPAT_LOG_NEW_IUNLINK;
> > +		return;
> > +	}
> > +	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
> > +	sbp->sb_features2 |= XFS_SB_VERSION2_NEW_IUNLINK;
> 
> All metadata updates need to be logged.  Dave just spent a bunch of time
> heckling me for that in the y2038 patchset. ;)

hmmm... xfs_sync_sb in xfs_mountfs() will generate a sb transaction,
right? I don't get the risk here.

> 
> Also, I don't think it's a good idea to enable new incompat features
> automatically, since this makes the fs unmountable on old kernels.

As I said above, new xfs_iunlink() doesn't support multiple buckets
anymore (just support it for log recovery). So this feature would be
needed.

If supporting old multiple buckets xfs_iunlink() is needed, that's
a quite large modification of this entire patchset.

Thanks,
Gao Xiang

