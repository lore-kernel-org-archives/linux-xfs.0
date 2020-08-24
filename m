Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E140AC433E3
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 09:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF08D206F0
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 09:20:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="S1z/AmmN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgHXJUi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 05:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730501AbgHXJUa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 05:20:30 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322B8C061755
        for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2020 02:20:29 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id q3so2614403pls.11
        for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2020 02:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KQzdEJUadSVD+lgD6sVSSDMTvkRGkwdel+4+TdgeUE4=;
        b=S1z/AmmNOCH9afSNr/qrDInALgK0j4q5VYp45vGoszL08gQOq77XWvhovm91maa4+P
         FqKO0IvQQ1zgFOTeD7xwiYdXCC4eSy866y0i4iOHUdhtIcu9OyTLXqq9sIjITeHIlDP/
         TqDQL3++BGqzXH8U95cUEVFQg9f7Oyelz1pTusAebmjo7UGy1iK4oNwyu8zu1fDcAfPX
         nbF7uSCxB/11Zqo85kx55hx/wYlWNGXWIUW2MXqUz8acgYZGRkoKmiKOAMbN76qrQ5Ur
         CsLY7wA5OwEKSwWBknbMM6OhsOsgmjQ3BQKlOzM52TKrjGMbACD7aubcslrIXV21mpIp
         D4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KQzdEJUadSVD+lgD6sVSSDMTvkRGkwdel+4+TdgeUE4=;
        b=LQs7htPA0AZS5tUVKeTnahfc+ODJvyMlhrPHkdPO2R57JKabHv7T+a/G5pd37graOa
         NflQdzsN2GKiFdAfYrb4DabmRN42VM5tFmsxxbBZQDabXG4waqKT8Kqxsw9PHX7AZ/Jm
         ZE9ex42gDjc0O/CLyOBSCQAo23Wvl6NTsqiNBLnc9VaSLNafbmaqa8XfqxPHPUS6WJ0Y
         WTLxY6p1KqbJ9PrWblbPIs3ALnheRjSpMVcU1+3IvuAOOagdl2QHM9DmBlmDBcC6PzgG
         Wu1XbA+t8CZJmG+oqix8NuytunBCOsT6O1o2kdvZ52nRKj2LyDvGjrQB4SEFTTMWrQNl
         P+tg==
X-Gm-Message-State: AOAM5321iFRZ8feqohwA4mrhpxdUGwmI3X9SACjNfWFL7fsc9YMIgqkj
        l556DLsmKqqK74PEM+iGDLgkvA==
X-Google-Smtp-Source: ABdhPJyCrZvD6mxlThjGGxFBbEkhy5RNyLB5+uuwXeW5h1XhNu5PQ5mV/pcyDAllrzYkYjEheHn/mA==
X-Received: by 2002:a17:90a:f994:: with SMTP id cq20mr3717444pjb.229.1598260828641;
        Mon, 24 Aug 2020 02:20:28 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x144sm897257pfc.82.2020.08.24.02.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 02:20:27 -0700 (PDT)
Subject: Re: [PATCH 4/5] bio: introduce BIO_FOLL_PIN flag
To:     Christoph Hellwig <hch@infradead.org>,
        John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20200822042059.1805541-1-jhubbard@nvidia.com>
 <20200822042059.1805541-5-jhubbard@nvidia.com>
 <20200823062559.GA32480@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d75ce230-6c8d-8623-49a2-500835f6cdfc@kernel.dk>
Date:   Mon, 24 Aug 2020 03:20:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200823062559.GA32480@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/23/20 12:25 AM, Christoph Hellwig wrote:
> On Fri, Aug 21, 2020 at 09:20:58PM -0700, John Hubbard wrote:
>> Add a new BIO_FOLL_PIN flag to struct bio, whose "short int" flags field
>> was full, thuse triggering an expansion of the field from 16, to 32
>> bits. This allows for a nice assertion in bio_release_pages(), that the
>> bio page release mechanism matches the page acquisition mechanism.
>>
>> Set BIO_FOLL_PIN whenever pin_user_pages_fast() is used, and check for
>> BIO_FOLL_PIN before using unpin_user_page().
> 
> When would the flag not be set when BIO_NO_PAGE_REF is not set?
> 
> Also I don't think we can't just expand the flags field, but I can send
> a series to kill off two flags.

(not relevant to this series as this patch has thankfully already been
dropped, just in general - but yes, definitely need a *strong* justification
to bump the bio size).

Would actually be nice to kill off a few flags, if possible, so the
flags space isn't totally full.

-- 
Jens Axboe

