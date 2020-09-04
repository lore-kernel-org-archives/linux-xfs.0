Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2A7C433E2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 15:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EA6020770
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 15:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbgIDPHq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 11:07:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51896 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729942AbgIDPHo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 11:07:44 -0400
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-IHnNxyJDMaSz4iUEOZwoZg-1; Fri, 04 Sep 2020 11:07:41 -0400
X-MC-Unique: IHnNxyJDMaSz4iUEOZwoZg-1
Received: by mail-pf1-f200.google.com with SMTP id e12so4057033pfm.0
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2020 08:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6alm9RnKTnqzDypTtlv6uyuiukN8ZZ/o5xdVagnHKwE=;
        b=NV6VqSZm5ZFLc45tChSNjpY7Eybxi7f8gsEw24jU3kxOB2WxUWNZbh+J2uAAZ9gzmk
         nVyI+OvWSlcC5EWSrh/XwxDXYdOQileYRrnH1PvYb6ZyVY9F1sSMmippupdHFyzlLi5l
         MOWR0r8tIBYlXFkZNFAIbogP4Gq1ySTkbNKGBnQ1UUkFtPhDQW6ofo0FjIyahiy1PHOe
         982TlnFAVOvzC4iBBOt+EN0ZHTAb+qBExbYze3fpDJAnLkX7n3Zyz3zaXQSImYm059lD
         de8TEsulIczOa8vCIt7LySPyxYK8sYk2Su9PM+05EbHXjWFtCA6SAz0Uwd3vYMvw8/OX
         B0pA==
X-Gm-Message-State: AOAM5300uM9EFS9S7SsdXd1iaPR0u57MeVE652t0561mcgrXwLeZSFa2
        H9X7CmwPzrOvhgTwgoH2yygr9pbfDoO3h+JgOVXFdpzaAY0cVyA5tv6VPzq5JjzjjF9ttDnVXqK
        U6EpQiIm/TyRPs6A0DNcK
X-Received: by 2002:a65:47c4:: with SMTP id f4mr7432696pgs.234.1599232060836;
        Fri, 04 Sep 2020 08:07:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyo6rIaJcps8iWJfFMGJ3bM7EdQBVVTwXceFS2iyE5XEvG/UoU2CfnLfr+8enTDQcLrYOMNiw==
X-Received: by 2002:a65:47c4:: with SMTP id f4mr7432673pgs.234.1599232060575;
        Fri, 04 Sep 2020 08:07:40 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x12sm5425238pjq.43.2020.09.04.08.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 08:07:40 -0700 (PDT)
Date:   Fri, 4 Sep 2020 23:07:30 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/2] xfs: clean up calculation of LR header blocks
Message-ID: <20200904150730.GB17378@xiangao.remote.csb>
References: <20200904082516.31205-1-hsiangkao@redhat.com>
 <20200904082516.31205-3-hsiangkao@redhat.com>
 <20200904112548.GC529978@bfoster>
 <20200904125929.GB28752@xiangao.remote.csb>
 <20200904133721.GE529978@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904133721.GE529978@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 04, 2020 at 09:37:21AM -0400, Brian Foster wrote:
> On Fri, Sep 04, 2020 at 08:59:29PM +0800, Gao Xiang wrote:
...
> > Could you kindly give me some code flow on your preferred way about
> > this so I could update this patch proper (since we have a complex
> > case in xlog_do_recovery_pass(), I'm not sure how the unique helper
> > will be like because there are 3 cases below...)
> > 
> >  - for the first 2 cases, we already have rhead read in-memory,
> >    so the logic is like:
> >      ....
> >      log_bread (somewhere in advance)
> >      ....
> > 
> >      if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
> >           ...
> >      } else {
> >           ...
> >      }
> >      (so I folded this two cases in xlog_logrec_hblks())
> > 
> >  - for xlog_do_recovery_pass, it behaves like
> >     if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
> >          log_bread (another extra bread to get h_size for
> >          allocated buffer and hblks).
> > 
> >          ...
> >     } else {
> >          ...
> >     }
> >     so in this case we don't have rhead until
> > xfs_sb_version_haslogv2(&log->l_mp->m_sb) is true...
> > 
> 
> I'm not sure I'm following the problem...
> 
> The current patch makes the following change in xlog_do_recovery_pass():
> 
> @@ -3024,15 +3018,10 @@ xlog_do_recovery_pass(
>  		if (error)
>  			goto bread_err1;
>  
> -		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
> -		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
> -			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
> -			if (h_size % XLOG_HEADER_CYCLE_SIZE)
> -				hblks++;
> +		hblks = xlog_logrecv2_hblks(rhead);
> +		if (hblks != 1) {
>  			kmem_free(hbp);
>  			hbp = xlog_alloc_buffer(log, hblks);
> -		} else {
> -			hblks = 1;
>  		}
>  	} else {
>  		ASSERT(log->l_sectBBsize == 1);
> 
> My question is: why can't we replace the xlog_logrecv2_hblks() call here
> with xlog_logrec_hblks()? We already have rhead as the existing code is
> already looking at h_version. We're inside a _haslogv2() branch, so the
> check inside the helper is effectively a duplicate/no-op.. Hm?

Yeah, I get your point. That would introduce a duplicated check of
_haslogv2() if we use xlog_logrec_hblks() here (IMHO compliers wouldn't
treat the 2nd _haslogv2() check as no-op).

I will go forward like this if no other concerns. Thank you!

Thanks,
Gao Xiang

> 
> Brian
> 
> > Thanks in advance!
> > 
> > Thanks,
> > Gao Xiang
> > 
> > 
> > > 
> > > Brian
> > 
> 

