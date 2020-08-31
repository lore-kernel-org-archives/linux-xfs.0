Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09953C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 18:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D09092083E
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 18:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="qqc7fRH7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgHaSFY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 14:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729029AbgHaSFR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 14:05:17 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DC7C061575
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 11:05:16 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id di5so2773720qvb.13
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 11:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vnQDmM3Y8VUdtCiO/ltS5fo251Xne+kzbECtkIEbMh4=;
        b=qqc7fRH7cSLGx0hFoBZYnjshuA5fcxz7qjblG2Q0bETEUDLwyZQbLF/6xetFb2acjW
         FrJGUKtC2W798soZNAsTpRsS9bb260BWCoeKakdX9tzbq7a1hRIEA9r81tk1Rj49DYe/
         UHYst0p2iNJtFKSBNejq3bA4N4YZG+cXyIgyqvQ8III0RYmg8Y7dueaBWb+roS6lHgrX
         xxSfzYIHaTkiPo3L8c4wrUKO8bM53yYDhrYW9Ay3MCGgFrh8KpbnDpCv91VO20xYdlbg
         3rhL5c+/JVRMYYzsPdWL45RrgMhvb9BMVtopYfZZ5xtZhYZS0R4g7bZDqOjnL7HheW/t
         Eb+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vnQDmM3Y8VUdtCiO/ltS5fo251Xne+kzbECtkIEbMh4=;
        b=lAxGfL0e8bTIv45lQRtCZjftU5dwQPX0RJw6N/XzgXXX6s4OnWUsFPXqEQAuNFbsaA
         JRTrdx5oFoECa1qLF3XEwpi8WaoQct9WNvb8NIiejPvST/OAD1+jtUNTtFkaM2QTad93
         ky1+gTuXKZKJZQ5gw512uAatqmu2+CURJ+EP9DTCij83BFSym/qjXc5ccEr/bkjuV/en
         fWPmoKH+BlVmZYfZ4Fu9S4/O9+ZAy4YVtBYAdi7PERytz9qRWLZsJeIb6XhhX/1Ngpwh
         ZejKZWIRFg4KnU3HD3ZnYgwCeibpyx3OAiRlOW3BLJVOxDEja36WaVATYZ/mongm1Zgf
         Jp6Q==
X-Gm-Message-State: AOAM533h+PIIVcCkdUbXXxPbxjo4ZkEBFrtsTe7yD/BUxr9cOIEyaHf+
        kLQtLEPNYRmOANVSNS14USTeF9Znl7p0UA==
X-Google-Smtp-Source: ABdhPJzqNSDrgeEQze3GKyRQwVFa6wtY+F5LnFBzz9wyqUcAPQZ2u9ZghEcn6ShhhXgEd5afNN8d6w==
X-Received: by 2002:a0c:a9d6:: with SMTP id c22mr2266372qvb.102.1598897115990;
        Mon, 31 Aug 2020 11:05:15 -0700 (PDT)
Received: from lca.pw (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id d9sm10024507qkj.83.2020.08.31.11.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 11:05:15 -0700 (PDT)
Date:   Mon, 31 Aug 2020 14:05:13 -0400
From:   Qian Cai <cai@lca.pw>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     darrick.wong@oracle.com, hch@infradead.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] iomap: Fix WARN_ON_ONCE() from unprivileged users
Message-ID: <20200831180513.GC4080@lca.pw>
References: <20200831172534.12464-1-cai@lca.pw>
 <20200831174219.GI14765@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831174219.GI14765@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 06:42:19PM +0100, Matthew Wilcox wrote:
> On Mon, Aug 31, 2020 at 01:25:34PM -0400, Qian Cai wrote:
> > +	case IOMAP_DELALLOC:
> > +		/*
> > +		 * DIO is not serialised against mmap() access at all, and so
> > +		 * if the page_mkwrite occurs between the writeback and the
> > +		 * iomap_apply() call in the DIO path, then it will see the
> > +		 * DELALLOC block that the page-mkwrite allocated.
> > +		 */
> > +		path = file_path(dio->iocb->ki_filp, pathname,
> > +				 sizeof(pathname));
> > +		if (IS_ERR(path))
> > +			path = "(unknown)";
> > +
> > +		pr_warn_ratelimited("Direct I/O collision with buffered writes! File: %s Comm: %.20s\n",
> > +				    path, current->comm);
> 
> "File: %pD4"?

Sounds like a good idea. I could use that.
