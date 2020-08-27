Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 782CCC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 15:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C8D42177B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 15:57:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="LEP9G9et"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgH0P5H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 11:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgH0P5H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 11:57:07 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2404EC061264
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 08:57:07 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id o196so5765088qke.8
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 08:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2d/kLksGLg8BmoGE94UbDXQhgCXyKqUn+Wd/kGZnKp4=;
        b=LEP9G9ete+wX6Own3Eg51JDXOHDeJTvnZE0CP0YxcxHZfQlPv8sxL3Y1SRtYoe1aJv
         g+ihMkbBCMrqVlXpC7KO649zuQQ0lR3b/B8PovP34g6Sm/Fw5AhHRpXr7lHfVYuWRvFL
         s4CpitXVdtR0fvsme+0Nb6l/gT3WciW2gvNYvDVJz61n8SxwG426vfHJnZzcNxbCtcqq
         xOhRrhm+D7Mm0f/xLOd+WvPcpRKcyS4fnXoX4XjUMp3VIwqORQjLj8VJz3hH/vCU14zW
         IrtKX8X2Y9M1xihF9jgC4H9FlXIKJC2tB7rDllTYcUbXl89BiSIM8NcVkSd4Lh6SIag2
         CSRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2d/kLksGLg8BmoGE94UbDXQhgCXyKqUn+Wd/kGZnKp4=;
        b=K/ECYcFu4bc3KGd6anfRb4562/V/Hd9tebRyqzVIjIpbjCVh1Qd1zlRqajzkB33Zml
         wPgxeXsuvtqIiW9kenSjrBCRJ186nKfn/SSI8FqxEiBCNA7ej8H/k+sw/dx2/Lo0S65B
         Q4KjcmrO7lwjQW03f9i/g6bWPzlq8BdTgriBQD1OwpgMblmnJbX6BavqHJ0oDH5c7Cdm
         sN+sbI25+myFdANu4kdwUiDk2iT+FR9flTiilu+Df66WprLmoVwQCZlJChzFt00V2R3K
         2u5EhHczLFjqlIyDQv+1PAcr3YGMCQDfyAbMGW59Ko18ma221QGwxzdIDEPRIbXNqmNg
         H9aA==
X-Gm-Message-State: AOAM533mh+6KCYKsdSz+A5kAyapPcGqKBJcEOOHFHt12W4gXUDb5ymY4
        B/gclDBLQM9l80Kbr9e05O/DKuYjVV9cWaHe
X-Google-Smtp-Source: ABdhPJzyfjpD0FGKP9jCR5+pk+mS6EwehghX6FdkGLGoHlaFemUZBTkMdTgvpRl0uNi5ncjVA17Wrw==
X-Received: by 2002:a37:ad0a:: with SMTP id f10mr19298391qkm.154.1598543825741;
        Thu, 27 Aug 2020 08:57:05 -0700 (PDT)
Received: from [192.168.1.210] (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id h25sm2011175qka.106.2020.08.27.08.57.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 08:57:05 -0700 (PDT)
Subject: Re: [PATCH 1/4] generic: require discard zero behavior for
 dmlogwrites on XFS
To:     Christoph Hellwig <hch@infradead.org>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <20200826143815.360002-1-bfoster@redhat.com>
 <20200826143815.360002-2-bfoster@redhat.com>
 <CAOQ4uxjYf2Hb4+Zid7KeWUcu3sOgqR30de_0KwwjVbwNw1HfJg@mail.gmail.com>
 <20200827070237.GA22194@infradead.org>
 <CAOQ4uxhhN6Gj9AZBvEHUDLjTRKWi7=rOhitmbDLWFA=dCZQxXw@mail.gmail.com>
 <20200827073700.GA30374@infradead.org>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <c59a4ed6-2698-ab61-6a73-143e273d9e22@toxicpanda.com>
Date:   Thu, 27 Aug 2020 11:57:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827073700.GA30374@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/27/20 3:37 AM, Christoph Hellwig wrote:
> On Thu, Aug 27, 2020 at 10:29:05AM +0300, Amir Goldstein wrote:
>> I figured you'd say something like that :)
>> but since we are talking about dm-thin as a solution for predictable
>> behavior at the moment and this sanity check helps avoiding adding
>> new tests that can fail to some extent, is the proposed bandaid good enough
>> to keep those tests alive until a better solution is proposed?
> 
> Well, the problem is that a test that wants to reliable nuke data needs
> to... *drumroll* reliably nuke data.  Which means zeroing or at least
> a known pattern.  discard doesn't give you that.
> 
> I don't see how a plain discard is going to work for any file system
> for that particular case.
> 

This sort of brings up a good point, the whole point of DISCARD support 
in log-writes was to expose problems where we may have been discarding 
real data we cared about, hence adding the forced zero'ing stuff for 
devices that didn't support discard.  But that made the incorrect 
assumption that a drive with actual discard support would actually 
return 0's for discarded data.  That assumption was based on hardware 
that did actually do that, but now we live in the brave new world of 
significantly shittier drives.  Does dm-thinp reliably unmap the ranges 
we discard, and thus give us this zero'ing behavior?  Because we might 
as well just use that for everything so log-writes doesn't have to 
resort to pwrite()'ing zeros everywhere.  Thanks,

Josef
