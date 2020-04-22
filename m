Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1368AC55189
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 23:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3F2020724
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 23:14:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="roi6w8e5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgDVXO1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 19:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726401AbgDVXO0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 19:14:26 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AC8C03C1AB
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 16:14:25 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id o19so4445531qkk.5
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 16:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=yutIE/3Yrasa++aWOCa3PZNUoPlrlPERr3vYpXHco/M=;
        b=roi6w8e5qBgfrEAFnX0ITcdhSDL8WSk9M0K+Pi5JsvodaNNOas+t0Q1f3de9phX1r3
         zH9nNHarNQ5F0bPzz7BOwaRNKmtglTqtN0NM6aiRDb1o0ARGr4RLUKq2Ljipggfzmq4f
         4lue9ey15OIgipQe2SFDgP3Zg483GPNPRk1b8P8tkH8JOTSig5IAtEHFk48/ttXK/xW3
         HXoY6IUYmJ/pTBF9GpTUhyyw7weiMGNPNlwjMBnBqpgI6X0Q/tR6jaPPDUnk4ojUthH4
         sJ/35wr3LbgYPfPQAvyDm9c7nFllFe/TQ0modirFmWgoD/qWXe5K3H06giTotm5Z7P3Z
         jarQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=yutIE/3Yrasa++aWOCa3PZNUoPlrlPERr3vYpXHco/M=;
        b=nCLLl5uLTpo4hAMHWSzV/roQ61T9KvFtAWEQHR909iJa0d4cW3S0CyvC7WFyIo/j0q
         MCWd+TiBkxixw0T6Ayg1pUwBgMPFAT6+gAWXHwpyCVWBm9CpESB8QoiEx1Lu+ht75hFR
         74hS/8oT68IhSc6GC/qTdKBKkChyVQZByHRL7IIVqhPMDgxdBrubfF8MT9JSSA205Tww
         Ow+dR0s/dd9vanL2+XjswkG5+guj80BacCR0PKwIPB5Yzennjvd2xeALI58oGIgg2SAI
         d+YEsW5TkP5yRjj3IMh62TuAjbKSnUTEfm8qHuAzqgkx0Tyca04zExj8N9ri2twnxbye
         huBw==
X-Gm-Message-State: AGi0PuZ9RxKLU9x/K9pFMTOfDwomJoDrSPwoqyIEM6YD5di/DpIxFylO
        MGgtxwkYoYlgj1DHOJFmG1vPnW4QvZr4wA==
X-Google-Smtp-Source: APiQypKpwv318za6PvBDHu/CmZW2XLyq7lRBmFefrk1Y5QT6hBrl33XFhRuafmp5OdsdRdB+WGIptg==
X-Received: by 2002:a37:6415:: with SMTP id y21mr792941qkb.258.1587597263810;
        Wed, 22 Apr 2020 16:14:23 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:1102:ce0:3629:8daa:1271? ([2620:10d:c091:480::1:af35])
        by smtp.gmail.com with ESMTPSA id q6sm534297qtd.61.2020.04.22.16.14.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 16:14:23 -0700 (PDT)
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-nvme@vger.kernel.org" <linux-nvme@vger.kernel.org>
Cc:     lsf-pc <lsf-pc@lists.linuxfoundation.org>
From:   Josef Bacik <josef@toxicpanda.com>
Subject: LSFMMBPF 2020 Cancellation announcement
Message-ID: <0b6d3d6f-99de-3603-4b42-c3db5113633d@toxicpanda.com>
Date:   Wed, 22 Apr 2020 19:14:21 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Each year, we look forward to gathering at Linux Storage, Filesystem, Memory
Management, and BPF Summit to share information, collaborate, and learn
together. Due to continual assessments and growing concerns around COVID-19, we
have made the decision to cancel Linux Storage, Filesystem, Memory Management,
and BPF Summit this year. Next year the summit will be held in Palm Springs, on
May 12-14, 2021 at the Riviera Palm Springs.  A new CFP and registration will be
held again, along with a new round of invites.  The program committee will
remain the same, and next year we will choose new members.

Event Registration

The Linux Foundation will take care of canceling all event registrations - you
do not need to do anything.

We thank you for your patience and understanding while we work through this very
fluid situation. A great deal of work and preparation has gone into the
information and content planned to be delivered at LSFMMBPF and we look forward
to sharing it all with our community next year.

Thank you again for your support. Our sincere sympathies are with all those
being affected and we wish for good health and safety for all.

Thank you on behalf of the program committee:

         Josef Bacik (Filesystems)
         Amir Goldstein (Filesystems)
         Martin K. Petersen (Storage)
         Omar Sandoval (Storage)
         Michal Hocko (MM)
         Dan Williams (MM)
         Alexei Starovoitov (BPF)
         Daniel Borkmann (BPF)
