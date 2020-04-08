Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0218C2D0F4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 22:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9925B20730
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 22:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgDHWpd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 18:45:33 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46120 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726469AbgDHWpd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 18:45:33 -0400
Received: from dread.disaster.area (pa49-180-125-11.pa.nsw.optusnet.com.au [49.180.125.11])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3A04A3A3507;
        Thu,  9 Apr 2020 08:45:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jMJRn-0005L2-Nc; Thu, 09 Apr 2020 08:45:27 +1000
Date:   Thu, 9 Apr 2020 08:45:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, chandan@linux.ibm.com,
        bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Message-ID: <20200408224527.GN24067@dread.disaster.area>
References: <20200404085203.1908-1-chandanrlinux@gmail.com>
 <20200404085203.1908-3-chandanrlinux@gmail.com>
 <20200406170603.GD6742@magnolia>
 <20200406233002.GD21885@dread.disaster.area>
 <20200408154512.GA6741@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408154512.GA6741@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=2h+yFbpuifLtD1c++IMymA==:117 a=2h+yFbpuifLtD1c++IMymA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10
        a=7-415B0cAAAA:8 a=JPFhGo0VOn1Im-IpDp4A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 08, 2020 at 08:45:12AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 07, 2020 at 09:30:02AM +1000, Dave Chinner wrote:
> > Long story short - there's no degradation in
> > performance in the dabtree out to tens of millions of records with
> > different fixed size or random sized attributes, nor does various
> > combinations of insert/lookup/remove/replace operations seem to
> > impact the tree performance at scale. IOWs, we hit the 16 bit extent
> > limits of the attribute trees without finding any degradation in
> > performance.
> 
> Ok.  I'll take "attr v3 upgrade" off my list of things to look out for.
> 
> > Hence we concluded that the dabtree structure does not require
> > significant modification or optimisation to work well with typical
> > parent pointer attribute demands...
> > 
> > As for free space indexes....
> > 
> > The issue with the directory structure that requires external free
> > space is that the directory data is not part of the dabtree itself.
> > The attribute fork stores all the attributes at the leaves of the
> > dabtree, while the directory structure stores the directory data in
> > external blocks and the dabtree only contains the name hash index
> > that points to the external data.
> > 
> > i.e. When we add an attribute to the dabtree, we split/merge leaves
> > of the tree based on where the name hash index tells us it needs to
> > be inserted/removed from. i.e. we make space available or collapse
> > sparse leaves of the dabtree as a side effect of inserting or
> > removing objects.
> > 
> > The directory structure is very different. The dirents cannot change
> > location as their logical offset into the dir data segment is used
> > as the readdir/seekdir/telldir cookie. Therefore that location is
> > not allowed to change for the life of the dirent and so we can't
> > store them in the leaves of a dabtree indexed in hash order because
> > the offset into the tree would change as other entries are inserted
> > and removed.  Hence when we remove dirents, we must leave holes in
> > the data segment so the rest of the dirent data does not change
> > logical offset.
> > 
> > The directory name hash index - the dabtree bit - is in a separate
> > segment (the 2nd one). Because it only stores pointers to dirents in
> > the data segment, it doesn't need to leave holes - the dabtree just
> > merge/splits as required as pointers to the dir data segment are
> > added/removed - and has no free space tracking.
> > 
> > Hence when we go to add a dirent, we need to find the best free
> > space in the dir data segment to add that dirent. This requires a
> > dir data segment free space index, and that is held in the 3rd dir
> > segment.  Once we've found the best free space via lookup in the
> > free space index, we go modify the dir data block it points to, then
> > update the dabtree to point the name hash at that new dirent.
> > 
> > IOWs, the requirement for a free space map in the directory
> > structure results from storing the dirent data externally to the
> > dabtree. Attributes are stored directly in the leaves of the
> > dabtree - except for remote attributes which can be anywhere in the
> > BMBT address space - and hence do no need external free space
> > tracking to determine where to best insert them...
> 
> <nod> Got it.  I've suspected this property about the xattr structures
> for a long time, so I'm glad to hear someone else echo that. :)
> 
> Dave: May I try to rework the above into something suitable for the
> ondisk format documentation?

Sure. Anything that helps people understand the complexity of the
directory data structure is a good thing :)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
