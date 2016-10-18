Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53045 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758634AbcJRIiZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Oct 2016 04:38:25 -0400
Date: Tue, 18 Oct 2016 10:38:23 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfs: don't take the IOLOCK exclusive for direct I/O page
 invalidation
Message-ID: <20161018083823.GH3359@quack2.suse.cz>
References: <1476706392-2264-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476706392-2264-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org

On Mon 17-10-16 14:13:12, Christoph Hellwig wrote:
> XFS historically took the iolock exclusive when invalidating pages
> before direct I/O operations to protect against writeback starvations.
> 
> But this writeback starvation issues has been fixed a long time ago
> in the core writeback code, and all other file systems manage to do
> without the exclusive lock.  Convert XFS over to avoid the exclusive
> lock in this case, and also move to range invalidations like done
> by the other file systems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
