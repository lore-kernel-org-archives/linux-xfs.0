Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A2FC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 01:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52D6260E53
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 01:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbhJMBFB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 21:05:01 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:37086 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233371AbhJMBFB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Oct 2021 21:05:01 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 92D178C25F;
        Wed, 13 Oct 2021 12:02:57 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1maSfZ-005aKP-1x; Wed, 13 Oct 2021 12:02:57 +1100
Date:   Wed, 13 Oct 2021 12:02:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 03/15] xfs: don't track firstrec/firstkey separately in
 xchk_btree
Message-ID: <20211013010257.GU2361455@dread.disaster.area>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408157028.4151249.16573862981315637553.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163408157028.4151249.16573862981315637553.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61663041
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=NYPyDbIded_ECPZrPYsA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 04:32:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The btree scrubbing code checks that the records (or keys) that it finds
> in a btree block are all in order by calling the btree cursor's
> ->recs_inorder function.  This of course makes no sense for the first
> item in the block, so we switch that off with a separate variable in
> struct xchk_btree.
> 
> Christoph helped me figure out that the variable is unnecessary, since
> we just accessed bc_ptrs[level] and can compare that against zero.  Use
> that, and save ourselves some memory space.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Yup, took a little bit of reading to work it out, but it looks
correct.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
