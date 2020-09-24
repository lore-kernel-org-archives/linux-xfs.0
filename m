Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3919EC4346E
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 06:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D966321D7F
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 06:19:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="le5uNYNm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgIXGTR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 02:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgIXGTR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 02:19:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35670C0613CE
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 23:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IH0FwCLUu0OgGngptKX6AvjxFhoyvGgcGG37EMIzzT8=; b=le5uNYNmu3bk+PMnTQ4jz9WxUQ
        IQVVnoMOB7aJ+zrIGi+W8kw4RJxxUmqJ4g6qYarUZW9e+KCCM4JdzFJ/mw3I+Y0U/3ZVeobnqtZQC
        gaWlolDScQB6WbWgMPNyvpQGX+0dSTULPG6EbI9+1O7XQ1Zbfxv2h+YKiR4JAePD9jtCRdeLlfAbu
        pkc5hM5nB0ylhSE5wZah5HlAxCnnh1wp3x/P8I+7N6QQkbOjAlS5/L0zbAfifTSTlBoevPL3bhWwv
        fryKp0Hj+RTh5ZWzGyzR4fLQE+SVskIJyrAHmTNVTpXkEAoryOLzerw6DwPYfO13UHUCZwfLjs0zo
        y0f4DLAA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLKb1-0007OY-2C; Thu, 24 Sep 2020 06:19:11 +0000
Date:   Thu, 24 Sep 2020 07:19:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: coordinate parallel updates to the rt bitmap
Message-ID: <20200924061911.GB27289@infradead.org>
References: <20200923182437.GW7955@magnolia>
 <20200924054041.GA21542@infradead.org>
 <20200924060001.GZ7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924060001.GZ7955@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 23, 2020 at 11:00:01PM -0700, Darrick J. Wong wrote:
> > > +	struct aglock		*lock = &ag_locks[(signed)NULLAGNUMBER];
> > 
> > Err, what is this weird cast doing here?
> 
> Well.... ag_locks is allocated with length ag_locks[agcount + 1], and
> then the pointer is incremented so that ag_locks[-1] is the rt lock.

At least in the for-next branch it isn't:

	ag_locks = calloc(mp->m_sb.sb_agcount, sizeof(struct aglock));

More importantly, I can't even find other uses of ag_locks for the
RT subvolume.  Is this hidden in one of your series?

Either way I think a separate lock for the RT subvolume would make a
whole lot more sense.
