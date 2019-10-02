Return-Path: <SRS0=zZKn=X3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A57FC352AA
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Oct 2019 06:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD0ED2086A
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Oct 2019 06:00:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z8YHTWcR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfJBGA0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Oct 2019 02:00:26 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44777 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfJBGAZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Oct 2019 02:00:25 -0400
Received: by mail-lj1-f193.google.com with SMTP id m13so15749106ljj.11
        for <linux-xfs@vger.kernel.org>; Tue, 01 Oct 2019 23:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2VurSUdG2EXKgPGzilz3cdb0KfeZZ/7y8Vl2lbYCSQ4=;
        b=Z8YHTWcRyE/7ROu392MQ6iHXnlnwX5k8RU3XjazkGyvznx7rlfeT99qREzayY+kAg2
         mzQspkWk0IzWlB+NOj6tiQdhypQoQQF7k0XbmO+ApJtybpw+xkARm2vzCoYzg3iqJPFE
         GnXvlcL0QXVv7mK3RRapEAjVLyK/GXsgXItp0Em9qmBEiFOQGtpDIkkMOwDeMqiagPuJ
         k7TMhZXgZQ4WFLeh9V6//lZFeR/cVPHoUqRnlGAJGzai6X3tqb167J+e4GheJlDlVXLo
         Ce67rP3XTfWgbX/2cbsyom8CUo6JxtVkuf6yO6woTPgEGs3XeY/yACxVvZGr5ifYjWWP
         7cqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2VurSUdG2EXKgPGzilz3cdb0KfeZZ/7y8Vl2lbYCSQ4=;
        b=doKcBqBGjvDkd5mXqnMyS7BJJYlfSLV9CdFRW4+yTPTZOCI8llviHsJutx5AFLN0Pk
         pR2dUwVMcY5bzu28ffNe3MXaRTQdaM7/aXdeW/gHMH9oCcVOwhMAzJUxbK+nHPr9Hnmx
         DK4Hao1EYOxC4YnpkRhdwmARooOPRnvhc3Xxyd6FkK6PcMP15netGDFA5fmErdhW84CF
         8VyUCzWZl5IxK4YbwLGGu8qBBdXzYjhqKhA97oZ3e0CMUGyFPKQrsRvbrAdNIpNWU5Qa
         aK14PMM3G648GcyD3bxJ6YmNtElvUJiABwkbvOHfySpK56bG9hOkPZ5NqthCXlRMEr5A
         LCMQ==
X-Gm-Message-State: APjAAAX/5Fj/jtJJvzuUEEeykmhWPJWF+vVBT2Mg4lDC6thyT9oxDoni
        0dY1dRBZtgzdXOa6CZtr4uooUxQn
X-Google-Smtp-Source: APXvYqwF7KdBsh/Yt06mmRPMvX1Qv6ZFzTgxj1/pzR8a2JunlXoxctqOV0VknjPQcS10fxtq0IxQ8Q==
X-Received: by 2002:a2e:9b4f:: with SMTP id o15mr1101196ljj.142.1569996023165;
        Tue, 01 Oct 2019 23:00:23 -0700 (PDT)
Received: from amb.local (out244.support.agnat.pl. [91.234.176.244])
        by smtp.gmail.com with ESMTPSA id k23sm4506759ljc.13.2019.10.01.23.00.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2019 23:00:22 -0700 (PDT)
Subject: Re: [PATCH 04/10] libxfs: retain ifork_ops when flushing inode
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
 <155594791533.115924.7540619376750686973.stgit@magnolia>
From:   =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Message-ID: <585e5cf7-5800-20ae-118e-96386ccd5902@gmail.com>
Date:   Wed, 2 Oct 2019 08:00:21 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <155594791533.115924.7540619376750686973.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 22/04/2019 17:45, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Retain the ifork ops used to validate the inode so that we can use the
> same one to iflush it.  xfs_repair phase 6 can use multiple transactions
> to fix various inode problems, which means that the inode might not be
> fully fixed when each transaction commits.
> 
> This can be a particular problem if there's a shortform directory with
> both invalid directory entries and incorrect i8count.  Phase 3 will set
> the parent inode to "0" to signal to phase 6 that it needs to reset the
> parent and i8count, but phase 6 starts a transaction to junk the bad
> entries which fail to commit because the parent is invalid:
> 
> fixing i8count in inode 69022994673
> Invalid inode number 0x0
> xfs_dir_ino_validate: XFS_ERROR_REPORT
> Metadata corruption detected at 0x464eb0, inode 0x10121750f1 data fork
> xfs_repair: warning - iflush_int failed (-117)
> 
> And thus the inode fixes never get written out.


