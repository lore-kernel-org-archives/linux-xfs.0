Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF17C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Dec 2021 07:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351648AbhLXHGG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241206AbhLXHGF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Dec 2021 02:06:05 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDDCC061401
        for <linux-xfs@vger.kernel.org>; Thu, 23 Dec 2021 23:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=b7maIXCJ0kNGbhIK1DG0w8mC3/QhEhjSsLDfhy0Q1Us=; b=GbtVDUSb97hraCET3IDfBnGRUY
        +UCkpt5BHnf+tK40SPPQRnwChXnZ4GiTeiezbZaqyCeJYS60BtasVXvJZERjmC3I1Qmti/hE06t1I
        qv9Ng20ug8CXXBKKuykbgMkIcA1xbQwgyA5HiObUdNCGgtILHugEn6ssrrJvQbYDeiYWIJJmogrgU
        OzQInWAgrn79fYETrfDWyH0uIsKp/stapD1VP2aKXzlO+5wMrTpzidT6NZR0gfnuPD1QDul/ZhgLA
        4PYtBAxhIbGw2FBHWijUPBDw9ly15FjScGJombc07PhGi8ReDwN6Fl50uMv450Sr831uMEroP25K+
        XDTG3COQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0eeT-00DpWC-5D; Fri, 24 Dec 2021 07:06:05 +0000
Date:   Thu, 23 Dec 2021 23:06:05 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_quota: fix up dump and report documentation
Message-ID: <YcVxXWKsT7OSMCi0@infradead.org>
References: <20211217202050.14922-1-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211217202050.14922-1-sandeen@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 17, 2021 at 02:20:50PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> Documentation for these commands was a bit of a mess.
> 
> 1) The help args were respecified in the _help() functions, overwriting
>    the strings which had been set up in the _init functions as all
>    other commands do. Worse, in the report case, they differed.
> 
> 2) The -L/-U dump options were not present in either short help string.
> 
> 3) The -L/-U dump options were not documented in the xfs_quota manpage.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Why the double₋signoff?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
