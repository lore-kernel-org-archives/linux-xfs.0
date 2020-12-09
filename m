Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FDCC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 08:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 506F423AA8
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 08:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgLIIpY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 03:45:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727941AbgLIIpW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 03:45:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607503436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1JFD4hzgNFE/5BMGNBTK0V6V4lOV5ESei3QWKWCY4a8=;
        b=aNBGzashEPf8t/qIfu099ki3q84qevpd/mqtgkw9nRH0Av5WzCS5cP2bfZWpf7f0IjXxJX
        QFooqV0yCPabo6pfPE8uLzqvW4CKfWLqX9/hyI5kM8i/jiKiWsWtbLVEGa767p92n8lbKC
        LFXY7aEA02P6dYTu1RpQxFODmI9+pqE=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-BC6JMUfKMTeBhap5cxxiMA-1; Wed, 09 Dec 2020 03:43:54 -0500
X-MC-Unique: BC6JMUfKMTeBhap5cxxiMA-1
Received: by mail-pf1-f198.google.com with SMTP id b11so671366pfi.7
        for <linux-xfs@vger.kernel.org>; Wed, 09 Dec 2020 00:43:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1JFD4hzgNFE/5BMGNBTK0V6V4lOV5ESei3QWKWCY4a8=;
        b=Ldl5pzwoYa3I20pzhZIiP0Qa30FuB7yxw6NYHGw5SozS7lQGGeuCJvfhMtX7i1fHVc
         8vwbc4ivE/McT0o1ULO7tQIHqZ+8q6ddwsY9EkJSNzt+YnyA8dDFJWd19xvvdN56O1dP
         +4rLqHtnswViqd06DlfdRO0zc94tX4aDpKaYPL6aZre3yfF7lxKtgDTBPU299s8I5h89
         +BWpfhU9gdx8F365OylmldxOchJ2UoM5NXcTgzb7u5ImpVCWKv5eqc2lysYAwFV+0Q9H
         GOlP3undscchF/Pe8NzgIYdzuPh5wWVLJu+iYnUiUBd1vXxUhKqZ/S9ooi89Rl7JpZr4
         JI0A==
X-Gm-Message-State: AOAM533bGH4Wtokfnbhe/P4/QCDXRYmvWQwEp1U98FfSFAIhUqxIqyqA
        4nQjb83GWDcZaagHqVvKfOnhTSykaqbHZxwmZSdQ7qlQXuMUkw65mjj65hAdDtXCyIXiTgI7p13
        eIvvjbXu9d4PCFaJKoHw6
X-Received: by 2002:a63:2045:: with SMTP id r5mr1083728pgm.6.1607503433361;
        Wed, 09 Dec 2020 00:43:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJweOJLdL5pXztaOgSWq7dUAT/Ds+csa/6dZ7p+1rKnr+skpBpplk7yckWU/iZ0uthTDV+Rvbw==
X-Received: by 2002:a63:2045:: with SMTP id r5mr1083721pgm.6.1607503433175;
        Wed, 09 Dec 2020 00:43:53 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d8sm1269635pjv.3.2020.12.09.00.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 00:43:52 -0800 (PST)
Date:   Wed, 9 Dec 2020 16:43:42 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v4 3/6] xfs: move on-disk inode allocation out of
 xfs_ialloc()
Message-ID: <20201209084342.GA83673@xiangao.remote.csb>
References: <20201208122003.3158922-1-hsiangkao@redhat.com>
 <20201208122003.3158922-4-hsiangkao@redhat.com>
 <20201209075246.GA10645@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201209075246.GA10645@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph,

On Wed, Dec 09, 2020 at 08:52:46AM +0100, Christoph Hellwig wrote:
> > +	/* Initialise the newly allocated inode. */
> > +	return xfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, prid);
> 
> IMHO this comment is not overly helpful..

That was inherited from old version, I could get rid of in the next version....

> 
> > +	if (IS_ERR(ip)) {
> > +		error = PTR_ERR(ip);
> > +		ip = NULL;
> >  		goto out_trans_cancel;
> > +	}
> 
> And the calling convention with the ERR_PTR return does not seem to
> fit the call chain to well.  But those are minor details, so:

Yeah, I also think so, since I found many error exit paths
rely on ip == NULL.

> 
> >  STATIC int
> >  xfs_qm_qino_alloc(
> > -	xfs_mount_t	*mp,
> > -	xfs_inode_t	**ip,
> > -	uint		flags)
> > +	struct xfs_mount	*mp,
> > +	struct xfs_inode	**ipp,
> > +	unsigned int		flags)
> >  {
> >  	xfs_trans_t	*tp;
> >  	int		error;
> >  	bool		need_alloc = true;
> 
> Why do you reindent and de-typdefify the arguments, but not the local
> variables?

since I renamed *ip to *ipp (it seems that should be *ipp here), so I need to
modify this line
-	xfs_inode_t	**ip,

so I fixed the typedef, but it introduced an intent issue, so I fixed the
whole input argument block for better coding style.

That is related to the argument only, so I didn't fix the local argument
though (since I didn't touch them).

> 
> All the stuff below also seems to deal with the fact that the old return
> ip by reference calling convention seems to actually work better with
> the code base..

Yeah, so maybe I should revert back to the old code? not sure... Anyway,
I think codebase could be changed over time from a single change. Anyway,
I'm fine with either way. So I may hear your perference about this and send
out the next version (I think such cleanup can be fited in 5.11, so I can
base on this and do more work....)

Thanks,
Gao Xiang

> 

