Return-Path: <SRS0=s1/4=C4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59CEFC43464
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 13:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1315920878
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 13:40:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e/5cvBBH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgISNku (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Sep 2020 09:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgISNku (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Sep 2020 09:40:50 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F16C0613CE
        for <linux-xfs@vger.kernel.org>; Sat, 19 Sep 2020 06:40:49 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id e11so8540355wme.0
        for <linux-xfs@vger.kernel.org>; Sat, 19 Sep 2020 06:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=RhZ6m/4WZXYTUsh9TErZVXB9k3rcIhBBiD3qyOUX9nc=;
        b=e/5cvBBHIRjCpu8J+mbbqNRGoDwgwD+xY95dvARR3r/7X3Exkb7V3RNTL6TTXuyQsA
         qQ6sNZyAv8c3WExIGRBYn1jlYo2TngGh08TKAuf2crDmotNo6g6brQzLb9pccfhu73KA
         PzMfULg+RCH4u4JrE7/u0cq/JK9lq2w+JKFhK2BQLOCoYPyVPDPZlI2UcvIfLX8fgtB2
         96nFKu3HLik/N5yGN7++FeV3tRP7noxmJ1wXlco/2YeGdjd63T3p50qtkL8s77cVMwJI
         Q255TuSt0kGQFyboplBXkrwpozb0I0V9Z71YmuhzowOshH4UxN/20Pif2V2WkYQabhwl
         9I1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=RhZ6m/4WZXYTUsh9TErZVXB9k3rcIhBBiD3qyOUX9nc=;
        b=G2/ltus14kS9cJjfJ1deIxADX0E/HwQrmcZf/87q87W6ZPqV81rf/Gn++Ys9k70lrO
         gOb0ACdpcEgnVKMBKABeWj+zia9QfMQHgDE+WtNIc0xtajJLZZZXgAtUPfRSCLgo57QL
         AOD0rEHK6gtK/S3xCwjtsiVbj9fGm60xUUiaIrgWS4VJY57nsOVxp8uzxAZ/3MgnInkF
         WXHSYMZs/B5+khahn7gHfPKdA1mdHw/56+KWX3fQEkvZ5HjNQS8biS6zqcj5P54Y41+G
         QZ088hC3EcKdctb5ydxhDjp6aMex3ibTW8aSNnVD5uDk0H4BNVrjKPC4LOO4tAfy4LTT
         A8kw==
X-Gm-Message-State: AOAM533WMNe3joV2v5i76Xn6Nh5rbu8NnrFw4OtBR2YH8SLKzz6Xa5Xw
        PJCEYRoKQUbX8A9JEdTZZ5hYfxC1InW4Qw==
X-Google-Smtp-Source: ABdhPJz1DkfwgnVXGPxZg2jWEdZFL3AO/+HyXtP3vmQCQaA47tBQkso40S20Wn0U8JAg0xtWO06Yzw==
X-Received: by 2002:a1c:dec2:: with SMTP id v185mr20371386wmg.1.1600522847219;
        Sat, 19 Sep 2020 06:40:47 -0700 (PDT)
Received: from [192.168.1.2] (static-76-13-27-46.ipcom.comunitel.net. [46.27.13.76])
        by smtp.gmail.com with ESMTPSA id k8sm11635817wma.16.2020.09.19.06.40.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 06:40:46 -0700 (PDT)
To:     linux-xfs@vger.kernel.org
From:   nitsuga5124 <nitsuga5124@gmail.com>
Subject: XFS Disk Repair failing with err 117 (Help Recovering Data)
Message-ID: <2f7bfe5c-13c9-4c12-3c0a-2c1752709749@gmail.com>
Date:   Sat, 19 Sep 2020 15:40:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

First of all, i want to say that i think this is not a hardware issue, 
the hard drive sounds fine and it didn't show any signs of slowness, 
it's also not very old, got it the 10th of January.

The entire disk is behind luks encryption:
```
#lsblk
sdc         8:32   0   3.6T  0 disk
└─storage 254:1    0   3.6T  0 crypt
```

Recently i've been having some issues where the drive suddenly becomes 
unreadable (seems to be caused by kited) but all of the times it 
happened, using `xfs_repair` with the following syntax `sudo xfs_repair 
/dev/mapper/storage -v`; made the drive readable again, but this time i 
didn't have this luck, and the drive was unable to be repaired, leading 
to this error at the end:

```
Phase 6 - check inode connectivity...
         - resetting contents of realtime bitmap and summary inodes
         - traversing filesystem ...
         - agno = 0
bad hash table for directory inode 128 (no data entry): rebuilding
rebuilding directory inode 128
Invalid inode number 0x0
Metadata corruption detected at 0x56135ef283e8, inode 0x84 data fork

fatal error -- couldn't map inode 132, err = 117
```

I ran `xfs_db` to see what was happening on that inode:
`sudo xfs_db -x -c 'blockget inode 132' /dev/mapper/storage > xfs_db.log`
and this are the outputs:

- stderr:
```
Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 
0x1b275ab8/0x1000
Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 
0x1b2d32e0/0x1000
Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 
0x1b338de0/0x1000
Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 
0x1b38ead0/0x1000
Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 
0x1b3e9750/0x1000
Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 
0x1b4383b0/0x1000
Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 
0x1b47c868/0x1000
Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 
0x1b547748/0x1000
Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 
0x1b619828/0x1000
Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 
0x1b63b9d8/0x1000
Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 
0x1b687f38/0x1000
Metadata CRC error detected at 0x557ecac7bc85, xfs_cntbt block 
0x1b8d1230/0x1000
Metadata CRC error detected at 0x557ecac7bc85, xfs_cntbt block 
0x1b8d1290/0x1000
Metadata corruption detected at 0x557ecacb369b, xfs_refcountbt block 
0x1b227dd8/0x1000
Metadata corruption detected at 0x557ecacb0600, xfs_inobt block 
0x1afb5e68/0x1000
Metadata corruption detected at 0x557ecacb0600, xfs_finobt block 
0x1afe9ef0/0x1000
Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 
0x8b928790/0x1000
Metadata corruption detected at 0x557ecacb369b, xfs_refcountbt block 
0x8b928780/0x1000
Metadata corruption detected at 0x557ecacb0600, xfs_inobt block 
0x8b928310/0x1000
Metadata corruption detected at 0x557ecacb0600, xfs_finobt block 
0x8b928468/0x1000
Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 
0x11660d9e8/0x1000
Metadata corruption detected at 0x557ecacb369b, xfs_refcountbt block 
0x1166000a0/0x1000
Metadata corruption detected at 0x557ecacb0600, xfs_inobt block 
0x116531ea8/0x1000
Metadata corruption detected at 0x557ecacb0600, xfs_finobt block 
0x116531ed0/0x1000
Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 
0x176489440/0x1000
Metadata corruption detected at 0x557ecacb369b, xfs_refcountbt block 
0x17603e178/0x1000
Metadata corruption detected at 0x557ecacb0600, xfs_inobt block 
0x1760313d0/0x1000
Metadata corruption detected at 0x557ecacb0600, xfs_finobt block 
0x176031920/0x1000
```

- stdout:
It's a 14GB file, i will not send it.

Help trying to recover the data (move it to another drive) would be great.
ideally i would fix the error, and i would move the data to another 
drive, shrink the partition, make a new partition with EXT4 instead of 
XFS, and move the data to the new partition, shrink, expand, and keep 
doing that until everything is moved to EXT4 or some other file system, 
or XFS again without whole drive encryption; i think this issues are 
occurring because using luks on XFS is not a common thing, so it's 
probably untested and unstable.

http://xfs.9218.n7.nabble.com/Assert-in-xfs-repair-Phase-7-and-other-xfs-restore-problems-td33368.html 


I have found a possible solution for this problem in this mailing list.
The solution looks to be to clear the corrupted inode (132)
but i'm unable to find a way to do this while the drive is unmounted. Is 
this possible? if so, how?

https://forums.unraid.net/topic/66749-xfs-file-system-corruption-safest-way-to-fix/

I have also found this post on the unraid forums about the same error, 
(where i also found this email address), and the solution was the use a 
way older version of xfs_repair, but sadly that solution didn't work 
(probably because it's way too old?); Can you also confirm that the 
issue is fixed on xfs_repair xfs_repair version 5.8.0?
