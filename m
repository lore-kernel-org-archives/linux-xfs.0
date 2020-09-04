Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9E4C433E2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 12:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAC5520829
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 12:46:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dhcYIA9U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbgIDMq7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 08:46:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55482 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729942AbgIDMq6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 08:46:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599223607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JNLUCosKnVwhb1plUMHMEn0+A4rGonLaay/rRvftIw0=;
        b=dhcYIA9UT/CG4BAtSuLPz3ATAHDx0lmIBlniGh36pDrVMeoJnqC10v8mrZT+FlKSlxWHH9
        W5R7AWpPHTkzuQxC/BHr9wdktKDtqMgmXRZIizbuexhF2YxHiNmOzYZDBTNtqF7r3kF6uQ
        VBVYdVKLALataeaB/rebxzs6j3eVgOE=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-FXf137LKN8-bn4fTULIGBA-1; Fri, 04 Sep 2020 08:46:45 -0400
X-MC-Unique: FXf137LKN8-bn4fTULIGBA-1
Received: by mail-pl1-f198.google.com with SMTP id j5so744870plk.22
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2020 05:46:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JNLUCosKnVwhb1plUMHMEn0+A4rGonLaay/rRvftIw0=;
        b=rqzApDalKDPE2G6o0oIRuFghUZ9Y+OqYBfFyRLmNBjNQdT8lkFx/bBKICb9tCONTmK
         66iqe8xRuR1qUtJ/dPQ/l5bpaVJl8q9kA/vuRhMLyjsWLhVwE5G/s3C8W4UdEmwVjMD2
         iCoJLSiPjiWJ+XpxOAskt/cvfgLAsUGENRe0BtHTSU0jC48slqx8qVXhYYZNkdlWhvAU
         t0psmdMKIw2dqlCWhYad6l5zs/RFTddosmuao6Eq7F6gldTv8aYeEoTwC46Pd0tcGeGg
         TWAYe/JrtW/f3APn9cu5OMC5NyTvi6ncUdStIiRIx1yoG3FZB13BnpLC6polOoA4peKR
         d5cg==
X-Gm-Message-State: AOAM531NdtpfP+x7Hk+2QUjUBWt8PQjzdbrW3fNsigcqyAfaz05R1BG2
        WKTrkMu3gk9KiUmOGd6FfuI1CQ9gbu2jfE7SoOsvOGKDhjQEEGBp4BZvKZugEOYBosJQb6egiGl
        aJeZppuxxsLBt+oBR0X+r
X-Received: by 2002:a62:8607:0:b029:13c:1611:6593 with SMTP id x7-20020a6286070000b029013c16116593mr6455058pfd.16.1599223604671;
        Fri, 04 Sep 2020 05:46:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywRZJ+ElKnLI6e701JIMsQa9Ur2AXqTb6tdkaCayH84iOxJEcP62u9LHXuCEM0KJdHeuEGBg==
X-Received: by 2002:a62:8607:0:b029:13c:1611:6593 with SMTP id x7-20020a6286070000b029013c16116593mr6455041pfd.16.1599223604282;
        Fri, 04 Sep 2020 05:46:44 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z4sm1088192pfq.43.2020.09.04.05.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 05:46:43 -0700 (PDT)
Date:   Fri, 4 Sep 2020 20:46:34 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 1/2] xfs: avoid LR buffer overrun due to crafted
 h_{len,size}
Message-ID: <20200904124634.GA28752@xiangao.remote.csb>
References: <20200904082516.31205-1-hsiangkao@redhat.com>
 <20200904082516.31205-2-hsiangkao@redhat.com>
 <20200904112529.GB529978@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904112529.GB529978@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Fri, Sep 04, 2020 at 07:25:29AM -0400, Brian Foster wrote:
> On Fri, Sep 04, 2020 at 04:25:15PM +0800, Gao Xiang wrote:

...

