Return-Path: <SRS0=BjFQ=46=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C02CC4CECE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 18:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 456DA20716
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 18:47:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Mw+VFPC1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgCMSrf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 14:47:35 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]:36977 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbgCMSrf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Mar 2020 14:47:35 -0400
Received: by mail-qt1-f180.google.com with SMTP id l20so8435602qtp.4
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2020 11:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=mj7rGF7ON3Eo/FvVmngslw/F8fURXQu1EMn3nTTBUPQ=;
        b=Mw+VFPC1w0UbdRMWSYVpgl8XZWcn/xyU7HjgZBjymT1LdxHLk54OdU9J7RryeWrV6G
         pmCAsvxCw6XBIrR2Z5DSa9CfEeJcGKuh/zQ62J5GrmsM23BnS/TkQOWWIGVCT/cPUhnP
         mm/zvQEUeE+q3yK42lamLdvqmphm2Ot6wWUJv1CQBEctQWHl5XrvfaJBRTO78Y/uEQWX
         1l7qCdw3dlmrC8UvDgfJkqLAkCDAm4l7/mSIUZHe+CJjQxziWFJmZIyA+x8UAD/HVCqX
         kJqpDXv5yS7j0ShkpKY8fpwCpz07OokC7FALZ+xhU7HVgk00IIS+O4y9al6ahGYBMuiP
         ykgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=mj7rGF7ON3Eo/FvVmngslw/F8fURXQu1EMn3nTTBUPQ=;
        b=ZT90277yHneaOh5zNsFVCE/EfUmhCpzgRYRLrtw0xELiviFP7f9MIMnd9z/mNtO8w0
         NngB2K0XkU1UmgRMOhlNCaxL4wJz012cLxEn6+ImzFT8OPuOoD/2lhTJZi1vE5F0+YYg
         lOofjNp8mtKnI3XJjyDDmvDTCIAZfTubA8T5S5RJI/uElWPXCRfPrY7mNaIRPWW2N9Vi
         VjKBlr1E4ZczKZ9RzKkINjWQdWh7wo//qM6bWJqfWRMHjsoI34FP9L8MvwcFBtLs0kgF
         xAE9GR3vqDT/4uyrCJ9ZQz5Zb0kNn6fY/BSQAcUmzEVKeJ9mTxvWEZaMn41TIOxA3YRM
         XZ3A==
X-Gm-Message-State: ANhLgQ2UlTD3N+CDKx+B5XEalvslKse3ae2YDu36jnzm9XaxeT8cnFuw
        X+KuOP9JPc88Gsy5US04O6PWOA==
X-Google-Smtp-Source: ADFU+vt5NDaayPMUHsXSY8k4ZwE0SyPb1aBxsDRcUQaLRF+uXaXF3f1cbfLoYMcPhiB48Es6cJN9Mg==
X-Received: by 2002:aed:2202:: with SMTP id n2mr14466967qtc.4.1584125254322;
        Fri, 13 Mar 2020 11:47:34 -0700 (PDT)
Received: from [192.168.1.106] ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id w1sm14917915qkc.117.2020.03.13.11.47.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 11:47:33 -0700 (PDT)
To:     lsf-pc <lsf-pc@lists.linuxfoundation.org>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-nvme@vger.kernel.org" <linux-nvme@vger.kernel.org>
From:   Josef Bacik <josef@toxicpanda.com>
Subject: LSF/MM/BPF 2020: Postponement announcement
Message-ID: <e4f390c7-3b25-67c8-5d6d-d7e87ba1c072@toxicpanda.com>
Date:   Fri, 13 Mar 2020 14:47:32 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

Unfortunately given the escalating nature of the response to COVID-19 we are
making the decision to change the original LSF/MM/BPF dates in April 2020.  We
currently do not have concrete plans about how we will reschedule, the Linux
Foundation is working very hard at getting us alternative dates as we speak.
Once the new plans are concretely made we will notify everyone again with the
new plans.

The tentative plan is to keep the attendees as they are if we reschedule within
2020.  This includes anybody that declined for travel related concerns.  We will
re-send all invitations again to the original invitees so it's clear that you
have been invited.

If we have to reschedule into 2021 then we will redo the CFP once we are closer
to the actual date again and redo all of the invites and topics so we're as up
to date as possible with the current state of the community.

We will keep the current program committee and I will continue to chair until we
have the next LSF/MM/BPF.

Thank you on behalf of the program committee:

         Josef Bacik (Filesystems)
         Amir Goldstein (Filesystems)
         Martin K. Petersen (Storage)
         Omar Sandoval (Storage)
         Michal Hocko (MM)
         Dan Williams (MM)
         Alexei Starovoitov (BPF)
         Daniel Borkmann (BPF)
