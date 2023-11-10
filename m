Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F4CC4167B
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 22:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjKJWYA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 17:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjKJWX7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 17:23:59 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEEF4205
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2023 14:23:56 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1cc131e52f1so27995995ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2023 14:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699655036; x=1700259836; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CtRcpCvXtsBhIWmfzPeXz1LcP6zrtftlgTaO5Bgm78A=;
        b=N4FJNBeM6beqvWLEwxh5Sd9Sd7jfjBqM29U3mfhjY18z+oEuZ0rKFyV57tG5jxIVqK
         vG4mpGlquZJau/lbxmPzj4DBajoAXCKciTNh+AQ3uLin2REp30mZC7Ta4Ugkl6Z4qu7K
         1NpFEdsbaKNSmnwywinVQryU+8XkfcghYVPnbY4xw2G1LGjJNWMiw5SEORBeCoSA4sVq
         9iQe4XzHkxEkEP4NrXQnXcdycdsWLjcryhw5cxXWP5Qrm9RlwlqAy3HKMT5qs5n/jtee
         AJ9WesZyVyxwgnfI4tm2hIcqDdRF95wIH374CPeGTqwq3WmyVXI/kxRzw0yzc9w5Hg60
         W2uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699655036; x=1700259836;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CtRcpCvXtsBhIWmfzPeXz1LcP6zrtftlgTaO5Bgm78A=;
        b=IpwXWT/dVgLwLDKMfJTkSlGXJayhbF9BpceA52DvR7maAcRccPhb4/vUazqfF2bMqt
         9K8+S4oHUzmRueLm5rVjctZlee7sctRzLpGNaO0irWJKic2Tq7QOfrGjUCTkDTvswfs8
         EHXYzUQcDm9+ZX0LkC2wBzxIYe7tIodLePtXpUTCbaa+/uJfbNamB3pOW+XNZqsh9PGl
         Jv3KgVTRr27ogaYWIVuOXySp+csMbjIiOfeDWuST1TzMRP/gPx+KqUN/gYTnE+zy1E+W
         FB4IphC9ko6BaEe4CoVXSAAYKNhWVgGsFgYUqp9kY4lCeRgd5j7JNpt29hF8eP9KzRfI
         sQDQ==
X-Gm-Message-State: AOJu0YwxpjhiAJWWRQu+PY7mnGUD1/sJasVpu8HhyPvgM8bbdcdiaUVi
        R3diYjKrOTvyIxCMM8leo1/llyU3kJs=
X-Google-Smtp-Source: AGHT+IHtY3QUV2a3vIl7PMurk2ZzAwhMbH3Vk5VMXcpH1R+uoMkhzdv5ak0t6wz+kTK/xwdtKhHEag==
X-Received: by 2002:a17:903:2302:b0:1cc:5549:aab8 with SMTP id d2-20020a170903230200b001cc5549aab8mr708799plh.5.1699655035353;
        Fri, 10 Nov 2023 14:23:55 -0800 (PST)
Received: from ?IPV6:2606:4700:110:8939:3cc4:589f:70ed:f5b0? ([2a09:bac0:1000:a2::4:330])
        by smtp.gmail.com with ESMTPSA id iw6-20020a170903044600b001ca4ad86369sm130645plb.236.2023.11.10.14.23.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Nov 2023 14:23:54 -0800 (PST)
Message-ID: <179cca2a-65ee-45cf-8d5c-ca09fc18212e@gmail.com>
Date:   Fri, 10 Nov 2023 14:23:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Question on xfs related kernel panic
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <911c61d5-08e6-4233-a1dc-5b3df2250031@gmail.com>
 <20231110193440.GL1205143@frogsfrogsfrogs>
Content-Language: en-US
From:   Jianan Wang <wangjianan.zju@gmail.com>
In-Reply-To: <20231110193440.GL1205143@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Thanks for your response. I will open a case to Ubuntu on this issue. However, can you give me a hint on what could be wrong? Failed to kmalloc seems to be a pretty severe issue, and is that related to any kind of kernel memory corruption by certain kernel modules or so?

Thanks.
Jianan.

