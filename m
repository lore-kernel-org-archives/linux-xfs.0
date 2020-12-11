Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E313C4361B
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 23:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00714221E3
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 23:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437306AbgLKXnz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Dec 2020 18:43:55 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45986 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407184AbgLKXnZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Dec 2020 18:43:25 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BBNXxsJ007809;
        Fri, 11 Dec 2020 23:42:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=DHrRy6S+C0e8BoDmZqJ17luozFdJ3Xi1HeOaWHakVYo=;
 b=aYCoWy6UOexNhPxvlRzNzOyYJeqz+/Yp056GiupjLy2JiJF6P1mahTvKai/WNEsfyEVN
 53WoHIWwNuKj29okoZcaa4ygsRmcmvdhbVU9Ybamyvde9ij86+VVFGTyj72LUoZj2GH/
 nxfkfNOCX6/1apV4C0n5KSrMt2eRfCu9heKTQtguzKhLklQ11i+t+9l16Zphqy5xaokU
 PBoHEXXjkHFHVhNvoZaqvSRMvxHlrvrvH+Ojr0wORT1zkxwS9xucozGuqacQdSmpnQlR
 5g3K2WM9yeQpemIuPsOhgvHD/v3et/Mhx8/wm85gjKcugkMKDgSO5OKfMR+yKyuPGjCI Mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 357yqcd70f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Dec 2020 23:42:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BBNdt6r145322;
        Fri, 11 Dec 2020 23:42:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 358m54s7us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Dec 2020 23:42:35 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BBNgYoN009066;
        Fri, 11 Dec 2020 23:42:34 GMT
Received: from localhost (/10.159.149.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Dec 2020 15:42:34 -0800
Date:   Fri, 11 Dec 2020 15:42:33 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     wenli xie <wlxie7296@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug report] overlayfs over xfs whiteout operation may cause
 deadlock
