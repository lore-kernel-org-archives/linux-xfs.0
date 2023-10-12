Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62967CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 08:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbjJLIol (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 04:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbjJLIok (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 04:44:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7660898
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 01:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cLW93K0LyOIMXFxHX7JLeOSn//sMhNIiytlwirPu4fY=; b=ES6a+x6BFctiXHi0pPyBaaQy94
        axL5oJnMXqDXrcyTSCeI6FllT3ZG/XumP4Kcz3i81v8FY7r2RPYFZ8Rxk/Z8WcvlbIBFOR+hpqgbH
        2h1TKwsmtlhnRW0kZ19P8bfK1UnVnJcjUOO5ADB7OWrzHS1hkom8o2KPVxbA8mVYgWS3GNbnAJ4dm
        o/1QGLmmgswLVaW3hsvnqQVPOJfFa0TTme6GYlcN6I+T8Vd41vrOl6zrHFsvCnKhZMAqGu5j6W/M5
        JDwhOpQNaO0+eLABa6bJFQmyt+EqVvUh/p7jerNCsoxpAn+oq2HwXMhTjSND8jd0ncPjJtCSYuFO1
        PaoObhOg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qqrJ9-000FNj-0G;
        Thu, 12 Oct 2023 08:44:39 +0000
Date:   Thu, 12 Oct 2023 01:44:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: AIL doesn't need manual pushing
Message-ID: <ZSex91tjrLLDRyk2@infradead.org>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-3-david@fromorbit.com>
 <YxikJ9D5SY/eSZlz@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxikJ9D5SY/eSZlz@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 07, 2022 at 07:01:11AM -0700, Christoph Hellwig wrote:
> > +static inline xfs_lsn_t xfs_ail_push_target(struct xfs_ail *ailp)
> > +{
> > +	xfs_lsn_t	lsn;
> > +
> > +	spin_lock(&ailp->ail_lock);
> > +	lsn = __xfs_ail_push_target(ailp);
> > +	spin_unlock(&ailp->ail_lock);
> > +	return lsn;
> > +}
> 
> Before this patch xfs_defer_relog called xlog_grant_push_threshold
> without the ail_lock, why is ail_lock needed now?

Looking through the most recent version of the patch this is still
there and I'm also not seeing an explanation in the patch.  Can
you comment on this change in the commit log?

I also still find it not very helpful that xlog_grant_push_threshold
gets moved and renamed as part of a huge behavior change patch.

The rest still looks good to me even in the last version.
