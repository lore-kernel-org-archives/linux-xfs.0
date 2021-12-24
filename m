Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F2EEC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Dec 2021 07:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351758AbhLXHQS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343520AbhLXHQR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Dec 2021 02:16:17 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26279C061401
        for <linux-xfs@vger.kernel.org>; Thu, 23 Dec 2021 23:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gVzZuhnkKK7YO3zXgTd6Jcjqrhf9szZrH8SdiT3ryn8=; b=nXMex2+mZyWbAAnftF9Tdz0Uqd
        rqaxpWYWRNC3WW2MZ59R3HWASG2bX3DMZhY0PuDaErm1Rrxjvwr+qRE5wbPcLm/eOxMVrJQ0JKO9+
        7nBoK/Kbbaa4jJzgfJlKAyCXNAMXYjcY6nOBUJ8An+ZA/i28dl4sRJsDUDclfpHAo2egQYsovt3am
        DADLG4q6RvHjxS+4p8eVz2ZlkSbUYbPVc1QCXu4qwmPZQdUqD/pDPYmkwiL9HyHsryBNzftzG5T3E
        HuJdyu4I3PiRPYTe9ATMFbPGeAIj/LbS3ASgQAHIh5GOBMeRo6UeNz0lXxGBdMXK7jaWVjyOObHNB
        19fZ/a8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0eoJ-00Dpqf-Nn; Fri, 24 Dec 2021 07:16:15 +0000
Date:   Thu, 23 Dec 2021 23:16:15 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: shut down filesystem if we xfs_trans_cancel
 with deferred work items
Message-ID: <YcVzv4Oik59RD4X7@infradead.org>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961696648.3129691.5075630610079213754.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163961696648.3129691.5075630610079213754.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 15, 2021 at 05:09:26PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While debugging some very strange rmap corruption reports in connection
> with the online directory repair code.  I root-caused the error to the
> following incorrect sequence:
> 
> <start repair transaction>
> <expand directory, causing a deferred rmap to be queued>
> <roll transaction>
> <cancel transaction>
> 
> Obviously, we should have committed the transaction instead of
> cancelling it.  Thinking more broadly, however, xfs_trans_cancel should
> have warned us that we were throwing away work item that we already
> committed to performing.  This is not correct, and we need to shut down
> the filesystem.
> 
> Change xfs_trans_cancel to complain in the loudest manner if we're
> cancelling any transaction with deferred work items attached.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