Message-ID: <20201211234233.GK106271@magnolia>
References: <CABRboy006NP8JrxuBgEJbfCcGGUY2Kucwfov+HJf2xW34D5Ocg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABRboy006NP8JrxuBgEJbfCcGGUY2Kucwfov+HJf2xW34D5Ocg@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9832 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012110155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9832 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1011 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110154
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 10, 2020 at 03:14:53PM +0800, wenli xie wrote:
> We are using the linux ubuntu kernel for 5.4.0-34.generic.x86_64. In our
> host, there are many containers use the same base image. All of them have
> `mv /etc/security/access.conf  /etc/security/access.conf.bak` operation
> when the container starts up. Sometimes we met that the `mv` process came
> to D state and couldn't recover.
> I did some research and find this issue can be reproduced by following
> steps.
> 
> 1. mount a disk to /var/mnt/test with xfs fs.
>  mount -t xfs /mnt/test
> 2. Create lower dir under /var/mnt/test
>    /var/mnt/test/lowdir
>    /var/mnt/test/lowdir1
> 3. Create `/etc/access.conf` in dir `/var/mnt/test/lowdir`
> 4.
> Run following script in different terminals
> 1)
> while true
> do
>   umount /var/mnt/test/merged
>   rm -rf /var/mnt/test/merged
>   rm -rf /var/mnt/test/upperdir
>   rm -rf /var/mnt/test/workdir
>   mkdir /var/mnt/test/merged
>   mkdir /var/mnt/test/workdir
>   mkdir /var/mnt/test/upperdir
>   mount -t overlay overlay -o
> lowerdir=/var/mnt/test/lowerdir:/var/mnt/test/lowerdir1,upperdir=/var/mnt/test/upperdir,workdir=/var/mnt/test/workdir
> /var/mnt/test/merged
>   mv /var/mnt/test/merged/etc/access.conf
> /var/mnt/test/merged/etc/access.conf.bak
>   touch /var/mnt/test/merged/etc/access.conf
>   mv /var/mnt/test/merged/etc/access.conf
> /var/mnt/test/merged/etc/access.conf.bak
>   touch /var/mnt/test/merged/etc/access.conf
>   echo "---------------"
> done
> 
> 2)
> while true
> do
>   umount /var/mnt/test/merged1
>   rm -rf /var/mnt/test/merged1
>   rm -rf /var/mnt/test/upperdir1
>   rm -rf /var/mnt/test/workdir1
>   mkdir /var/mnt/test/merged1
>   mkdir /var/mnt/test/workdir1
>   mkdir /var/mnt/test/upperdir1
>   mount -t overlay overlay -o
> lowerdir=/var/mnt/test/lowerdir:/var/mnt/test/lowerdir1,upperdir=/var/mnt/test/upperdir1,workdir=/var/mnt/test/workdir1
> /var/mnt/test/merged1
>   mv /var/mnt/test/merged1/etc/access.conf
> /var/mnt/test/merged1/etc/access.conf.bak
>   touch /var/mnt/test/merged1/etc/access.conf
>   mv /var/mnt/test/merged1/etc/access.conf
> /var/mnt/test/merged1/etc/access.conf.bak
>   touch /var/mnt/test/merged1/etc/access.conf
>   echo "---------------"
> done
> 
> 3)
> while true
> do
>   umount /var/mnt/test/merged3
>   rm -rf /var/mnt/test/merged3
>   rm -rf /var/mnt/test/upperdir3
>   rm -rf /var/mnt/test/workdir3
>   mkdir /var/mnt/test/merged3
>   mkdir /var/mnt/test/workdir3
>   mkdir /var/mnt/test/upperdir3
>   mount -t overlay overlay -o
> lowerdir=/var/mnt/test/lowerdir:/var/mnt/test/lowerdir1,upperdir=/var/mnt/test/upperdir3,workdir=/var/mnt/test/workdir3
> /var/mnt/test/merged3
>   mv /var/mnt/test/merged3/etc/access.conf
> /var/mnt/test/merged3/etc/access.conf.bak
>   touch /var/mnt/test/merged3/etc/access.conf
>   mv /var/mnt/test/merged3/etc/access.conf
> /var/mnt/test/merged3/etc/access.conf.bak
>   touch /var/mnt/test/merged3/etc/access.conf
>   echo "---------------"
> done
> 
> 4)
> while true
> do
>   umount /var/mnt/test/merged4
>   rm -rf /var/mnt/test/merged4
>   rm -rf /var/mnt/test/upperdir4
>   rm -rf /var/mnt/test/workdir4
>   mkdir /var/mnt/test/merged4
>   mkdir /var/mnt/test/workdir4
>   mkdir /var/mnt/test/upperdir4
>   mount -t overlay overlay -o
> lowerdir=/var/mnt/test/lowerdir:/var/mnt/test/lowerdir1,upperdir=/var/mnt/test/upperdir4,workdir=/var/mnt/test/workdir4
> /var/mnt/test/merged4
>   mv /var/mnt/test/merged4/etc/access.conf
> /var/mnt/test/merged4/etc/access.conf.bak
>   touch /var/mnt/test/merged4/etc/access.conf
>   mv /var/mnt/test/merged4/etc/access.conf
> /var/mnt/test/merged4/etc/access.conf.bak
>   touch /var/mnt/test/merged4/etc/access.conf
>   echo "---------------"
> done
> 
> 5)
> while true
> do
>   umount /var/mnt/test/merged5
>   rm -rf /var/mnt/test/merged5
>   rm -rf /var/mnt/test/upperdir5
>   rm -rf /var/mnt/test/workdir5
>   mkdir /var/mnt/test/merged5
>   mkdir /var/mnt/test/workdir5
>   mkdir /var/mnt/test/upperdir5
>   mount -t overlay overlay -o
> lowerdir=/var/mnt/test/lowerdir:/var/mnt/test/lowerdir1,upperdir=/var/mnt/test/upperdir5,workdir=/var/mnt/test/workdir5
> /var/mnt/test/merged5
>   mv /var/mnt/test/merged5/etc/access.conf
> /var/mnt/test/merged5/etc/access.conf.bak
>   touch /var/mnt/test/merged5/etc/access.conf
>   mv /var/mnt/test/merged5/etc/access.conf
> /var/mnt/test/merged5/etc/access.conf.bak
>   touch /var/mnt/test/merged5/etc/access.conf
>   echo "---------------"
> done
> 
> 6)
> while true
> do
>   umount /var/mnt/test/merged6
>   rm -rf /var/mnt/test/merged6
>   rm -rf /var/mnt/test/upperdir6
>   rm -rf /var/mnt/test/workdir6
>   mkdir /var/mnt/test/merged6
>   mkdir /var/mnt/test/workdir6
>   mkdir /var/mnt/test/upperdir6
>   mount -t overlay overlay -o
> lowerdir=/var/mnt/test/lowerdir:/var/mnt/test/lowerdir1,upperdir=/var/mnt/test/upperdir6,workdir=/var/mnt/test/workdir6
> /var/mnt/test/merged6
>   mv /var/mnt/test/merged6/etc/access.conf
> /var/mnt/test/merged6/etc/access.conf.bak
>   touch /var/mnt/test/merged6/etc/access.conf
>   mv /var/mnt/test/merged6/etc/access.conf
> /var/mnt/test/merged6/etc/access.conf.bak
>   touch /var/mnt/test/merged6/etc/access.conf
>   echo "---------------"
> done
> 
> 
> 
> After a while, you will found that there are `mv` process become to D state
> 
> crash> foreach UN ps -m|sort|tail
> [0 00:00:23.271] [UN]  PID: 38033  TASK: ffff908cd4c8ba80  CPU: 20
>  COMMAND: "mv"
> [0 00:00:23.332] [UN]  PID: 38029  TASK: ffff908cd6093a80  CPU: 1
> COMMAND: "mv"
> [0 00:00:23.332] [UN]  PID: 38037  TASK: ffff908cd606ba80  CPU: 31
>  COMMAND: "touch"
> [0 00:00:23.332] [UN]  PID: 38038  TASK: ffff908cd4c50000  CPU: 24
>  COMMAND: "mv"
> [0 00:00:23.333] [UN]  PID: 38032  TASK: ffff908cd5a0ba80  CPU: 33
>  COMMAND: "mv"
> [0 00:00:23.333] [UN]  PID: 38035  TASK: ffff908cd5110000  CPU: 8
> COMMAND: "touch"
> [0 00:00:23.336] [UN]  PID: 38040  TASK: ffff908cd4cbba80  CPU: 2
> COMMAND: "touch"
> [0 00:00:23.337] [UN]  PID: 38039  TASK: ffff908cd62cba80  CPU: 35
>  COMMAND: "touch"
> [0 00:00:23.338] [UN]  PID: 38030  TASK: ffff908cdbfc0000  CPU: 15
>  COMMAND: "mv"
> [0 00:00:23.339] [UN]  PID: 38036  TASK: ffff908cd4ce8000  CPU: 22
>  COMMAND: "mv"
> 
> 
> The `mv` process have the same stack like:
> 
> crash> bt
> PID: 38029  TASK: ffff908cd6093a80  CPU: 1   COMMAND: "mv"
>  #0 [ffffa848961b3558] __schedule at ffffffff8fa96c09
>  #1 [ffffa848961b35e8] schedule at ffffffff8fa97235
>  #2 [ffffa848961b3608] schedule_timeout at ffffffff8fa9ccc6
>  #3 [ffffa848961b36c8] __down_common at ffffffff8fa9b2b3
>  #4 [ffffa848961b3748] __down at ffffffff8fa9b311
>  #5 [ffffa848961b3758] down at ffffffff8ed43be1
>  #6 [ffffa848961b3778] xfs_buf_lock at ffffffffc06fab78 [xfs]
>  #7 [ffffa848961b37a8] xfs_buf_find at ffffffffc06fb160 [xfs]
>  #8 [ffffa848961b3850] xfs_buf_get_map at ffffffffc06fbf41 [xfs]
>  #9 [ffffa848961b38a0] xfs_buf_read_map at ffffffffc06fcd67 [xfs]
> #10 [ffffa848961b38f0] xfs_trans_read_buf_map at ffffffffc0752496 [xfs]
> #11 [ffffa848961b3938] xfs_read_agi at ffffffffc06cdf02 [xfs]
> #12 [ffffa848961b39a0] xfs_iunlink at ffffffffc071c741 [xfs]
> #13 [ffffa848961b3a08] xfs_droplink at ffffffffc071c9e2 [xfs]
> #14 [ffffa848961b3a30] xfs_rename at ffffffffc07221b7 [xfs]
> #15 [ffffa848961b3b08] xfs_vn_rename at ffffffffc0717ec4 [xfs]
> #16 [ffffa848961b3b80] vfs_rename at ffffffff8eff9d65
> #17 [ffffa848961b3c40] ovl_do_rename at ffffffffc091d177 [overlay]
> #18 [ffffa848961b3c78] ovl_rename at ffffffffc091e885 [overlay]
> #19 [ffffa848961b3d10] vfs_rename at ffffffff8eff9d65
> #20 [ffffa848961b3dd8] do_renameat2 at ffffffff8effcc66
> #21 [ffffa848961b3ea8] __x64_sys_rename at ffffffff8effcdb9
> #22 [ffffa848961b3ec0] do_syscall_64 at ffffffff8ec04c54
> #23 [ffffa848961b3f50] entry_SYSCALL_64_after_hwframe at ffffffff8fc00091
>     RIP: 00007f84ed829da7  RSP: 00007ffe6da90508  RFLAGS: 00000202
>     RAX: ffffffffffffffda  RBX: 00007ffe6da9093f  RCX: 00007f84ed829da7
>     RDX: 0000000000000000  RSI: 00007ffe6da92b94  RDI: 00007ffe6da92b7a
>     RBP: 00007ffe6da908e0   R8: 0000000000000001   R9: 0000000000000000
>     R10: 0000000000000001  R11: 0000000000000202  R12: 00007ffe6da909c0
>     R13: 0000000000000000  R14: 0000000000000000  R15: 00007ffe6da92b7a
>     ORIG_RAX: 0000000000000052  CS: 0033  SS: 002b
> 
> 
> I revert this PR
> https://github.com/torvalds/linux/commit/fa6c668d807b1e9ac041101dfcb59bd8e279cfe5
> , which can indicate which process is hold the lock. This can help for the
> debug.
> 
> 1. Check for process 38036
> 
> crash> set 38036
>     PID: 38036
> COMMAND: "mv"
>    TASK: ffff908cd4ce8000  [THREAD_INFO: ffff908cd4ce8000]
>     CPU: 22
>   STATE: TASK_UNINTERRUPTIBLE
> 
> 
> It is waiting for a lock, which is holding by 38029:
> 
> crash> struct xfs_buf.b_last_holder ffff908f92a0a680
>   b_last_holder = 38029
> 
> 
> 2. Check for process 38029
> crash> set 38029
>     PID: 38029
> COMMAND: "mv"
>    TASK: ffff908cd6093a80  [THREAD_INFO: ffff908cd6093a80]
>     CPU: 1
>   STATE: TASK_UNINTERRUPTIBLE
> 
> crash> struct xfs_buf.b_last_holder ffff908f993cc780
>   b_last_holder = 38030
> 
> It is waiting for a lock, which is holding  by 38030
> 
> 3. Check for process 38030
> crash> set 38030
>     PID: 38030
> COMMAND: "mv"
>    TASK: ffff908cdbfc0000  [THREAD_INFO: ffff908cdbfc0000]
>     CPU: 15
>   STATE: TASK_UNINTERRUPTIBLE
> 
> crash> struct xfs_buf.b_last_holder ffff908f92a0a680
>   b_last_holder = 38029
> 
> 
> 
> I did a bit more trace by ebpf, the lock ffff908f92a0a680 should be held by
> 38029 in xfs_iunlink_remove() but not released:
> 
>   b'xfs_buf_trylock+0x1'
>   b'xfs_buf_get_map+0x51'
>   b'xfs_buf_read_map+0x47'
>   b'xfs_trans_read_buf_map+0xf6'
>   b'xfs_read_agi+0xd2'
>   b'xfs_iunlink_remove+0x9a'
>   b'xfs_rename+0x618'
>   b'xfs_vn_rename+0x104'
>   b'vfs_rename+0x6e5'
>   b'ovl_do_rename+0x47'
>   b'ovl_rename+0x5d5'
>   b'vfs_rename+0x6e5'
>   b'do_renameat2+0x576'
>   b'__x64_sys_rename+0x29'
>   b'do_syscall_64+0x84'
>   b'entry_SYSCALL_64_after_hwframe+0x49'
> 
> The lock 0xffff908f993cc780 should also be held by 38030
> xfs_iunlink_remove() but not released:
> 
>   b'xfs_buf_trylock+0x1'
>   b'xfs_buf_get_map+0x51'
>   b'xfs_buf_read_map+0x47'
>   b'xfs_trans_read_buf_map+0xf6'
>   b'xfs_read_agi+0xd2'
>   b'xfs_iunlink_remove+0x9a'
>   b'xfs_rename+0x618'
>   b'xfs_vn_rename+0x104'
>   b'vfs_rename+0x6e5'
>   b'ovl_do_rename+0x47'
>   b'ovl_rename+0x5d5'
>   b'vfs_rename+0x6e5'
>   b'do_renameat2+0x576'
>   b'__x64_sys_rename+0x29'
>   b'do_syscall_64+0x84'
>   b'entry_SYSCALL_64_after_hwframe+0x49'
> 
> 
> Looks like there are ABBA deadlock in this scenario.
> 
> This issue is very easy to be reproduced by the scripts I provided.

Hm.  Does this happen on upstream?  There have been a couple of deadlock
fixes for the rename code in the past couple of years.

93597ae8dac0149b5c00b787cba6bf7ba213e666 (5.5)
bc56ad8c74b8588685c2875de0df8ab6974828ef (5.4)

I have no idea if Ubuntu has picked up the newer one, you'll have to
contact them.

(Did this ever show up on linux-xfs?)

--D
