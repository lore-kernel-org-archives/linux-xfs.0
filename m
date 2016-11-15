Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45555 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752497AbcKOOQW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 09:16:22 -0500
Date: Tue, 15 Nov 2016 06:16:21 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 1/4] xfs: clean up cow fork reservation and tag
 inodes correctly
Message-ID: <20161115141621.GA18630@infradead.org>
References: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
 <1478636856-7590-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478636856-7590-2-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> +	if (imap->br_startoff != got.br_startoff ||
> +	    imap->br_blockcount != got.br_blockcount)
>  		xfs_inode_set_cowblocks_tag(ip);

Can't got.br_blockcount be smaller than imap->br_blockcount if we have
an existing COW fork reservation lying around behind the whole we're
filling?  Also they way xfs_bmapi_reserve_delalloc works the startoff
will be the same.  E.g. this check should probably be:

	if (got.br_blockcount > imap->br_blockcount)

Except for that the patch looks good and is a nice cleanup.
