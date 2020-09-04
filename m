Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1062AC43461
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 13:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD6E5207EA
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 13:01:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B6RvUqdh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgIDNBl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 09:01:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57061 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730298AbgIDM7o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 08:59:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599224382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UUtXd1xMQ7KHaZG/zgmMlu2bCG3w6vU0xn87tIL7ihs=;
        b=B6RvUqdhJ2xLaHMSBndsqMI537p6TgfEdCvHDSGNdD9pwpuq6fEKPSlEGisdjPsx9jlDUv
        XA2kMLItL8V3mRinmveQXEmx1ZncxXGWSE7RAQFgHJt4DVpQJUGCgvzTb+dW4DyX+HXDWz
        53IozNQ5s0rov0QmwrqI4IAEn/uyEeU=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-plr55ZSQNyKl7FknaegStA-1; Fri, 04 Sep 2020 08:59:40 -0400
X-MC-Unique: plr55ZSQNyKl7FknaegStA-1
Received: by mail-pj1-f71.google.com with SMTP id lx6so3097675pjb.9
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2020 05:59:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UUtXd1xMQ7KHaZG/zgmMlu2bCG3w6vU0xn87tIL7ihs=;
        b=WfLiKHWcMzT/6IYKTHiNyTkCcO0hhaHnheDsab5PLUuATZEbt9J8EHVR+Cqxn9OYbx
         nfsDC0SpcsxQ+XVCO/udA0CIU5H6vRMqHDw1a+0rc/LtvopgNokYfBc473XZU3EWHrKN
         dFZQHW6TRzhxDojO65j2LUbDAAM7zuLBb3dbbm4P66qiKqb6kNRE1ks9lMjbaNahczvW
         cmOD7NK4RddQrEoJLUVXT8l1YSY62sAbT5+whUDH7wRB/GGUoL5yNO6XNZn32BxVPtqF
         /JAKGpq3rh/dJnr4ZrgT3S2Kg6CPPsNs2h8LHtuAUhSwD0i7pWMG9tppy5LMwaf9WhWc
         5fVg==
X-Gm-Message-State: AOAM533v5HEC6N+yhfhhDECyhlBQcid4Mih/B80zK7Gt5gPqG8Q9f1sR
        2KDkhnxLJkft3tATgNjnwxQ+99LU0L/RoeTjljLk0eGbv2WmTF5IMXTkvmVooV+kzZ9K2Gl3T3F
        w8Jl/FPooJ7axqGni7kj7
X-Received: by 2002:a17:902:aa03:: with SMTP id be3mr8276000plb.245.1599224379485;
        Fri, 04 Sep 2020 05:59:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIEz5QYtFzpSNj/1cfERu7m/Phl/UbZM4QlordAZSEoaEm1/7uBNHYZLYFjsubFwW3TtX/Wg==
X-Received: by 2002:a17:902:aa03:: with SMTP id be3mr8275982plb.245.1599224379132;
        Fri, 04 Sep 2020 05:59:39 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q127sm6590411pfb.61.2020.09.04.05.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 05:59:38 -0700 (PDT)
Date:   Fri, 4 Sep 2020 20:59:29 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/2] xfs: clean up calculation of LR header blocks
Message-ID: <20200904125929.GB28752@xiangao.remote.csb>
References: <20200904082516.31205-1-hsiangkao@redhat.com>
 <20200904082516.31205-3-hsiangkao@redhat.com>
 <20200904112548.GC529978@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904112548.GC529978@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Fri, Sep 04, 2020 at 07:25:48AM -0400, Brian Foster wrote:
> On Fri, Sep 04, 2020 at 04:25:16PM +0800, Gao Xiang wrote:

...

> >  
> > +static inline int xlog_logrecv2_hblks(struct xlog_rec_header *rh)
> > +{
> > +	int	h_size = be32_to_cpu(rh->h_size);
> > +
> > +	if ((be32_to_cpu(rh->h_version) & XLOG_VERSION_2) &&
> > +	    h_size > XLOG_HEADER_CYCLE_SIZE)
> > +		return DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
> > +	return 1;
> > +}
> > +
> > +static inline int xlog_logrec_hblks(struct xlog *log, xlog_rec_header_t *rh)
> > +{
> > +	if (!xfs_sb_version_haslogv2(&log->l_mp->m_sb))
> > +		return 1;
> > +	return xlog_logrecv2_hblks(rh);
> > +}
> > +
> 
> h_version is assigned based on xfs_sb_version_haslogv2() in the first
> place so I'm not sure I see the need for multiple helpers like this, at
> least with the current code. I can't really speak to why some code
> checks the feature bit and/or the record header version and not the
> other way around, but perhaps there's some historical reason I'm not
> aware of. Regardless, is there ever a case where
> xfs_sb_version_haslogv2() == true and h_version != 2? That strikes me as
> more of a corruption scenario than anything..

Thanks for this.

Honestly, I'm not quite sure if xfs_sb_version_haslogv2() == true and
h_version != 2 is useful (or existed historially)... anyway, that is
another seperate topic though...

Could you kindly give me some code flow on your preferred way about
this so I could update this patch proper (since we have a complex
case in xlog_do_recovery_pass(), I'm not sure how the unique helper
will be like because there are 3 cases below...)

 - for the first 2 cases, we already have rhead read in-memory,
   so the logic is like:
     ....
     log_bread (somewhere in advance)
     ....

     if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
          ...
     } else {
          ...
     }
     (so I folded this two cases in xlog_logrec_hblks())

 - for xlog_do_recovery_pass, it behaves like
    if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
         log_bread (another extra bread to get h_size for
         allocated buffer and hblks).

         ...
    } else {
         ...
    }
    so in this case we don't have rhead until
xfs_sb_version_haslogv2(&log->l_mp->m_sb) is true...

Thanks in advance!

Thanks,
Gao Xiang


> 
> Brian

