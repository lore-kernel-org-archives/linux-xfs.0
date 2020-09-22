Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC03C4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 16:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6820823A1E
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 16:23:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S9EJsGDG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgIVQXo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:23:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726573AbgIVQXn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 12:23:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600791822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5F6jQbD+DU7Oa1tnIbR+H4176msmSPD9uzEVdHbwjlk=;
        b=S9EJsGDGnjeQ7GGD37dJ9AhKQF5JP2yBOa8zasrr+JDtrdM06rVinh4woJoookljQhALYH
        mjxNoGNa2fWsU4Z2LYCsqfTPygz1mCC5p8l641f5sQqGAZyYjq+SoqJE/3iB39B0vyBFN2
        nWV1NwJJdggwaASwSShER7UEtWk6dn8=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-3Jp67fsxNH2SkUQM87OZfg-1; Tue, 22 Sep 2020 12:23:40 -0400
X-MC-Unique: 3Jp67fsxNH2SkUQM87OZfg-1
Received: by mail-pf1-f197.google.com with SMTP id a16so11738982pfk.2
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 09:23:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5F6jQbD+DU7Oa1tnIbR+H4176msmSPD9uzEVdHbwjlk=;
        b=ZfIeDwQ0LXstVgQj8cM3ytAP5lpnxVmT+zlhiH50D+naMjHHd4wnQhJYE3ffPcHfvR
         TsAzWDhXjQmF8rjsfIWi3MR3rWjOm9jc0RSQw84I6+bklWi7wiCv3P+MBXYwnH5oc72B
         4O7ve8TMVxV4k2KHJjlT3vttabp775bJMHWqfghRqJSmhVllj9zOxCCnnoabG7SR13RT
         0/wLvnTIrSKu0dVmPzvN4453yf5wKny/7ztFxlKM4JDB2xwefqQFtoqN2qtewn/pb4uE
         /bda5fJ/l3FKeK9vt2qTiwixPT87GaTKdSFOKoM5p0GH66PpbkqICOB3xe8GgFd/J1Au
         iw9w==
X-Gm-Message-State: AOAM533oIVmJFP9w0OXsNqFJn7ose91+zCbsbYBGW32xAfd24FVQuldN
        1OAG8GUmUwZ6RNR2EL19tK4ScAoqIAFzbHfrNzy4CgHeizpu8obej1GV5Bn0EEfPa308LqG1/o5
        qUn3NxuAWFXOAiyE6sfoe
X-Received: by 2002:a63:8bc2:: with SMTP id j185mr4056695pge.159.1600791818891;
        Tue, 22 Sep 2020 09:23:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZBOBKyDcSDFKL9Xnab6ssUnWw3/D08X05tg7GpWSdhnGo0hnC+B1IE3+qfnxfdF0ryMBnwA==
X-Received: by 2002:a63:8bc2:: with SMTP id j185mr4056677pge.159.1600791818620;
        Tue, 22 Sep 2020 09:23:38 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n2sm2894717pja.41.2020.09.22.09.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 09:23:38 -0700 (PDT)
Date:   Wed, 23 Sep 2020 00:23:28 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: drop the obsolete comment on filestream locking
Message-ID: <20200922162328.GA1077@xiangao.remote.csb>
References: <20200922034249.20549-1-hsiangkao.ref@aol.com>
 <20200922034249.20549-1-hsiangkao@aol.com>
 <20200922044428.GA4284@xiangao.remote.csb>
 <20200922160328.GG7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922160328.GG7955@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Tue, Sep 22, 2020 at 09:03:28AM -0700, Darrick J. Wong wrote:
> On Tue, Sep 22, 2020 at 12:44:28PM +0800, Gao Xiang wrote:
> > On Tue, Sep 22, 2020 at 11:42:49AM +0800, Gao Xiang wrote:
> > > From: Gao Xiang <hsiangkao@redhat.com>
> > > 
> > > Since commit 1c1c6ebcf52 ("xfs: Replace per-ag array with a radix
> > > tree"), there is no m_peraglock anymore, so it's hard to understand
> > > the described situation since per-ag is no longer an array and no
> > > need to reallocate, call xfs_filestream_flush() in growfs.
> > > 
> > > In addition, the race condition for shrink feature is quite confusing
> > > to me currently as well. Get rid of it instead.
> > > 
> > 
> > (Add some words) I think I understand what the race condition could mean
> > after shrink fs is landed then, but the main point for now is inconsistent
> > between code and comment, and there is no infrastructure on shrinkfs so
> > when shrink fs is landed, the locking rule on filestream should be refined
> > or redesigned and xfs_filestream_flush() for shrinkfs which was once
> > deleted by 1c1c6ebcf52 might be restored to drain out in-flight
> > xfs_fstrm_item for these shrink AGs then.
> > 
> > From the current code logic, the comment has no use and has been outdated
> > for years. Keep up with the code would be better IMO to save time.
> 
> Not being familiar with the filestream code at all, I wonder, what
> replaced all that stuff?  Does that need a comment?  I can't really tell
> at a quick glance what coordinates growfs with filestreams.

(try to cc Dave...)

I'm not quite familiar with filestream as well. After several days random
glance about the constraint of shrink feature in XFS, I found such comment
and try to understand such constraint.

Finally, I think it was useful only when perag was once an array and need
to be reallocated (before 1c1c6ebcf52). So need to close the race by the
m_peraglock (which is now deleted) and drain out in-flight AG filestream
by xfs_filestream_flush() in growfs code (I think due to pag array
reallocation). 

For now, m_peraglock and xfs_filestream_flush() in xfs_growfs_data_private()
no longer exist... and we don't need to reallocate perag array but rather
to use radix tree instead.

but IMO, shrink an AG might need to restore to drain in-flight filestream,
I couldn't tell much more of it... Overall, the current comment is quite
confusing. I'd suggest it'd be better with some more reasonable comment
about this at least...

Thanks,
Gao Xiang

> 
> --D
> 

