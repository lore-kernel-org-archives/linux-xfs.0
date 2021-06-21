Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24EEC48BE5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 06:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C694761040
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 06:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFUGlC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 02:41:02 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:36178 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229576AbhFUGlC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jun 2021 02:41:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=eguan@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Ud6M3lq_1624257525;
Received: from localhost(mailfrom:eguan@linux.alibaba.com fp:SMTPD_---0Ud6M3lq_1624257525)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 21 Jun 2021 14:38:45 +0800
Date:   Mon, 21 Jun 2021 14:38:45 +0800
From:   Eryu Guan <eguan@linux.alibaba.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Eryu Guan <guaneryu@gmail.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>,
        ebiggers@kernel.org
Subject: Re: [PATCH 07/13] fstests: automatically generate group files
Message-ID: <20210621063845.GG60846@e18g06458.et15sqa>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370437774.3800603.15907676407985880109.stgit@locust>
 <YMmpDGT9b4dBdSh2@infradead.org>
 <20210617001320.GK158209@locust>
 <YMsAEQsNhI1Y5JR8@infradead.org>
 <20210617171500.GC158186@locust>
 <YMyjgGEuLLcid9i+@infradead.org>
 <CAOQ4uxjvkJh2XcfDgj7g+JUkFXEc36_6YOKQHJ=pX2hpGfUDhQ@mail.gmail.com>
 <20210618155630.GE158209@locust>
 <YNAiutsL1f/KoBXM@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNAiutsL1f/KoBXM@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 21, 2021 at 06:25:14AM +0100, Christoph Hellwig wrote:
> On Fri, Jun 18, 2021 at 08:56:30AM -0700, Darrick J. Wong wrote:
> > On Fri, Jun 18, 2021 at 06:32:18PM +0300, Amir Goldstein wrote:
> > > On Fri, Jun 18, 2021 at 4:47 PM Christoph Hellwig <hch@infradead.org> wrote:
> > > >
> > > > On Thu, Jun 17, 2021 at 10:15:00AM -0700, Darrick J. Wong wrote:
> > > > > I suppose I could make the '-g' switch call 'make group.list', though
> > > > > that's just going to increase the amount of noise for anyone like me who
> > > > > runs fstests with a mostly readonly rootfs.
> > > >
> > > > Just stick to the original version and see if anyone screams loud
> > > 
> > > What is the original version?
> > 
> > Assuming the developer is smart enough to run 'make all install' before
> > running fstests.
> 
> So install is also required now?  I have never before installed xfstests
> I think.

No, install is not required, but running make after updating fstests is
required, at least some tests may introduce new test binary in src and
the binary is missing if you don't run make. So I think make is fine
after updating fstests.

Thanks,
Eryu
