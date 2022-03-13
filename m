Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA23C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Mar 2022 15:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbiCMPsf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Mar 2022 11:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbiCMPse (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Mar 2022 11:48:34 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D631F210F
        for <linux-xfs@vger.kernel.org>; Sun, 13 Mar 2022 08:47:23 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id dr20so28763811ejc.6
        for <linux-xfs@vger.kernel.org>; Sun, 13 Mar 2022 08:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=xxuyoCp3IpYhBrr9Kl/RpkxTwP+UwgQCaB5jhtXZLZc=;
        b=Rl6/Scd+3XiVXJawD0FjGz0gQbxVrfIESLSe5x7zuC64Y9Ke7F84IhYuD4uz1tZCW2
         KJ4xNAW8+vl7+IuD/8rR3K8W09OsImyPgO+AiMG5L0ccbdMoMSXdVpUhNTBoBtOkmhvO
         TpMRugKQwhHeOJ5uZOoWT6JYL6I4vD0xkorK67WC+kaXyY/inBUKBuoASss4N/x8a4L1
         SVbRYUu+ujVDfroHKnA8TRbv+wlf9GpHRWlRl6j/xc4dmEhnAt9tR47YJ+vjgiLBLyIe
         +hexXSKekK720Smb7kRetGmT+jGFT6JBM+TyMhqoXLZaojGyrId0HGUxzOOzRbhMVBQu
         eZ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=xxuyoCp3IpYhBrr9Kl/RpkxTwP+UwgQCaB5jhtXZLZc=;
        b=3duNzicScWjzeB5tqAA7ZD4Zr6EMnxcp02Mvy6Qdppac5SgBWKtjtb3sioPrq9/YsB
         oGUeDitNzeXN1Qw2UJAI64n5FVgtGsmWJXfxQp+j89zBdW6jqNzYTJwyKsQ6or58mvA5
         8tMbDKH8zUNRZp0toZRzueOf3rNwRjfImeOlK74bOj6aNUADHfDn/NJ0bsgvDCJNbBIb
         /vx7tySPxNFaQLD5kDMtfWWl4pyIYwkTOEyxjnPzxOcUsvEHwsBP0GH4Nf8WxmDPJ34n
         HIeR44tIO1b1SR3vsKrLKOKgqfPGo65vRv5Uw6KvWsLe1JScaj2shnAIYSeWL2Ij3gQJ
         RHAg==
X-Gm-Message-State: AOAM5310Mb3oC+dr339d0TxhXIhK0qjELcGgFv1vjAZGHruuqqKo3dRz
        EPr0KPl3zPdw1sU/i5v1KvPFeojA755dkA==
X-Google-Smtp-Source: ABdhPJw7oKD3WOx8hv925ZXDJeu/pAnJ3DYfgo7jVuGu5JkK/3hfYTtzyJgdIDEohFvl+/i3vmlRUw==
X-Received: by 2002:a17:907:7e90:b0:6da:49e4:c7be with SMTP id qb16-20020a1709077e9000b006da49e4c7bemr15799130ejc.493.1647186441330;
        Sun, 13 Mar 2022 08:47:21 -0700 (PDT)
Received: from ?IPV6:2003:d9:9704:7c00:b4c3:cb25:4133:3ad1? (p200300d997047c00b4c3cb2541333ad1.dip0.t-ipconnect.de. [2003:d9:9704:7c00:b4c3:cb25:4133:3ad1])
        by smtp.googlemail.com with ESMTPSA id m3-20020a17090679c300b006cf9ce53354sm5666637ejo.190.2022.03.13.08.47.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 08:47:20 -0700 (PDT)
Message-ID: <613af505-7646-366c-428a-b64659e1f7cf@colorfullife.com>
Date:   Sun, 13 Mar 2022 16:47:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     linux-xfs@vger.kernel.org
From:   Manfred Spraul <manfred@colorfullife.com>
Subject: Metadata CRC error detected at xfs_dir3_block_read_verify+0x9e/0xc0
 [xfs], xfs_dir3_block block 0x86f58
Cc:     "Spraul Manfred (XC/QMM21-CT)" <Manfred.Spraul@de.bosch.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello together,


after a simulated power failure, I have observed:

 >>>

Metadata CRC error detected at xfs_dir3_block_read_verify+0x9e/0xc0 
[xfs], xfs_dir3_block block 0x86f58
[14768.047531] XFS (loop0): Unmount and run xfs_repair
[14768.047534] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[14768.047537] 00000000: 58 44 42 33 9f ab d7 f4 00 00 00 00 00 08 6f 
58  XDB3..........oX

<<<

Is this a known issue?

The image file is here: 
https://github.com/manfred-colorfu/nbd-datalog-referencefiles/blob/main/xfs-02/result/data-1821799.img.xz

As first question:

Are 512 byte sectors supported, or does xfs assume that 4096 byte writes 
are atomic?


How were the power failures simulated:

I added support to nbd to log all write operations, including the 
written data. This got merged into nbd-3.24

I've used that to create a log of running dbench (+ a few tar/rm/manual 
tests) on a 500 MB image file.

