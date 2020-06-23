Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC3AC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 10:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF65E20774
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 10:08:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TJPYq1Ki"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732056AbgFWKIv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 06:08:51 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48274 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728265AbgFWKIv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 06:08:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592906929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QzZVasNlfsySyYAHFQagkd6WYPAo80IwAoNZB5L0GsA=;
        b=TJPYq1KiaMesVaAvZQejZRY9mlrqMMaY/LQ/y0KNcK9dLUoKaJvn4Y/Za1UZJV/3ixpcja
        q/BJwRYZM8ucy5SWaOoQaBRSI5k+031sehsEHjmcPFIxcGZXh9b1Zn1Ze912APX3Yu01Go
        PSSqX1DEF6L3T7ERZJAZOmvyKT9iZcU=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-8KVrkh_BOeGIbcAZkAMRiQ-1; Tue, 23 Jun 2020 06:08:48 -0400
X-MC-Unique: 8KVrkh_BOeGIbcAZkAMRiQ-1
Received: by mail-pg1-f197.google.com with SMTP id s7so11599162pgm.4
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jun 2020 03:08:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QzZVasNlfsySyYAHFQagkd6WYPAo80IwAoNZB5L0GsA=;
        b=R9AQP+wxuY1E247GqZRkmuHUkPOIUmmpvaOfomz2BjypiyfXxWgaX98+FZTzhYRS3p
         d3Ed4+ecjezLuJPTOZ1c/yjpKeVcXW45JJu8oSEGSg7uMsoQEBwafkqYtmatLpM/f6cZ
         PSx4xtajW/Rx5L7Q0QfA0V0ZJ+WOckr+jorZqtYoeXkE+KD2Gj9mj+4gyyhgKbdo2RLD
         WG7EvGCSKGz4xKrnlY5LVbGHLBx0yEW5CTJYNxS3moZCvOjvD8I4rteR8ytMvlXniaDN
         VLbBDWyAwYqUo9pEbtanNXsaFS2MMNq7KOjIJhl6OaEiSqru7HErExLA5meyX340O6cj
         4NrA==
X-Gm-Message-State: AOAM533cGSISXSTEuBiMbgGdKblRHrmPBx1HPb4O7S7DBvyLNkN4xRY4
        Tu4U2MuGzfYiLiQbOQVc1JXcqF3uwWNbFUBMgOnf2AELqj4Cxlrwm6l5EuCrepDT0n1+woJeouQ
        7TvtTwwUIVOljRCaw2fQO
X-Received: by 2002:a17:902:326:: with SMTP id 35mr23322578pld.301.1592906927204;
        Tue, 23 Jun 2020 03:08:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwQsDB9y6ljLMBf2sA+Q/zr0tbIbylSE6vkUSdCJAa/m7JNuou0jVX0dB3NciWoZ5OnFEMzw==
X-Received: by 2002:a17:902:326:: with SMTP id 35mr23322555pld.301.1592906926960;
        Tue, 23 Jun 2020 03:08:46 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 207sm16945708pfw.190.2020.06.23.03.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 03:08:46 -0700 (PDT)
Date:   Tue, 23 Jun 2020 18:08:37 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3] xfs: get rid of unnecessary xfs_perag_{get,put} pairs
Message-ID: <20200623100837.GA1523@xiangao.remote.csb>
References: <20200603121156.3399-1-hsiangkao@redhat.com>
 <20200605085200.24989-1-hsiangkao@redhat.com>
 <20200605155604.GU2162697@magnolia>
 <20200605183037.GA4468@xiangao.remote.csb>
 <20200605184732.GB4468@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605184732.GB4468@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

Friendly ping (just to keep up). What should I do for this patch?
Should I kill all ASSERTs instead (ASSERTs v3 is just v1 + read_{agf,agi}?
I could resend again quickly if needed..

Thanks,
Gao Xiang

On Sat, Jun 06, 2020 at 02:47:32AM +0800, Gao Xiang wrote:
> On Sat, Jun 06, 2020 at 02:30:37AM +0800, Gao Xiang wrote:
> 
> ...
> 
> > > 
> > > Alternately-- if you want to sanity check that b_pag and the buffer
> > > belong to the same ag, why not do that in xfs_buf_find for all the
> > > buffers?
> > 
> > Since that modification doesn't relate to this patch though (since
> > the purpose of this patch is not add ASSERT to xfs_buf_find).
> > 
> > If in that way, I think we can just kill all these ASSERTs.
> 
> Add some to the previous words:
> 
> What I really concern is to avoid introduce some regression from
> this trivial patch. That is the original reason why I added these
> assertions and tested with stress.
> 
> If some of these seems useful to the codebase, I could leave them
> in this patch (since these are related to the modification of this
> patch). Otherwise, I'd suggest kill them all though as I mentioned
> earilier in the reply of v1.
> 
> Thanks,
> Gao Xiang
> 
> 

