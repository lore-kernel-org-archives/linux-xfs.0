Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C4A7C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 08:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48CAA611ED
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 08:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbhG0IIA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 04:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235847AbhG0IIA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 04:08:00 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A40C061757
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 01:07:59 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so3842412pjd.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 01:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=BAW4yXW1wky2MWYcNS13Fgg5FWtpc/zGK1fpDZ5lSG4=;
        b=AMiYzYp9vGgL6RBI1fP/iO0w5s2H4JtIpRUG3vpUyCDZOv7uklTJJcGgYUN7W37pkV
         v3Rtc84pLEJKJy9vHtDZbZfgv3klHwkIQtlcmX7EptXTYswFmZDIkrRqdEYoLYzNZz8r
         OFCFgBAYvu8KAqeHgOSHp3iWYOftXCBcEmOEIoB2p7tB5WS8vHp1n1aAdmvLktOTF43V
         M9CaxZSnIAF6/r13spvHQTYLIYi5B50Kkvnp+rw3+hGNAbZNEchdhBNNMmZ+bhKoeBEj
         3BqI321RBky1uiNapJnZitB37AnaJAnwALSaJglEpq5heGez6hp7fulGbOI0wlhdzBcT
         75bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=BAW4yXW1wky2MWYcNS13Fgg5FWtpc/zGK1fpDZ5lSG4=;
        b=gJF35NY9km9wo1Wmo3YsaA6Z+3gvKl7XdVIbZJTlcmRUBUwIxvrkemOIXodUvrmWsF
         Kr+UxV6nQ2QahYIsNcHR0A7rOBwHBNqVV3mq7Yltdnj/n7t5Q/zCwyMLv+8WYPhsC7pg
         F9PNyukWQ3IsPf9I5NyFheJ16XfWKiG5HUq6HIkEqgNqxdkqUE1nyLDEhD2qz/vppjKj
         5qKk7vwan9CA2WNf8Er7FvzQrno62cAO12/Q3hotnzXONYJhZDA+yGDxTgGCyCUnShG9
         4rt2VCbcphSEpoqntFIIPC0GBwAguLYpBHGsQLyMj5uTV1HSBhdVkMdYq0+zDU05DBKD
         seRQ==
X-Gm-Message-State: AOAM532AHXP7DB/rljqj6SpWdTo/Zoy8Brb5TzRLiQ8y1mX2TZqPYdme
        keCM0GYUm20gGbvHE4On9NYJnVfSZJg=
X-Google-Smtp-Source: ABdhPJxfvWA7qSsMRejct9DQBJ8GmQDT8G0B0JJtjNpovFIir85zcs05iIq5dn3a/jpV3l2DxEcO/Q==
X-Received: by 2002:aa7:90c9:0:b029:307:49ca:dedd with SMTP id k9-20020aa790c90000b029030749cadeddmr22191479pfk.9.1627373279397;
        Tue, 27 Jul 2021 01:07:59 -0700 (PDT)
Received: from garuda ([122.171.185.191])
        by smtp.gmail.com with ESMTPSA id o2sm2700460pfp.28.2021.07.27.01.07.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Jul 2021 01:07:58 -0700 (PDT)
References: <20210726114541.24898-1-chandanrlinux@gmail.com> <20210726114541.24898-2-chandanrlinux@gmail.com> <20210726180049.GB559212@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 01/12] xfs: Move extent count limits to xfs_format.h
In-reply-to: <20210726180049.GB559212@magnolia>
Date:   Tue, 27 Jul 2021 13:37:55 +0530
Message-ID: <87eebkfack.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 Jul 2021 at 23:30, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 05:15:30PM +0530, Chandan Babu R wrote:
>> Maximum values associated with extent counters i.e. Maximum extent length,
>> Maximum data extents and Maximum xattr extents are dictated by the on-disk
>> format. Hence move these definitions over to xfs_format.h.
>>
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>  fs/xfs/libxfs/xfs_format.h | 7 +++++++
>>  fs/xfs/libxfs/xfs_types.h  | 7 -------
>>  2 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 8cd48a651b96..37cca918d2ba 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -1109,6 +1109,13 @@ enum xfs_dinode_fmt {
>>  	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
>>  	{ XFS_DINODE_FMT_UUID,		"uuid" }
>>
>> +/*
>> + * Max values for extlen, extnum, aextnum.
>> + */
>> +#define	MAXEXTLEN	((uint32_t)0x001fffff)	/* 21 bits */
>> +#define	MAXEXTNUM	((int32_t)0x7fffffff)	/* signed int */
>> +#define	MAXAEXTNUM	((int16_t)0x7fff)	/* signed short */
>
> Why do the cast types change here?  This is a simple hoist, right?

Sorry, I will restore the casts to how it was earlier. I don't remember the
exact reason for changing them. I thought I had seen some compilation
issues. But after restoring them, I see that the code compiles fine.

--
chandan
