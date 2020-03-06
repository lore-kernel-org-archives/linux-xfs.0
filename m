Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C78C10F25
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 15:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70D732084E
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 15:56:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="vrJLB0AM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgCFP4C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 10:56:02 -0500
Received: from mail-qt1-f171.google.com ([209.85.160.171]:42567 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgCFP4C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 10:56:02 -0500
Received: by mail-qt1-f171.google.com with SMTP id r6so2021437qtt.9
        for <linux-xfs@vger.kernel.org>; Fri, 06 Mar 2020 07:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ezCPULtseWvdBonQ6V0xPRaeP4ZB/PxE/0zq2zKcecE=;
        b=vrJLB0AMnGlO//iPUaQj4czq/Ymit0XSXn1kNCy8dDIfN4SAIn0VAB/1G2P2aIDpAU
         Q27jZMqu4vigDxjEMZyxINWUtIYfkl6/mAt+DeCjj4wMTZs2RV/kEGdrj66XgR5U7ES2
         wMm/c7XuXN1jlz66+O3Hn8wnQULPar1idqw7jtMSp27Zoz1C708TI1chwf9e+jI/GDFQ
         vCbYi/CLGURNzDWhNREp1p+ANBwZhR29YBXFznGQq+ABEJUoUKb6c/lAAuCEMTH/AYd1
         dHzKsl398YVeJCoLhooB/CBNL6dXtcStxFOrJ5HA0DD1cJht5EBgTz5+RJ/FijRjxZbf
         TJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ezCPULtseWvdBonQ6V0xPRaeP4ZB/PxE/0zq2zKcecE=;
        b=ZFG9TDG1BJdoFS27xxsx3N8BNL0+6BjyEdT/KIgYOQ7vWWjKEbFpTrKqo4nJerTXvA
         lr715YRkuqX9hzQEVhvhkSfpu33lpHZ8EdHsJyG+SxmpqX5dNLZARd0e7f2nxx4yhzpj
         nyOQvE9ZwbvIqiB4C0S/kVeUxKLfm5RGqZaDlDFHS7T3R4UkwKrP3JVhrd+DOGCjW6xw
         z1RQ9ccOhjpQnHHarYAVE0O+wRlbcrTGqCd4Ng6YFioZfAkfE4tXrn5GFi6+s4PxwEZ1
         HZFMZi0y7S6abL7YlPnQB/X7hgb1iEM219vDjVwdyFqbghtn9MHtfJjsUsQNs2yJzmqo
         JwfQ==
X-Gm-Message-State: ANhLgQ0TQIvBO7lY0oANHAOFIoJePqx/tQAarWlAIc+/x2AmVrax8R/3
        CPXHbPnr7N2o45bxHu1GTdyK4w==
X-Google-Smtp-Source: ADFU+vsPsQ92aQJlmertWUO6qTT3jd50HRGHtgKqPbNGPZeA9q+jXoLGczomOumHpidCeor50ODRsQ==
X-Received: by 2002:aed:2823:: with SMTP id r32mr3419004qtd.320.1583510159759;
        Fri, 06 Mar 2020 07:55:59 -0800 (PST)
Received: from [192.168.1.106] ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 4sm9421817qkl.79.2020.03.06.07.55.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 07:55:58 -0800 (PST)
Subject: Re: [LSFMMBPF TOPIC] Killing LSFMMBPF
From:   Josef Bacik <josef@toxicpanda.com>
To:     lsf-pc <lsf-pc@lists.linuxfoundation.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, bpf@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-block@vger.kernel.org
References: <b506a373-c127-b92e-9824-16e8267fc910@toxicpanda.com>
Message-ID: <94dff81a-f0bb-1f91-999b-50bf29b75f4a@toxicpanda.com>
Date:   Fri, 6 Mar 2020 10:55:57 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <b506a373-c127-b92e-9824-16e8267fc910@toxicpanda.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/6/20 9:35 AM, Josef Bacik wrote:
> Hello,
> 
> This has been a topic that I've been thinking about a lot recently, mostly 
> because of the giant amount of work that has been organizing LSFMMBPF.  I was 
> going to wait until afterwards to bring it up, hoping that maybe it was just me 
> being done with the whole process and that time would give me a different 
> perspective, but recent discussions has made it clear I'm not the only one.
> 
> LSFMMBPF is not useful to me personally, and not an optimal use of the 
> communities time.  The things that we want to get out of LSFMMBPF are (generally)

It has been pointed out to me that this appears to make it sound like I think 
the whole conference is useless.  I would like to make it clear that this is not 
the case at all.  This is still the only conference that I make sure to make it 
to every year, because all of the reasons I list.

The point of me posting this is to get us to put some real thought into what 
would be the most optimal way to accomplish the same things in a different way. 
Maybe I should have titled it "Make LSFMMBPF great again!" instead.

I feel that there is a lot of fat to trim here, and many voices not being heard 
because of the way the conference is organized.  If I'm the only one then that's 
cool, but if I'm not I'd like people to think really hard about what the ideal 
meetup looks like, and how we can move in that direction.  Thanks,

Josef
