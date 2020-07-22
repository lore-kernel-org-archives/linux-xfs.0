Return-Path: <SRS0=rRn/=BB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE8DC433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 14:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6C6F20729
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 14:15:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XHvGLJ/A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732391AbgGVOPG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jul 2020 10:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgGVOPF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jul 2020 10:15:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B555C0619DC
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2020 07:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Nglx5cq1WqOWnkQHmrk9cM4F+Wg104TImPu7ee/Rg9E=; b=XHvGLJ/AU5XqTOLK+qnKn67d7X
        qnyB6uc0pw2zsf4tAjE4/VqyE3kx7shdBIgG0gCXKaYDySM/C65licmGR9ZBU2y42T4SN3jLBwJgS
        UGchtDUZBEFukwsJZgHRb+kPL04U2y8ti5rZ0EDfLYj2aL/PF1id3jQ7IctDM9xL0lBLtUt9ZbEgN
        F2QOY3pDLCtPNRuJJaZu0wPkSYpxyjbMnh+ksgQ+QvyYeZfrmwzjG5Brro3UAvcOmI6iXwxQqRh3M
        qQV/xtpc4w1+JpD/+7RApbHO0gkot4QQ7ClfoNi2gxKW5PV346DhSTyWCelKbWv/0fusDtT6Az/Xk
        1u8ip3SQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyFWP-0005O2-O2; Wed, 22 Jul 2020 14:15:02 +0000
Date:   Wed, 22 Jul 2020 15:15:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: Refactor xfs_da_state_alloc() helper
Message-ID: <20200722141501.GB20266@infradead.org>
References: <20200722090518.214624-1-cmaiolino@redhat.com>
 <20200722090518.214624-6-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722090518.214624-6-cmaiolino@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 22, 2020 at 11:05:18AM +0200, Carlos Maiolino wrote:
> Every call to xfs_da_state_alloc() also requires setting up state->args
> and state->mp
> 
> Change xfs_da_state_alloc() to receive an xfs_da_args_t as argument and
> return a xfs_da_state_t with both args and mp already set.

I would have not use the typedef versions and switched to the raw
struct type, but that's something we should eventually take care of
with a bulk cleanup anyway, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
