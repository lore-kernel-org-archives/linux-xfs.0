Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDACC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 07:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A37AB60F93
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 07:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbhG1HX4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 03:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbhG1HXz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 03:23:55 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AC8C061757
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 00:23:53 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so2905328pjh.3
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 00:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=qs1Y5gO7qq8tk57/jlOw2IPJ3vVkZngDhiKa03qTJYc=;
        b=u05vM5KDA8I5rE5pEttAoj+8IrRf3ex4akoUO/NfDWSgnHopR8U2/P5lEFraGN+hST
         TtC491OMmK1ctvrhlBJMNbmHmrW4VDsY0x/ZlFQHZ1plS6hg7HMxKL3F/qiGC1SZ//8J
         EX+1HdDzlJWiS6BqqrsvY9XPyGbGjOlkTNaQNCfry7ihz7WktQCtKnR8a9PUvb0bBD6t
         saqXrF4dnZljFqe87y2daInfQ7ARyZJuSg9gFc9ZXXMqll7l5+XhzilBFlrjvv4p/kfG
         WWbsWj/hUyl6v2axaNkn6uWBHXVpM4Ggj3kYFgDCp7zKHfWxfRyJQynfWhsXkstaIh0J
         5TXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=qs1Y5gO7qq8tk57/jlOw2IPJ3vVkZngDhiKa03qTJYc=;
        b=Prw+9aVUh7Hd+TmwGyq6zvpHkFHFi1kxKLwW2lSGi4n6AVaAbS+7V7nuopKtb0lopV
         qZpq0TzUTgJyPxSl3OtYv4rzSLSz0B1kViQSYyUwuQvCJiUEj0Xb0jwTiTgWD+mSm6mS
         +dEfG15Rev6rna5o0gMyqP01CzHEIsR9fZGkyEDDLIdbPRSkU6G8ibrRXEdeJjFP+dt7
         B7sU8OuzL+YY8oKlo+wLps/pBKw4I7pb87fmL5aaa8Y0izH1iuLMt0VFhi0A2UkWHe5D
         qQHfJvzO+z1MsDLricMWR/YZGIKiJhrMKsXcEo/ci2bS3kUC4LQZ8io+9A9PohHvU5GY
         EK5A==
X-Gm-Message-State: AOAM5300E48s7ygl6VZlW+rBSm2RM2jKVQUbDzCiZ4AQTP/Wd+MDxgbf
        YIrCSE0fw4qGBDdm0UHeon2Chb2w4OGnXg==
X-Google-Smtp-Source: ABdhPJxVBAl441V5dmTn+KJr2N9A5aCxoNvU4EYCMp5mqMjq7GM73jLycGMQIVxfW/pBQfJDAcQkNg==
X-Received: by 2002:a63:4c26:: with SMTP id z38mr27505086pga.376.1627457033189;
        Wed, 28 Jul 2021 00:23:53 -0700 (PDT)
Received: from garuda ([122.171.208.125])
        by smtp.gmail.com with ESMTPSA id b18sm4890092pji.39.2021.07.28.00.23.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Jul 2021 00:23:52 -0700 (PDT)
References: <20210726114541.24898-1-chandanrlinux@gmail.com> <20210726114541.24898-13-chandanrlinux@gmail.com> <20210727231055.GV559212@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 12/12] xfs: Error tag to test if v5 bulkstat skips inodes with large extent count
In-reply-to: <20210727231055.GV559212@magnolia>
Date:   Wed, 28 Jul 2021 12:53:50 +0530
Message-ID: <8735ryx5o9.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Jul 2021 at 04:40, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 05:15:41PM +0530, Chandan Babu R wrote:
>> This commit adds a new error tag to allow user space tests to check if V5
>> bulkstat ioctl skips reporting inodes with large extent count.
>>
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>
> Keep in mind that each of these injection knobs costs us 4 bytes per
> mount.  No particular objections, but I don't know how urgently we need
> to do that to test a corner case...
>

How about using the existing error tag XFS_RANDOM_REDUCE_MAX_IEXTENTS instead
of creating a new one? XFS_RANDOM_REDUCE_MAX_IEXTENTS conveys the meaning that
we use a pseudo max data/attr fork extent count. IMHO this fits into the
bulkstat testing use case where we use a pseudo max data fork extent count.

--
chandan
