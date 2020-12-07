Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F44C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0DB1235F9
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgLGOVa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 09:21:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725770AbgLGOV3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 09:21:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607350803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w2LrjLRMHGwCD3Mw4s/8mpEMkL/bKdDjGG61vW9MI6Q=;
        b=glikIZLe74wztUsFdl41uLWdJnslHrBhL7Nv8fga19updtJ/z+hwX1vBZLCJfyLoMkRHJL
        FqNM6rWHGTzb4C3L5N6bsbx3L2y64ba1yVIw65UH1Ouh+1fAPjq88hhYNFV+pjtiZMzvVL
        qCGwt6CyR4QUJpzct9eezEa+cSCnd7g=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-NJWYGoOMP-6wI_Z7dGTnMg-1; Mon, 07 Dec 2020 09:20:01 -0500
X-MC-Unique: NJWYGoOMP-6wI_Z7dGTnMg-1
Received: by mail-pf1-f199.google.com with SMTP id f3so8566547pfa.13
        for <linux-xfs@vger.kernel.org>; Mon, 07 Dec 2020 06:20:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=w2LrjLRMHGwCD3Mw4s/8mpEMkL/bKdDjGG61vW9MI6Q=;
        b=QS3l7yGekXQm+Y+ty0ympGCdM9ZyMoJ5D5AjyeyGZtBgyR7dQkKG5s/jn9O0LJcSCb
         VsJZSMlNZagdxrbqyTFJEAjad9aXBwQRvp6YGwU5/gTvtxJ9cBLFNCIdOUarAWOTWdo0
         DfGBN6ubeoS3vRr1Lzq69rbPrFLLD8Leti0Lzmklv/Oo0LRRzgZ4YczG87q1xkDR+Eiw
         5vU1HnegbjmFEqPBuLz4j2ZKaAk7y/URE4nxpT83xIy+MWf8TSj/vPWvNcTN+Hg8pogN
         RNvvk2DDFigH4WSJKqmumPR/l72W9KE8UyLQPiG66XZxxN0uNTTvFO8Wx1UwsU512UeI
         ZShw==
X-Gm-Message-State: AOAM531JcjSrvV3x+Phwp2Y0EEKPcpa42zieyozAoBWCrFsjGFAhZwp3
        LCSXFqB93qRtNuheP2PLSfX0fmy0Za8X7hcMVvHIxYwex4v/+JKwGTZy6khFihfD/D6XMK+Hprh
        fM+/o5qG2NYF7gcC2fnhB
X-Received: by 2002:a17:902:a60c:b029:da:e036:5dbe with SMTP id u12-20020a170902a60cb02900dae0365dbemr10559116plq.43.1607350800281;
        Mon, 07 Dec 2020 06:20:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw2ztERHjrFFrM3VYUzwnAP4Bgp22Z/kSstiMmG748kah3WCF5ioTh/rBqbKz4YbJ7r1ogvCA==
X-Received: by 2002:a17:902:a60c:b029:da:e036:5dbe with SMTP id u12-20020a170902a60cb02900dae0365dbemr10559088plq.43.1607350800024;
        Mon, 07 Dec 2020 06:20:00 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x128sm14638591pfx.52.2020.12.07.06.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 06:19:59 -0800 (PST)
Date:   Mon, 7 Dec 2020 22:19:48 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3 3/6] xfs: move on-disk inode allocation out of
 xfs_ialloc()
Message-ID: <20201207141948.GB2817641@xiangao.remote.csb>
References: <20201207001533.2702719-1-hsiangkao@redhat.com>
 <20201207001533.2702719-4-hsiangkao@redhat.com>
 <20201207134941.GD29249@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201207134941.GD29249@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 02:49:41PM +0100, Christoph Hellwig wrote:
> On Mon, Dec 07, 2020 at 08:15:30AM +0800, Gao Xiang wrote:
> >  /*
> > + * Initialise a newly allocated inode and return the in-core inode to the
> > + * caller locked exclusively.
> >   */
> > -static int
> > -xfs_ialloc(
> > -	xfs_trans_t	*tp,
> > -	xfs_inode_t	*pip,
> > -	umode_t		mode,
> > -	xfs_nlink_t	nlink,
> > -	dev_t		rdev,
> > -	prid_t		prid,
> > -	xfs_buf_t	**ialloc_context,
> > -	xfs_inode_t	**ipp)
> > +static struct xfs_inode *
> > +xfs_dir_ialloc_init(
> 
> This is boderline bikeshedding, but I would just call this
> xfs_init_new_inode.

(See below...)

> 
> >  int
> >  xfs_dir_ialloc(
> > @@ -954,83 +908,59 @@ xfs_dir_ialloc(
> >  	xfs_inode_t	**ipp)		/* pointer to inode; it will be
> >  					   locked. */
> >  {
> >  	xfs_inode_t	*ip;
> >  	xfs_buf_t	*ialloc_context = NULL;
> > +	xfs_ino_t	pino = dp ? dp->i_ino : 0;
> 
> Maybe spell out parent_inode?  pino reminds of some of the weird Windows
> code that start all variable names for pointers with a "p".

Ok, yet pino is somewhat common, as I saw it in f2fs and jffs2 before.
I know you mean 'Hungarian naming conventions'.

If you don't like pino. How about parent_ino? since parent_inode occurs me
about "struct inode *" or something like this (a pointer around some inode),
rather than an inode number.

> 
> > +	/* Initialise the newly allocated inode. */
> > +	ip = xfs_dir_ialloc_init(*tpp, dp, ino, mode, nlink, rdev, prid);
> > +	if (IS_ERR(ip))
> > +		return PTR_ERR(ip);
> > +	*ipp = ip;
> >  	return 0;
> 
> I wonder if we should just return the inode by reference from
> xfs_dir_ialloc_init as well, as that nicely fits the calling convention
> in the caller, i.e. this could become
> 
> 	return xfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, prid, ipp);
> 
> Note with the right naming we don't really need the comment either,
> as the function name should explain everything.

Okay, the name was from Dave to unify the prefix (namespace)... I think it'd
be better to get Dave's idea about this as well. As of me, I'm fine with
either way.

Thanks,
Gao Xiang


> 

