Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C90CC77B75
	for <linux-xfs@archiver.kernel.org>; Mon,  8 May 2023 14:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbjEHOqi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 May 2023 10:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbjEHOqg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 May 2023 10:46:36 -0400
Received: from out28-68.mail.aliyun.com (out28-68.mail.aliyun.com [115.124.28.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C525251
        for <linux-xfs@vger.kernel.org>; Mon,  8 May 2023 07:46:19 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.3324625|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00243102-3.31984e-06-0.997566;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047194;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=1;RT=1;SR=0;TI=SMTPD_---.SbiXoIF_1683557170;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.SbiXoIF_1683557170)
          by smtp.aliyun-inc.com;
          Mon, 08 May 2023 22:46:10 +0800
Date:   Mon, 08 May 2023 22:46:12 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: performance regression between 6.1.x and 5.15.x
In-Reply-To: <20230508172406.1CF3.409509F4@e16-tech.com>
References: <20230508172406.1CF3.409509F4@e16-tech.com>
Message-Id: <20230508224611.0651.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

> Hi,
> 
> I noticed a performance regression of xfs 6.1.27/6.1.23,
> with the compare to xfs 5.15.110.
> 
> It is yet not clear whether  it is a problem of xfs or lvm2.
> 
> any guide to troubleshoot it?
> 
> test case:
>   disk: NVMe PCIe3 SSD *4 
>   LVM: raid0 default strip size 64K.
>   fio -name write-bandwidth -rw=write -bs=1024Ki -size=32Gi -runtime=30
>    -iodepth 1 -ioengine sync -zero_buffers=1 -direct=0 -end_fsync=1 -numjobs=4
>    -directory=/mnt/test
> 
> 
> 6.1.27/6.1.23
> fio bw=2623MiB/s (2750MB/s)
> perf report:
> Samples: 330K of event 'cycles', Event count (approx.): 120739812790
> Overhead  Command  Shared Object        Symbol
>   31.07%  fio      [kernel.kallsyms]    [k] copy_user_enhanced_fast_string
>    5.11%  fio      [kernel.kallsyms]    [k] iomap_set_range_uptodate.part.24
>    3.36%  fio      [kernel.kallsyms]    [k] asm_exc_nmi
>    3.29%  fio      [kernel.kallsyms]    [k] native_queued_spin_lock_slowpath
>    2.27%  fio      [kernel.kallsyms]    [k] iomap_write_begin
>    2.18%  fio      [kernel.kallsyms]    [k] get_page_from_freelist
>    2.11%  fio      [kernel.kallsyms]    [k] xas_load
>    2.10%  fio      [kernel.kallsyms]    [k] xas_descend
> 
> 5.15.110
> fio bw=6796MiB/s (7126MB/s)
> perf report:
> Samples: 267K of event 'cycles', Event count (approx.): 186688803871
> Overhead  Command  Shared Object       Symbol
>   38.09%  fio      [kernel.kallsyms]   [k] copy_user_enhanced_fast_string
>    6.76%  fio      [kernel.kallsyms]   [k] iomap_set_range_uptodate
>    4.40%  fio      [kernel.kallsyms]   [k] xas_load
>    3.94%  fio      [kernel.kallsyms]   [k] get_page_from_freelist
>    3.04%  fio      [kernel.kallsyms]   [k] asm_exc_nmi
>    1.97%  fio      [kernel.kallsyms]   [k] native_queued_spin_lock_slowpath
>    1.88%  fio      [kernel.kallsyms]   [k] __pagevec_lru_add
>    1.53%  fio      [kernel.kallsyms]   [k] iomap_write_begin
>    1.53%  fio      [kernel.kallsyms]   [k] __add_to_page_cache_locked
>    1.41%  fio      [kernel.kallsyms]   [k] xas_start
> 


more info:

1, 6.2.14 have same performance as 6.1.x

2,  6.1.x fio performance detail:
Jobs: 4 (f=4): [W(4)][16.7%][w=10.2GiB/s][w=10.4k IOPS][eta 00m:15s]
Jobs: 4 (f=4): [W(4)][25.0%][w=9949MiB/s][w=9949 IOPS][eta 00m:12s] 
Jobs: 4 (f=4): [W(4)][31.2%][w=9618MiB/s][w=9618 IOPS][eta 00m:11s]
Jobs: 4 (f=4): [W(4)][37.5%][w=7970MiB/s][w=7970 IOPS][eta 00m:10s]
Jobs: 4 (f=4): [W(4)][41.2%][w=5048MiB/s][w=5047 IOPS][eta 00m:10s]
Jobs: 4 (f=4): [W(4)][42.1%][w=2489MiB/s][w=2488 IOPS][eta 00m:11s]
Jobs: 4 (f=4): [W(4)][42.9%][w=3227MiB/s][w=3226 IOPS][eta 00m:12s]
Jobs: 4 (f=4): [W(4)][45.5%][w=3622MiB/s][w=3622 IOPS][eta 00m:12s]
Jobs: 4 (f=4): [W(4)][47.8%][w=3651MiB/s][w=3650 IOPS][eta 00m:12s]
Jobs: 4 (f=4): [W(4)][52.2%][w=3435MiB/s][w=3435 IOPS][eta 00m:11s]
Jobs: 4 (f=4): [W(4)][52.0%][w=2464MiB/s][w=2463 IOPS][eta 00m:12s]
Jobs: 4 (f=4): [W(4)][53.8%][w=2438MiB/s][w=2438 IOPS][eta 00m:12s]
Jobs: 4 (f=4): [W(4)][55.6%][w=2435MiB/s][w=2434 IOPS][eta 00m:12s]
Jobs: 4 (f=4): [W(4)][57.1%][w=2449MiB/s][w=2448 IOPS][eta 00m:12s]
Jobs: 4 (f=4): [W(4)][60.7%][w=2422MiB/s][w=2421 IOPS][eta 00m:11s]
Jobs: 4 (f=4): [W(4)][62.1%][w=2457MiB/s][w=2457 IOPS][eta 00m:11s]
Jobs: 4 (f=4): [W(4)][63.3%][w=2436MiB/s][w=2436 IOPS][eta 00m:11s]
Jobs: 4 (f=4): [W(4)][64.5%][w=2432MiB/s][w=2431 IOPS][eta 00m:11s]
Jobs: 4 (f=4): [W(4)][67.7%][w=2440MiB/s][w=2440 IOPS][eta 00m:10s]
Jobs: 4 (f=4): [W(4)][71.0%][w=2437MiB/s][w=2437 IOPS][eta 00m:09s]
Jobs: 4 (f=4): [W(4)][74.2%][w=2442MiB/s][w=2442 IOPS][eta 00m:08s]
Jobs: 4 (f=4): [W(4)][77.4%][w=2425MiB/s][w=2424 IOPS][eta 00m:07s]
Jobs: 4 (f=4): [W(4)][80.6%][w=2459MiB/s][w=2459 IOPS][eta 00m:06s]
Jobs: 4 (f=4): [W(4)][86.7%][w=2428MiB/s][w=2427 IOPS][eta 00m:04s]
Jobs: 4 (f=4): [W(4)][90.0%][w=2441MiB/s][w=2440 IOPS][eta 00m:03s]
Jobs: 4 (f=4): [W(4)][93.3%][w=2438MiB/s][w=2437 IOPS][eta 00m:02s]
Jobs: 4 (f=4): [W(4)][96.7%][w=2450MiB/s][w=2449 IOPS][eta 00m:01s]
Jobs: 4 (f=4): [W(4)][100.0%][w=2430MiB/s][w=2430 IOPS][eta 00m:00s]
Jobs: 4 (f=4): [F(4)][100.0%][w=2372MiB/s][w=2372 IOPS][eta 00m:00s]

5.15 fio performance detail:
Jobs: 4 (f=4): [W(4)][14.3%][w=8563MiB/s][w=8563 IOPS][eta 00m:18s]
Jobs: 4 (f=4): [W(4)][18.2%][w=6376MiB/s][w=6375 IOPS][eta 00m:18s]
Jobs: 4 (f=4): [W(4)][20.8%][w=4566MiB/s][w=4565 IOPS][eta 00m:19s]
Jobs: 4 (f=4): [W(4)][23.1%][w=3947MiB/s][w=3947 IOPS][eta 00m:20s]
Jobs: 4 (f=4): [W(4)][25.9%][w=4601MiB/s][w=4601 IOPS][eta 00m:20s]
Jobs: 4 (f=4): [W(4)][28.6%][w=5797MiB/s][w=5796 IOPS][eta 00m:20s]
Jobs: 4 (f=4): [W(4)][32.1%][w=6802MiB/s][w=6801 IOPS][eta 00m:19s]
Jobs: 4 (f=4): [W(4)][35.7%][w=7411MiB/s][w=7411 IOPS][eta 00m:18s]
Jobs: 4 (f=4): [W(4)][40.7%][w=8445MiB/s][w=8444 IOPS][eta 00m:16s]
Jobs: 4 (f=4): [W(4)][46.2%][w=7992MiB/s][w=7992 IOPS][eta 00m:14s]
Jobs: 4 (f=4): [W(4)][52.0%][w=8118MiB/s][w=8117 IOPS][eta 00m:12s]
Jobs: 4 (f=4): [W(4)][56.0%][w=7742MiB/s][w=7741 IOPS][eta 00m:11s]
Jobs: 4 (f=4): [W(4)][62.5%][w=7497MiB/s][w=7496 IOPS][eta 00m:09s]
Jobs: 4 (f=4): [W(4)][66.7%][w=7248MiB/s][w=7248 IOPS][eta 00m:08s]
Jobs: 4 (f=4): [W(4)][70.8%][w=7461MiB/s][w=7460 IOPS][eta 00m:07s]
Jobs: 4 (f=4): [W(4)][75.0%][w=7959MiB/s][w=7959 IOPS][eta 00m:06s]
Jobs: 4 (f=4): [W(3),F(1)][79.2%][w=6982MiB/s][w=6982 IOPS][eta 00m:05s]
Jobs: 1 (f=1): [_(2),W(1),_(1)][87.0%][w=2809MiB/s][w=2808 IOPS][eta 00m:03s]
Jobs: 1 (f=1): [_(2),W(1),_(1)][95.5%][w=2669MiB/s][w=2668 IOPS][eta 00m:01s]
Jobs: 1 (f=1): [_(2),F(1),_(1)][100.0%][w=2552MiB/s][w=2552 IOPS][eta 00m:00s]


3, 'sysctl -a |grep dirty'  of 6.1.x and 5.15.x
vm.dirty_background_bytes = 1073741824
vm.dirty_background_ratio = 0
vm.dirty_bytes = 8589934592
vm.dirty_expire_centisecs = 600
vm.dirty_ratio = 0
vm.dirty_writeback_centisecs = 200
vm.dirtytime_expire_seconds = 43200

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/05/08


