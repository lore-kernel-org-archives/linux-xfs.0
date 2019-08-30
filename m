Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63385C3A5A3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FF6C2087F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:36:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ui/epanL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfH3Fgy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 01:36:54 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50830 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfH3Fgy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:36:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RqeQfdGM7IEwsTCZ+rpo18ojOXpaBswX9P8yXP0zrKY=; b=ui/epanLEaMBftqYe3ya565uF
        uocOrI3w2l4PhhV7IVMxRlAtXGLEqrdO/suqBUdinu8EWdNGfXkIw3C1o88qOLc+bVpZik3mFEJzH
        Po9PIsqIQaC9CXhSoskWj1M2iJb7ehGeS+TzURw/hOYKRLvXaBegNh4dlPXdBiSh/ronAK3ObU/BO
        WfYsHlmuMubVKSGtm5/DKNnXUYvJHQ8nnT/UEQXDcOYC1KMDhjaMRCcRgiTNNLHFQOrDUmSWieK5a
        6tQ2S7P5Fr2P5qnPn9fSfOiDfF06ck0TiIrUgxC9rboQFJ/O7e/9M+DHUEbsrKqWxhgiVFv7NVtC7
        2ypzZCOKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3Zag-0007Lv-D9; Fri, 30 Aug 2019 05:36:54 +0000
Date:   Thu, 29 Aug 2019 22:36:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: allocate xattr buffer on demand
Message-ID: <20190830053654.GH6077@infradead.org>
References: <20190829113505.27223-1-david@fromorbit.com>
 <20190829113505.27223-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829113505.27223-6-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 09:35:05PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When doing file lookups and checking for permissions, we end up in
> xfs_get_acl() to see if there are any ACLs on the inode. This
> requires and xattr lookup, and to do that we have to supply a buffer
> large enough to hold an maximum sized xattr.
> 
> On workloads were we are accessing a wide range of cache cold files
> under memory pressure (e.g. NFS fileservers) we end up spending a
> lot of time allocating the buffer. The buffer is 64k in length, so
> is a contiguous multi-page allocation, and if that then fails we
> fall back to vmalloc(). Hence the allocation here is /expensive/
> when we are looking up hundreds of thousands of files a second.
> 
> Initial numbers from a bpf trace show average time in xfs_get_acl()
> is ~32us, with ~19us of that in the memory allocation. Note these
> are average times, so there are going to be affected by the worst
> case allocations more than the common fast case...
> 
> To avoid this, we could just do a "null"  lookup to see if the ACL
> xattr exists and then only do the allocation if it exists. This,
> however, optimises the path for the "no ACL present" case at the
> expense of the "acl present" case. i.e. we can halve the time in
> xfs_get_acl() for the no acl case (i.e down to ~10-15us), but that
> then increases the ACL case by 30% (i.e. up to 40-45us).
> 
> To solve this and speed up both cases, drive the xattr buffer
> allocation into the attribute code once we know what the actual
> xattr length is. For the no-xattr case, we avoid the allocation
> completely, speeding up that case. For the common ACL case, we'll
> end up with a fast heap allocation (because it'll be smaller than a
> page), and only for the rarer "we have a remote xattr" will we have
> a multi-page allocation occur. Hence the common ACL case will be
> much faster, too.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
