Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F42C07E99
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 23:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA37561964
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 23:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhGEXXC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jul 2021 19:23:02 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:48367 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229733AbhGEXXB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jul 2021 19:23:01 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UeszRGy_1625527221;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UeszRGy_1625527221)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 06 Jul 2021 07:20:22 +0800
Date:   Tue, 6 Jul 2021 07:20:21 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reset child dir '..' entry when unlinking child
Message-ID: <YOOTtQoRfAay1Hhs@B-P7TQMD6M-0146.local>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
References: <20210703030233.GD24788@locust>
 <20210705220925.GN664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210705220925.GN664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave and Christoph,

On Tue, Jul 06, 2021 at 08:09:25AM +1000, Dave Chinner wrote:
> On Fri, Jul 02, 2021 at 08:02:33PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > While running xfs/168, I noticed a second source of post-shrink
> > corruption errors causing shutdowns.
> > 
> > Let's say that directory B has a low inode number and is a child of
> > directory A, which has a high number.  If B is empty but open, and
> > unlinked from A, B's dotdot link continues to point to A.  If A is then
> > unlinked and the filesystem shrunk so that A is no longer a valid inode,
> > a subsequent AIL push of B will trip the inode verifiers because the
> > dotdot entry points outside of the filesystem.
> 
> So we have a directory inode that is empty and unlinked but held
> open, with a back pointer to an invalid inode number? Which can
> never be followed, because the directory has been unlinked.
> 
> Can't this be handled in the inode verifier? This seems to me to
> be a pretty clear cut case where the ".." back pointer should
> always be considered invalid (because the parent dir has no
> existence guarantee once the child has been removed from it), not
> just in the situation where the filesystem has been shrunk...

Yes, I agree all of this, this field can be handled by the inode
verifier. The only concern I can think out might be fs freeze
with a directory inode that is empty and unlinked but held open,
and then recovery on a unpatched old kernels, not sure if such
case can be handled properly by old kernel verifier.

Otherwise, it's also ok I think.

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