> > @@ -2904,9 +2904,10 @@ STATIC int
> >  xlog_valid_rec_header(
> >  	struct xlog		*log,
> >  	struct xlog_rec_header	*rhead,
> > -	xfs_daddr_t		blkno)
> > +	xfs_daddr_t		blkno,
> > +	int			bufsize)
> >  {
> > -	int			hlen;
> > +	int			hlen, hsize = XLOG_BIG_RECORD_BSIZE;
> >  
> >  	if (XFS_IS_CORRUPT(log->l_mp,
> >  			   rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM)))
> > @@ -2920,10 +2921,22 @@ xlog_valid_rec_header(
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > -	/* LR body must have data or it wouldn't have been written */
> > +	/*
> > +	 * LR body must have data (or it wouldn't have been written) and
> > +	 * h_len must not be greater than h_size with one exception (see
> > +	 * comments in xlog_do_recovery_pass()).
> > +	 */
> 
> I wouldn't mention the exceptional case at all here since I think it
> just adds confusion. It's an unfortunate wart with mkfs that requires a
> kernel workaround, and I think it's better to keep it one place. I.e.,
> should it ever be removed, I find it unlikely somebody will notice this
> comment and fix it up accordingly.

Thanks for your review.

ok, if I understand correctly, will remove this "with one exception
(see comments..." expression. Please kindly correct me if I
misunderstand.

> 
> > +
> > +	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > hsize))
> >  		return -EFSCORRUPTED;
> > +
> > +	if (bufsize && XFS_IS_CORRUPT(log->l_mp, bufsize < hsize))
> > +		return -EFSCORRUPTED;
> 
> Please do something like the following so the full corruption check
> logic is readable:
> 
> 	if (XFS_IS_CORRUPT(..., bufsize && hsize > bufsize))
> 		return -EFSCORRUPTED;

That is good idea, will update this as well. 

>

...

> >  		rhead = (xlog_rec_header_t *)offset;
> > -		error = xlog_valid_rec_header(log, rhead, tail_blk);
> > -		if (error)
> > -			goto bread_err1;
> 
> This technically defers broader corruption checks (i.e., magic number,
> etc.) until after functional code starts using other fields below. I
> don't think we should remove this.
> 

I'm trying to combine this with the following part...(see below...)

> >  
> >  		/*
> >  		 * xfsprogs has a bug where record length is based on lsunit but
> > @@ -3001,21 +3011,19 @@ xlog_do_recovery_pass(
> >  		 */
> >  		h_size = be32_to_cpu(rhead->h_size);
> >  		h_len = be32_to_cpu(rhead->h_len);
> > -		if (h_len > h_size) {
> > -			if (h_len <= log->l_mp->m_logbsize &&
> > -			    be32_to_cpu(rhead->h_num_logops) == 1) {
> > -				xfs_warn(log->l_mp,
> > +		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
> > +		    rhead->h_num_logops == cpu_to_be32(1)) {
> > +			xfs_warn(log->l_mp,
> >  		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
> > -					 h_size, log->l_mp->m_logbsize);
> > -				h_size = log->l_mp->m_logbsize;
> > -			} else {
> > -				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > -						log->l_mp);
> > -				error = -EFSCORRUPTED;
> > -				goto bread_err1;
> > -			}
> > +				 h_size, log->l_mp->m_logbsize);
> > +			h_size = log->l_mp->m_logbsize;
> > +			rhead->h_size = cpu_to_be32(h_size);
> 
> I don't think we should update rhead like this, particularly in a rare
> and exclusive case. This structure should reflect what is on disk.
> 
> All in all, I think this patch should be much more focused:
> 
> 1.) Add the bufsize parameter and associated corruption check to
> xlog_valid_rec_header().
> 2.) Pass the related value from the existing calls.
> 3.) (Optional) If there's reason to revalidate after executing the mkfs
> workaround, add a second call within the branch that implements the
> h_size workaround.
> 

I moved workaround code to xlog_valid_rec_header() at first is
because in xlog_valid_rec_header() actually it has 2 individual
checks now:

1) check rhead->h_len vs rhead->h_size for each individual log record;
2) check rhead->h_size vs the unique allocated buffer size passed in
   for each record (since each log record has one stored h_size,
   even though there are not used later according to the current
   logic of xlog_do_recovery_pass).

if any of the conditions above is not satisfied, xlog_valid_rec_header()
will make fs corrupted immediately, so I tried 2 ways up to now:

 - (v1,v2) fold in workaround case into xlog_valid_rec_header()
 - (v3) rearrange workaround and xlog_valid_rec_header() order in
        xlog_do_recovery_pass() and modify rhead->h_size to the
        workaround h_size before xlog_valid_rec_header() validation
        so xlog_valid_rec_header() will work as expected since it
        has two individual checks as mentioned above.

If there is some better way, kindly let me know :) and I'd like to
hear other folks about this in advance as well.... so I can go
forward since this part is a bit tricky for now.

> Also, please test the workaround case to make sure it still works as
> expected (if you haven't already).

ok, will double confirm this, thanks!

Thanks,
Gao Xiang

> 
> Brian
>
 

