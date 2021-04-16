Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF25AC433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 20:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98665613CD
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 20:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbhDPUq0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 16:46:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235547AbhDPUqZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 16:46:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618605959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9ikVYnJmXm7rmedRCsq+WqUHu9br5D12FCNxKkfzKKE=;
        b=IKguRBpAgUM0MoXBhjgfwnXEO1qxAJ6OUyqWT9tNUY6beNmTuKmeaxsS54+nlWj0h4TZsx
        DWRRTncbH7g3VQ28FcxIIvwqadmIpeQ+J7OJN75KfrAuesrqnmZG+Y+8nWHPIqKb2eXq9k
        KUryTHf1B7yCXSfKJJkT4y5hhIr+et4=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-AM1Ftwq2O8O15vGXsQFzEw-1; Fri, 16 Apr 2021 16:45:58 -0400
X-MC-Unique: AM1Ftwq2O8O15vGXsQFzEw-1
Received: by mail-pf1-f197.google.com with SMTP id z11-20020aa785cb0000b0290241496f2b5aso4896749pfn.8
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 13:45:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9ikVYnJmXm7rmedRCsq+WqUHu9br5D12FCNxKkfzKKE=;
        b=fhkWjBJGEX42r2dSGfw0GVSiMIBkT9SIhkbNbPZKEi/MigIP4wfeWrqfsWDhayooFY
         EZATGq8MVPonYD8QAageKKE7ieBH7sy1N2ILeVSjrRrdPtE5LdN3Jg4+MLtvHIoSy96l
         mfw7WnZ2vWcT275qG3EFLJqwGGZ84nOstmQyMwpy64u8vBfv9hazte8gzA6dll1+/uYW
         rNjmjZ0eranJ2lqHghagUMSUaDtuXKJu1U5V8zzlA7AUXabg79TYK4lDt2pWMEauqTg9
         XrE6JYyQdUaVt8qkRYkz622AJEKRrexN/Gxb1R8XxKZLSKMDOOqv1S4QIKJDwWNv6RFc
         6X0Q==
X-Gm-Message-State: AOAM530sNRXAtymODQAt5g3DDbPNkVsNhNlw47BZAXt8vdFnt5UAusK6
        IAZkUavNynUJavCR5DcImJO8LzEmJRvosE/oFj0uwG/ijU48JeaJ9gZ5AsNDTefjwmZosSobnSn
        tk7u2bIIag9EchPSyz4MH16xXBaIhmgO+8OD6MzhwULGO9RfAMeL4idmNjTjn2Yd3nCaXhjA+xQ
        ==
X-Received: by 2002:a62:18cf:0:b029:242:eeb0:4ce7 with SMTP id 198-20020a6218cf0000b0290242eeb04ce7mr9631820pfy.42.1618605956880;
        Fri, 16 Apr 2021 13:45:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzE7KaufmD4ymWJgzCT1HehbmwiTCReFqB/ek1C7RQjrBAHdpoA1u3Cuej+zoUDbuIRiRU/Ww==
X-Received: by 2002:a62:18cf:0:b029:242:eeb0:4ce7 with SMTP id 198-20020a6218cf0000b0290242eeb04ce7mr9631804pfy.42.1618605956493;
        Fri, 16 Apr 2021 13:45:56 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i14sm373574pfa.156.2021.04.16.13.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 13:45:55 -0700 (PDT)
Date:   Sat, 17 Apr 2021 04:45:46 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: don't use in-core per-cpu fdblocks for !lazysbcount
Message-ID: <20210416204546.GA2224153@xiangao.remote.csb>
References: <20210416091023.2143162-1-hsiangkao@redhat.com>
 <20210416141018.iio743iupb6vpcip@omega.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210416141018.iio743iupb6vpcip@omega.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Carlos,

On Fri, Apr 16, 2021 at 04:10:18PM +0200, Carlos Maiolino wrote:
> On Fri, Apr 16, 2021 at 05:10:23PM +0800, Gao Xiang wrote:
> > There are many paths which could trigger xfs_log_sb(), e.g.
> >   xfs_bmap_add_attrfork()
> >     -> xfs_log_sb()
> > , which overrided on-disk fdblocks by in-core per-CPU fdblocks.
> > 
> > However, for !lazysbcount cases, on-disk fdblocks is actually updated
> > by xfs_trans_apply_sb_deltas(), and generally it isn't equal to
> > in-core fdblocks due to xfs_reserve_block() or whatever, see the
> > comment in xfs_unmountfs().
> > 
> > It could be observed by the following steps reported by Zorro [1]:
> > 
> > 1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
> > 2. mount $dev $mnt
> > 3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
> > 4. umount $mnt
> > 5. xfs_repair -n $dev
> > 
> > yet due to commit f46e5a174655("xfs: fold sbcount quiesce logging
> > into log covering"),
> 
> > ... xfs_sync_sb() will be triggered even !lazysbcount
> > but xfs_log_need_covered() case when xfs_unmountfs(), so hard to
> > reproduce on kernel 5.12+.
> 
> I think this could be rephrased, but I am not native english-speaker either, so
> I can't say much. Maybe...
> 
> "xfs_sync_sb() will be triggered if no log covering is needed and !lazysbcount."

Thanks for your suggestion, I will update the description as...
 "xfs_sync_sb() will also be triggered if log covering is needed
  and !lazysbcount."

> 
> > Reported-by: Zorro Lang <zlang@redhat.com>
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_sb.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 60e6d255e5e2..423dada3f64c 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -928,7 +928,13 @@ xfs_log_sb(
> >  
> >  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> >  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > +	if (!xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > +		struct xfs_dsb	*dsb = bp->b_addr;
> > +
> > +		mp->m_sb.sb_fdblocks = be64_to_cpu(dsb->sb_fdblocks);
> > +	} else {
> > +		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > +	}
> 
> The patch looks good to me, feel free to add:
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 

Thanks for your review!

Thanks,
Gao Xiang

> -- 
> Carlos
> 

