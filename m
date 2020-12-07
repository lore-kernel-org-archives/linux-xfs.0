Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F1CC433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06EA621D46
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgLGO03 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 09:26:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725803AbgLGO03 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 09:26:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607351103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TabEvs9nOYfldMpiaLcIFD6Sgf6PvfWkqAsBUlZIh0g=;
        b=gRfUN3p6rmLKrot3C+l+lk2nRZu61gDstj0nmNG3zCAB9PcVlJS0BL5cbTnsdG9Zag6Lp9
        JOG6j8DPxXxIJsHtj0+ssKgNU5dghxVIYhWGXPEBs38gqHBZQOq6PEtp4olY5775ydLbNv
        WrUth7MuFsE9YgWqyc1hacrdIR/bBaQ=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-j8NbLIx_MkmgrU_bnjfd1g-1; Mon, 07 Dec 2020 09:25:01 -0500
X-MC-Unique: j8NbLIx_MkmgrU_bnjfd1g-1
Received: by mail-pf1-f200.google.com with SMTP id q22so9585710pfj.20
        for <linux-xfs@vger.kernel.org>; Mon, 07 Dec 2020 06:25:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TabEvs9nOYfldMpiaLcIFD6Sgf6PvfWkqAsBUlZIh0g=;
        b=odgMOMo1iM31ocKfN2CxGRbd8YxKDARkK3/QT68cI0wwcNW0mcvRi+uyGTNoxr4L0j
         DGL/q4e0fqBYu8s6ZeMepf+gld/rTiW92nDkG2WQQwzDqweYjmaXuVPOGnMtwVPmieOk
         WqBBN+ZVTAsO95YJfkBuPs3T4L8EC6kAJMb8EvA34M6TYGh/OcvtasDDMgcUqpFGadwV
         SOuGf7VGW/fJlaoN3QB1u/boekVB8ghDwdF+G70QQH5wjJLSWDNTJOxSWFWA5SpIGt3/
         aShpjxacn1wg0QHC7kz/zpQyp1c56JwvYyVUSV8aL43Bmsc7Kz6KMA5vZYiKCqWUlcaR
         oq1Q==
X-Gm-Message-State: AOAM531ixnkmdCvydRX4ZEn3QKO9me3Day5uttZmo8Ziw9u3RA59wKpu
        ooHzuCe+XWtgbWRBSkc7ZeRLNKC8VXa4bTTnqUePnXfJ2Nfx+yVDBEBRvOnwSoqhLV4nVFMFru1
        BuJLMEdxyAT+bh9eqeTQ3
X-Received: by 2002:a17:90a:6a48:: with SMTP id d8mr6736376pjm.130.1607351099741;
        Mon, 07 Dec 2020 06:24:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVq9l5PD+9C9QItEvF0yL+Y75gPjYoPz3KwydEt21hYfj5B0dFwtGhVHZ1bYWMRG+Fgg60dQ==
X-Received: by 2002:a17:90a:6a48:: with SMTP id d8mr6736357pjm.130.1607351099528;
        Mon, 07 Dec 2020 06:24:59 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y10sm10563947pjm.34.2020.12.07.06.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 06:24:58 -0800 (PST)
Date:   Mon, 7 Dec 2020 22:24:48 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 6/6] xfs: kill ialloced in xfs_dialloc()
Message-ID: <20201207142448.GD2817641@xiangao.remote.csb>
References: <20201207001533.2702719-1-hsiangkao@redhat.com>
 <20201207001533.2702719-7-hsiangkao@redhat.com>
 <20201207135719.GG29249@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201207135719.GG29249@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 02:57:19PM +0100, Christoph Hellwig wrote:
> > +		error = xfs_ialloc_ag_alloc(*tpp, agbp);
> > +		if (error < 0) {
> >  			xfs_trans_brelse(*tpp, agbp);
> >  
> >  			if (error == -ENOSPC)
> >  				error = 0;
> >  			break;
> > +		} else if (error == 0) {
> 
> No need for the else after the break.

Personally, I'd like to save a line by using "} else if {"
for such case (and tell readers about these two judgments),
and for any cases, compilers will do their best.

Yet, if you like, I could add an extra line for this.
Will update in the next version.

Thanks,
Gao Xiang

> 