In total, 2.9 mio 512-byte sector writes. The datalog is ~1.5 GB long.

If replaying the initial 1,821,799, 1,821,800, 1,821,801 or 1,821,802 
blocks, the above listed error message is shown.

After 1,821,799 or 1,821,803 sectors, everything is ok.

(block numbers are 0-based)

> > H=2400000047010000 C=0x00000001 (NBD_CMD_WRITE+NONE) 
> O=0000000010deb000 L=00001000
> block 1821795 (0x1bcc63): writing to offset 283029504 (0x10deb000), 
> len 512 (0x200).
> block 1821796 (0x1bcc64): writing to offset 283030016 (0x10deb200), 
> len 512 (0x200).
> block 1821797 (0x1bcc65): writing to offset 283030528 (0x10deb400), 
> len 512 (0x200).  << OK
> block 1821798 (0x1bcc66): writing to offset 283031040 (0x10deb600), 
> len 512 (0x200).  FAIL
> block 1821799 (0x1bcc67): writing to offset 283031552 (0x10deb800), 
> len 512 (0x200).  FAIL
> block 1821800 (0x1bcc68): writing to offset 283032064 (0x10deba00), 
> len 512 (0x200).  FAIL
> block 1821801 (0x1bcc69): writing to offset 283032576 (0x10debc00), 
> len 512 (0x200).  FAIL
> block 1821802 (0x1bcc6a): writing to offset 283033088 (0x10debe00), 
> len 512 (0x200). << OK
>

The output from xfs_repair is below.

kernel: 5.16.12-200.fc35.x86_64

nbd:nbd-3.24-1.fc37.x86_64

mkfs options: mkfs.xfs /dev/nbd0 -m bigtime=1 -m finobt=1 -m rmapbt=1

mount options: mount -t xfs -o uqnoenforce /dev/nbd0 $tmpmnt

Generator script: 
https://github.com/manfred-colorfu/nbd-datalog-referencefiles/blob/main/xfs-02/generator/maketr

Further log file are also on github: 
https://github.com/manfred-colorfu/nbd-datalog-referencefiles/tree/main/xfs-02/result


<<<

/dev/loop0: [0037]:17060 (/tmp/data-341131.img)
Phase 1 - find and verify superblock...
         - block cache size set to 759616 entries
Phase 2 - using internal log
         - zero log...
zero_log: head block 734 tail block 734
         - scan filesystem freespace and inode maps...
         - found root inode chunk
Phase 3 - for each AG...
         - scan (but don't clear) agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
         - agno = 1
         - agno = 2
Metadata CRC error detected at 0x563aa27804c3, xfs_dir3_block block 
0x86f58/0x1000
corrupt block 0 in directory inode 551205
         would junk block
no . entry for directory 551205
no .. entry for directory 551205
problem with directory contents in inode 551205
would have cleared inode 551205
         - agno = 3
         - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - check for inodes claiming duplicate blocks...
         - agno = 1
         - agno = 3
         - agno = 2
         - agno = 0
corrupt block 0 in directory inode 551205
         would junk block
no . entry for directory 551205
no .. entry for directory 551205
problem with directory contents in inode 551205
would have cleared inode 551205
entry "COREL" in shortform directory 789069 references free inode 551205
would have junked entry "COREL" in directory inode 789069
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
         - traversing filesystem ...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
entry "COREL" in shortform directory inode 789069 points to free inode 
551205
would junk entry
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
disconnected inode 551174, would move to lost+found
disconnected inode 551176, would move to lost+found
disconnected inode 551178, would move to lost+found
disconnected inode 551180, would move to lost+found
disconnected inode 551206, would move to lost+found
disconnected inode 551207, would move to lost+found

disconnected inode 551208, would move to lost+found
disconnected inode 551209, would move to lost+found
disconnected inode 551210, would move to lost+found
disconnected inode 551211, would move to lost+found
disconnected inode 551212, would move to lost+found
disconnected inode 551213, would move to lost+found
disconnected inode 551214, would move to lost+found
disconnected inode 551215, would move to lost+found
disconnected inode 551217, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 789069 nlinks from 11 to 10
No modify flag set, skipping filesystem flush and exiting.

<<<<

>>>

