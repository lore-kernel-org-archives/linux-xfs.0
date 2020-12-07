Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250D0C4167B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9479235F7
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbgLGOMn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 09:12:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29024 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgLGOMm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 09:12:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607350276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VkuXqn07NC4RmmDkLXtn+/ClysLAXWLMMs5/uaYHgYw=;
        b=L1LO+ELHY8L5Ma/hcm/Y4TiXkvfxUu2Mj2Gyexl+jyxj19Z5d/0+xuhnbw3E0MpeOmVHPv
        Jotz3E3dLGFzjXGBieqFBaUgvvwfXWpo7viTCzIGdm+CA61fxiOZSPZnS1sEsIu+QFss6m
        Sg3e+WIu5GutLpldq8wPHA5at/MxD2g=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-ZEEvcr4IOgur-wp6WM1BVA-1; Mon, 07 Dec 2020 09:11:14 -0500
X-MC-Unique: ZEEvcr4IOgur-wp6WM1BVA-1
Received: by mail-pg1-f200.google.com with SMTP id c6so276748pgt.19
        for <linux-xfs@vger.kernel.org>; Mon, 07 Dec 2020 06:11:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VkuXqn07NC4RmmDkLXtn+/ClysLAXWLMMs5/uaYHgYw=;
        b=eQKhG1YhQxte9jq9mxlttIGDaBDLWgSJlE+a/AJXmJutRlnMuCRwqfmRRN89sVU3+X
         lD3/RiDpwqvIOldfYo6j8YJBHfJg30J1jCVkxOgbu5IGHY5e3qFn3UFhczwH7O1qGCeU
         Ju4LDKEtaXSV+2ynZvIZcZ9KnJ0q/J1/jYe0IVhmBh8MC0geAoUarRM0M22FbvrF3kZQ
         AztriKiysAzrl9vcYQyTjzgjJq4d3sceEtUzwAp4d1vCpANPgObRqw4xlsK2WwKIM91S
         NG++dWBTwJ7mR7UnBrDF5qbEdIM8Xd7R36N7aS0Ao7238Oi3Vnbeu4A1NH+luVjGZioH
         MFRA==
X-Gm-Message-State: AOAM533VRqhHoaXZAHkBEBOgO/Lo/v01V8Qf45zAA9QBwYQKOjLFWhn4
        UFGwIzMDy+7mh1P3FFaFOtrzUAWIh8Dtu1AX6y5e6gvb76huaYlRg2QcXwzS5qeE2bVv4+3cr6N
        vWZFv4a2EumU22VDHI/kd
X-Received: by 2002:a62:c505:0:b029:19d:c3fe:6d92 with SMTP id j5-20020a62c5050000b029019dc3fe6d92mr13880557pfg.47.1607350273953;
        Mon, 07 Dec 2020 06:11:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkBxyk206alvT7mPdTo3tQ9khlj97UeTzTkj83yXcXKskwBNzYfDVFWEX6MGkhpUMycG+3Xw==
X-Received: by 2002:a62:c505:0:b029:19d:c3fe:6d92 with SMTP id j5-20020a62c5050000b029019dc3fe6d92mr13880536pfg.47.1607350273694;
        Mon, 07 Dec 2020 06:11:13 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z13sm10906925pjt.45.2020.12.07.06.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 06:11:12 -0800 (PST)
Date:   Mon, 7 Dec 2020 22:11:01 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3 2/6] xfs: introduce xfs_dialloc_roll()
Message-ID: <20201207141101.GA2817641@xiangao.remote.csb>
References: <20201207001533.2702719-1-hsiangkao@redhat.com>
 <20201207001533.2702719-3-hsiangkao@redhat.com>
 <20201207134350.GC29249@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201207134350.GC29249@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 02:43:50PM +0100, Christoph Hellwig wrote:
> > +	/*
> > +	 * We want the quota changes to be associated with the next transaction,
> > +	 * NOT this one. So, detach the dqinfo from this and attach it to the
> > +	 * next transaction.
> > +	 */
> > +	if (tp->t_dqinfo) {
> > +		dqinfo = tp->t_dqinfo;
> > +		tp->t_dqinfo = NULL;
> > +		tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
> > +		tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
> 
> No need for the braces here.

Ok, will fix.

> 
> > +	if (error) {
> > +		xfs_buf_relse(agibp);
> > +		return error;
> > +	}
> 
> I haven't looked over the other patches if there is a good reason for
> it, but to me keeping the xfs_buf_relse in the caller would seem more
> natural.

This part is inherited from Dave's original patch, but I guess I could
move this to all callers if needed, no strong opinion from myself.

> 
> >  
> > +/* XXX: will be removed in the following patch */
> > +int
> 
> I don't think the comment is very helpful.  As of this patch the
> declaration is obviously needed, and that is all that matters.

Ok, will remove it.

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