On 11/10/23 11:34, Darrick J. Wong wrote:
> On Fri, Nov 10, 2023 at 12:14:45AM -0800, Jianan Wang wrote:
>> Hi all,
>>
>> I have a question regarding a kernel panic leading to our server reboot issue, which has its stack-trace like the following (copied from /var/lib/systemd/pstore/*):
>>
>> <4>[888969.888666] general protection fault, probably for non-canonical address 0xbf5bc9c369fd38ba: 0000 [#1] SMP PTI
>> <4>[888969.891355] CPU: 47 PID: 2662145 Comm: find Tainted: P           OE     5.15.0-46-generic #49~20.04.1-Ubuntu
> Please open a support case with your vendor for this issue with their
> kernel.
>
> --D
>
>> <4>[888969.894004] Hardware name: Supermicro SYS-4029GP-TRT2/X11DPG-OT-CPU, BIOS 3.8b 01/17/2023
>> <4>[888969.896608] RIP: 0010:__kmalloc+0xfc/0x4b0
>> <4>[888969.899170] Code: ca 2b ad 56 49 8b 50 08 49 83 78 10 00 4d 8b 30 0f 84 67 03 00 00 4d 85 f6 0f 84 5e 03 00 00 41 8b 45 28 49 8b 7d 00 4c 01 f0 <48> 8b 18 48 89 c1 49 33 9d b8 00 00 00 4c 89 f0 48 0f c9 48 31 cb
>> <4>[888969.904329] RSP: 0018:ffffba69b18a78c0 EFLAGS: 00010282
>> <4>[888969.906872] RAX: bf5bc9c369fd38ba RBX: 0000000000002c40 RCX: ffffffffc4d3ea92
>> <4>[888969.909420] RDX: 0000000004d3b836 RSI: 0000000000002c40 RDI: 00000000000350a0
>> <4>[888969.911952] RBP: ffffba69b18a7900 R08: ffff979effef50a0 R09: 000000000000002c
>> <4>[888969.914471] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
>> <4>[888969.916976] R13: ffff976080042500 R14: bf5bc9c369fd389a R15: ffffffffc4d80b0e
>> <4>[888969.919594] FS:  00007fdbf10dd800(0000) GS:ffff979effec0000(0000) knlGS:0000000000000000
>> <4>[888969.922109] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> <4>[888969.924601] CR2: 00007f236f3419f0 CR3: 00000050e6e62001 CR4: 00000000007706e0
>> <4>[888969.927099] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> <4>[888969.929579] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> <4>[888969.932029] PKRU: 55555554
>> <4>[888969.934445] Call Trace:
>> <4>[888969.936827]  <TASK>
>> <4>[888969.939269]  kmem_alloc+0x6e/0x110 [xfs]
>> <4>[888969.941882]  xfs_init_local_fork+0x72/0xf0 [xfs]
>> <4>[888969.944418]  xfs_iformat_local+0xac/0x180 [xfs]
>> <4>[888969.946921]  xfs_iformat_data_fork+0x105/0x130 [xfs]
>> <4>[888969.949405]  xfs_inode_from_disk+0x2be/0x470 [xfs]
>> <4>[888969.951869]  xfs_iget+0x334/0xbd0 [xfs]
>> <4>[888969.954319]  ? kvfree+0x2c/0x40
>> <4>[888969.956529]  xfs_lookup+0xd2/0x100 [xfs]
>> <4>[888969.958930]  xfs_vn_lookup+0x76/0xb0 [xfs]
>> <4>[888969.961310]  __lookup_slow+0x85/0x150
>> <4>[888969.963443]  walk_component+0x145/0x1c0
>> <4>[888969.965637]  ? __fdget_raw+0x10/0x20
>> <4>[888969.967747]  ? path_init+0x1e5/0x390
>> <4>[888969.969888]  path_lookupat.isra.0+0x6e/0x150
>> <4>[888969.971927]  filename_lookup+0xcf/0x1a0
>> <4>[888969.973943]  ? __check_object_size+0x14f/0x160
>> <4>[888969.975937]  ? strncpy_from_user+0x44/0x160
>> <4>[888969.977879]  ? getname_flags+0x6f/0x1f0
>> <4>[888969.979769]  user_path_at_empty+0x3f/0x60
>> <4>[888969.981604]  vfs_statx+0x73/0x110
>> <4>[888969.983390]  __do_sys_newfstatat+0x36/0x70
>> <4>[888969.985125]  ? alloc_fd+0x58/0x190
>> <4>[888969.986806]  ? f_dupfd+0x4b/0x70
>> <4>[888969.988513]  ? do_fcntl+0x3af/0x5b0
>> <4>[888969.990090]  __x64_sys_newfstatat+0x1e/0x30
>> <4>[888969.991649]  do_syscall_64+0x59/0xc0
>> <4>[888969.993146]  ? syscall_exit_to_user_mode+0x27/0x50
>> <4>[888969.994611]  ? do_syscall_64+0x69/0xc0
>> <4>[888969.996020]  ? exit_to_user_mode_prepare+0x3d/0x1c0
>> <4>[888969.997404]  ? filp_close+0x60/0x70
>> <4>[888969.998752]  ? syscall_exit_to_user_mode+0x27/0x50
>> <4>[888970.000084]  ? __x64_sys_close+0x12/0x50
>> <4>[888970.001371]  ? do_syscall_64+0x69/0xc0
>> <4>[888970.002605]  ? do_syscall_64+0x69/0xc0
>> <4>[888970.003793]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
>>
>> Our xfs version, config, OS and kernel version are the following:
>>
>> Linux$ xfs_info -V /data/
>> xfs_info version 5.9.0
>>
>> Linux$ xfs_info /data
>> meta-data=/dev/md127p1           isize=512    agcount=32, agsize=117206400 blks
>>          =                       sectsz=4096  attr=2, projid32bit=1
>>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>>          =                       reflink=1
>> data     =                       bsize=4096   blocks=3750604800, imaxpct=5
>>          =                       sunit=128    swidth=512 blks
>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>> log      =internal log           bsize=4096   blocks=521728, version=2
>>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>> Linux$ cat /etc/*-release
>> DISTRIB_ID=Ubuntu
>> DISTRIB_RELEASE=20.04
>> DISTRIB_CODENAME=focal
>> DISTRIB_DESCRIPTION="Ubuntu-Server 20.04.6 2023.05.30 (Cubic 2023-05-30 13:13)"
>> NAME="Ubuntu"
>> VERSION="20.04.6 LTS (Focal Fossa)"
>> ID=ubuntu
>> ID_LIKE=debian
>> PRETTY_NAME="Ubuntu-Server 20.04.6 2023.05.30 (Cubic 2023-05-30 13:13)"
>> VERSION_ID="20.04"
>> HOME_URL="https://www.ubuntu.com/"
>> SUPPORT_URL="https://help.ubuntu.com/"
>> BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
>> PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
>> VERSION_CODENAME=focal
>> UBUNTU_CODENAME=focal
>>
>> Linux$ uname -a
>> Linux abc-server-001 5.15.0-46-generic #49~20.04.1-Ubuntu SMP Thu Aug 4 19:15:44 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
>>
>> It would be great if any insight could be provided on whether this is a known issue or how we could troubleshoot further.
>>
>> Best Regards.
>>
>> Jianan
>>
