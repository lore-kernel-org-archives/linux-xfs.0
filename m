Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CB6C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC8A961059
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbhESXgn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 19:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhESXgm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 May 2021 19:36:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 544CC60FE3;
        Wed, 19 May 2021 23:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621467322;
        bh=TA2+WPpXUqZyElUryUrHbxDBiJNjKYL+Ipg/4i110qM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DQqDvFhyNgbTPNxxWDiIRhJSEQx0W1YPnAWiI9nezKZp5PnRvoCXKOQ0TVS4dNOqJ
         WnPkoCL5i5NakirpZ3qn5+vbDRxEBA8olJjvXY3YEgS2fi1pbe4dL5/xpfbJSK8FG7
         xDny0Qr5Y+9akeGK46rCRewrzceVzK/TL5ZauXnUZu40+XzvPsOV+ybzHGRt+jyL0x
         J+W97d2+Omds8LFmcRrOOU6DUG8jwQJN9mKYHuqOoAaTGmo0RuKRPOQHUk8ux5h6ZN
         9E+UMLcuvh5Nxa/gfRHs6BCloLv2bwtj8nzdrvN5zzmQbj70sz6HzlfY69188u4dQE
         ComGlWUwFaAjQ==
Date:   Wed, 19 May 2021 16:35:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix deadlock retry tracepoint arguments
Message-ID: <20210519233521.GU9675@magnolia>
References: <162086768823.3685697.11936501771461638870.stgit@magnolia>
 <162086769410.3685697.9016566085994934364.stgit@magnolia>
 <YKUQlmmHxWDubKHT@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKUQlmmHxWDubKHT@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 02:20:22PM +0100, Christoph Hellwig wrote:
> On Wed, May 12, 2021 at 06:01:34PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > sc->ip is the inode that's being scrubbed, which means that it's not set
> > for scrub types that don't involve inodes.  If one of those scrubbers
> > (e.g. inode btrees) returns EDEADLOCK, we'll trip over the null pointer.
> > Fix that by reporting either the file being examined or the file that
> > was used to call scrub.
> 
> Without an indication of which one we trace this is a little weird,
> isn't it?  Still better than a crash, though..

The scrub type is also encoded in the tracepoint, so we can tell that
the inode number is meaningless.

--D
