Return-Path: <SRS0=ZMk+=CA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE155C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 09:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6B9E21734
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 09:01:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cUEqJ6ZY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgHVJBx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Aug 2020 05:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgHVJBv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 05:01:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C24DC061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 02:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mEMyxLbg5BRfCtIyPnBukYwp2EUQro2YWM2HVgMH61I=; b=cUEqJ6ZYoB1oLN7bJA5aJgAvTQ
        g/3wN5DpIdHeBKWUm9a67XPO+unDbRTU9XGnX/kC1Peqs+fbg06ajGJHrYcJIJibJjBDrvzOnXfpX
        VDxZ9CziUJKJxTXJ4ysLKzwboCJLhjNpniOgPtChBA3hf7Fu9KsXC3t3Iv/nFDo0oLleo1vVk82UU
        WslRc7AsMMsuubppbeGwK/uM1H1u28uUqZ9FKi18eYR14WAzXTjpbw/MHw7nX4+74qHBz2J0FGmno
        4N6tbbfwTvhOyKM8EDZ1Mc6pef33SiLHUZXUgIQD4F0GUp5p//LwmrGz6Dl1nfoofqE8I8SxHW8FB
        952SaVaQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9PPF-0006qX-K9; Sat, 22 Aug 2020 09:01:45 +0000
Date:   Sat, 22 Aug 2020 10:01:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: arrange all unlinked inodes into one list
Message-ID: <20200822090145.GA25623@infradead.org>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-5-david@fromorbit.com>
 <20200818235959.GR6096@magnolia>
 <20200819005830.GA20276@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819005830.GA20276@xiangao.remote.csb>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 19, 2020 at 08:58:30AM +0800, Gao Xiang wrote:
> btw, if my understanding is correct, as I mentioned starting from my v1,
> this new feature isn't forward compatible since old kernel hardcode
> agino % XFS_AGI_UNLINKED_BUCKETS but not tracing original bucket_index
> from its logging recovery code. So yeah, a bit awkward from its original
> design...

I think we should add a log_incompat feature just to be safe.
