Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75486C41621
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 09:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FA8A208E0
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 09:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgCXJnv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 05:43:51 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:36088 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726962AbgCXJnv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 05:43:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=eguan@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0TtVSrO8_1585043022;
Received: from localhost(mailfrom:eguan@linux.alibaba.com fp:SMTPD_---0TtVSrO8_1585043022)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 24 Mar 2020 17:43:43 +0800
Date:   Tue, 24 Mar 2020 17:43:42 +0800
From:   Eryu Guan <eguan@linux.alibaba.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     guaneryu@gmail.com, jtulak@redhat.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org, Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Subject: Re: [PATCH] xfstests: remove xfs/191-input-validation
Message-ID: <20200324094342.GI47669@e18g06458.et15sqa>
References: <20200318172115.1120964-1-hch@lst.de>
 <20200319043306.GK14282@dhcp-12-102.nay.redhat.com>
 <20200324084304.GA25318@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324084304.GA25318@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 09:43:04AM +0100, Christoph Hellwig wrote:
> On Thu, Mar 19, 2020 at 12:33:06PM +0800, Zorro Lang wrote:
> > On Wed, Mar 18, 2020 at 06:21:15PM +0100, Christoph Hellwig wrote:
> > > This test has constantly failed since it was added, and the promised
> > > input validation never materialized.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > 
> > Hmm... that's truth this case always fails. But a mkfs.xfs sanity test is
> > good.
> > 
> > We have a RHEL internal mkfs.xfs sanity test case, but it takes long time to
> > run, can't port to xfstests directly.
> > I don't know if Jan would like to improve this case, might make it simple,
> > remove those unstable test lines, rewrite the case to avoid unstable test
> > results? Or we remove this case, then write a new one?
> > I can do that too, if the xfs-devel thinks it worth.
> 
> Fine with me, but we really need to get rid of tests failing for no
> good reason.  And given that there hasn't been any action for years
> just removing this test seems like the by far best option.

Yang Xu had sent patch[1] to fix xfs/191 last June, but it needed ack
from XFS developers back then, and fell out off radar eventually.

Do we want to pick & review it again?

Thanks,
Eryu

[1] https://lore.kernel.org/fstests/1560929963-2372-1-git-send-email-xuyang2018.jy@cn.fujitsu.com/
