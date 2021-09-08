Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C19C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Sep 2021 08:16:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CA0B61041
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Sep 2021 08:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347922AbhIHIRR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Sep 2021 04:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbhIHIRL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Sep 2021 04:17:11 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40362C061575
        for <linux-xfs@vger.kernel.org>; Wed,  8 Sep 2021 01:16:03 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id k5-20020a05600c1c8500b002f76c42214bso864693wms.3
        for <linux-xfs@vger.kernel.org>; Wed, 08 Sep 2021 01:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=momtchev.com; s=google;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=orlKRtjpadQuCvU2NUZqpnLDrmhMWsv4+duGuxVAf6E=;
        b=GhYZTrF4Bf3rFBvlBhudRhRbTeZvNb3dBFK9wKRg6b4oo9bu9Aofmcdjb6yKwvjDdI
         CI2JZHKFN8T7F0AIjOuRliy0mMkUJtsxY5ni3owp3H+6pcVvw8TvJJqQLuTS6hNLv8iv
         d8p1hpDas4okd5W1ESWjGh42YtHhJELZ73ln0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=orlKRtjpadQuCvU2NUZqpnLDrmhMWsv4+duGuxVAf6E=;
        b=d2F3jU6HskWFmYuiiXZJYzxXUXNqUSi21VB6fY2O9A3xjjCrRnX0e8/BUWfsC8Q5Z3
         jNh1S2iI0rPCzKb4wUrZX8duUzJQGwt162yE/07RaVldnQBe/0nxRGhxE21Vct6jwlCy
         mDFB5le7ExSu/aGfSyDeRQuoFFBGK8vkHwDtcIRbTsM29tDGPSWlKPRZB/v84NUXRqpe
         XqKFtzrT2JA1Iz7vOFC/Dx36Ez9qSDlfk0u9EC4lSh8g4/dtMJE1PlH5OgBE6nlxwD/P
         eOf0rYif5LMJugq3vQiQAw6tY+UGzUatgxexCAmH+kR9UB7W9VIm21HBm4B5Se1CmRL2
         dABw==
X-Gm-Message-State: AOAM531tDS8fneN2lwY2XEFjnM/Rieg+lYIJneunLLnA2dL3PkNJvYyK
        QsF2nhpZIuw967JgW7WDX9JUjwvXMUd2mw==
X-Google-Smtp-Source: ABdhPJzImg/sJA7HkvK4RHGQkVHunOjfLmPWjS0btbX/NwW8oJ52/ocFDhhSfbQojYY+Y3p/lgh+2A==
X-Received: by 2002:a7b:c08d:: with SMTP id r13mr2285723wmh.186.1631088961407;
        Wed, 08 Sep 2021 01:16:01 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ecbf:5251:cfd2:ca90:c88c:1bfa? ([2a01:e34:ecbf:5251:cfd2:ca90:c88c:1bfa])
        by smtp.gmail.com with ESMTPSA id m184sm1380717wmm.3.2021.09.08.01.16.00
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 01:16:00 -0700 (PDT)
To:     linux-xfs@vger.kernel.org
From:   Momtchil Momtchev <momtchil@momtchev.com>
Subject: heavy xfsaild I/O blocking process exit
Message-ID: <b0537b9a-d2f8-9288-b631-5bf67488d930@momtchev.com>
Date:   Wed, 8 Sep 2021 10:15:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Hello,


I have a puzzling problem with XFS on Debian 10. I am running 
number-crunching driven by Node.js - I have a process that creates about 
2 million 1MB to 5MB files per day with an about 24h lifespan (weather 
forecasting). The file system is obviously heavily fragmented. I have 
absolutely no problems when running this in cruise mode, but every time 
I decide to stop that process, especially when it has been running for a 
few weeks or months, the process will become a zombie (freeing all its 
user memory and file descriptors) and then xfsaild/kworker will continue 
flushing the log for about 30-45 minutes before the process really 
quits. It will keep its binds to network ports (which is my main 
problem) but the system will remain responsive and usable. The I/O 
pattern is several seconds of random reading then a second or two of 
sequential writing.

The kernel functions that are running in the zombie process context are 
mainly xfs_btree_lookup, xfs_log_commit_cil, xfs_next_bit, 
xfs_buf_find_isra.26

xfsaild is spending time in radix_tree_next_chunk, xfs_inode_buf_verify

kworker is in xfs_reclaim_inode, radix_tree_next_chunk



This is on (standard up-to date Debian 10):

Linux version 4.19.0-16-amd64 (debian-kernel@lists.debian.org) (gcc 
version 8.3.0 (Debian 8.3.0-6)) #1 SMP Debian 4.19.181-1 (2021-03-19)

xfs_progs 4.20.0-1



File system is RAID-0, 2x2TB disks with LVM over md (512k chunks)

meta-data=/dev/mapper/vg0-home   isize=512    agcount=32, 
agsize=29849728 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=0
          =                       reflink=0
data     =                       bsize=4096   blocks=955191296, imaxpct=5
          =                       sunit=128    swidth=256 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=466402, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


MemTotal:       32800968 kB
MemFree:          759308 kB
MemAvailable:   27941208 kB
Buffers:           43900 kB
Cached:         26504332 kB
SwapCached:         7560 kB
Active:         16101380 kB
Inactive:       11488252 kB
Active(anon):     813424 kB
Inactive(anon):   228180 kB
Active(file):   15287956 kB
Inactive(file): 11260072 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:      16777212 kB
SwapFree:       16715524 kB
Dirty:              2228 kB
Writeback:             0 kB
AnonPages:       1034280 kB
Mapped:            89660 kB
Shmem:               188 kB
Slab:            1508868 kB
SReclaimable:    1097804 kB
SUnreclaim:       411064 kB
KernelStack:        3792 kB
PageTables:         5872 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    33177696 kB
Committed_AS:    1394296 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
Percpu:             7776 kB
HardwareCorrupted:     0 kB
AnonHugePages:    215040 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:               0 kB
DirectMap4k:    11682188 kB
DirectMap2M:    21731328 kB
DirectMap1G:     1048576 kB


-- 
Momtchil Momtchev <momtchil@momtchev.com>

