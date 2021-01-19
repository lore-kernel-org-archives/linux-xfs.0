Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B55C282D3
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82F3220706
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbhASR0C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 12:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389476AbhASRRC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 12:17:02 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC43C0613C1
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jan 2021 09:16:21 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id gx5so10348689ejb.7
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jan 2021 09:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gVOq8xOh9tvYSMKp76cFsBGe5YHJ9Vg5lNq411HWSmA=;
        b=BZGbvgbM7espOkyL6HqxmA1r25Tj9IrZrF7XwFLq5AENPg/AUTYPHobPMnS56+Sfpe
         Xl48Ja1D5z+6ZL5v1j28TnTxTpGAfvp4G2U3C563xly2MloXAeOvfjfiz7pLiNAN0EVE
         7B5MFzW6Vdsnfzaz6mdSPuAJVafv6fX+TgXj4vnbxAJZicGubnDjyRI5A0TO2XL5nU96
         Vlf1FqeLi2CY4KsZGVhvqRgMqi8WBUxtkg7XQkQDtYVOEuJ1Hn90gVHHCEcLHIYdOfmj
         Jenn23xjm1qwv3pstgGI2czRwRVOZdpjuL7LI7YHDJqhIM36ZMmzYn8g1GoWVaZpAqHr
         +ftg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gVOq8xOh9tvYSMKp76cFsBGe5YHJ9Vg5lNq411HWSmA=;
        b=mi3dzuBSlRi6O8xBLTciHU98DGUwbvxddkuGgoBaoXyekESV5JlVax906oIzc49iIf
         BXzOHMA5T+RigNSubXQMn/YMjXOoltHjt21+LrCry0/5GCbI4w4CZEjRYgHKUOA6scpk
         m7qa8txtxGyU/5GLyRNBRp7sc6G1VMY4+nx/Wn72wlbWXOKhCgYTJtqEpET64OjtR1aZ
         CMlEacPdaLgLRxe/d1XDrP8eR1yS+B0QLobS4CPnb/72jea/SAfxvWykyERPl/iTHTjL
         0SkD7m6bTtp3SOz1jSWspSbJQCQ68wDkH94NuMualg6ZRQreV3d2YDlp2uaGnCsCMOBb
         dFxg==
X-Gm-Message-State: AOAM530s6jYapSwyTX5AowEI44KpydqpB2GlKPQSMAPb/sNFtITYXH+B
        RuVZ2LntovSgZSG0FnFD2OVVqP9tvtlY1Q==
X-Google-Smtp-Source: ABdhPJzbTNee+ppyeBNKIcostqSUESA1h1AKuw6XtdOiIVAtLqp584udbF5x9q+k2yqxgmAP1Bf4ZA==
X-Received: by 2002:a17:906:6d44:: with SMTP id a4mr3895737ejt.453.1611076580757;
        Tue, 19 Jan 2021 09:16:20 -0800 (PST)
Received: from [10.100.31.37] ([109.90.143.203])
        by smtp.gmail.com with ESMTPSA id c24sm10369979edt.74.2021.01.19.09.16.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 09:16:20 -0800 (PST)
Subject: Re: [PATCH v2 0/6] debian: xfsprogs package clean-up
To:     linux-xfs@vger.kernel.org, nathans@debian.org
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210116092328.2667-1-bastiangermann@fishpost.de>
 <49ecc92b-6f67-5938-af41-209a0e303e8e@sandeen.net>
 <522af0f2-8485-148f-1ec2-96576925f88e@fishpost.de>
 <e96dc035-ba4b-1a50-bc2d-fba2d3e552d8@sandeen.net>
Cc:     Eric Sandeen <sandeen@sandeen.net>
From:   Bastian Germann <bastiangermann@fishpost.de>
Message-ID: <3a1bd0e4-a4b2-5822-ed1a-d9a443b8ace7@fishpost.de>
Date:   Tue, 19 Jan 2021 18:16:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <e96dc035-ba4b-1a50-bc2d-fba2d3e552d8@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-frami
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Am 19.01.21 um 18:07 schrieb Eric Sandeen:
> On 1/19/21 9:02 AM, Bastian Germann wrote:
>> Thanks! It would be great to have a 5.10.0 version available in Debian bullseye. Currently, it has 5.6.0. The freeze is in three weeks, so to give the package time to migrate it should be uploaded in January.
> 
> It's not clear to me who you're asking to do this, but I'm
> afraid it's not my role (or my ability). :)
> 
> -Eric
> 

Nathan uploaded most of the versions, so I guess he can upload.
The Debian package is "team maintained" though with this list address as 
recorded maintainer.
