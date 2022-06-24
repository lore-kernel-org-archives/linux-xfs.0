Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0707C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jun 2022 14:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbiFXOxW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 10:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbiFXOwy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jun 2022 10:52:54 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD847FD22
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jun 2022 07:48:54 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id k6so1648443ilq.2
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jun 2022 07:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DWcyz906WJfvMFL2VVjgjsdhhZt0R2JBG5BvPCvlnPE=;
        b=kAZfa4Gvw0mMhZjLyDIabymc1EmZA6j/Ij9km3tKCr2BFPbswn26/J6hUzgzxK1udT
         LXghN15N0v7AXCHZjA2DZSNUqDb8GKoz3EPZn168zMo/kyOYC8fhdWqF/to68Cm5uxLi
         KUmvke0fE3Nb+xs/xxNlvH/wfLHfkCsapDQ8szgjNP6dRJ5TGPFoxdXQ3s+3EWsusHWR
         9J/fh9bzOC3ORimLqxSc/OtThU3lq68I5z0UVi8MeqqhfTtGrGxDnG19KA2TV9dSV3bW
         BgGazgp0V8riFQG6oC8SqJWq18ANKzv8SntphwIcsljLarq5zbbOYF/a54oGxURUkgY4
         Aq7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DWcyz906WJfvMFL2VVjgjsdhhZt0R2JBG5BvPCvlnPE=;
        b=rk+bEL4QujKa3sUpSKZCB2e+vlXPoxAlRGkwB/gheacVUxa+grFvZviNhbfP59kLwg
         auMKqaSJL2sh+ti8odS8Ddb6pgzmFgsvXKZ4TgozzrJrVlCndj9eIQJF6as967nPN5gZ
         0VHOtlhK+jX+VrMgl57pi4PgCNGJ1nos0SMtKR0DzvEgN2GnA/ME4N42CbBZRe9U1Ey2
         4jcptsuFMHF7MsO/LQro2JiemWAxUshrCIpUPK91w036q/ImxwSbNU/5ls4pFl6s7Ww7
         sczyZZ+LuFM+sTZq45l6TrTju6/pPhYwkdrbLo06Ih9YfksC/jB6cvlG84DPc4n4RJYC
         Jpxw==
X-Gm-Message-State: AJIora/vR8R747egr1TJEm6mgWpCrz4/f8sfaEfG0KT1jwS3eO45q7Oc
        zD4dy47WUFkFUANdZI1wKeTnOw==
X-Google-Smtp-Source: AGRyM1vtQ5lI0ui69eAPGDOvVUnSBy1LS9YB7l1nUJUBdVR6AuykMTvdZaQ+wwkP8ETAWatGVBndKg==
X-Received: by 2002:a05:6e02:1ba3:b0:2d8:d74b:8ff6 with SMTP id n3-20020a056e021ba300b002d8d74b8ff6mr8714104ili.264.1656082134104;
        Fri, 24 Jun 2022 07:48:54 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e25-20020a0566380cd900b00339ee768069sm1137354jak.74.2022.06.24.07.48.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 07:48:53 -0700 (PDT)
Message-ID: <293e593d-2f2a-623e-bf2f-786fce623327@kernel.dk>
Date:   Fri, 24 Jun 2022 08:48:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RESEND PATCH v9 07/14] fs: Add check for async buffered writes
 to generic_write_checks
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>, Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, willy@infradead.org,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>
References: <20220623175157.1715274-1-shr@fb.com>
 <20220623175157.1715274-8-shr@fb.com> <YrVJvA+kOvjYJHqw@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YrVJvA+kOvjYJHqw@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/23/22 11:21 PM, Christoph Hellwig wrote:
> FYI, I think a subject like
> 
> "fs: add a FMODE_BUF_WASYNC flags for f_mode"
> 
> might be a more descriptive.  As the new flag here really is the
> interesting part, not that we check it.

Agree on that - if others do too, I can just make that edit.

-- 
Jens Axboe

