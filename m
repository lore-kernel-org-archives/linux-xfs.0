Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CE0C3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 11:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DBB7214DA
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 11:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbfHTLgZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 07:36:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1773 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729576AbfHTLgZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Aug 2019 07:36:25 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EFC727BDD1
        for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2019 11:36:24 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id a2so6877259wrs.8
        for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2019 04:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=+jTC31UoVxVyJbeKdpThaY7dIDTPTM58fPXXoh/n94I=;
        b=SaLJddCAJaSYqDeZAjT7PcXywSYYTgr6vv+cMbiNDtqirMP+52+0qTi3M6t5E0P1e7
         sbfluUKIQj7i/+gWbKg0HgKHVdvPtYuBqbbBwzw2Qhb3EC2U5nqWF8YtDh6OKWoPm0sw
         fgtc7w6mhsc/xWL7Ql0sV244f/Fz9d2wgqZVWcBsceX0QlJZ3gJly9VmNovUptZmKZUU
         RaI/OcA2wvLe8tNAj5BTBKV4BB/zRzDvyDW7Hl1fvOxxfThYwzhHQdpEGLnRMNILzBIb
         7iKn0QS3/l9CVZK9AFj+77Y17ZpyZHwFg58RnnnWh/s0taOZZ8SjRAt4/MYOQkR+4Suy
         vtFg==
X-Gm-Message-State: APjAAAX7UKwiY5anz821PyxdM3KAKr2yNIKI9o4eD7HNa7vPJQjFEB3M
        YQkTSMOiKMbayoWoOZyjmekFsVVL8rLdSNhfMf2sst1VQBRq+aK8pG4+iPHpva4ifE0ZffendZp
        1QlLvjXfp09lI5h6CBjdc
X-Received: by 2002:adf:ef07:: with SMTP id e7mr34882019wro.242.1566300983619;
        Tue, 20 Aug 2019 04:36:23 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzAYdlEhSdDtLN+CYcxeGMt+rxtk0Xw8GXeAg6FWlBrxY3BzmFeRyzV70cLgQ+UXhJsdubCvw==
X-Received: by 2002:adf:ef07:: with SMTP id e7mr34881989wro.242.1566300983378;
        Tue, 20 Aug 2019 04:36:23 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id v7sm2356800wrn.41.2019.08.20.04.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 04:36:22 -0700 (PDT)
Date:   Tue, 20 Aug 2019 13:36:20 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-fsdevel@vger.kernel.org, adilger@dilger.ca,
        jaegeuk@kernel.org, darrick.wong@oracle.com, miklos@szeredi.hu,
        rpeterso@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] fs: Enable bmap() function to properly return errors
Message-ID: <20190820113619.qhvf44wyc4b2emw3@pegasus.maiolino.io>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>,
        linux-fsdevel@vger.kernel.org, adilger@dilger.ca,
        jaegeuk@kernel.org, darrick.wong@oracle.com, miklos@szeredi.hu,
        rpeterso@redhat.com, linux-xfs@vger.kernel.org
References: <20190808082744.31405-1-cmaiolino@redhat.com>
 <20190808082744.31405-2-cmaiolino@redhat.com>
 <20190814111435.GB1885@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814111435.GB1885@lst.de>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 14, 2019 at 01:14:35PM +0200, Christoph Hellwig wrote:
> Just curious from looking this again - shoudn't the 0 block be turned
> into an error by the bmap() function?  At least for the legacy ->bmap
> case so that we don't have to carry this cruft around.

I don't think so, this patch does not change the bmap interface on the
filesystems itself, and at this point, we don't have a way to distinguish
between a hole and an error from the filesystem's bmap() interface. The main
idea of enabling bmap() to return errors, was to take advantage of the fiemap
errors (in another patch in this series).

Although, I do agree that this also opens the possibility to change the
interface itself, and make ->bmap calls to really return errors, but this will
require a bigger change in all users of ->bmap(). I can work on that, but I'd
prefer to change this interface in another patchset, after this one is merged.
So, we can work only on those filesystems where ->bmap() will still be a thing.

Cheers.

-- 
Carlos
