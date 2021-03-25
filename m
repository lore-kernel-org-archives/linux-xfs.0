Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40AE2C433C1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 01:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0CFF61A14
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 01:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCYBRm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 21:17:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239584AbhCYBRK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 21:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616634984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VetUnH9/M5CVKX+uHrQLKkYkVqS2toONTcK/x4eavj4=;
        b=X8fi1SqndtZH8w+wN91pyMbEdzbfRxjYZsjFd/zutHqBO6WtkBuBNz+QFIfwjK6U257mqt
        SKTCwqlmaKO1caTishs6PijcFQaEUktEJPaXu5g3UGirZ4FeIBFqLsPBz+AbDM5qxqvtXN
        4mPpu9yEJnHja9FfqzKRMPgcIfHt6lo=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-bndFijm9Nra1As0gn5getw-1; Wed, 24 Mar 2021 21:16:22 -0400
X-MC-Unique: bndFijm9Nra1As0gn5getw-1
Received: by mail-pf1-f199.google.com with SMTP id 7so2560694pfn.4
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 18:16:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VetUnH9/M5CVKX+uHrQLKkYkVqS2toONTcK/x4eavj4=;
        b=GSivYnm1WGuHoN1r+1/cb4BPm4btTri2Mrv+P7g9sURT8agaJzts/68HD0YCuCzIur
         SQkA/x6G74XH+1AR2h9UnQ6skK6ZbvyQXGgW2SF88cnx6hMhlMSS+hFxKJfrWiZGZSOM
         84yYSA9k7YTUH7FjGETTgPJ05KxZFzDnqTlxc/tT+I8dSeTS0YhZi8bxKZn6H8nkVEJu
         2Sh6bIi36DrRgDsjPOUN8QjnAwOqAe5SIicaGNWuonZO1NWTxBbYh/QS9R6E6nOSxZTj
         OsAq4wK1aqrl5rQ7nJeaMAp0P2cUSZngMZK3yGRnxnsVFKhNBjLUDmiK3gaR1P6E2+2y
         849A==
X-Gm-Message-State: AOAM530N+7tEFl52yynE2LgK2EJhj+UgYBxZNQhAUkMKQ48bdnBuPT9o
        gZJdQcQDcvcvQ87gLyr9NWAJwgXTQX3pTPIIWKSEgHGqSxzJ6z3hvHaIgekhSKgxIdOkFryeIs7
        Etjm9TprEIPElSuGjeBBQ
X-Received: by 2002:a17:902:a513:b029:e5:d91c:2ede with SMTP id s19-20020a170902a513b02900e5d91c2edemr6599633plq.65.1616634981012;
        Wed, 24 Mar 2021 18:16:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7tC13SKfqZcJETvJy4htGyqlFiH+aU40lCAiDlL1xlKADwyUlIp2BvcnvcGFCeB/+07JHyg==
X-Received: by 2002:a17:902:a513:b029:e5:d91c:2ede with SMTP id s19-20020a170902a513b02900e5d91c2edemr6599615plq.65.1616634980769;
        Wed, 24 Mar 2021 18:16:20 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f6sm3751635pfk.11.2021.03.24.18.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 18:16:20 -0700 (PDT)
Date:   Thu, 25 Mar 2021 09:16:11 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     L A Walsh <xfs@tlinx.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: xfsdump | xfsrestore resulting in files->orphanage
Message-ID: <20210325011611.GD2421109@xiangao.remote.csb>
References: <605BDCBB.6070607@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <605BDCBB.6070607@tlinx.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On Wed, Mar 24, 2021 at 05:43:39PM -0700, L A Walsh wrote:
> oops, forgot to cc list.
> 
> -------- Original Message --------
> 
> On 2021/03/24 16:58, Eric Sandeen wrote:
> > 
> > This is a bug in root inode detection that Gao has fixed, and I really
> > need to merge.
> > 
> > In the short term, you might try an older xfsdump version, 3.1.6 or earlier.
> ---
> 	In the short term -- I was dumping from a dumpdir
> for a partition (just to make a copy of it on the new disk), but there was
> no real requirement to do so, so I just dumped from
> the "source" dir, which for whatever reason didn't have the problem.
> 
> 	My final try would have been to use rsync or such.
> > 
> > (Assuming you don't actually have a bind mount)
> ---
> Not on that partition...
> 3.1.6?  Hasn't 318 been out for quite a while?
> 
> I looked through my bins only have 312 and 314 (and 318)...
> tried 314, but it started out with the same inode confusion -- didn't
> wait until it started spitting out any other errors.

Not sure get all your point.

That is because commit ("xfsdump: handle bind mount targets") was included in
3.1.7. So it would be better to confirm if 3.1.6 works as expected.

In principle, 3.1.6 should work if applying to non-bindmount root dir. (I mean
if no new non-identify potential issue here)

Thanks,
Gao Xiang

