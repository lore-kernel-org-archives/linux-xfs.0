Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7329C4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 20:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D7F72389F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 20:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgLGUnj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 15:43:39 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:56826 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725814AbgLGUnj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 15:43:39 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 9DE13106DBF;
        Tue,  8 Dec 2020 07:42:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kmNLO-001Z9T-1x; Tue, 08 Dec 2020 07:42:50 +1100
Date:   Tue, 8 Dec 2020 07:42:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] [RFC] xfs: initialise attr fork on inode create
Message-ID: <20201207204250.GU3913616@dread.disaster.area>
References: <20201202232724.1730114-1-david@fromorbit.com>
 <20201207173111.GA21651@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207173111.GA21651@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=7-415B0cAAAA:8
        a=3r27D0jGJgoq2iKSdL4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 05:31:11PM +0000, Christoph Hellwig wrote:
> Btw, while looking at the code before replying to Casey I noticed
> something else in this area of code which we should probably fix
> if we touch all this.  We are really supposed to create the ACLs
> and security labels atomically with the actual inode creation.  And
> I think we have all the infrastructure to do this without too much
> pain now for ACLs.  Security labels with the weird
> security_inode_init_security interface might be a little harder but
> not impossible.

Yes, that's long been a known problem - it was a problem way back in
the day for DMF and the DMAPI attributes that needed to be added at
create time. That's where XFS_TRANS_RESERVE originally came from, so
that ENOSPC didn't prevent the dmapi xattr from being added to a
newly created inode.

This atomicity problem is one of the things that Allison's attribute
defer-op rework is intended to address.  i.e. being able to
atomically create xattrs at inode create time and have them fully
recoverable by intent replay if the initial inode allocation and
directory linkage transaction succeeds.

Essential the transaction context would start in
xfs_generic_create(), not xfs_create(), and roll through to the
xattr creations for ACLs and security contexts...

> And I suspect security_inode_init_security might be right thing
> to reuse for the helper to figure out what attrs would be set.

Problem is that it appears to need an inode to already be allocated
and instantiated to work....

> If
> security_inode_init_security with an idempotent callback is
> idempotent itself we might be able to use it directly, but all the
> weird hooking makes it rather hard to read.

Yeah, it's like a layer of inscrutible obscurity has been added to a
simple ops table... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
