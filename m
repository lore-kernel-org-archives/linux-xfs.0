Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BBBC43217
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 16:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241307AbiEBQLS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 12:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241165AbiEBQLQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 12:11:16 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51132DE95
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 09:07:47 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t13so12009554pgn.8
        for <linux-xfs@vger.kernel.org>; Mon, 02 May 2022 09:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=vmp9CQIj1Zs/em4uo2GbHk0NnCqJbYnCBw5TO/vJ0eE=;
        b=DkgHRwBeptOQUef7LWCd9qKGFhzSbT3Ijmd+WMgxscmZkJoRtExzgWwlapmqlIGmfI
         mu+FjCmNhJRStsbeODKe5Negvi6KvW6ZBRGPlb5+16I4sOhH9x6y9noeRGSH8ZrOuKnk
         lnEEBiToVM2DyhbQc53hR6aI53AIhWAPiWyzVYAu+daHb9UzbhIIOk7Vbj5IwoANmyVV
         Bf/HTXoBhEnIKPYm3UTssLxE+VEM1H8AslebOd37GqDC6JsAZ9QFIcwkMO8ykJR+Vp15
         0Xh3qyuHcff8GNtu2J2IGOwEGhwmhwo8o1ZMU8Sinwr1JUi0N4c2NLxgPLv2zZ8Q6bsJ
         P9XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=vmp9CQIj1Zs/em4uo2GbHk0NnCqJbYnCBw5TO/vJ0eE=;
        b=VB81dSZ/WtZ/CWuKw7CI343EBMNQ6GYiodpnFEBRcJcaEd0HhuxLbttcg2nUsUzUiW
         CrKVkXwFSKmprcHrklSVbrLIgtZWkOzzI9LdbrL75bRSjUwWFIvMzE/dSNh5kp+/b5C/
         wBi6b9XYZEG7tC/0eLIn16i832yurIfAddOjHqe3EufijOCuaCE/xeXSfaEKyA8O/ny4
         mV6XIW0QBYeiZqEH38kRawGJr7o46hPrIYq6mkRLPd/n4zA7uK3demG7f2jWn8ZF0K73
         f/epZDeC+YATogasaMIExvhOX1MkwBrzoRth5OCMXwWvOJiO+a1ODFa3MqrJ/rSNGPKz
         1BRw==
X-Gm-Message-State: AOAM532D6eWIPHsYW2NxPKs8T0y4fTBpDWqEWXHZotFDqAxZvEQqD417
        1g8DTJFIEsVoFQ/BJEY6JRaPRF572QOy0qCY
X-Google-Smtp-Source: ABdhPJxN7SayQGlnlRlAnxrbhg/8PgwF1fcHSSb/MBaeXeimsNPqrIIR1crr/+zE4OKE6Nsu7mKRzA==
X-Received: by 2002:a05:6a00:1515:b0:50d:bc1a:f7b3 with SMTP id q21-20020a056a00151500b0050dbc1af7b3mr12207502pfu.37.1651507666742;
        Mon, 02 May 2022 09:07:46 -0700 (PDT)
Received: from [127.0.1.1] ([8.34.116.185])
        by smtp.gmail.com with ESMTPSA id g25-20020a62e319000000b0050dc7628168sm4883880pfh.66.2022.05.02.09.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 09:07:46 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ming.lei@redhat.com
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        czhong@redhat.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org
In-Reply-To: <20220420143110.2679002-1-ming.lei@redhat.com>
References: <20220420143110.2679002-1-ming.lei@redhat.com>
Subject: Re: [PATCH V2] block: ignore RWF_HIPRI hint for sync dio
Message-Id: <165150766572.3972.14278571508374814557.b4-ty@kernel.dk>
Date:   Mon, 02 May 2022 10:07:45 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 20 Apr 2022 22:31:10 +0800, Ming Lei wrote:
> So far bio is marked as REQ_POLLED if RWF_HIPRI/IOCB_HIPRI is passed
> from userspace sync io interface, then block layer tries to poll until
> the bio is completed. But the current implementation calls
> blk_io_schedule() if bio_poll() returns 0, and this way causes io hang or
> timeout easily.
> 
> But looks no one reports this kind of issue, which should have been
> triggered in normal io poll sanity test or blktests block/007 as
> observed by Changhui, that means it is very likely that no one uses it
> or no one cares it.
> 
> [...]

Applied, thanks!

[1/1] block: ignore RWF_HIPRI hint for sync dio
      commit: 9650b453a3d4b1b8ed4ea8bcb9b40109608d1faf

Best regards,
-- 
Jens Axboe


