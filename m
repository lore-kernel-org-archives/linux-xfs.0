Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD2DC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jan 2022 12:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240592AbiALMLW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jan 2022 07:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240575AbiALMLV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jan 2022 07:11:21 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FC0C06173F
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jan 2022 04:11:19 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id q14so2696751qtx.10
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jan 2022 04:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:to:content-language:from
         :subject:content-transfer-encoding;
        bh=SSPgvGjr8f3bDJHqrM+z+31tCAnXbFYjG7YYMe8ppOY=;
        b=qxs7A1HLAM1RhFDKKeO+0ScUsn5bFgPvadVpS99sJdMKG1DkXHoOOHzGJjdpAR9w6k
         JrA8M/Pvb4ok/vJ/q13NHS1Yc8attrL7LTJZuLoRbdG+gBU6mwUbKRIAiz0gqB4wsoyx
         VMgYYYaWgvqTlgraTTGGnL5quuFe24jEw7vKUZ0s0VFVZeO+ucAJmfP+krYpnZH3fv8B
         IFmtSR+Wd6uCCiuiwpcK5vMA1TdfmKvOaKHQCMawESNsbpxI3SJcNTVmMEbzAKPZufmU
         N6MUZ4p1cuqVmnXrjaa/qcDIOuAwGGz8bL138M9++4Cgs0TBJi3A+CuL0wIrEkn6s4Wa
         UUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:to
         :content-language:from:subject:content-transfer-encoding;
        bh=SSPgvGjr8f3bDJHqrM+z+31tCAnXbFYjG7YYMe8ppOY=;
        b=RbBQendooYOsR0Zm3Wd+qYlJvGxtyNANutz6XdF0EJUoghjd/DrTCP1LVHTPg4L1fu
         JCePV71N61wMpdkdJbjPDz3MeN4a9YwfGnxvRtjd41l7X2svFn7OiRWr4FAfvorj8VJP
         a3pr1xP8rwyywgFK906U7jecfEcIhYdC02S4iNsJBJE4zUvd0BXsMY4eeTONvJoC1kWj
         oxXwvV0fIXXSyMTjXP1Tl69Umh9mEmpQv97xit2ctYLj2UtMmwJFbFzeiMt1lzwcWxJN
         bL6oSYPfnAgOSxJpH16pS9HY60uFmcg9Nlm1KStLLKmQo+ZWLHA68Phi7GqkaaA6X83d
         jHXg==
X-Gm-Message-State: AOAM530+dIMZBMcnPgkzR5xScYRUWII2+Hrl48FBVS/pWs55VhSNhk+d
        XFfQbpr+z1fejPiCwcrpNxUNPYY1nuDcrA==
X-Google-Smtp-Source: ABdhPJwmQLcAxG97RbbHTCLIpw9BfMq/xI/pqxO0p4OLVNwq1XTLY/3pswbzLoW9mieg9mEyYbSADQ==
X-Received: by 2002:ac8:5842:: with SMTP id h2mr7290584qth.244.1641989479073;
        Wed, 12 Jan 2022 04:11:19 -0800 (PST)
Received: from [10.10.6.102] ([41.190.94.217])
        by smtp.gmail.com with ESMTPSA id h19sm6947631qth.46.2022.01.12.04.11.17
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 04:11:18 -0800 (PST)
Message-ID: <bf0b1c63-8fee-112b-fc6c-801593ef4f23@gmail.com>
Date:   Wed, 12 Jan 2022 14:11:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
To:     linux-xfs@vger.kernel.org
Content-Language: en-US
From:   Well Loaded <wellloaded@gmail.com>
Subject: XFS volume unmounts itself with lots of kernel logs generated
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I'm having issues with my XFS volume. It mounts itself as soon as some 
medium load happens e.g. can open/view a text file, it crashes under 
rsync. This below is the relevant part of the syslog:


