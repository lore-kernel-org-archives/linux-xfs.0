Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB895C2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 12:14:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B37712071E
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 12:14:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q+LFr1xm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfLXMOL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 07:14:11 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36890 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfLXMOL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 07:14:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bjNMhW2+rRAy6TMUxWYb2Ex59I3BoGGIh767xDfMbLk=; b=q+LFr1xma0bq7qKrQPMeX6O0B
        cvJ9jLbHKGrWzuqVTZyf9Gq6Pn4kyvJG/zwGibtZDhA68rXJ62suqwD86/dwoF6WF0kDksBEjsnlP
        Ys8+6b6BbX+W7ryfqHF2MGDpMT0bHT3pIDqd79mrEGtZMS/9h4H0Gzu+0zcww30UBT1pq37CbNhuo
        eBWHclLrfN6bS82XZPrEkBaaunnkBCaUjfgu4aFNFz7wG2scZ1zff8sd7fSENQM6gy016wyMa9f2Z
        uXJVgVITUSs81cAdmDjvkQofKeSDGg/tsLgcPmibysvpUUkG4F1ffM/il+7UmSljKCdGgO3bF/6Ww
        AnRi7O4xw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijj4l-0001m1-1h; Tue, 24 Dec 2019 12:14:11 +0000
Date:   Tue, 24 Dec 2019 04:14:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 05/14] xfs: Factor out new helper functions
 xfs_attr_rmtval_set
Message-ID: <20191224121410.GB18379@infradead.org>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-6-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212041513.13855-6-allison.henderson@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 11, 2019 at 09:15:04PM -0700, Allison Collins wrote:
> Break xfs_attr_rmtval_set into two helper functions
> xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
> xfs_attr_rmtval_set rolls the transaction between the
> helpers, but delayed operations cannot.  We will use
> the helpers later when constructing new delayed
> attribute routines.

Please use up the foll 72-ish characters for the changelog (also for
various other patches).

For the actual patch: can you keep the code in the order of the calling
conventions, that is the lower level functions up and
xfs_attr_rmtval_set at the bottom?  Also please keep the functions
static until callers show up (which nicely leads to the above order).
