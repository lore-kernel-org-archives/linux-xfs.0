Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B80C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Feb 2022 11:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbiBRLbD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Feb 2022 06:31:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbiBRLbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Feb 2022 06:31:03 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D09E2AF906;
        Fri, 18 Feb 2022 03:30:46 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V4p.agV_1645183842;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0V4p.agV_1645183842)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 18 Feb 2022 19:30:43 +0800
Date:   Fri, 18 Feb 2022 19:30:42 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: add missing cmap->br_state = XFS_EXT_NORM update
Message-ID: <Yg+DYkuTayILe5YA@B-P7TQMD6M-0146.local>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220217095542.68085-1-hsiangkao@linux.alibaba.com>
 <20220218054032.GO8313@magnolia>
 <Yg802fTm0n31FC+T@B-P7TQMD6M-0146.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yg802fTm0n31FC+T@B-P7TQMD6M-0146.local>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 18, 2022 at 01:55:37PM +0800, Gao Xiang wrote:
> Hi Darrick,
> 
> On Thu, Feb 17, 2022 at 09:40:32PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 17, 2022 at 05:55:42PM +0800, Gao Xiang wrote:
> > > COW extents are already converted into written real extents after
> > > xfs_reflink_convert_cow_locked(), therefore cmap->br_state should
> > > reflect it.
> > > 
> > > Otherwise, there is another necessary unwritten convertion
> > > triggered in xfs_dio_write_end_io() for direct I/O cases.
> > > 
> > > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > 
> > I /think/ this looks ok.  Does it test ok too?  AFAICT nothing in the
> > iomap/writeback machinery cares the incorrect state because we always
> > set IOMAP_F_SHARED (which triggers COW) so I think this is simply a fix
> > for directio, like you said?
> 
> Yeah, I think so, from the code logic buffered i/o seems no impacted...
> And the unnecessary unwritten convertion under direct i/o takes
> noticeable extra overhead in our workloads...
> 
> I checked my last night xfstests, it seems it stops unexpectedly (maybe
> due to some environmental problem). I will rerun tests today and
> feedback later.

On my test environment machine, with linux 5.17-rc4,
both w/ and w/o the patch, it fails:

generic/594 generic/600 xfs/158 xfs/160

I think no issue with this patch.

Thanks,
Gao Xiang
