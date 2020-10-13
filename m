Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9985AC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 15:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A47025220
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 15:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbgJMP4L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 11:56:11 -0400
Received: from out20-61.mail.aliyun.com ([115.124.20.61]:52938 "EHLO
        out20-61.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbgJMP4K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 11:56:10 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.09496473|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_social|0.00616385-0.00140248-0.992434;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047207;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.IiizUKW_1602604567;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.IiizUKW_1602604567)
          by smtp.aliyun-inc.com(10.147.40.200);
          Tue, 13 Oct 2020 23:56:08 +0800
Date:   Tue, 13 Oct 2020 23:56:11 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     linux-xfs@vger.kernel.org
Subject: dbench throughput(sync, reflink=0|1) on xfs over hardware throughput
Cc:     wangyugui@e16-tech.com
Message-Id: <20201013235609.EFC0.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.75.01 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

#any reply, please Cc: wangyugui@e16-tech.com

dbench throughput(sync, reflink=0|1) on xfs over hardware
throughput(6Gb/s=750MB/s).

Is this a bug of xfs sync?  or some feature of performance optimization?

we test mkfs.xfs -m reflink=0|1, crc=0|1, still over hardware
throughput(6Gb/s=750MB/s).

Disk: TOSHIBA  PX05SMQ040
This is a 12Gb/s SAS SSD disk, but connect to 6Gb/s SAS HBA,
so it works with 6Gb/s.

dbench -s -t 60 -D /xfs 32
#Throughput 884.406 MB/sec (sync open)


dbench -s -t 60 -D /xfs 1
#Throughput 149.172 MB/sec (sync open)

we test the same disk with ext4 filesystem, 
the throughput is very close to, but less than the hardware limit.

dbench -s -t 60 -D /ext4 32
#Throughput 740.95 MB/sec (sync open)

dbench -s -t 60 -D /ext4 1
#Throughput 124.67 MB/sec (sync open)

linux kernel: 5.4.70, 5.9.0

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2020/10/13


