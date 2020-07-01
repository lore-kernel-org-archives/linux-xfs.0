Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F6BC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 22:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC94A2082F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 22:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgGAWnA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 18:43:00 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:60648 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726114AbgGAWnA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 18:43:00 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id A749DD7915B;
        Thu,  2 Jul 2020 08:42:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqlRR-0000rm-2U; Thu, 02 Jul 2020 08:42:57 +1000
Date:   Thu, 2 Jul 2020 08:42:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/18] xfs: clear XFS_DQ_FREEING if we can't lock the
 dquot buffer to flush
Message-ID: <20200701224257.GZ2005@dread.disaster.area>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353171640.2864738.7967439700762859129.stgit@magnolia>
 <20200701083358.GA25171@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701083358.GA25171@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=LzeFFNRhbkwz88AI5wwA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 09:33:58AM +0100, Christoph Hellwig wrote:
> On Tue, Jun 30, 2020 at 08:41:56AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In commit 8d3d7e2b35ea, we changed xfs_qm_dqpurge to bail out if we
> > can't lock the dquot buf to flush the dquot.  This prevents the AIL from
> > blocking on the dquot, but it also forgets to clear the FREEING flag on
> > its way out.  A subsequent purge attempt will see the FREEING flag is
> > set and bail out, which leads to dqpurge_all failing to purge all the
> > dquots.  This causes unmounts and quotaoff operations to hang.
> > 
> > Fixes: 8d3d7e2b35ea ("xfs: trylock underlying buffer on dquot flush")
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Looks like Dave submitted this as a separate fix just after you..

Ah, I didn't look at this patchset yesterday so didn't notice that
Darrick had already posted it. I'm happy for this version to be
merged...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
