Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1BDC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiF2HRj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbiF2HRT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:17:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CC633890
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6hn6BbJBpOjq0zW+jMAPDmx4ZznJQw/+ohziW1vBGVg=; b=b2OxTZfgJksfkv7XXjn7EpPhM1
        SXPATVuVqAVw1+hdKQX9Rs5z7ofDlu426P8hArq3e9cwtvGe/s1mk0WhR9rddPiwQpsEJUNYRFCOW
        zrajBY/ycO6Ac28yplks1WAZLIE3fmhoYIHaIt8mdtiW9BtY4ODmtwn+RmPQU05mBfpfaZpVntB8y
        dGXAZys9WipYfknkm8mx3/OOrW9xC81ujdFjhzCHpLKYaRUTRAAHy+MnsFFjTYhJ41TuLAoeV4N80
        v28ooMBTPnV2EOtqg6F2aZ9sLLgvD1Hu4tSAXWfWHRkbUC0pce68H6u/xDMwi44ysvHZ5sC4LdU6Y
        TPiWMXww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6Rwq-00A3QG-Nx; Wed, 29 Jun 2022 07:17:16 +0000
Date:   Wed, 29 Jun 2022 00:17:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: introduce xfs_iunlink_lookup
Message-ID: <Yrv8fKfV4pxA7ZxR@infradead.org>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627004336.217366-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 10:43:31AM +1000, Dave Chinner wrote:
> When an inode is on an unlinked list during normal operation, it is
> guaranteed to be pinned in memory as it is either referenced by the
> current unlink operation or it has a open file descriptor that
> references it and has it pinned in memory. Hence to look up an inode
> on the unlinked list, we can do a direct inode cache lookup and
> always expect the lookup to succeed.

> +	rcu_read_lock();
> +	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> +
> +	/* Inode not in memory, nothing to do */
> +	if (!ip) {
> +		rcu_read_unlock();
> +		return NULL;
> +	}

If the above commit log is true (which I think it is), the comment here
is wrong, and the check should probably grow a WARN_ON as well.

> +	spin_lock(&ip->i_flags_lock);
> +	if (ip->i_ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino) ||
> +	    (ip->i_flags & (XFS_IRECLAIMABLE | XFS_IRECLAIM))) {
> +		/* Uh-oh! */
> +		ip = NULL;
> +	}

And this should not happen either and could use an assert.
