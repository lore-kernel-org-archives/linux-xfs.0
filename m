Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DC3C3A59E
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 11:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8613E22DA7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 11:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfHTL5i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 07:57:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfHTL5h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Aug 2019 07:57:37 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF54764041
        for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2019 11:57:36 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id k8so5806244wrx.19
        for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2019 04:57:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=XDKEoOdHwq1lbeRx7Aw+gnzvXTG37O7vnLdKpNshzwg=;
        b=F8H5KpL9StYHt73RRblruViXpyJvQ/kYf5mkxi6kKf0mYvXW8VjUnAqaqCG7klcmFE
         uztAj5o4R6Q65DALCo5Th4CtoOZ6s2J2k+gFOOpKm7LOx3ZPPPHhlLtwRqvaeDDCtjAU
         LiG0T3/K8ucODQlc89DN7nq9crMsNE4+BLXdm06ctWfEN3PDTWTiU53Z31x7W1CqaW6J
         glJsegZyP8x8lTOk1ydgJevwdMJG9mcU6ICzSAhYeZYah9I5RvGkYEkIHlOENso1ab7T
         QcNFKSSXOTyNty4NYCjycnelpomuIhbOEKr31XScEhCBRwPTT2U8zYnZQhTCUbTMyRQH
         jv4A==
X-Gm-Message-State: APjAAAVlxum2Y7Vj1FrhcE86WU5MV8YYPOgi0V5AWUrRR7E5qR9FtXQU
        hNEXAxOQJs2wIcCC4UEfwfhL9N7C1kCUc/MfPxY2qo9neJGWCv6SyWayg/1jDQWMU/WV5/xgRUO
        Y2QMOC7U7s48OJLR2Dcem
X-Received: by 2002:a5d:5302:: with SMTP id e2mr34260715wrv.345.1566302255528;
        Tue, 20 Aug 2019 04:57:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxacsi4LfxSfRp+8+CxkC8yY0Yg8as35IT8Y5TfMDGMA3q7N5ldlBJvJxDKANyD5thffwKLXQ==
X-Received: by 2002:a5d:5302:: with SMTP id e2mr34260687wrv.345.1566302255317;
        Tue, 20 Aug 2019 04:57:35 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id v124sm14321570wmf.23.2019.08.20.04.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 04:57:34 -0700 (PDT)
Date:   Tue, 20 Aug 2019 13:57:32 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-fsdevel@vger.kernel.org, adilger@dilger.ca,
        jaegeuk@kernel.org, darrick.wong@oracle.com, miklos@szeredi.hu,
        rpeterso@redhat.com, linux-xfs@vger.kernel.org, dhowells@redhat.com
Subject: Re: [PATCH 2/9] cachefiles: drop direct usage of ->bmap method.
Message-ID: <20190820115731.bed7gwfygk66nj43@pegasus.maiolino.io>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>,
        linux-fsdevel@vger.kernel.org, adilger@dilger.ca,
        jaegeuk@kernel.org, darrick.wong@oracle.com, miklos@szeredi.hu,
        rpeterso@redhat.com, linux-xfs@vger.kernel.org, dhowells@redhat.com
References: <20190808082744.31405-1-cmaiolino@redhat.com>
 <20190808082744.31405-3-cmaiolino@redhat.com>
 <20190814111535.GC1885@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814111535.GC1885@lst.de>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 14, 2019 at 01:15:35PM +0200, Christoph Hellwig wrote:
> On Thu, Aug 08, 2019 at 10:27:37AM +0200, Carlos Maiolino wrote:
> > +	block = page->index;
> > +	block <<= shift;
> 
> Can't this cause overflows?

Hmm, I honestly don't know. I did look at the code, and I couldn't really spot
anything concrete.

Maybe if the block size is much smaller than PAGE_SIZE, but I am really not
sure.

Bear in mind though, I didn't change the logic here at all. I just reused one
variable instead of juggling both (block0 and block) old variables. So, if this
really can overflow, the code is already buggy even without my patch, I'm CC'ing
dhowells just in case.


> 
> > +
> > +	ret = bmap(inode, &block);
> > +	ASSERT(!ret);
> 
> I think we want some real error handling here instead of just an
> assert..

I left this ASSERT() here, to match the current logic. By now, the only error we
can get is -EINVAL, which basically says ->bmap() method does not exist, which
is basically what does happen today with:

ASSERT(inode->i_mapping->a_ops->bmap);


But I do agree, it will be better to provide some sort of error handling here,
maybe I should do something like:

ASSERT(ret == -EINVAL)

to keep the logic exactly the same and do not blow up in the future if/when we
expand possible error values from bmap()

What you think?

-- 
Carlos
