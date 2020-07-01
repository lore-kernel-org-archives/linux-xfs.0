Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14244C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 22:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B1B20780
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 22:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgGAWG2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 18:06:28 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:48671 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725771AbgGAWG2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 18:06:28 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id D78385ECF07;
        Thu,  2 Jul 2020 08:06:25 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqks5-0000ft-D4; Thu, 02 Jul 2020 08:06:25 +1000
Date:   Thu, 2 Jul 2020 08:06:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: track unlinked inodes in core inode
Message-ID: <20200701220625.GV2005@dread.disaster.area>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-4-david@fromorbit.com>
 <20200701085904.GB10152@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701085904.GB10152@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=ZhPaH392S4mT5zdtkEoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 04:59:04PM +0800, Gao Xiang wrote:
> On Tue, Jun 23, 2020 at 07:50:14PM +1000, Dave Chinner wrote:
> 
> ...
> 
> > +static struct xfs_inode *
> > +xfs_iunlink_ilookup(
> >  	struct xfs_perag	*pag,
> >  	xfs_agino_t		agino)
> >  {
> > -	struct xfs_iunlink	*iu;
> > +	struct xfs_mount	*mp = pag->pag_mount;
> > +	struct xfs_inode	*ip;
> >  
> > -	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &agino,
> > -			xfs_iunlink_hash_params);
> 
> Just notice that when working on this patchset. Since pagi_unlinked_hash
> is unused now, let's kill pagi_unlinked_hash in xfs_perag as well.
> 
> typedef struct xfs_perag {
> ...
> struct rhashtable       pagi_unlinked_hash;
> ...
> };

Good catch. I'll remove that for the next iteration.

> Also I noticed xfs_iunlink_insert_inode and xfs_iunlink_remove_inode
> are used once now, maybe folding into the caller would be better...
> (Just my personal thought...)

I used them to make it obvious what operation was being performed on
the unlinked list. In the end they might be simple enough to remove,
but when I first wrote this patch is was necessary to document what
operations were being performed by the code rather than it just
being a big tangle of spagetti...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
