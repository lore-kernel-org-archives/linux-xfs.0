Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33AAC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Feb 2022 04:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiBREYt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Feb 2022 23:24:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiBREYs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Feb 2022 23:24:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400DB1277B;
        Thu, 17 Feb 2022 20:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Twy8bHXVuGiqojDpjPWR5wAliPZVNEGz6RxLEr/EStY=; b=QEWgBN0ALj5dP9eYdTp2Bvdoq7
        kurAWQd4bf/PKofyNScuGnszzTlY+0vQVWgmGo/GxiWLD+p2e5vJfKaIzXgQmRYHLYDXd/lyqXQv0
        7jEmFbHsUnuzPFi93SaoRzSZ1fqrFw7IpO9aKxdppF2bF8fpwMtULvf8d5ALEqAf31MHbL4dK0IMV
        WTaQ5IOrDwb01vKXHX0GvhPUlJb7Z4uMQ4/lyOtgwDG9tG+g4L2KneE0w89kHMbiBy8GnfmpN01CR
        gzqIugOw5e9532idpIHTWfWXAdJKZtPiHNkTNaofOLPTRqc3Nmgn0zEl5WMTEJj6MdlRtyz6MVQv0
        wARKumdA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nKuoe-00GGyD-LB; Fri, 18 Feb 2022 04:24:20 +0000
Date:   Fri, 18 Feb 2022 04:24:20 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Lee Jones <lee.jones@linaro.org>, linux-ext4@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [REPORT] kernel BUG at fs/ext4/inode.c:2620 - page_buffers()
Message-ID: <Yg8fdCuE6RusrjIh@casper.infradead.org>
References: <Yg0m6IjcNmfaSokM@google.com>
 <Yg8KZvDVFJgTXm4C@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg8KZvDVFJgTXm4C@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 17, 2022 at 09:54:30PM -0500, Theodore Ts'o wrote:
> process_vm_writev() uses [un]pin_user_pages_remote() which is the same
> interface uses for RDMA.  But it's not clear this is ever supposed to
> work for memory which is mmap'ed region backed by a file.
> pin_user_pages_remote() appears to assume that it is an anonymous
> region, since the get_user_pages functions in mm/gup.c don't call
> read_page() to read data into any pages that might not be mmaped in.

... it doesn't end up calling handle_mm_fault() in faultin_page()?
