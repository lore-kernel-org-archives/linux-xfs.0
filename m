Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C36C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 22:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AF4E2395B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 22:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgLGWFG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 17:05:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbgLGWFG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 17:05:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607378620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n3f55idUWef+oM3UWt0470km4aqSTP3XgPC4MJZJUA4=;
        b=CyXOAc2tL3nO83KED+n6OWYGc/ixbeLL6NGqtxze6vWyTEKvR6A0uXDCZu3IB+TXrYux+J
        RDx3F9GJTRfz5UX8f6XXsYEXZkIHRTPer5gaBkRApuSgLrBaW1nNlDnVByUndLI8HDR+Xu
        RBRJwNMEhG7z31KZQwWP/mzISY6f3QU=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-qCliwE8JOpOE7ylkqop5iQ-1; Mon, 07 Dec 2020 17:03:38 -0500
X-MC-Unique: qCliwE8JOpOE7ylkqop5iQ-1
Received: by mail-pf1-f197.google.com with SMTP id b11so10857971pfi.7
        for <linux-xfs@vger.kernel.org>; Mon, 07 Dec 2020 14:03:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=n3f55idUWef+oM3UWt0470km4aqSTP3XgPC4MJZJUA4=;
        b=bB9kZ8Er3WGhcedvDbFfsIKMnS2RBO1ZC+NHHG1ey8HYYtVD0l2N6j9bAjcXDp+53u
         15xze6JqQnq50+zLqiFRpTOvikjWfF4eSUHv1Wnlfw5sCnagYv9qjTVXeqfwg7Ud+6Z9
         k1cTsUnx4ueT0VgZ/VAAVbtkh/iZyniYoH6afVMRyp2LBjvHcbus3JVAx0WYEz3lYBIq
         VloPX5Wc8A1o3CpZ2zrENyR/rSEd4+q1ZhHyV/TVuYdmHslRspMGp0sM2YbFUIdYtg3V
         hlRfuDY+quLNWzzK2exZ3nJDhRESJtjLUhYMKGZNZbXm732kiJ1ruNcnKIxFJ9teioSz
         SZYg==
X-Gm-Message-State: AOAM533GbG5bAtR6lCsi7fJICQoBKPtjxPDJc/6idG7lkLm7Lbve64RO
        V9s544/52NntPS9w85vp27WTOs1S+Vzi52Q8KGSZQbD/Ho9JLEk+B6vJ0KkXKEOZMIPRLPZI+gF
        GEqSHdfH5bGdVd+1ZShhn
X-Received: by 2002:a17:902:9341:b029:da:13f5:302a with SMTP id g1-20020a1709029341b02900da13f5302amr18440980plp.9.1607378617156;
        Mon, 07 Dec 2020 14:03:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxR+ilWhm0ZcRsvCaV110ch/SbgOshOqAX8WzMjWCya8h0M2desd56+4xUR/rZdZNJFI9QQw==
X-Received: by 2002:a17:902:9341:b029:da:13f5:302a with SMTP id g1-20020a1709029341b02900da13f5302amr18440964plp.9.1607378616963;
        Mon, 07 Dec 2020 14:03:36 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d20sm754088pjz.3.2020.12.07.14.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 14:03:36 -0800 (PST)
Date:   Tue, 8 Dec 2020 06:03:25 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 6/6] xfs: kill ialloced in xfs_dialloc()
Message-ID: <20201207220325.GA2886611@xiangao.remote.csb>
References: <20201207001533.2702719-1-hsiangkao@redhat.com>
 <20201207001533.2702719-7-hsiangkao@redhat.com>
 <20201207135719.GG29249@lst.de>
 <20201207142448.GD2817641@xiangao.remote.csb>
 <20201207202345.GT3913616@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201207202345.GT3913616@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 08, 2020 at 07:23:45AM +1100, Dave Chinner wrote:
> On Mon, Dec 07, 2020 at 10:24:48PM +0800, Gao Xiang wrote:
> > On Mon, Dec 07, 2020 at 02:57:19PM +0100, Christoph Hellwig wrote:
> > > > +		error = xfs_ialloc_ag_alloc(*tpp, agbp);
> > > > +		if (error < 0) {
> > > >  			xfs_trans_brelse(*tpp, agbp);
> > > >  
> > > >  			if (error == -ENOSPC)
> > > >  				error = 0;
> > > >  			break;
> > > > +		} else if (error == 0) {
> > > 
> > > No need for the else after the break.
> > 
> > Personally, I'd like to save a line by using "} else if {"
> > for such case (and tell readers about these two judgments),
> > and for any cases, compilers will do their best.
> 
> And extra line is not an issue, and the convention we use everywhere
> is to elide the "else" whereever possible. e.g. we do:
> 
> 	if (foo)
> 		return false;
> 	if (!bar)
> 		return true;
> 	if (baz)
> 		return false;
> 	return true;
> 
> Rather than if() {} else if() {} else if() {} else {}. The elses in
> these cases mainly obfuscate the actual logic flow...

(I mean no need to to use else if on irrelevant relationship as well)
Anyway, let me update it later...

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 

