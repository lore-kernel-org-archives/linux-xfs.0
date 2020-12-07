Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA31C4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9F46235FC
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgLGOem (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 09:34:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33657 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725823AbgLGOem (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 09:34:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607351595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kVhnehPqL4hic/XVN7aLsQdtmAe9sMUozoHX5NBbr1w=;
        b=cxP883yp1xcniL6NnFoCj+59llzTc90ho+OKmSk1gC0XGl4iN+5skNizCCe1Byy/5bVa/T
        OPDElhJsZTP1ceIYbzcnM+rOw+tVuzrg78AUCZE/0kgBz+CHk+K/bL81hiFaW8afrvjmMl
        ZP3ZL74WD1YO4KjRTlmNZuI8nvxYOg8=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-cz581RcRO7yxcP8qf6rA6g-1; Mon, 07 Dec 2020 09:33:14 -0500
X-MC-Unique: cz581RcRO7yxcP8qf6rA6g-1
Received: by mail-pj1-f70.google.com with SMTP id p6so36339pjr.0
        for <linux-xfs@vger.kernel.org>; Mon, 07 Dec 2020 06:33:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kVhnehPqL4hic/XVN7aLsQdtmAe9sMUozoHX5NBbr1w=;
        b=RU4c7kHM25gSO4hAv8Qgciz0+OCJ2Xia/H42qG5GDVbNyic/MRznwEVTWSRXpQihD+
         gXF6TWOju3olHax7fWwTtZEcintIPSmYJt2X4skmF+QWcNU4s1Tk3xsCpWs6bChu7m2b
         DYpXa4miaI4xsaQFv76TegiL7eNE7wCaNqHAMzCRlCzsUYm/K2zAVmvbd8jHkRK9a9NN
         W+Aq5ZhFsswahtW9a0nUD3t07IeQ+3BYTS0mbWO0/izvmNbZxgfCKqrfccaDu3DYk8ny
         kjFTpDvH/oZiMPPDjEiI4uxsp/kWVt1jGD8xz1JuK6TiXsiqdGPQRCyerQX20dp2KpJC
         jesQ==
X-Gm-Message-State: AOAM533kVVa1cfYBo/ByDR79XCssHE/dvd1xec5NSkxBkDsmyDa96p5R
        tTdrfzT2stVXWWmn4BuEeNfPmYC4HqWy/Qtvvo9rVyXlP7HdF/XTNTB0kzFKTvvsswG2hmyIID7
        Rri4ioSWFDNPpAJyxNCu+
X-Received: by 2002:a62:1d10:0:b029:163:deb3:5df2 with SMTP id d16-20020a621d100000b0290163deb35df2mr16287189pfd.68.1607351591434;
        Mon, 07 Dec 2020 06:33:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwtUOO1Cbp/6h7SEm3EV63P03fUmT85NR+lbqgvYiYcco8jkusSKxt/3fFaxqMiVyoj4aFt1g==
X-Received: by 2002:a62:1d10:0:b029:163:deb3:5df2 with SMTP id d16-20020a621d100000b0290163deb35df2mr16287165pfd.68.1607351591136;
        Mon, 07 Dec 2020 06:33:11 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b1sm10571904pgb.30.2020.12.07.06.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 06:33:10 -0800 (PST)
Date:   Mon, 7 Dec 2020 22:33:00 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3 5/6] xfs: spilt xfs_dialloc() into 2 functions
Message-ID: <20201207143300.GE2817641@xiangao.remote.csb>
References: <20201207001533.2702719-1-hsiangkao@redhat.com>
 <20201207001533.2702719-6-hsiangkao@redhat.com>
 <20201207135642.GF29249@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201207135642.GF29249@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph,

On Mon, Dec 07, 2020 at 02:56:42PM +0100, Christoph Hellwig wrote:
> >  		if (pag->pagi_freecount) {
> >  			xfs_perag_put(pag);
> > +			*IO_agbp = agbp;
> > +			return 0;
> 
> I think assigning *IO_agbp would benefit from a little consolidation.
> Set it to NULL in the normal unsuccessful return, and add a found_ag
> label that assigns agbp and returns 0.

Just to confirm the main idea, I think it might be:

*IO_agbp = NULL;  at first,

and combine all such assignment
> > +			*IO_agbp = agbp;
> > +			return 0;
>

into a new found_ag lebel, and use goto found_ag; for such cases.
Do I understand correctly? If that is correct, will update
in the next version.

Thanks,
Gao Xiang

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

