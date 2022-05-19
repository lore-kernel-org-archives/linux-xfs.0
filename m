Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E1FC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 17:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242148AbiESRIu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 13:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiESRIt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 13:08:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F3D9BAEF
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 10:08:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5A58B8276B
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 17:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEB5C385AA;
        Thu, 19 May 2022 17:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652980125;
        bh=TN1yT0gf70oVjeoMumCnpQpMsPVOdE5YwPMAWCbV8Qo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WThhnWVnmybjQOpaFccwR/7heHLndLhcNkIqUQXCBMvwPGflgx0G0JP5BfMNtHfNx
         E6aluPRz5CFC2/eEP6p0IDFOJzWTzeldIju6t7xuENT4625EG6ZaIcZHeL4P5VzeaO
         m/ssIMv90igPlklD3p/mjxUUY2rczFUqjHodwVakeaBm68xCsl9oN17z1nxg50Y5vG
         jvp0/ML5PyJKwnBsaRqNxkMUuQibL32aDtp5SSMNUpFeAW9yfLVqRz0d1jkfJn0Ohu
         n4hF0JwFdUD/9aX6xNmwBUYHGqy/oE2o6lrHANY/SQsDhHgtHPY6ZyKUaxMsTnrwgU
         8IaKQ+vBBXuAA==
Date:   Thu, 19 May 2022 10:08:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: convert buf_cancel_table allocation to
 kmalloc_array
Message-ID: <YoZ5nFI7fNSmFYCB@magnolia>
References: <165290012335.1646290.10769144718908005637.stgit@magnolia>
 <165290014021.1646290.13716646283504726941.stgit@magnolia>
 <YoYBqe1I5fjl9Dfl@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoYBqe1I5fjl9Dfl@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 19, 2022 at 01:36:57AM -0700, Christoph Hellwig wrote:
> On Wed, May 18, 2022 at 11:55:40AM -0700, Darrick J. Wong wrote:
> > +	p = kmalloc_array(XLOG_BC_TABLE_SIZE, sizeof(struct list_head),
> > +			GFP_KERNEL | __GFP_NOWARN);
> 
> Why the __GFP_NOWARN?

It's a straight port of xfs_km_flags_t==0, which is what the old code
did.  I suspect it doesn't make any practical difference since at most
this will be allocating 1k of memory.  Want me to make it GFP_KERNEL
only?

--D