Jan 12 11:42:01 NAS kernel: [ 3179.130696] XFS (sdc1): Unmounting Filesystem
Jan 12 11:42:03 NAS kernel: [ 3180.798027] XFS (sdc1): Mounting V4 
Filesystem
Jan 12 11:42:03 NAS kernel: [ 3180.921496] XFS (sdc1): Ending clean mount
Jan 12 11:47:22 NAS kernel: [ 3498.175610] CPU: 5 PID: 5404 Comm: rsync 
Not tainted 4.18.0-0.bpo.1-amd64 #1 Debian 4.18.6-1~bpo9+1
Jan 12 11:47:22 NAS kernel: [ 3498.175616] Hardware name: VMware, Inc. 
VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 
12/12/2018
Jan 12 11:47:22 NAS kernel: [ 3498.175622] Call Trace:
Jan 12 11:47:22 NAS kernel: [ 3498.175629]  dump_stack+0x5c/0x7b
Jan 12 11:47:22 NAS kernel: [ 3498.175688]  xfs_trans_cancel+0x116/0x140 
[xfs]
Jan 12 11:47:22 NAS kernel: [ 3498.175736]  xfs_create+0x41d/0x640 [xfs]
Jan 12 11:47:22 NAS kernel: [ 3498.175780] 
xfs_generic_create+0x241/0x2e0 [xfs]
Jan 12 11:47:22 NAS kernel: [ 3498.175808]  ? d_splice_alias+0x139/0x3f0
Jan 12 11:47:22 NAS kernel: [ 3498.175812]  path_openat+0x141c/0x14d0
Jan 12 11:47:22 NAS kernel: [ 3498.175816]  do_filp_open+0x99/0x110
Jan 12 11:47:22 NAS kernel: [ 3498.175820]  ? __check_object_size+0x98/0x1a0
Jan 12 11:47:22 NAS kernel: [ 3498.175823]  ? do_sys_open+0x12e/0x210
Jan 12 11:47:22 NAS kernel: [ 3498.175825]  do_sys_open+0x12e/0x210
Jan 12 11:47:22 NAS kernel: [ 3498.175829]  do_syscall_64+0x55/0x110
Jan 12 11:47:22 NAS kernel: [ 3498.175832] 
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Jan 12 11:47:22 NAS kernel: [ 3498.175836] RIP: 0033:0x7f6652f836f0
Jan 12 11:47:22 NAS kernel: [ 3498.175837] Code: 00 f7 d8 64 89 01 48 83 
c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 83 3d 19 30 2c 00 
00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 
e8 fe 9d 01 00 48 89 04 24
Jan 12 11:47:22 NAS kernel: [ 3498.175875] RSP: 002b:00007ffc53860668 
EFLAGS: 00000246 ORIG_RAX: 0000000000000002
Jan 12 11:47:22 NAS kernel: [ 3498.175877] RAX: ffffffffffffffda RBX: 
0000000000000000 RCX: 00007f6652f836f0
Jan 12 11:47:22 NAS kernel: [ 3498.175879] RDX: 0000000000000180 RSI: 
00000000000000c2 RDI: 00007ffc538628d0
Jan 12 11:47:22 NAS kernel: [ 3498.175881] RBP: 000000000003a2f8 R08: 
000000000000ffff R09: 67756c702e707061
Jan 12 11:47:22 NAS kernel: [ 3498.175882] R10: 0000000000000000 R11: 
0000000000000246 R12: 00007ffc53862942
Jan 12 11:47:22 NAS kernel: [ 3498.175884] R13: 8421084210842109 R14: 
00000000000000c2 R15: 00007f6653011540
Jan 12 11:47:22 NAS kernel: [ 3498.175888] XFS (sdc1): 
xfs_do_force_shutdown(0x8) called from line 1018 of file 
/build/linux-GVmoCH/linux-4.18.6/fs/xfs/xfs_trans.c.  Return address = 
00000000ddf97241


I have already performed xds_repair /dev/sdc1 and xfs_repair -L 
/dev/sdc1 they both completed successfully but the issue is still happening.

Is there anything else I can try? Is this perhaps a bug?

Thanks!
