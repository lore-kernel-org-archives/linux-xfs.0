Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5521CC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 05:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiGKF0h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 01:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGKF0g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 01:26:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3715B19296
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 22:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DZNqS0dVGNijGlztj7sSsY9KjUI5BBvLJP2QymBlKhs=; b=raVYIJxWFQCZAbt/JPgifW/zRN
        oM6//KgTpBR3doTLXWZ56q56M6xDVEBo0Zbom0Q27JogfE5xm/8nRgHXh8S8frjn0GYHZrtjVry1L
        B+qHHtn3mdTN+Bi0V7G9VOY8W/zgHHNwmJ/UtOzHa2eeUtKjrCuv3vsHOxJyMl/WoGw09z9Jw1vRT
        mR0omgda8IDZOc0L5J0jJPjtgZvcR0J8vgZSOrsGIQjNc1L50SaMmicdA8aGAa/ynJlQEDyJWCB5H
        283v8v1I4FnY/eJcU4f9QyGYnsiylgF4NXaYvmn9OO/06CF+qNECsgyjIQI63J503Ict37D0JOeno
        x+agg/PQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAlwH-00G7KY-Tg; Mon, 11 Jul 2022 05:26:33 +0000
Date:   Sun, 10 Jul 2022 22:26:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com
Subject: Re: [PATCH 1/5] xfs: convert XFS_IFORK_PTR to a static inline helper
Message-ID: <Ysu0iYgkaGdg6oVJ@infradead.org>
References: <165740691606.73293.12753862498202082021.stgit@magnolia>
 <165740692193.73293.17607871779448850064.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165740692193.73293.17607871779448850064.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 09, 2022 at 03:48:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We're about to make this logic do a bit more, so convert the macro to a
> static inline function for better typechecking and fewer shouty macros.
> No functional changes here.

No arguments about the inline which is always a good idea.  But is
there much of a point in changing the naming?  The old one nicely
sticks out just like XFS_I and VFS_I have been inline functions for
a long time.
