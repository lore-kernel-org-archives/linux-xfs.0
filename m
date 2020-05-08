Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57513C38A2A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 07:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 375062070B
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 07:13:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ScNnWVl1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgEHHNg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 03:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725991AbgEHHNg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 03:13:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A11C05BD43
        for <linux-xfs@vger.kernel.org>; Fri,  8 May 2020 00:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BQ9Q+hZD4ctYKOO/Ry5Tl83vEAhejSAW8g6cGbYmTnI=; b=ScNnWVl1w6TP9gFwC+RYz8E9PD
        NSEBIanCq27SFQBnsTrWgMKJ+yQpgp8gf9sQMP9+1xcLmsvoT4QGuTdnwY1wiSHH+mJ2QYAFwVu6Z
        +lheHm40wGbIVeybl/SBBIusgfGQoVOLs90yeLk+GYh5L3rrad41zvTuoP5dj+FMNzpma7k0ecVWI
        pSEe6yxiQvQwsLqX52MwARu0OuRhqHeWPxuUqxX8XdF/AItrpR/dFf9FmK+7cCOxRs7C22BirZrRx
        HSGvrvD1YjSqO1EAoRMX+Qx2zjoV/s44p25y0HTt4mTyQNDMz0O06pjxKpYCtTkTlalh9rozQObqq
        F2dgBhTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWxCS-0007OV-9P; Fri, 08 May 2020 07:13:36 +0000
Date:   Fri, 8 May 2020 00:13:36 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: group quota should return EDQUOT when prj quota
 enabled
Message-ID: <20200508071336.GA26853@infradead.org>
References: <447d7fec-2eff-fa99-cd19-acdf353c80d4@redhat.com>
 <cb095532-b72b-6369-7304-3b589568f0fe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb095532-b72b-6369-7304-3b589568f0fe@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 07, 2020 at 10:38:33PM -0500, Eric Sandeen wrote:
> Long ago, group & project quota were mutually exclusive, and so
> when we turned on XFS_QMOPT_ENOSPC ("return ENOSPC if project quota
> is exceeded") when project quota was enabled, we only needed to
> disable it again for user quota.
> 
> When group & project quota got separated, this got missed, and as a
> result if project quota is enabled and group quota is exceeded, the
> error code returned is incorrectly returned as ENOSPC not EDQUOT.
> 
> Fix this by stripping XFS_QMOPT_ENOSPC out of flags for group
> quota when we try to reserve the space.

Looks weird, but given that it has historical precedence, and you fix
all this mess up in the next patch:

Reviewed-by: Christoph Hellwig <hch@lst.de>
