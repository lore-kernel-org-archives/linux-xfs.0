Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBF6C43334
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jun 2022 08:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiFBIJH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jun 2022 04:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbiFBIJF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jun 2022 04:09:05 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E94496A4
        for <linux-xfs@vger.kernel.org>; Thu,  2 Jun 2022 01:09:03 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h5so5444640wrb.0
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jun 2022 01:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eUM9+XnalZT18c7gwsWOLxfN4u2iAez4Y1cABKmJu7Y=;
        b=pEjALHln/V5MI9KV/B8S84wKMxLpaS6mFQYsQg4h1Pw54EPO1vAV8zqlmjOHzeRiKS
         qFAOHOdwesAKJ+PBPUEOiwmIh5shZOixMb6R4W/6Ndz9dtr+CYBytV4gTde4NlQJFuyF
         jtQ76iLIWD/UxnCIq420Md4LDbyHKOpT/r7DDphdjP+JT+B5PFW1yBKTJXu7XqaHcRzR
         rhFrfUic4ClKv1WRcrM3H8g1C61tTdejTt6RQ9oy8R66zL0YE8m5xngYIGRFiHLQb2B9
         QLXUUcfzqAw24VJLu0K7m1AyLCYxCpArGXpmStRDdkq3TSF9bqhcOeiMkHio/qX/MTKu
         JQbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eUM9+XnalZT18c7gwsWOLxfN4u2iAez4Y1cABKmJu7Y=;
        b=Pg9A+u2zjwcr/s4vDlSWxSNLaA44N4IoZ5Nu6f/9SRv6LBFBy1VIq3vT7v//9rbbQ3
         eYQb1HZrZH/UmjUUmiqirP4D8Arex0GbXOcWSkZ9it/7ZgdkImR+SHw9rZd6iUdGKDn6
         gg78e6Z9p0hyLcVcEfrbGtJWOJi3cS4b3CMyNF5zLuC8lrCRtyXMpLOPk9V+lK+C68e8
         hh63QuAHfYrc3233J7GPmHAvOXkTCWIsq8bo+3HtuA8hE7IbdMZu6HwgHcuJyInjw9ay
         ZzAq9KwYGH/ukyyoToluSz4r0GjABto13Z7xO4lgSQfA38jx9fwGwHx9vX9y0cgbRCXW
         XXUA==
X-Gm-Message-State: AOAM532qn7Y6lJ9FyeQljVuCF0khCSALg1BJ6DWvX/rV7PI4wgHOKycs
        p/nyV3l8a/2H0IGJCFNq52IAOw==
X-Google-Smtp-Source: ABdhPJyJQE6sH13ogO1etQC1ENO2og0WoBGaPBG3HKHQ+nyT0I31zdiYkJyuiDyDUMe3DaMxCJwp1A==
X-Received: by 2002:adf:d193:0:b0:210:2e72:48b6 with SMTP id v19-20020adfd193000000b002102e7248b6mr2483115wrc.387.1654157342024;
        Thu, 02 Jun 2022 01:09:02 -0700 (PDT)
Received: from [10.40.36.78] ([193.52.24.5])
        by smtp.gmail.com with ESMTPSA id z14-20020adfd0ce000000b0020e68dd2598sm3574188wrh.97.2022.06.02.01.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jun 2022 01:09:01 -0700 (PDT)
Message-ID: <545ab14b-a95a-de2e-dbc6-f5688b09b47c@kernel.dk>
Date:   Thu, 2 Jun 2022 02:09:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v7 00/15] io-uring/xfs: support async buffered writes
Content-Language: en-US
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     david@fromorbit.com, jack@suse.cz, hch@infradead.org
References: <20220601210141.3773402-1-shr@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220601210141.3773402-1-shr@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/1/22 3:01 PM, Stefan Roesch wrote:
> This patch series adds support for async buffered writes when using both
> xfs and io-uring. Currently io-uring only supports buffered writes in the
> slow path, by processing them in the io workers. With this patch series it is
> now possible to support buffered writes in the fast path. To be able to use
> the fast path the required pages must be in the page cache, the required locks
> in xfs can be granted immediately and no additional blocks need to be read
> form disk.

This series looks good to me now, but will need some slight rebasing
since the 5.20 io_uring branch has split up the code a bit. Trivial to
do though, I suspect it'll apply directly if we just change
fs/io_uring.c to io_uring/rw.c instead.

The bigger question is how to stage this, as it's touching a bit of fs,
mm, and io_uring...

-- 
Jens Axboe

