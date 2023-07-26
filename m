Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE6CC41513
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 22:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjGZWBJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 18:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjGZWBI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 18:01:08 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261681BF2
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 15:01:07 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b8c81e36c0so2035305ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 15:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690408866; x=1691013666;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+WAq+j8rpwE8jCLQS/mfI/ZnBgNEzR7nuJ5WnOlJ1To=;
        b=LcIfUPbXibFKOcwZyNPdEPd2BAOIawA7Piuq8jlnCvvo8HOZA9xXNry3iC2H0Fd6ZB
         cSd3Eret8x0pxP52DOr+piDJiw05JdJL0c/uaMFpJioI7du0ito8SSc7xEpzs7x7KRdW
         CJSmkQwnHIR16kBQyyRL9RWImlNFGYMbRNOm0blQxc3o0pmRskX23x0r+iqpBou0vGR7
         KvVk+gP7aX2dowabeNtQn0LL5VeIivtzWlPCc71dRhDUgyICPsVbhWcNmbc43RLeHF/h
         oq7tnG7t6RtS8GpYvpBBoSE+fJ8whUZbziQYul5jIollF0H96gUJAqr+JpXTWieWcMwK
         Q4qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690408866; x=1691013666;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+WAq+j8rpwE8jCLQS/mfI/ZnBgNEzR7nuJ5WnOlJ1To=;
        b=BOymDEFCj5Z7wHcQVGNBB3JiXgOHKuusObckBnSVG3xAQrRexNN8jnGb4XLpzvNLn8
         wlJneNYIHwdu8LHtWqeuI70P4g61YZQMXZqb/fk9lOjB6/5bfxjvL6PP0We8+Tn1UsXN
         iUsSDk5sKqfczbJuBbg27u1V0vCPoRf4c9stSB/DrOK3bnLavzR8pKMUs0t7o7VXg+00
         v0P++DtSC7FhRPiFL1KZZQFOZxXhLjwI1P69cyfiYW7BgYNd/vWIHE2rpVqiKgalkzvb
         Cnb2SCP98nTbWf81v5CbHAWfyVxvADWLRcm44t/pZQtQlOmDiJuEgmj7IuHsxKv+ATsc
         wFxA==
X-Gm-Message-State: ABy/qLYUnI2XCMfTVMCSygz24DNjkm2LykG7LhA3tFd6k63+vGMmwLSa
        n9qVgnjy8sTZj3/pxTgKf7wRZA==
X-Google-Smtp-Source: APBJJlGh8nBKWSdToAnmGsCSTUJ3ncEp5T8HpMsW+UsFO7Ykt5aeLDuiVsMLRb3wQpYHPh8ZOTRIQw==
X-Received: by 2002:a17:902:ea06:b0:1b8:a67f:1c0f with SMTP id s6-20020a170902ea0600b001b8a67f1c0fmr3344752plg.39.1690408865163;
        Wed, 26 Jul 2023 15:01:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902e9d100b001bb9883714dsm29527plk.143.2023.07.26.15.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 15:01:04 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qOmZ3-00AuS9-2i;
        Thu, 27 Jul 2023 08:01:01 +1000
Date:   Thu, 27 Jul 2023 08:01:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 3/7] add nowait parameter for iomap_seek()
Message-ID: <ZMGXnVX3+C5PHpiC@dread.disaster.area>
References: <20230726102603.155522-1-hao.xu@linux.dev>
 <20230726102603.155522-4-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726102603.155522-4-hao.xu@linux.dev>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2023 at 06:25:59PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add a nowait parameter for iomap_seek(), later IOMAP_NOWAIT is set
> according to this parameter's value.

This shows the problem with adding booleans as flags to
functions. Now there are -two- anonymous boolean flags to
iomap_seek(), and reading the code becomes really hard to know what
is actually being asked of iomap_seek().

This is another reason for not combining iomap_seek_data/hole()...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
