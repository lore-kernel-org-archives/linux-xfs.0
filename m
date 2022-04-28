Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09221C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 12:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbiD1MyP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 08:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346751AbiD1Mx6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 08:53:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3AE5F8CE
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 05:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cwijA81IbdDzVgkp834v9Z0FlR4apqNoRSdhgwYBdho=; b=fjXugTe6rBmA2uyGMAapYVa9Nt
        4Wwm2i+tEun1CAOwWl4dbQ+nFNOCCj0Pp4fU8geyDrhzuYWNWOM8vdcXBgz0xZQl/TqLeevsKBzv8
        Ao7s27t1tdzMmSRt7XTkDOOg4wbEC0Ki+Z+FD6NxWdo+HstkR3vc6u27krHMubXg2g8CZb2+jh6ze
        h0RKWlVsIoUmNC8eGHgvopES/3Wd1TuYMNId5NW0KywLhIo3jQaicgPEW5BH0Mrs2l8tj9GMuJAnO
        HSHvMPgZ7E07FEnW0pJ4iRbkXrM96aV318bNHeYEWLfGmL9q8hPuj6XR+a4L50LH1xmWcSADVVO+D
        1wAXFX5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3bW-006tNK-QZ; Thu, 28 Apr 2022 12:50:42 +0000
Date:   Thu, 28 Apr 2022 05:50:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: create shadow transaction reservations for
 computing minimum log size
Message-ID: <YmqNov8LXUWLPzQT@infradead.org>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
 <165102073482.3922658.3874181264513799865.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165102073482.3922658.3874181264513799865.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 05:52:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Every time someone changes the transaction reservation sizes, they
> introduce potential compatibility problems if the changes affect the
> minimum log size that we validate at mount time.  If the minimum log
> size gets larger (which should be avoided because doing so presents a
> serious risk of log livelock), filesystems created with old mkfs will
> not mount on a newer kernel; if the minimum size shrinks, filesystems
> created with newer mkfs will not mount on older kernels.
> 
> Therefore, enable the creation of a shadow log reservation structure
> where we can "undo" the effects of tweaks when computing minimum log
> sizes.  These shadow reservations should never be used in practice, but
> they insulate us from perturbations in minimum log size.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
