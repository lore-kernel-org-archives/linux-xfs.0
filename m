Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36737 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751979AbdIVOcQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2017 10:32:16 -0400
Date: Fri, 22 Sep 2017 07:32:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Capture state of the right inode in xfs_iflush_done
Message-ID: <20170922143216.GA17593@infradead.org>
References: <20170922113555.17711-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170922113555.17711-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

Oops, yes this fix looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I wish we could clean this up a bit by making li_bio_list a
real list_head, and then factoring the loop into a helper so that
lip isn't even in scope..
