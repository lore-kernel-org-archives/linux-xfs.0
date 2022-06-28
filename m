Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38665C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 22:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiF1WZP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 18:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiF1WYs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 18:24:48 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A78D3E0D6
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 15:21:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1784F5ECC3B;
        Wed, 29 Jun 2022 08:21:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6Jag-00CEek-Mc; Wed, 29 Jun 2022 08:21:50 +1000
Date:   Wed, 29 Jun 2022 08:21:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH V2] xfs: make src file readable during reflink
Message-ID: <20220628222150.GK227878@dread.disaster.area>
References: <20220624191037.23683-1-wen.gang.wang@oracle.com>
 <5ED436A4-6BBF-4868-BF42-3CAC7B90BCCA@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ED436A4-6BBF-4868-BF42-3CAC7B90BCCA@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62bb7f00
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=NRD0DPY9OXsKKrBbQIAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 03:57:14PM +0000, Wengang Wang wrote:
> Hi Darrick,
> 
> How about the V2?
> 
> thanks,
> wengang
> 
> > On Jun 24, 2022, at 12:10 PM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> > 
> > During a reflink operation, the IOLOCK and MMAPLOCK of the source file
> > are held in exclusive mode for the duration. This prevents reads on the
> > source file, which could be a very long time if the source file has
> > millions of extents.
> > 
> > As the source of copy, besides some necessary modification (say dirty page
> > flushing), it plays readonly role. Locking source file exclusively through
> > out the full reflink copy is unreasonable.
> > 
> > This patch downgrades exclusive locks on source file to shared modes after
> > page cache flushing and before cloning the extents. To avoid source file
> > change after lock downgradation, direct write paths take IOLOCK_EXCL on
> > seeing reflink copy happening to the files.
> > 
> > Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> > ---
> > V2 changes:
> > Commit message
> > Make direct write paths take IOLOCK_EXCL when reflink copy is happening
> > Tiny changes

Version 2 never made it to the list. Please resend.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
