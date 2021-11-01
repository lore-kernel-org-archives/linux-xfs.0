Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15C4C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 20:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D713D610FC
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 20:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhKAUyT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Nov 2021 16:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhKAUyM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Nov 2021 16:54:12 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA6DC061767
        for <linux-xfs@vger.kernel.org>; Mon,  1 Nov 2021 13:51:38 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id v65so23124643ioe.5
        for <linux-xfs@vger.kernel.org>; Mon, 01 Nov 2021 13:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CMGE2kkQeNi/kwlNp/sxaKwbffuHzsFYRTX7+Qn4S5k=;
        b=Dbu4JokQJoepDvPa1O2EjBOPWwhJaddMCAqi05hDlVjKvuMr9LIcsz6aWOSgpvXI3A
         31sX9LkCHSEigGYGMOVpIN/2+Yo4GHSwRHQWq3KYJ4BSin4ZhaF354PhZDZgVbWCgYII
         rfLqji0mTVg1k79xcx58UVwLWJI/35FBHOnpNpZ/js87+L40AiaLaTwO6WF7WMm6Rci/
         /Ib9YX9HEiHx8MZH8Nh6lUf+fq/PJkAHD9Oi+cdMO3s2yTEGIDGHb2Y5IhF13SOPxXdd
         0Fu6yTi4N2nNAGliR36vvNlPEqA1iHYgpz1AdQNqkHPmcXJyVXsKoWn8hU+474QzCQIm
         k5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CMGE2kkQeNi/kwlNp/sxaKwbffuHzsFYRTX7+Qn4S5k=;
        b=WP6O9Q+0UvOEa5n2zx7fmMsWf3dZCWPYkYKY1MYDi5beBpInms0TpjB9yTVZsq79ut
         R4+nppAuf87sh+sIVaC84vVKrcdKMzIPOGhwFJlW+PkzzZYnAFwdSFwHpVvpagMRm92e
         LbKW5I8VFbfgK3o7/fqZKRy/e5DtmZ5J8t7c3A1aO1EbKI8+AJ9klOrQQ4LQHJK7DcgU
         dWo9xk4/waabXwXwvbx5+pmz8khUVzShZpifIcMF6HYpy/HMTJwW85j5mxbiOtIq6bhe
         ecsDQ2xMR03n7+2ggqKARfOca3WKeUbwapGn8Zbe2p2HL/bCbmvabFadTyuvamRmZq26
         udQQ==
X-Gm-Message-State: AOAM530XDNDJytomWYex/SoQz0hlbvc+yFAd+VQRl1EsK8IzS4NFvyYO
        tjl3X0GE1mFBAl1K32BPs9uRDg==
X-Google-Smtp-Source: ABdhPJxlImzKDo8ZsB+bpNGxu2iBOEwuLlA9ExA3PeHJGanwTyuKtaNtZMQstsxJLn9G6YhLjPBDNQ==
X-Received: by 2002:a6b:8e58:: with SMTP id q85mr22385605iod.7.1635799898185;
        Mon, 01 Nov 2021 13:51:38 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f11sm5817976ilu.82.2021.11.01.13.51.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 13:51:37 -0700 (PDT)
Subject: Re: [PATCH 02/21] block: Add bio_add_folio()
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
References: <20211101203929.954622-1-willy@infradead.org>
 <20211101203929.954622-3-willy@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0384e51b-0938-dccb-8c70-caa1f2b35d34@kernel.dk>
Date:   Mon, 1 Nov 2021 14:51:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211101203929.954622-3-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/1/21 2:39 PM, Matthew Wilcox (Oracle) wrote:
> This is a thin wrapper around bio_add_page().  The main advantage here
> is the documentation that stupidly large folios are not supported.
> It's not currently possible to allocate stupidly large folios, but if
> it ever becomes possible, this function will fail gracefully instead of
> doing I/O to the wrong bytes.

Might be better with UINT_MAX instead of stupidly here, because then
it immediately makes sense. Can you make a change to that effect?

With that:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

