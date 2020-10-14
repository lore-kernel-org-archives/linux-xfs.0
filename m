Return-Path: <SRS0=c4da=DV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00FAC433E7
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 22:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A4FD2223F
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 22:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgJNWnj convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 18:43:39 -0400
Received: from out20-109.mail.aliyun.com ([115.124.20.109]:36168 "EHLO
        out20-109.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbgJNWnj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 18:43:39 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08754819|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_news_journal|0.2243-0.00424564-0.771454;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047187;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.IjLxN2I_1602715416;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.IjLxN2I_1602715416)
          by smtp.aliyun-inc.com(10.147.42.22);
          Thu, 15 Oct 2020 06:43:36 +0800
Date:   Thu, 15 Oct 2020 06:43:40 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Dave Chinner <david@fromorbit.com>
Subject: Re: dbench throughput on xfs over hardware limit(6Gb/s)
Cc:     linux-xfs@vger.kernel.org
In-Reply-To: <20201014212458.GC7391@dread.disaster.area>
References: <20201014113211.2372.409509F4@e16-tech.com> <20201014212458.GC7391@dread.disaster.area>
Message-Id: <20201015064339.35D4.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.75.01 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

> Reads can still be served from the page cache without doing physical
> IO.

You are right.

for ext4, with more clients(32->80),  the Throughput of ext4 is over
6Gb/s too.

the 'Throughput' of dbench include not only 'write', but also include
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

Thanks a lot.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2020/10/15


