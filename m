Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F27C001E0
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Aug 2023 23:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjHAXfP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 19:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjHAXfO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2023 19:35:14 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E7F2707
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 16:35:05 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6874a386ec7so395471b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 01 Aug 2023 16:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690932905; x=1691537705;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dkyQ5mGXv5tDN3VlFhqUQ/5LN/Jl3KXt1aFfp7FfZ/k=;
        b=eDBOqb7c1SyBBspA+Na1La+wPcz8m8I0+8U9D4kSNIrM6VSqGxGVToziNzOqykz/g+
         0S0UCOL1DnWNSUQuU9qcTYpaBVM7/S/0kEKUo7lnu2aznuF/vc6arKmEcIwuXm6C+xVz
         RFeRgeI7CyyB6zdJwzh3yc2SzRj/JaF8/Rz0wvMlRr9OOWTaQZgSzJr8FGuoZIikRhVx
         K9Gg53E/FglPMermFMTnqjaG99ohNJUBZ+v3Qe3wEOk85ezPzATiDjr6uFFVHzTXQ3Gq
         /2hfgXuF0utw3b2lD5/4BfC9afF0of3Z+1i2OZEAIHotME7RGJCp4lLkM8xk02kThLg4
         78Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690932905; x=1691537705;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dkyQ5mGXv5tDN3VlFhqUQ/5LN/Jl3KXt1aFfp7FfZ/k=;
        b=GGKjXYtPD9ZVd6BKTu7zw/wPJLxBKhEXuaHLJxCKGtOYrQWoLKg74IwNJhYWJSB1UR
         sl0sptKqIspOSVp6SudvPolJDLtKGiBsQsuFveka/RHfn/LPicLxNXMbhQRZuPm6lQJV
         hEkZieqkVEEFP+j4y+gCIg3DfeEPeM/+Uod3bVHgeQHKvhUCna17Nrc4b23iB+Ui6bv0
         MruxEU1rON6DDF8FMybEpDZPqwBcI3jd4g5z8htzT9lE64xjVaepLuUgnt92dqu7DASb
         cRHC3T/As9CUj11ACqqLizyJLmociSn/HjMZUATnGzM8udswTSLr6Q1aiJVhAQjnKRQq
         ZqlA==
X-Gm-Message-State: ABy/qLbH22LNQhjAMqaj/RCk4GFy9VtlcK/81ySeH4rAhSqZEtNO+c1p
        LtkG17hiqWP3lQsnbv5o+buN7A==
X-Google-Smtp-Source: APBJJlEHpNrym5p4+nrbk4k+mBpBpDrGPiFO73CLnUpZ02yjUIRkEJi2h4JqCmMrwWpHyxqIpvrzLg==
X-Received: by 2002:a05:6a00:1d98:b0:682:59aa:178d with SMTP id z24-20020a056a001d9800b0068259aa178dmr11952269pfw.1.1690932904585;
        Tue, 01 Aug 2023 16:35:04 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x41-20020a056a000be900b0068703879d3esm8933102pfu.113.2023.08.01.16.35.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 16:35:04 -0700 (PDT)
Message-ID: <c033ea82-43af-23f0-e8fb-acb8a6a9571c@kernel.dk>
Date:   Tue, 1 Aug 2023 17:35:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [GIT PULL v2] Improve iomap async dio performance
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
References: <98cbe74e-91d8-9611-5ac0-b344b4365e79@kernel.dk>
In-Reply-To: <98cbe74e-91d8-9611-5ac0-b344b4365e79@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/28/23 7:47 AM, Jens Axboe wrote:
> Hi,
> 
> Here's the pull request for improving async dio performance with
> iomap. Contains a few generic cleanups as well, but the meat of it
> is described in the tagged commit message below.
> 
> Please pull for 6.6!
> 
> 
> The following changes since commit ccff6d117d8dc8d8d86e8695a75e5f8b01e573bf:
> 
>   Merge tag 'perf-tools-fixes-for-v6.5-1-2023-07-18' of git://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools (2023-07-18 14:51:29 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.dk/linux.git tags/xfs-async-dio.6-2023-07-28

Darrick, I collected Dave's reviewed-by on all the patches. Same pull
request as this one, only the commit meta data changed:

   git://git.kernel.dk/linux.git tags/xfs-async-dio.6-2023-08-01

Please pull!

-- 
Jens Axboe


