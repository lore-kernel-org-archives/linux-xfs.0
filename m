Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6297BC19F29
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jul 2022 19:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbiG0TV4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 15:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237035AbiG0TVe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jul 2022 15:21:34 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861C4F7;
        Wed, 27 Jul 2022 12:17:59 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id 125so17479058vsd.5;
        Wed, 27 Jul 2022 12:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wh3tGYCUekH92S+gVrqkqJs8hyPO/UIvaPBUvUI5Dtk=;
        b=Ln57ga72dnSFYrjOHWn/8qdf1LYRnI1BCF/xRgAuuQyWPwx+LMAktpekR9dR/c+jIL
         aG2IwpwuoQS2uTyHbAfRd4tPk8/MMJNeG9tm+/dwg4zKxYs5VXDqCCGuTKuSRmbQmFEP
         CMLfqiJyuasTWKY1p/ufwipMbcEHf+yTWkrAjUDmfDXkI9qQ3APjUjaqYAzsI7xxbh8O
         2mDTfhK7WIkLR+eyYp86FV3fZoMt1AF1iWc+9Y40rMLXz6UfTCwYOhuzoKvQZESwC/vH
         TzVyeAHJ9EiizvPeuePxiH+PZVrvaRPpzIfjnfnMD8xnjwjSAKmdi96EvTTc04KaeOCc
         UlSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wh3tGYCUekH92S+gVrqkqJs8hyPO/UIvaPBUvUI5Dtk=;
        b=OEcEQ26sgUEuwfmA8I+ls/Sl5VPxZYqF7rSXJQFOrlVteb6XNQN8D7ExlFHK6DKbP5
         7XFb3SDXg7IsuwASL2YXt48MVm+LC757XyiS+cOxsFs7xGayipwwrWz9zB0w1mrsDEDc
         Mi9Nhp+BxzpA7nLnARC+ChpvilOonnnBVMj0b7L/CMvROmMv4fb2XlYWVxX6mmgFb98Y
         qaaoMb73o2rE/bjeTxbe5QjhpyXDCnbQ6i1YV8wuu4b5ej2wEkhhNkx9Y+6gyxcJzXED
         2a3ZJK7KPbFWCAQwrOOhQfiP6eSAmh9OT9HmeB+8gznURcR/N/8+DCuUiEIMiBXe2IFX
         ls5g==
X-Gm-Message-State: AJIora8pU/R8pW3amG6mFnD8kURPY5zqbUclpVB0ZCsiOQsV4yF64dl/
        4YMo5R0FXlRQa0o2e4YMzpse3BCW2rjKP4y3UwI=
X-Google-Smtp-Source: AGRyM1saPHMqHXsc9NyJjnZtSvf9Esn1PLKdJMFZPFC1THlgoWUhWRtoGiMlDpgF+pPxp/RxyOfC4mNv+h3mMpDk9go=
X-Received: by 2002:a67:c107:0:b0:358:7511:4e5b with SMTP id
 d7-20020a67c107000000b0035875114e5bmr3482533vsj.3.1658949478556; Wed, 27 Jul
 2022 12:17:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220726092125.3899077-1-amir73il@gmail.com>
In-Reply-To: <20220726092125.3899077-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 27 Jul 2022 21:17:47 +0200
Message-ID: <CAOQ4uxi=VYa+86A7G3wqCX84n2Aezx2mYqfYrFTAVtSpYmeq_Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 0/9] xfs stable candidate patches for
 5.10.y (from v5.13+)
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 26, 2022 at 11:21 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Darrick,
>
> This backport series contains mostly fixes from v5.14 release along
> with three deferred patches from the joint 5.10/5.15 series [1].
>
> I ran the auto group 10 times on baseline (v5.10.131) and this series
> with no observed regressions.
>
> I ran the recoveryloop group 100 times with no observed regressions.
> The soak group run is in progress (10+) with no observed regressions
> so far.
>
> I am somewhat disappointed from not seeing any improvement in the
> results of the recoveryloop tests comapred to baseline.
>
> This is the summary of the recoveryloop test results on both baseline
> and backport branch:
>
> generic,455, generic/457, generic/646: pass
> generic/019, generic/475, generic/648: failing often in all config
> generic/388: failing often with reflink_1024
> generic/388: failing at ~1/50 rate for any config
> generic/482: failing often on V4 configs
> generic/482: failing at ~1/100 rate for V5 configs
> xfs/057: failing at ~1/200 rate for any config
>
> I observed no failures in soak group so far neither on baseline nor
> on backport branch. I will update when I have more results.
>

Some more results after 1.5 days of spinning:
1. soak group reached 100 runs (x5 configs) with no failures
2. Ran all the tests also on debian/testing with xfsprogs 5.18 and
    observed a very similar fail/pass pattern as with xfsprogs 5.10
3. Started to run the 3 passing recoveryloop tests 1000 times and
    an interesting pattern emerged -

generic/455 failed 3 times on baseline (out of 250 runs x 5 configs),
but if has not failed on backport branch yet (700 runs x 5 configs).

And it's not just failures, it's proper data corruptions, e.g.
"testfile2.mark1 md5sum mismatched" (and not always on mark1)

I will keep this loop spinning, but I am cautiously optimistic about
this being an actual proof of bug fix.

If these results don't change, I would be happy to get an ACK for the
series so I can post it after the long soaking.

Thanks,
Amir.
