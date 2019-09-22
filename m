Return-Path: <SRS0=iA/C=XR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A539EC3A5A2
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Sep 2019 08:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62D84208C0
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Sep 2019 08:40:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OMePHSoe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbfIVIkC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Sep 2019 04:40:02 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:45848 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbfIVIkC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Sep 2019 04:40:02 -0400
Received: by mail-lf1-f50.google.com with SMTP id r134so7836165lff.12
        for <linux-xfs@vger.kernel.org>; Sun, 22 Sep 2019 01:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=GQbmA2HuUyDfJ+4qYR/pihDR9KEbnybGF4nqrsIjkms=;
        b=OMePHSoeT8WWBadPJP5h7GpqBCIQv6ThVI6ozHgAceGo/3t3zQsYHaBDgr+kbWLOB4
         eQf3m7CY3HFP9uT9zsJay7CFzaC5nMDGuWkF7YCGdcsUskvv+RcZYoRO2V9UKsKnNKpV
         +xyxpeZemm8sjtyXM5ban18Fl3N02KobHkORNhUXFd+5T0GkX5/gJkuqT13XfvDQa6BJ
         6F9iSDIAa/dFcsRNg15re8uwYI4TWg3t3C4BHaW/my1Bmv08k9XWGXdVMa8yktkoQzgo
         1+j7fgyn5sSIOSlvaC3V+aBbwqCIA6SXCYMu1b1EnWXeP0bD9CY0E+MtLROaBnNxRqtp
         8b3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GQbmA2HuUyDfJ+4qYR/pihDR9KEbnybGF4nqrsIjkms=;
        b=DXf2dl+k5AQXYQoSMefzdlKzlyXkr1btIAP2xGfkxlWFfzIKZ3HyhoiDx+0OZsyg3k
         bOLgZPXtP2xtq1+OJkGboBoETMctKzFMrIZG1MpbJsb6Ua8Ke7cmbnTT1E9zDoF4TY24
         smyChbOrvOSJlwZTgfknM4rDh0IP1lsLM8GuJbzwtQVj3+IlN7oDb+XVJdScaJiwcEP3
         qJTlz1rhODsmbnAwcDtMWbZ4MFGYRmKWfqmdSyVZJ4IHgyNxJcy0W3q9sI3pGHDPlJk+
         M2/6CTVxDlVnr4p1MowNZIRut0HN4rN1oGh3Nx8irjkOzAQWjbTgi3CYPMIgDy50iZsv
         iCUg==
X-Gm-Message-State: APjAAAV4tza8Ib1h7WOCv7qCUyJNSxZWtivMIXdm7QoQJ4e0AXe0HsKB
        jHmuEaO9A76tWhxViC/ooPF9YDkp
X-Google-Smtp-Source: APXvYqxSQx9SlJIYvgrh82mD8T6lts3rGPZApOv7xTta7GJcuFPYiKA216i9KMlED97wjTI0R1OhOA==
X-Received: by 2002:a19:2314:: with SMTP id j20mr13532635lfj.22.1569141599432;
        Sun, 22 Sep 2019 01:39:59 -0700 (PDT)
Received: from amb.local (31-179-17-47.dynamic.chello.pl. [31.179.17.47])
        by smtp.gmail.com with ESMTPSA id f28sm1498055lfp.28.2019.09.22.01.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Sep 2019 01:39:58 -0700 (PDT)
