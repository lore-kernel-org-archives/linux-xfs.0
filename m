Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9C4C3405F
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 18:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E298224672
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 18:46:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sVH/4jhw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgBSSq0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 13:46:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52922 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgBSSq0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 13:46:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uKn+FcObrSNqlgB+7OeiZL+lfEksvm+cclJaILfZN9M=; b=sVH/4jhwaujU5iADu6a2AK5x4j
        9NFm5F9bVR0/zp3ZAImhW0AJcIVF4+HwXNhzMWeswKXZnEYe1fbihOxbn19QKZP9AQ26yhBHABQvt
        TJQ7OxL1DIPprqcfmOMbUq0pGZDoPpBJ7uY/GKfkScaNvNlBgB3CFwu54UQkysmXozWjaBARBJviu
        O07J8+Tz5Yq99fBP5BbkFYWcp0ptgLENdFqaJ7rMMoufoNZXa9ojIw8P4CdF23JO1qPz+RMUgQVam
        RIDdnXCAK40csh8MkWYLJQYednh62iOssL54FaBrCEYrqhdNmgqtMbd1cl59bwt4+c8lWnrzgVn6b
        p1SoMjlw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4UMb-0000Gg-CJ; Wed, 19 Feb 2020 18:46:25 +0000
Date:   Wed, 19 Feb 2020 10:46:25 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix iclog release error check race with shutdown
Message-ID: <20200219184625.GB10588@infradead.org>
References: <20200218175425.20598-1-bfoster@redhat.com>
 <20200218215243.GS10776@dread.disaster.area>
 <20200218223644.GA24053@infradead.org>
 <20200219030040.GZ10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219030040.GZ10776@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 02:00:40PM +1100, Dave Chinner wrote:
> > Now the real question, which is a bit out of scope for this patch is
> > why we even have XLOG_STATE_IOERROR?
> 
> I _think_ it was originally intended to prevent log shutdown
> recursion when shutdowns trigger log IO errors and try to shut down
> again.
> 
> > Wouldn't it make more sense
> > to just user the shutdown flag in the mount structure and avoid the
> > extra state complexity and thus clean up this whole mess?
> 
> I'd suggest that XLOG_FORCED_SHUTDOWN() is more appropriate in code
> that has no reason to know anything about the xfs_mount state e.g.
> the code in xlog_state_release_iclog() has a log and iclog context
> and introducing a xfs-mount context to check for shutdown is a
> fairly significant layering violation deep inside the internal log
> implementation...

Yes, XLOG_FORCED_SHUTDOWN makes more sense.  I did in fact hack up
a quick patch for that last night, but I'm going to hold it back until
the bug fix is merged.