I just hit something similar again. xfsprogs from current for-next
(b94a69ac being latest commit in it)

[...]
bogus .. inode number (0) in directory inode 36510278809, clearing inode
number
[...]
entry "langs" in dir ino 34365014856 doesn't have a .. entry, will set
it in ino 36510278809.
[...]
setting .. in sf dir inode 36510278809 to 34365014856
Metadata corruption detected at 0x460e1c, inode 0x8802ea499 data fork
xfs_repair: warning - iflush_int failed (-117)
[...]
Phase 7 - verify and correct link counts...
Invalid inode number 0x0
xfs_dir_ino_validate: XFS_ERROR_REPORT
Metadata corruption detected at 0x460da8, inode 0x8802ea499 data fork

fatal error -- couldn't map inode 36510278809, err = 117


Full log output below:

> # /tmp/qq/sbin/xfs_repair -vvv -o bhash=256000 /dev/sdd1
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - zero log...
> zero_log: head block 3022391 tail block 3022391
>         - scan filesystem freespace and inode maps...
>         - 14:26:44: scanning filesystem freespace - 39 of 39 allocation groups done
>         - found root inode chunk
> libxfs_bcache: 0xdb0900
> Max supported entries = 2048000
> Max utilized entries = 40516
> Active entries = 40516
> Hash table size = 256000
> Hits = 0
> Misses = 40517
> Hit ratio =  0.00
> MRU 0 entries =  40516 (100%)
> MRU 1 entries =      0 (  0%)
> MRU 2 entries =      0 (  0%)
> MRU 3 entries =      0 (  0%)
> MRU 4 entries =      0 (  0%)
> MRU 5 entries =      0 (  0%)
> MRU 6 entries =      0 (  0%)
> MRU 7 entries =      0 (  0%)
> MRU 8 entries =      0 (  0%)
> MRU 9 entries =      0 (  0%)
> MRU 10 entries =      0 (  0%)
> MRU 11 entries =      0 (  0%)
> MRU 12 entries =      0 (  0%)
> MRU 13 entries =      0 (  0%)
> MRU 14 entries =      0 (  0%)
> MRU 15 entries =      0 (  0%)
> Dirty MRU 16 entries =      0 (  0%)
> Hash buckets with   0 entries 218473 (  0%)
> Hash buckets with   1 entries  34691 ( 85%)
> Hash buckets with   2 entries   2690 ( 13%)
> Hash buckets with   3 entries    139 (  1%)
> Hash buckets with   4 entries      7 (  0%)
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - 14:26:44: scanning agi unlinked lists - 39 of 39 allocation groups done
>         - process known inodes and perform inode discovery...
>         - agno = 15
>         - agno = 0
>         - agno = 30
>         - agno = 16
>         - agno = 31
>         - agno = 1
>         - agno = 17
>         - agno = 32
> bogus .. inode number (0) in directory inode 36510278809, clearing inode number
> bogus .. inode number (0) in directory inode 36512379414, clearing inode number
>         - agno = 18
>         - agno = 19
>         - agno = 33
>         - agno = 20
>         - agno = 34
>         - agno = 21
>         - agno = 35
>         - agno = 2
>         - agno = 22
>         - agno = 36
>         - agno = 23
>         - agno = 37
>         - agno = 24
>         - agno = 3
>         - agno = 38
>         - agno = 25
>         - agno = 4
>         - agno = 26
>         - agno = 5
>         - agno = 27
>         - agno = 6
>         - agno = 28
>         - agno = 7
>         - agno = 29
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - 17:27:19: process known inodes and inode discovery - 173158784 of 173158784 inodes done
>         - process newly discovered inodes...
>         - 17:27:19: process newly discovered inodes - 39 of 39 allocation groups done
> libxfs_bcache: 0xdb0900
> Max supported entries = 2048000
> Max utilized entries = 2048000
> Active entries = 2047963
> Hash table size = 256000
> Hits = 33258462
> Misses = 39986202
> Hit ratio = 45.41
> MRU 0 entries =  21826 (  1%)
> MRU 1 entries =      0 (  0%)
> MRU 2 entries =  43908 (  2%)
> MRU 3 entries = 218917 ( 10%)
> MRU 4 entries =  17304 (  0%)
> MRU 5 entries =  45429 (  2%)
> MRU 6 entries = 1097133 ( 53%)
> MRU 7 entries =  68828 (  3%)
> MRU 8 entries =      0 (  0%)
> MRU 9 entries =      0 (  0%)
> MRU 10 entries =      0 (  0%)
> MRU 11 entries = 318994 ( 15%)
> MRU 12 entries = 104225 (  5%)
> MRU 13 entries = 110173 (  5%)
> MRU 14 entries =   1226 (  0%)
> MRU 15 entries =      0 (  0%)
> Dirty MRU 16 entries =      0 (  0%)
> Hash buckets with   0 entries     75 (  0%)
> Hash buckets with   1 entries    669 (  0%)
> Hash buckets with   2 entries   2673 (  0%)
> Hash buckets with   3 entries   7083 (  1%)
> Hash buckets with   4 entries  14564 (  2%)
> Hash buckets with   5 entries  23510 (  5%)
> Hash buckets with   6 entries  31292 (  9%)
> Hash buckets with   7 entries  35847 ( 12%)
> Hash buckets with   8 entries  35808 ( 13%)
> Hash buckets with   9 entries  32245 ( 14%)
> Hash buckets with  10 entries  25460 ( 12%)
> Hash buckets with  11 entries  18399 (  9%)
> Hash buckets with  12 entries  12437 (  7%)
> Hash buckets with  13 entries   7502 (  4%)
> Hash buckets with  14 entries   4257 (  2%)
> Hash buckets with  15 entries   2172 (  1%)
> Hash buckets with  16 entries   1114 (  0%)
> Hash buckets with  17 entries    542 (  0%)
> Hash buckets with  18 entries    200 (  0%)
> Hash buckets with  19 entries     88 (  0%)
> Hash buckets with  20 entries     39 (  0%)
> Hash buckets with  21 entries     14 (  0%)
> Hash buckets with  22 entries      8 (  0%)
> Hash buckets with  23 entries      2 (  0%)
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - 17:27:21: setting up duplicate extent list - 39 of 39 allocation groups done
>         - check for inodes claiming duplicate blocks...
>         - agno = 30
>         - agno = 15
>         - agno = 0
>         - agno = 16
>         - agno = 1
>         - agno = 31
>         - agno = 17
> bogus .. inode number (0) in directory inode 36510278809, clearing inode number
> bogus .. inode number (0) in directory inode 36512379414, clearing inode number
>         - agno = 18
>         - agno = 32
>         - agno = 19
>         - agno = 20
>         - agno = 33
>         - agno = 21
>         - agno = 34
>         - agno = 22
>         - agno = 35
>         - agno = 23
>         - agno = 36
>         - agno = 2
>         - agno = 37
>         - agno = 24
>         - agno = 25
>         - agno = 38
>         - agno = 26
>         - agno = 27
>         - agno = 28
>         - agno = 3
>         - agno = 29
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - 20:44:23: check for inodes claiming duplicate blocks - 173158784 of 173158784 inodes done
> libxfs_bcache: 0xdb0900
> Max supported entries = 2048000
> Max utilized entries = 2048000
> Active entries = 2047999
> Hash table size = 256000
> Hits = 64756246
> Misses = 82886582
> Hit ratio = 43.86
> MRU 0 entries =  19324 (  0%)
> MRU 1 entries =      0 (  0%)
> MRU 2 entries =  47524 (  2%)
> MRU 3 entries = 217973 ( 10%)
> MRU 4 entries =  16829 (  0%)
> MRU 5 entries =  45729 (  2%)
> MRU 6 entries = 1071173 ( 52%)
> MRU 7 entries =      0 (  0%)
> MRU 8 entries =      0 (  0%)
> MRU 9 entries =      0 (  0%)
> MRU 10 entries =      0 (  0%)
> MRU 11 entries = 400426 ( 19%)
> MRU 12 entries =  97317 (  4%)
> MRU 13 entries = 130545 (  6%)
> MRU 14 entries =   1159 (  0%)
> MRU 15 entries =      0 (  0%)
> Dirty MRU 16 entries =      0 (  0%)
> Hash buckets with   0 entries     73 (  0%)
> Hash buckets with   1 entries    664 (  0%)
> Hash buckets with   2 entries   2642 (  0%)
> Hash buckets with   3 entries   7175 (  1%)
> Hash buckets with   4 entries  14586 (  2%)
> Hash buckets with   5 entries  23505 (  5%)
> Hash buckets with   6 entries  31069 (  9%)
> Hash buckets with   7 entries  35990 ( 12%)
> Hash buckets with   8 entries  36151 ( 14%)
> Hash buckets with   9 entries  31999 ( 14%)
> Hash buckets with  10 entries  25381 ( 12%)
> Hash buckets with  11 entries  18361 (  9%)
> Hash buckets with  12 entries  12288 (  7%)
> Hash buckets with  13 entries   7494 (  4%)
> Hash buckets with  14 entries   4346 (  2%)
> Hash buckets with  15 entries   2285 (  1%)
> Hash buckets with  16 entries   1126 (  0%)
> Hash buckets with  17 entries    502 (  0%)
> Hash buckets with  18 entries    211 (  0%)
> Hash buckets with  19 entries     95 (  0%)
> Hash buckets with  20 entries     28 (  0%)
> Hash buckets with  21 entries     16 (  0%)
> Hash buckets with  22 entries     12 (  0%)
> Hash buckets with  23 entries      1 (  0%)
> Phase 5 - rebuild AG headers and trees...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - agno = 16
>         - agno = 17
>         - agno = 18
>         - agno = 19
>         - agno = 20
>         - agno = 21
>         - agno = 22
>         - agno = 23
>         - agno = 24
>         - agno = 25
>         - agno = 26
>         - agno = 27
>         - agno = 28
>         - agno = 29
>         - agno = 30
>         - agno = 31
>         - agno = 32
>         - agno = 33
>         - agno = 34
>         - agno = 35
>         - agno = 36
>         - agno = 37
>         - agno = 38
>         - 20:44:35: rebuild AG headers and trees - 39 of 39 allocation groups done
>         - reset superblock...
> libxfs_bcache: 0xdb0900
> Max supported entries = 2048000
> Max utilized entries = 2048000
> Active entries = 2047979
> Hash table size = 256000
> Hits = 64756472
> Misses = 82918282
> Hit ratio = 43.85
> MRU 0 entries =  19304 (  0%)
> MRU 1 entries =      0 (  0%)
> MRU 2 entries =  47524 (  2%)
> MRU 3 entries = 217973 ( 10%)
> MRU 4 entries =  16829 (  0%)
> MRU 5 entries =  45729 (  2%)
> MRU 6 entries = 1071173 ( 52%)
> MRU 7 entries =      0 (  0%)
> MRU 8 entries =      0 (  0%)
> MRU 9 entries =      0 (  0%)
> MRU 10 entries =      0 (  0%)
> MRU 11 entries = 400426 ( 19%)
> MRU 12 entries =  97317 (  4%)
> MRU 13 entries = 130545 (  6%)
> MRU 14 entries =   1159 (  0%)
> MRU 15 entries =      0 (  0%)
> Dirty MRU 16 entries =      0 (  0%)
> Hash buckets with   0 entries     73 (  0%)
> Hash buckets with   1 entries    678 (  0%)
> Hash buckets with   2 entries   2631 (  0%)
> Hash buckets with   3 entries   7189 (  1%)
> Hash buckets with   4 entries  14612 (  2%)
> Hash buckets with   5 entries  23535 (  5%)
> Hash buckets with   6 entries  31083 (  9%)
> Hash buckets with   7 entries  35948 ( 12%)
> Hash buckets with   8 entries  35995 ( 14%)
> Hash buckets with   9 entries  32122 ( 14%)
> Hash buckets with  10 entries  25412 ( 12%)
> Hash buckets with  11 entries  18278 (  9%)
> Hash buckets with  12 entries  12245 (  7%)
> Hash buckets with  13 entries   7570 (  4%)
> Hash buckets with  14 entries   4320 (  2%)
> Hash buckets with  15 entries   2299 (  1%)
> Hash buckets with  16 entries   1131 (  0%)
> Hash buckets with  17 entries    497 (  0%)
> Hash buckets with  18 entries    231 (  0%)
> Hash buckets with  19 entries     95 (  0%)
> Hash buckets with  20 entries     31 (  0%)
> Hash buckets with  21 entries     15 (  0%)
> Hash buckets with  22 entries      9 (  0%)
> Hash buckets with  23 entries      1 (  0%)
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
> entry "servmask" in dir ino 25777842447 doesn't have a .. entry, will set it in ino 36512379414.
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - agno = 16
> entry "langs" in dir ino 34365014856 doesn't have a .. entry, will set it in ino 36510278809.
>         - agno = 17
>         - agno = 18
>         - agno = 19
>         - agno = 20
>         - agno = 21
>         - agno = 22
>         - agno = 23
>         - agno = 24
>         - agno = 25
>         - agno = 26
>         - agno = 27
>         - agno = 28
>         - agno = 29
>         - agno = 30
>         - agno = 31
>         - agno = 32
>         - agno = 33
>         - agno = 34
>         - agno = 35
>         - agno = 36
>         - agno = 37
>         - agno = 38
> setting .. in sf dir inode 36512379414 to 25777842447
> Metadata corruption detected at 0x460e1c, inode 0x8804eb216 data fork
> xfs_repair: warning - iflush_int failed (-117)
> setting .. in sf dir inode 36510278809 to 34365014856
> Metadata corruption detected at 0x460e1c, inode 0x8802ea499 data fork
> xfs_repair: warning - iflush_int failed (-117)
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> libxfs_bcache: 0xdb0900
> Max supported entries = 2048000
> Max utilized entries = 2048000
> Active entries = 2047971
> Hash table size = 256000
> Hits = 167418187
> Misses = 119244070
> Hit ratio = 58.40
> MRU 0 entries =  80752 (  3%)
> MRU 1 entries =      0 (  0%)
> MRU 2 entries =   1830 (  0%)
> MRU 3 entries = 500840 ( 24%)
> MRU 4 entries =  18369 (  0%)
> MRU 5 entries =      0 (  0%)
> MRU 6 entries = 1110024 ( 54%)
> MRU 7 entries = 133410 (  6%)
> MRU 8 entries =      0 (  0%)
> MRU 9 entries =      0 (  0%)
> MRU 10 entries = 202746 (  9%)
> MRU 11 entries =      0 (  0%)
> MRU 12 entries =      0 (  0%)
> MRU 13 entries =      0 (  0%)
> MRU 14 entries =      0 (  0%)
> MRU 15 entries =      0 (  0%)
> Dirty MRU 16 entries =      0 (  0%)
> Hash buckets with   0 entries     72 (  0%)
> Hash buckets with   1 entries    655 (  0%)
> Hash buckets with   2 entries   2512 (  0%)
> Hash buckets with   3 entries   7015 (  1%)
> Hash buckets with   4 entries  14124 (  2%)
> Hash buckets with   5 entries  23498 (  5%)
> Hash buckets with   6 entries  31301 (  9%)
> Hash buckets with   7 entries  36059 ( 12%)
> Hash buckets with   8 entries  36530 ( 14%)
> Hash buckets with   9 entries  32219 ( 14%)
> Hash buckets with  10 entries  25732 ( 12%)
> Hash buckets with  11 entries  18590 (  9%)
> Hash buckets with  12 entries  12175 (  7%)
> Hash buckets with  13 entries   7484 (  4%)
> Hash buckets with  14 entries   4068 (  2%)
> Hash buckets with  15 entries   2087 (  1%)
> Hash buckets with  16 entries   1073 (  0%)
> Hash buckets with  17 entries    487 (  0%)
> Hash buckets with  18 entries    194 (  0%)
> Hash buckets with  19 entries     81 (  0%)
> Hash buckets with  20 entries     34 (  0%)
> Hash buckets with  21 entries      7 (  0%)
> Hash buckets with  22 entries      2 (  0%)
> Hash buckets with  23 entries      1 (  0%)
> Phase 7 - verify and correct link counts...
> Invalid inode number 0x0
> xfs_dir_ino_validate: XFS_ERROR_REPORT
> Metadata corruption detected at 0x460da8, inode 0x8802ea499 data fork
> 
> fatal error -- couldn't map inode 36510278809, err = 117
> 

-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
