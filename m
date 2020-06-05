Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F7CFC433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 18:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34C4A2077D
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 18:30:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gu+RYA/x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgFESax (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 14:30:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56363 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726294AbgFESax (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jun 2020 14:30:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591381852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OQSuz0gu+1Gg57WX6WPgXALYgy7FLLUc6QiUUAfLpCs=;
        b=Gu+RYA/xItGp87UOO3DDjXeE47hrBx/3flte0C5fuTnuB0gkxnLUE+HJ/yKVruhAoQn5U3
        VnxoU5OP9HaTd3ARCOoUwH0euNUI+ADyKpjNCntfUDXPBFAkJSJbrt3x69TmOzzolYpMyF
        SwBm5m1b5asPizCork4yx5PVKbJlDSw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-3JDSR0wnONaVNOXMxxUFTg-1; Fri, 05 Jun 2020 14:30:48 -0400
X-MC-Unique: 3JDSR0wnONaVNOXMxxUFTg-1
Received: by mail-pj1-f69.google.com with SMTP id o7so5325931pjw.8
        for <linux-xfs@vger.kernel.org>; Fri, 05 Jun 2020 11:30:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OQSuz0gu+1Gg57WX6WPgXALYgy7FLLUc6QiUUAfLpCs=;
        b=fxyNyLL6Qidzeed0nQW+/Nk5EO3Wo8tSDSTRdgYGOkVRb5F7Ugq2J+lhrmBvKbnpuO
         YTuCQXjqGOnZEE496pUN2mFP3pEXFc0E6HXy0PSBTSBezc2+0+IEu89nM1UskETb5uv0
         NBU53cd9KJ8dDBYkhsQpFcAd5qlMHaoXqmJyd4wiHg2gLMakkL5QN/Q49bD4RwLT94Mx
         KBj6wCfNQOHbbF59epwGdMeaa2IVCx41kZxhU2BJv0JDBQPYLGW075YuGMRn6qi26cPy
         xyPu3RkSNtI0JKqko9pqJk52NDY1es643LsVUSJvu0TCz3EDddSPwRdk9lhmO1oCLIZj
         jWEw==
X-Gm-Message-State: AOAM531Q/eB8OTgTt0WMUCH9Ful9/Miu5wba4hbRBq7fPfR8uJsZi1xS
        OgRwxxdS2kOMWSYEc8AZv7NVMI8dOPhDjs3T7E3ZU3nRAMhxINpbwipX0Vf2pqf0UvJHAFN4w60
        hjQCODAxPJbySXSso+Q9k
X-Received: by 2002:aa7:96b0:: with SMTP id g16mr11144896pfk.126.1591381847616;
        Fri, 05 Jun 2020 11:30:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2AEFJleHCMjQdGHTSLeFBBjdU7YtNoH5b/VoHa9kCK0syN4UMiEik3ovB5xkfDiW48c6T3g==
X-Received: by 2002:aa7:96b0:: with SMTP id g16mr11144879pfk.126.1591381847348;
        Fri, 05 Jun 2020 11:30:47 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h3sm290207pfr.2.2020.06.05.11.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 11:30:46 -0700 (PDT)
Date:   Sat, 6 Jun 2020 02:30:37 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3] xfs: get rid of unnecessary xfs_perag_{get,put} pairs
Message-ID: <20200605183037.GA4468@xiangao.remote.csb>
References: <20200603121156.3399-1-hsiangkao@redhat.com>
 <20200605085200.24989-1-hsiangkao@redhat.com>
 <20200605155604.GU2162697@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605155604.GU2162697@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 05, 2020 at 08:56:04AM -0700, Darrick J. Wong wrote:
> On Fri, Jun 05, 2020 at 04:52:00PM +0800, Gao Xiang wrote:

...

> > ---
> > changes since v2:
> >   kill unneeded ASSERTs, leaving which first brought
> >   into a context pointed out by Dave (including callback
> >   entrances).

...

> >  
> > @@ -3006,7 +2999,8 @@ xfs_alloc_read_agf(
> >  	ASSERT(!(*bpp)->b_error);
> >  
> >  	agf = (*bpp)->b_addr;
> > -	pag = xfs_perag_get(mp, agno);
> > +	pag = (*bpp)->b_pag;
> > +	ASSERT(pag->pag_agno == agno);
> 
> I thought these assertions were all dropped in v3?

The ASSERT above is in xfs_alloc_read_agf. If I didn't misread what Dave
said, I think this is necessary at least.

> 
> Alternately-- if you want to sanity check that b_pag and the buffer
> belong to the same ag, why not do that in xfs_buf_find for all the
> buffers?

Since that modification doesn't relate to this patch though (since
the purpose of this patch is not add ASSERT to xfs_buf_find).

If in that way, I think we can just kill all these ASSERTs.

> 
> >  	ASSERT(ptr->s != 0);
> > +	ASSERT(pag->pag_agno == be32_to_cpu(agf->agf_seqno));
> 
> I still see a few of these after-the-fact agno checks throughout the patch.

what I wrote above is:

> >   into a context pointed out by Dave (including callback
> >   entrances).

I can leave these xfs_alloc_read_agf, xfs_ialloc_read_agi 2 assertions only
if you want.

Thanks,
Gao Xiang

> 
> --D
> 

