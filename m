Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37661 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751382AbdH3PAD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 11:00:03 -0400
Date: Wed, 30 Aug 2017 17:00:00 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] iomap: Switch from blkno to disk offset
Message-ID: <20170830150000.GC5920@quack2.suse.cz>
References: <20170829142942.21594-1-agruenba@redhat.com>
 <20170829142942.21594-2-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829142942.21594-2-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>

On Tue 29-08-17 16:29:39, Andreas Gruenbacher wrote:
> Replace iomap->blkno, the sector number, with iomap->addr, the disk
> offset in bytes.  For invalid disk offsets, use the special value
> IOMAP_NULL_ADDR instead of IOMAP_NULL_BLOCK.  This allows to use iomap
> for mappings which are not block aligned, such as inline data on ext4
> and stuffed inodes on gfs2.
> 
> Tested on xfs and ext4 with xfstests; seems to be working correctly.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
