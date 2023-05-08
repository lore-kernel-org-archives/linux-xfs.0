Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FAD8C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  8 May 2023 09:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbjEHJYP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 May 2023 05:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbjEHJYN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 May 2023 05:24:13 -0400
Received: from out28-82.mail.aliyun.com (out28-82.mail.aliyun.com [115.124.28.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6390C226AE
        for <linux-xfs@vger.kernel.org>; Mon,  8 May 2023 02:24:11 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2331686|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0420147-0.000836042-0.957149;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047192;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=1;RT=1;SR=0;TI=SMTPD_---.SbWHb.N_1683537845;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.SbWHb.N_1683537845)
          by smtp.aliyun-inc.com;
          Mon, 08 May 2023 17:24:05 +0800
Date:   Mon, 08 May 2023 17:24:07 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     linux-xfs@vger.kernel.org
Subject: performance regression between 6.1.x and 5.15.x
Message-Id: <20230508172406.1CF3.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I noticed a performance regression of xfs 6.1.27/6.1.23,
with the compare to xfs 5.15.110.

It is yet not clear whether  it is a problem of xfs or lvm2.

any guide to troubleshoot it?

test case:
  disk: NVMe PCIe3 SSD *4 
  LVM: raid0 default strip size 64K.
  fio -name write-bandwidth -rw=write -bs=1024Ki -size=32Gi -runtime=30
   -iodepth 1 -ioengine sync -zero_buffers=1 -direct=0 -end_fsync=1 -numjobs=4
   -directory=/mnt/test


6.1.27/6.1.23
fio bw=2623MiB/s (2750MB/s)
perf report:
Samples: 330K of event 'cycles', Event count (approx.): 120739812790
Overhead  Command  Shared Object        Symbol
  31.07%  fio      [kernel.kallsyms]    [k] copy_user_enhanced_fast_string
   5.11%  fio      [kernel.kallsyms]    [k] iomap_set_range_uptodate.part.24
   3.36%  fio      [kernel.kallsyms]    [k] asm_exc_nmi
   3.29%  fio      [kernel.kallsyms]    [k] native_queued_spin_lock_slowpath
   2.27%  fio      [kernel.kallsyms]    [k] iomap_write_begin
   2.18%  fio      [kernel.kallsyms]    [k] get_page_from_freelist
   2.11%  fio      [kernel.kallsyms]    [k] xas_load
   2.10%  fio      [kernel.kallsyms]    [k] xas_descend

5.15.110
fio bw=6796MiB/s (7126MB/s)
perf report:
Samples: 267K of event 'cycles', Event count (approx.): 186688803871
Overhead  Command  Shared Object       Symbol
  38.09%  fio      [kernel.kallsyms]   [k] copy_user_enhanced_fast_string
   6.76%  fio      [kernel.kallsyms]   [k] iomap_set_range_uptodate
   4.40%  fio      [kernel.kallsyms]   [k] xas_load
   3.94%  fio      [kernel.kallsyms]   [k] get_page_from_freelist
   3.04%  fio      [kernel.kallsyms]   [k] asm_exc_nmi
   1.97%  fio      [kernel.kallsyms]   [k] native_queued_spin_lock_slowpath
   1.88%  fio      [kernel.kallsyms]   [k] __pagevec_lru_add
   1.53%  fio      [kernel.kallsyms]   [k] iomap_write_begin
   1.53%  fio      [kernel.kallsyms]   [k] __add_to_page_cache_locked
   1.41%  fio      [kernel.kallsyms]   [k] xas_start


Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/05/08


