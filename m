Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD58C433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 18:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2475D206FA
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 18:47:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GybQFvba"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgFESrr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 14:47:47 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40357 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726846AbgFESrr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jun 2020 14:47:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591382865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JBS2Nn1gg3XZPKKrx4dS0ybMjE5ByJDzvl7oW7fjbLM=;
        b=GybQFvba4cII9MCutQ6krCVwC8M118kIfaq90UpSQLeC87/QWQKSMnJC2VSmU/JZ0NaZU5
        tR0Um1IFewUqhYsBx9A6Kl/1HnYFKEL+Isw2HmVpRSUpic/5zMCkjW/z4hOsM0PGU6BB1T
        BPoIm/cr6l9QzCoNSPdGQ2Rx1l7VWTU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-N1Z3TiggPKSTubnjxvvH0A-1; Fri, 05 Jun 2020 14:47:43 -0400
X-MC-Unique: N1Z3TiggPKSTubnjxvvH0A-1
Received: by mail-pj1-f69.google.com with SMTP id d14so5314556pjw.5
        for <linux-xfs@vger.kernel.org>; Fri, 05 Jun 2020 11:47:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JBS2Nn1gg3XZPKKrx4dS0ybMjE5ByJDzvl7oW7fjbLM=;
        b=eaYWawtWQ1S5I3zQGw91W3TVyhJ7KvktB51gnEeWUY9GRCO7ZJ2jWDtqkKZGp2Vtcw
         B6v+GdU0m+AjNRU1/dGt92nwaFiaiITVdl3m3wO9X1D/3XRVt2wGkeLdwV08F5UaF3vY
         oPlPtUbiciWcJB6IkJKh38SaCoou0iwwK+a08uVlCTM28rYg5mESgERvqOwwMnG/f9RD
         4XjaTKsnsma1+GWuQhnBVBte7bS91R1gV3kiRXBKHY20PxjZ1/qe7HTcC4zaYQ2710fp
         dks0mB+Kc/KXIfw/izRtjuaniBXr3O9TIjsPwbfj0zENKO+ZQfJ+G0HYhPcLeImqrg2o
         cfYw==
X-Gm-Message-State: AOAM531v0pgMSd2ncV99af0vo/bIr1ZhQaByWcsfsYxa9O7mju5PsJNG
        JebA3Q121yxasgjO9eqDRoKlW5LTH4lfg/hAL0uLw0Z6APOzsyLKbsYS4Uxsy0ecgnzzwCVPGq8
        p/sy7nLOI2whlcwnyKf/2
X-Received: by 2002:a63:497:: with SMTP id 145mr10603482pge.356.1591382862687;
        Fri, 05 Jun 2020 11:47:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKbfWV8OqtjvqCp1n2sDxra/Crb7LeAu3BWGD5YSC1v/+t4bqssORaFPK8AdLxxG1RikErWQ==
X-Received: by 2002:a63:497:: with SMTP id 145mr10603471pge.356.1591382862371;
        Fri, 05 Jun 2020 11:47:42 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 67sm378382pfg.9.2020.06.05.11.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 11:47:41 -0700 (PDT)
Date:   Sat, 6 Jun 2020 02:47:32 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3] xfs: get rid of unnecessary xfs_perag_{get,put} pairs
Message-ID: <20200605184732.GB4468@xiangao.remote.csb>
References: <20200603121156.3399-1-hsiangkao@redhat.com>
 <20200605085200.24989-1-hsiangkao@redhat.com>
 <20200605155604.GU2162697@magnolia>
 <20200605183037.GA4468@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605183037.GA4468@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 06, 2020 at 02:30:37AM +0800, Gao Xiang wrote:

...

> > 
> > Alternately-- if you want to sanity check that b_pag and the buffer
> > belong to the same ag, why not do that in xfs_buf_find for all the
> > buffers?
> 
> Since that modification doesn't relate to this patch though (since
> the purpose of this patch is not add ASSERT to xfs_buf_find).
> 
> If in that way, I think we can just kill all these ASSERTs.

Add some to the previous words:

What I really concern is to avoid introduce some regression from
this trivial patch. That is the original reason why I added these
assertions and tested with stress.

If some of these seems useful to the codebase, I could leave them
in this patch (since these are related to the modification of this
patch). Otherwise, I'd suggest kill them all though as I mentioned
earilier in the reply of v1.

Thanks,
Gao Xiang


