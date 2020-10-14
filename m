Return-Path: <SRS0=c4da=DV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B98DAC433E7
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 22:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 689E022241
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 22:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgJNWpf convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 18:45:35 -0400
Received: from out20-1.mail.aliyun.com ([115.124.20.1]:46063 "EHLO
        out20-1.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbgJNWpe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 18:45:34 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.03591358|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.088604-0.00230858-0.909087;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047203;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.IjM3JGc_1602715532;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.IjM3JGc_1602715532)
          by smtp.aliyun-inc.com(10.147.41.199);
          Thu, 15 Oct 2020 06:45:32 +0800
Date:   Thu, 15 Oct 2020 06:45:36 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Wang Yugui <wangyugui@e16-tech.com>
Subject: Re: dbench throughput(sync, reflink=0|1) on xfs over hardware throughput
Cc:     linux-xfs@vger.kernel.org
In-Reply-To: <20201014124138.7A0E.409509F4@e16-tech.com>
References: <20201013235609.EFC0.409509F4@e16-tech.com> <20201014124138.7A0E.409509F4@e16-tech.com>
Message-Id: <20201015064535.35D8.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.75.01 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi, 

Thanks a lot fo Dave Chinner,

The 'Throughput' of dbench include not only 'write', but also include
'read' in dbench too.

And 'max_latency' include not only 'write', but also include others too.

1)dbench result example1
WriteX        365460     4.474  2279.808
...
Throughput 385.697 MB/sec (sync open)  32 clients  32 procs  max_latency=2279.818 ms

2)dbench result example2
 WriteX        741543     3.521    16.380
 ...
Throughput 779.972 MB/sec (sync open)  48 clients  48 procs  max_latency=11.246 ms


for ext4, with more clients(32->80),  the Throughput of ext4 is over
6Gb/s too.


Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2020/10/15

> Hi,
> 
> For xfs sync performance optimization, there is an option 'osyncisdsync'
> which is removed in 4.0(man xfs)
> 
> the xfs sync performance optimization in linux 5.4.70/5.9.0 is beyond
> 'osyncisdsync'? When multiple write(sync) at the same time, just some of
> them are guaranteed?
> 
> Or deduplication(based on reflink=1) help the sync write?
> and 'mkfs.xfs -m reflink=0' failed to disable it?
> 
> iotop show that 'Actual DISK WRITE:' is NOT over hardware throughput.
> 
> Best Regards
> Wang Yugui (wangyugui@e16-tech.com)
> 2020/10/14
> 
> > Hi,
> > 
> > #any reply, please Cc: wangyugui@e16-tech.com
> > 
> > dbench throughput(sync, reflink=0|1) on xfs over hardware
> > throughput(6Gb/s=750MB/s).
> > 
> > Is this a bug of xfs sync?  or some feature of performance optimization?
> > 
> > we test mkfs.xfs -m reflink=0|1, crc=0|1, still over hardware
> > throughput(6Gb/s=750MB/s).
> > 
> > Disk: TOSHIBA  PX05SMQ040
> > This is a 12Gb/s SAS SSD disk, but connect to 6Gb/s SAS HBA,
> > so it works with 6Gb/s.
> > 
> > dbench -s -t 60 -D /xfs 32
> > #Throughput 884.406 MB/sec (sync open)
> > 
> > 
> > dbench -s -t 60 -D /xfs 1
> > #Throughput 149.172 MB/sec (sync open)
> > 
> > we test the same disk with ext4 filesystem, 
> > the throughput is very close to, but less than the hardware limit.
> > 
> > dbench -s -t 60 -D /ext4 32
> > #Throughput 740.95 MB/sec (sync open)
> > 
> > dbench -s -t 60 -D /ext4 1
> > #Throughput 124.67 MB/sec (sync open)
> > 
> > linux kernel: 5.4.70, 5.9.0
> > 
> > Best Regards
> > Wang Yugui (wangyugui@e16-tech.com)
> > 2020/10/13
> > 
> 


