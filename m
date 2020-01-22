Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B789FC32771
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 22:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7211B21835
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 22:12:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PmOd7GnD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgAVWMI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jan 2020 17:12:08 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35794 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVWMH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jan 2020 17:12:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=e1EXxl8tFt2zoQt87i9PYbChbvfU+DEgqjmWJgWZE6I=; b=PmOd7GnDmS6VrFpAcL/8jSVDZ
        IAiC7MYMEkTQP7fUA0dPAFuVCTad/WjAjIwui8qO1lOVQJ16uVkVtWeezii3m+HdIDwsCu7WJekDk
        gPDaSJW5tlHfIl8H4OrMLOU7P+P2mO0xSnHtXn9kOImEVGBeQHF2mGAWD5t5sc3+b1Kd9OwEeY9ad
        lXl2L8DoYh9x/kOOxBxSClw9PLNS1lNP/IkB1hTWjf0neVRdP2LvJ/Od/RyGsD/4drLL7ZnrmFUrO
        PEHg/2W5oHMdCry6CpRjNJgt9VgvZVH0YykUGsTeTXIT7o24w5doDACZtG4XgJqHMvupdlBooNHVo
        9RSSZj7Qw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iuOEJ-0001Hg-Er; Wed, 22 Jan 2020 22:12:07 +0000
Date:   Wed, 22 Jan 2020 14:12:07 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH 05/13] xfs: make xfs_buf_read_map return an error code
Message-ID: <20200122221207.GA29647@infradead.org>
References: <157956098906.1166689.13651975861399490259.stgit@magnolia>
 <157956102137.1166689.2159908930036102057.stgit@magnolia>
 <20200121225228.GA11169@infradead.org>
 <20200122002046.GQ8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122002046.GQ8247@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 21, 2020 at 04:20:46PM -0800, Darrick J. Wong wrote:
> I rearrange responsibility for dealing with buffer error handling in the
> patch "xfs: move buffer read io error logging to xfs_buf_read_map" later
> in this series.  Was that not what you were expecting?

I defintively don't expect a patch talking about logging to change error
handling behavior.  And yes, I also expect that if we change a function
to return an error code that is actually uses that to return errors.

> Though looking at that patch I guess we could set @error directly to the
> return values of xfs_buf_reverify/_xfs_buf_read.

Yes.  Code outside xfs_buf.c and maybe xfs_buf_item.c really ever access
b_error.
