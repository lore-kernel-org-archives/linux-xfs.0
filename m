Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01156C4CECD
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 02:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2F29218AC
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 02:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfIRCvx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Sep 2019 22:51:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfIRCvx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Sep 2019 22:51:53 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 14C91308212D;
        Wed, 18 Sep 2019 02:51:53 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80DC35C21A;
        Wed, 18 Sep 2019 02:51:52 +0000 (UTC)
Date:   Wed, 18 Sep 2019 10:59:15 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "Xu, Yang" <xuyang2018.jy@cn.fujitsu.com>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: question of xfs/148 and xfs/149
Message-ID: <20190918025915.GK7239@dhcp-12-102.nay.redhat.com>
References: <4BF2FD5A942B1C4B828DDAF5635768C1041AB0E2@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20190917163933.GC736475@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917163933.GC736475@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 18 Sep 2019 02:51:53 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 17, 2019 at 09:39:33AM -0700, Darrick J. Wong wrote:
> [add linux-xfs to cc]
> 
> On Tue, Sep 17, 2019 at 09:00:57AM +0000, Xu, Yang wrote:
> > HI All
> > 
> > When I investigated xfs/030 failure on upstream kernel after mering
> > xfstests commit d0e484ac699f ("check: wipe scratch devices between
> > tests"), I found two similar cases(xfs/148,xfs/149).

xfs/030 is weird, I've found it long time ago.

If I do a 'whole disk mkfs' (_scratch_mkfs_xfs), before this sized mkfs:

  _scratch_mkfs_xfs $DSIZE >/dev/null 2>&1

Everything looks clear, and test pass. I can't send a patch to do this,
because I don't know the reason.

I'm not familiar with xfs_repair so much, so I don't know what happens
underlying. I suppose the the part after the $DSIZE affect the xfs_repair,
but I don't know why the wipefs can cause that, wipefs only erase 4 bytes
at the beginning.

Darrick, do you know more about that?

Thanks,
Zorro

> > 
> > xfs/148 is a clone of test 030 using xfs_prepair64 instead of xfs_repair.
> > xfs/149 is a clone of test 031 using xfs_prepair instead of xfs_repair

I'm not worried about it too much, due to it always 'not run' and never
fails:)

xfs/148 [not run] parallel repair binary xfs_prepair64 is not installed
xfs/149 [not run] parallel repair binary xfs_prepair is not installed
Ran: xfs/148 xfs/149
Not run: xfs/148 xfs/149
Passed all 2 tests

> > 
> > But I don't find these two commands and know nothing about them.  If
> > these commands have been obsoleted long time ago, I think we can
> > remove the two cases. Or may I miss something?
> 
> <shrug> I think your analysis is correct, but let's see what the xfs
> list thinks.
> 
> --D
> 
> > 
> > Thanks
> > Yang Xu
> > 
> > 
