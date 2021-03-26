Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E20CFC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 22:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4EC561A2A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 22:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhCZWVS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 18:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbhCZWVI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Mar 2021 18:21:08 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85710C0613AA
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 15:21:06 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id o10so9832668lfb.9
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 15:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=cuT9eUh9dLlBI/8k2J97tfNxTxPcH+QgaFN3VVDQINE=;
        b=Dqbg6Tf12OBCxe5uAZGW6gh4U+Ev0+qLOuwyh3q4tK11m7sLvrdWiReYQ+TNVr4D1N
         tZQDjg1BfHG8MwBlyb4+zZ4L3qMLOEJarLWhI7ez1Nf/+u4o1f834BdyBDaLeAEIXrOL
         ZJu9nhUdWICiW1OyipL3ceJIN+neL3CsM0ZqhebWP83Q0YDNvqWZ1iQTUqvJm3ZIi+h0
         e3s8M5u5w0hdrS6MnEVuNvAyQWi9d4gkZwcX4NRawUBKwR7mXfi/1Bh+XnOPxF0lUc+e
         JUdFSeLDT7kV94l2N/ZrpiuPLMMzN/x6nhuifWnF+7qvKxi4KWKSDOev++Umlq1bBuW8
         sGZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=cuT9eUh9dLlBI/8k2J97tfNxTxPcH+QgaFN3VVDQINE=;
        b=HNqK729A6OuE31eZ4vhYHzpfMkEN3vfX3M4cam+Jr1Vi0vtaRP+pZllcrGylw+oCgQ
         x2Aj2ue3jlVVf15c3OoxO+f0uYq9yRh5zwHk5ryTAAbm0EdwhGtDJjXyY8vtKAdxg1i/
         jV0uQmdkVRO+nftj8XI5ITz75EMyn4FZ5WrD2v1wlSPfver6WFMpwJc3hrL11gVxiskL
         I613pG/NgYcHZyhof/TxrqgGFBqQciqx8WCaJamZpuSVkowjWWVReThQnzlK0zobJ/SF
         p5NhDYFS+L4c7GSh6b58KAgyPY7vCnwYlyTJ1i1RMv/fJVEcSyNlQUdSAP2IpDX2BSR+
         aBEg==
X-Gm-Message-State: AOAM532WlpJqM/4oxDpMACQrBCBO+S4Ss7m86j7IAn92tdYp7GXK1ofc
        sQE6cBIMsVaC9pTgreDxwyb2VnUq0kw=
X-Google-Smtp-Source: ABdhPJyN+1svyqz38jB1Io9jkIHp10KDSKcGl5yKADHskQw9bxkyX+6BEhWuId/fzUIZqgIhxXp7Zg==
X-Received: by 2002:a05:6512:11c3:: with SMTP id h3mr9324270lfr.366.1616797264836;
        Fri, 26 Mar 2021 15:21:04 -0700 (PDT)
Received: from amb.lan (user-5-173-202-3.play-internet.pl. [5.173.202.3])
        by smtp.gmail.com with ESMTPSA id o7sm992008lfr.217.2021.03.26.15.21.04
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 15:21:04 -0700 (PDT)
To:     linux-xfs@vger.kernel.org
From:   =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Subject: xfs_metadump from git for-next crashes in process_dir_free_block
Message-ID: <d6643b1e-1db8-91ff-9c2c-7695cbb89c88@gmail.com>
Date:   Fri, 26 Mar 2021 23:21:03 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: pl
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Hi,

was trying to do fresh metadump for

https://lore.kernel.org/linux-xfs/b3d66e9b-2223-9413-7d66-d348b63660c5@gmail.com/


but

> (gdb) bt
> #0  0x00007fe866afbde1 in ?? () from /lib64/libc.so.6
> #1  0x0000000000429234 in process_dir_free_block (block=0x6c5d200 "XDF3\311\033\254\061") at metadump.c:1449
> #2  0x000000000042a3b8 in process_single_fsb_objects (o=16777216, s=2471412828, c=1, btype=TYP_DIR2, last=16777217) at metadump.c:1910
> #3  0x000000000042abe2 in process_bmbt_reclist (rp=0x67a8fb0, numrecs=17, btype=TYP_DIR2) at metadump.c:2129
> #4  0x000000000042b791 in process_exinode (dip=0x67a8e00, itype=TYP_DIR2) at metadump.c:2300
> #5  0x000000000042b81c in process_inode_data (dip=0x67a8e00, itype=TYP_DIR2) at metadump.c:2326
> #6  0x000000000042bacd in process_inode (agno=9, agino=313967633, dip=0x67a8e00, free_inode=false) at metadump.c:2393
> #7  0x000000000042c05f in copy_inode_chunk (agno=9, rp=0x99aeba8) at metadump.c:2543
> #8  0x000000000042c21e in scanfunc_ino (block=0x99ae200, agno=9, agbno=4530, level=0, btype=TYP_INOBT, arg=0x7fffdd98f6f4) at metadump.c:2604
> #9  0x0000000000427358 in scan_btree (agno=9, agbno=4530, level=1, btype=TYP_INOBT, arg=0x7fffdd98f6f4, func=0x42c112 <scanfunc_ino>) at metadump.c:403
> #10 0x000000000042c3c7 in scanfunc_ino (block=0x789f200, agno=9, agbno=6319, level=1, btype=TYP_INOBT, arg=0x7fffdd98f6f4) at metadump.c:2627
> #11 0x0000000000427358 in scan_btree (agno=9, agbno=6319, level=2, btype=TYP_INOBT, arg=0x7fffdd98f6f4, func=0x42c112 <scanfunc_ino>) at metadump.c:403
> #12 0x000000000042c4b9 in copy_inodes (agno=9, agi=0x4fb7400) at metadump.c:2660
> #13 0x000000000042ca6b in scan_ag (agno=9) at metadump.c:2784
> #14 0x000000000042d6e7 in metadump_f (argc=3, argv=0x23f71d0) at metadump.c:3086
> #15 0x000000000041874e in command (argc=3, argv=0x23f71d0) at command.c:88
> #16 0x0000000000421d67 in main (argc=7, argv=0x7fffdd98f9b8) at init.c:190
> (gdb) frame 1
> #1  0x0000000000429234 in process_dir_free_block (block=0x6c5d200 "XDF3\311\033\254\061") at metadump.c:1449
> 1449                    memset(high, 0, mp->m_dir_geo->blksize - used);
> (gdb) l
> 1444
> 1445                    /* Zero out space from end of bests[] to end of block */
> 1446                    bests = freehdr.bests;
> 1447                    high = (char *)&bests[freehdr.nvalid];
> 1448                    used = high - (char*)free;
> 1449                    memset(high, 0, mp->m_dir_geo->blksize - used);
> 1450                    iocur_top->need_crc = 1;
> 1451                    break;
> 1452            }
> 1453            default:
> (gdb) print high
> $1 = 0x5341d334 <error: Cannot access memory at address 0x5341d334>
> (gdb) print mp->m_dir_geo->blksize
> $2 = 4096
> (gdb) print high-(char *)free
> $5 = 1283195188
> (gdb) print used
> $3 = 1283195188
> (gdb)


xfs_metadump from git, for-next branch.


-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
