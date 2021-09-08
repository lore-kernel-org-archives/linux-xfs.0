Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAA7C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Sep 2021 14:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CF6460EFE
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Sep 2021 14:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349323AbhIHOhI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Sep 2021 10:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349338AbhIHOhI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Sep 2021 10:37:08 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48913C061575
        for <linux-xfs@vger.kernel.org>; Wed,  8 Sep 2021 07:36:00 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id x5so1983879qtq.13
        for <linux-xfs@vger.kernel.org>; Wed, 08 Sep 2021 07:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yakkadesign-com.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=j2SSw7LGl6IVXp84SFGCdQy47gJixzVB84rzXR3Q4YQ=;
        b=sJ9Zndo/kNVfheRwt3CgHzGRlZPCfjJKB1/TiODyt3Jk33PvlxcgLsnAQGZ7kEPKOM
         kmIbfHKNFrFTIAFKFY0VALDyY4OsQQY9kG6IuXcI96uXir108rNll59YR2+cUsZRoHUX
         HBhoSmEJ1JeNZH8zTS6Kk+UEeBjW0stIgLv9OVaMdaj2pJOz8mBWhbaOBgf3ZIQ6bZo4
         kMFrduLd97FeE1N1XM36LiAsbXBg6vlo9boxS83Yeg5LU2fgAf5TYxkJUmxh8Pj+eIJe
         gAdB/ULv6vN/sS4Bo/ZNnvGpnxbXkz75FRM4WtHxrIxxv59G9Fybau/ftZbA1VYmTPkP
         fUwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=j2SSw7LGl6IVXp84SFGCdQy47gJixzVB84rzXR3Q4YQ=;
        b=XlSsecTgMI3a8rMhTWBoG8cACFGQI4FTE+t0zkstpIowFiwAjOf6OWzxxX7crp3t60
         lPDkdt2jiDeHbCw2adp5okThMHXrq0fM0sDizr3jJSF4YYbCktHZISySN1tRyiemiQZp
         H6rrTZ2aEu9KxNMNDCUTT1Z2Xv1t+Qy0m19+zG5VTyX45iXSN+csHGJ5WI6+ww+a3Vp4
         WqNDIVCpcuoOCZO5BtAlEsrEBSOaJO0afDB1jlTbnaefmbLZW6VcUkS7OMWqiFTARI4V
         WC6UB/md7JfsX/5iMIlslSqxluhkZW0ZObIVUrTTAtjf4lYZMGb5Ke9uD4PPWPjiHfmX
         jEjw==
X-Gm-Message-State: AOAM530IlWJNDemWKQpxIFfEEVk743TxOsdHUZpMvDa7WGR+cvqcxOK9
        IW6DK5MOwYIv8xI/BwuN/gdl30i9t/Allroxsvc=
X-Google-Smtp-Source: ABdhPJx/7mygL/MDkgoASj8rOX2U7X128Jl4N9vAOmMX7oW4zaR+/7jJFMm2S3PJWoWWZ01slEdw8A==
X-Received: by 2002:ac8:57cc:: with SMTP id w12mr4003046qta.239.1631111759270;
        Wed, 08 Sep 2021 07:35:59 -0700 (PDT)
Received: from ?IPv6:2602:306:bc57:e350:5a91:cfff:fe5a:fe83? ([2602:306:bc57:e350:5a91:cfff:fe5a:fe83])
        by smtp.googlemail.com with ESMTPSA id b5sm1641365qtr.11.2021.09.08.07.35.58
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Sep 2021 07:35:58 -0700 (PDT)
To:     linux-xfs@vger.kernel.org
From:   brian <a001@yakkadesign.com>
Subject: Repair Metadata corruption detected at xfs_inode_buf_verify on CentOS
 7 virtual machine
Message-ID: <055dbf6e-a9b5-08a1-43bc-59f93e77f67d@yakkadesign.com>
Date:   Wed, 8 Sep 2021 10:35:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I have CentOS 7 Virtualbox virtual machine (VM) that gives the following 
error on boot(removed parts replaced with …)
----------------------------------------------------------------------------
XFS (dm-2): Metadata corruption detected at xfs_inode_buf_verify...
XFS (dm-2): unmount and run xfs_repair
XFS (dm-2): First 128 bytes of corrupted metadata buffer:
…
XFS (dm-2): metadata I/O error in “xlog_recov_do..(read#2)” at daddr 
0x1b32 error 117
----------------------------------------------------------------------------

I tried entered emergency mode, entered password and tried:
     xfs_repair -L /dev/mapper/centos-root

But I got the error:
     /dev/mapper/centos-root contains a mounted filesystem
     /dev/mapper/centos-root contains a mounted and writable filesystem

Next I booted from the Centos ISO then went
       troubleshooting → Rescue a CentOS system  → 1) Continue

This fails.  I get lines of = marks.  When I left overnight, I had a 
blank screen.  When I ALT+Tab to program-log and then back to main, I 
got a screen of scrolling errors.

I nightly backup my data including this VM with rsync to a USB drive.  
My last backup was while the VM was running.  In Virtualbox and on my 
computers drive, I deleted the VM using the virtualbox GUI.  I thought 
this would move the VM to the trash but it permanently deleted the VM.  
The problem I'm having is with the backup VM from my USB drive.

How should I troubleshoot and fix this problem?  My main goal is to get 
my data off the VM.  I also unsuccessful with mounting the .vdi file in 
another computer.