Subject: Re: xfs_repair: phase6.c:1129: mv_orphanage: Assertion `err == 2'
 failed.
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
References: <7097d965-1676-a70e-56c7-b6cf048057f5@gmail.com>
 <03eac8a7-a442-d6cf-45ab-67500052cc69@sandeen.net>
From:   =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Message-ID: <4cd713f1-7f09-5556-8da4-b21cbb053983@gmail.com>
Date:   Sun, 22 Sep 2019 10:39:57 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <03eac8a7-a442-d6cf-45ab-67500052cc69@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16/09/2019 23:35, Eric Sandeen wrote:
> On 9/15/19 7:44 AM, Arkadiusz Miśkiewicz wrote:
>>
>> Hello.
>>
>> xfsprogs 5.2.1 and:
>>
>> disconnected dir inode 9185193405, moving to lost+found
>> disconnected dir inode 9185193417, moving to lost+found
>> disconnected dir inode 9185194001, moving to lost+found
>> disconnected dir inode 9185194004, moving to lost+found
>> disconnected dir inode 9185194010, moving to lost+found
>> disconnected dir inode 9185194012, moving to lost+found
>> disconnected dir inode 9185194018, moving to lost+found
>> disconnected dir inode 9185194027, moving to lost+found
>> disconnected dir inode 9185205370, moving to lost+found
>> disconnected dir inode 9185209007, moving to lost+found
>> corrupt dinode 9185209007, (btree extents).
>> Metadata corruption detected at 0x449621, inode 0x2237b2aaf
>> libxfs_iread_extents
>> xfs_repair: phase6.c:1129: mv_orphanage: Assertion `err == 2' failed.
>> Aborted
> 
>>
>>
>> # grep -A1 -B1 9185209007 log
>> entry ".." at block 0 offset 80 in directory inode 9185141346 references
>> non-existent inode 6454491396
>> entry ".." at block 0 offset 80 in directory inode 9185209007 references
>> free inode 62881485764
>> entry ".." at block 0 offset 80 in directory inode 9185220220 references
>> free inode 6454492606
>> --
>> rebuilding directory inode 9185141346
>> entry ".." in directory inode 9185209007 points to free inode
>> 62881485764, marking entry to be junked
>> rebuilding directory inode 9185209007
>> name create failed in ino 9185209007 (117), filesystem may be out of space
> 
> 117 is EUCLEAN/EFSCORRUPTED even though we were in the process of rebuilding it. :(
> 
> so this is probably why a subsequent attempt to move it to lost+found failed as well?
> 
> Is this a metadumpable filesystem...?


It's one of my big fses but metadump can't deal with it:

> [...]
> Copied 103433024 of 165039360 inodes (24 of 39 AGs)        Unknown directory buffer type!
> Copied 104001280 of 165039360 inodes (24 of 39 AGs)        Unknown directory buffer type!
> Copied 105465088 of 165039360 inodes (24 of 39 AGs)        Unknown directory buffer type!
> Copied 107092608 of 165039360 inodes (25 of 39 AGs)        Metadata corruption detected at 0x473455, xfs_dir3_leaf1 block 0xc8471ce78/0x1000
> Segmentation fault (core dumped)
> 
> (gdb) where
> #0  __memset_avx2_erms () at ../sysdeps/x86_64/multiarch/memset-vec-unaligned-erms.S:151
> #1  0x0000000000429113 in process_dir_leaf_block (block=0xf8be800 "") at metadump.c:1488
> #2  0x000000000042a1ac in process_single_fsb_objects (o=8388608, s=6720207336, c=1, btype=TYP_DIR2, last=8388609) at metadump.c:1904
> #3  0x000000000042a9ab in process_bmbt_reclist (rp=0x98c88d0, numrecs=3, btype=TYP_DIR2) at metadump.c:2121
> #4  0x000000000042b493 in process_exinode (dip=0x98c8800, itype=TYP_DIR2) at metadump.c:2292
> #5  0x000000000042b51c in process_inode_data (dip=0x98c8800, itype=TYP_DIR2) at metadump.c:2318
> #6  0x000000000042b7b0 in process_inode (agno=25, agino=4599138, dip=0x98c8800, free_inode=false) at metadump.c:2386
> #7  0x000000000042bd34 in copy_inode_chunk (agno=25, rp=0xa714818) at metadump.c:2536
> #8  0x000000000042beee in scanfunc_ino (block=0xa713a00, agno=25, agbno=15498, level=0, btype=TYP_INOBT, arg=0x7ffd2c457604) at metadump.c:2596
> #9  0x0000000000427156 in scan_btree (agno=25, agbno=15498, level=1, btype=TYP_INOBT, arg=0x7ffd2c457604, func=0x42bde7 <scanfunc_ino>) at metadump.c:402
> #10 0x000000000042c0a9 in scanfunc_ino (block=0x600e400, agno=25, agbno=8, level=1, btype=TYP_INOBT, arg=0x7ffd2c457604) at metadump.c:2619
> #11 0x0000000000427156 in scan_btree (agno=25, agbno=8, level=2, btype=TYP_INOBT, arg=0x7ffd2c457604, func=0x42bde7 <scanfunc_ino>) at metadump.c:402
> #12 0x000000000042c19c in copy_inodes (agno=25, agi=0x8bdce00) at metadump.c:2652
> #13 0x000000000042c775 in scan_ag (agno=25) at metadump.c:2776
> #14 0x000000000042d404 in metadump_f (argc=3, argv=0x2239190) at metadump.c:3078
> #15 0x0000000000417fdd in command (argc=3, argv=0x2239190) at command.c:89
> #16 0x0000000000421c69 in main (argc=7, argv=0x7ffd2c4578b8) at init.c:195
> (gdb) bt full
> #0  __memset_avx2_erms () at ../sysdeps/x86_64/multiarch/memset-vec-unaligned-erms.S:151
> No locals.
> #1  0x0000000000429113 in process_dir_leaf_block (block=0xf8be800 "") at metadump.c:1488
>         ltp = 0xf8bf7fc
>         lbp = 0xf8bdf96
>         ents = 0xf8be840
>         free = 0xf8bead0 ""
>         leaf = 0xf8be800
>         leafhdr = {
>           forw = 12,
>           back = 6,
>           magic = 15857,
>           count = 82,
>           stale = 0
>         }
> #2  0x000000000042a1ac in process_single_fsb_objects (o=8388608, s=6720207336, c=1, btype=TYP_DIR2, last=8388609) at metadump.c:1904
>         dp = 0xf8be800 ""
>         ret = 0
>         i = 0
> #3  0x000000000042a9ab in process_bmbt_reclist (rp=0x98c88d0, numrecs=3, btype=TYP_DIR2) at metadump.c:2121
>         i = 2
>         o = 8388608
>         op = 8388608
>         s = 6720207336
>         c = 1
>         cp = 1
>         f = 0
>         last = 8388609
>         agno = 25
>         agbno = 9320936
>         is_multi_fsb = false
>         error = 0
> #4  0x000000000042b493 in process_exinode (dip=0x98c8800, itype=TYP_DIR2) at metadump.c:2292
>         whichfork = 0
>         used = 48
>         nex = 3
> #5  0x000000000042b51c in process_inode_data (dip=0x98c8800, itype=TYP_DIR2) at metadump.c:2318
> No locals.
> #6  0x000000000042b7b0 in process_inode (agno=25, agino=4599138, dip=0x98c8800, free_inode=false) at metadump.c:2386
>         success = 1
>         crc_was_ok = true
>         need_new_crc = false
> #7  0x000000000042bd34 in copy_inode_chunk (agno=25, rp=0xa714818) at metadump.c:2536
>         dip = 0x98c8800
>         agino = 4599136
>         off = 0
>         agbno = 574892
>         end_agbno = 574900
>         i = 2
>         rval = 0
>         blks_per_buf = 8
> --Type <RET> for more, q to quit, c to continue without paging--
>         inodes_per_buf = 64
>         ioff = 0
> #8  0x000000000042beee in scanfunc_ino (block=0xa713a00, agno=25, agbno=15498, level=0, btype=TYP_INOBT, arg=0x7ffd2c457604) at metadump.c:2596
>         rp = 0xa714818
>         pp = 0x7ffd2c457500
>         i = 222
>         numrecs = 252
>         finobt = 0
> #9  0x0000000000427156 in scan_btree (agno=25, agbno=15498, level=1, btype=TYP_INOBT, arg=0x7ffd2c457604, func=0x42bde7 <scanfunc_ino>) at metadump.c:402
>         rval = 0
> #10 0x000000000042c0a9 in scanfunc_ino (block=0x600e400, agno=25, agbno=8, level=1, btype=TYP_INOBT, arg=0x7ffd2c457604) at metadump.c:2619
>         rp = 0x600e400
>         pp = 0x600ec1c
>         i = 16
>         numrecs = 280
>         finobt = 0
> #11 0x0000000000427156 in scan_btree (agno=25, agbno=8, level=2, btype=TYP_INOBT, arg=0x7ffd2c457604, func=0x42bde7 <scanfunc_ino>) at metadump.c:402
>         rval = 0
> #12 0x000000000042c19c in copy_inodes (agno=25, agi=0x8bdce00) at metadump.c:2652
>         root = 8
>         levels = 2
>         finobt = 0
> #13 0x000000000042c775 in scan_ag (agno=25) at metadump.c:2776
>         agf = 0x2a98a00
>         agi = 0x8bdce00
>         stack_count = 4
>         rval = 0
> #14 0x000000000042d404 in metadump_f (argc=3, argv=0x2239190) at metadump.c:3078
>         agno = 25
>         c = -1
>         start_iocur_sp = 0
>         outfd = -1
>         ret = 0
>         p = 0x7ffd2c457740 "\200wE,\375\177"
> #15 0x0000000000417fdd in command (argc=3, argv=0x2239190) at command.c:89
>         cmd = 0x7ffd2c458ff6 "metadump"
>         ct = 0x224c9d0
> #16 0x0000000000421c69 in main (argc=7, argv=0x7ffd2c4578b8) at init.c:195
>         c = 3
>         i = 0
>         done = 0
>         input = 0x4a5e90 <__libc_csu_init> "\363\017\036\372AWL\215=3\257\003"
>         v = 0x2239190
>         start_iocur_sp = 0
> (gdb) frame 1
> #1  0x0000000000429113 in process_dir_leaf_block (block=0xf8be800 "") at metadump.c:1488
> 1488                    memset(free, 0, (char *)lbp - free);
> (gdb) print free
> $4 = 0xf8bead0 ""
> (gdb) print lbp
> $5 = (__be16 *) 0xf8bdf96
> (gdb) print (char *)lbp-free
> $6 = -2874
> (gdb)




-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
