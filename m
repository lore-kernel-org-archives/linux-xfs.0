Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46221 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751900AbdF0Wn3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jun 2017 18:43:29 -0400
Date: Wed, 28 Jun 2017 00:43:27 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/6] vfs: Add iomap_seek_hole and iomap_seek_data
        helpers
Message-ID: <20170627224326.GA12755@lst.de>
References: <20170627214828.1029-1-hch@lst.de> <20170627214828.1029-5-hch@lst.de> <CAHpGcM+Dy+9dNwNpCmu492ayjbSnW-eeivw3+CfJUfbDHajn9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHpGcM+Dy+9dNwNpCmu492ayjbSnW-eeivw3+CfJUfbDHajn9w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas =?iso-8859-1?Q?Gr=FCnbacher?= <andreas.gruenbacher@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, Jun 28, 2017 at 12:14:57AM +0200, Andreas Grünbacher wrote:
> This shouldn't be true anymore now that the actors don't recompute the
> length; the above three lines should be obsolete.

Indeed.

> This comment makes more sense in iomap_seek_hole now.

Or just drop it..

What about the incremental patch below?

diff --git a/fs/iomap.c b/fs/iomap.c
index c90cda33994b..432eed8f091f 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -626,9 +626,6 @@ iomap_seek_hole(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
 		length -= ret;
 	}
 
-	/* The last segment can extend beyond the end of the file. */
-	if (length <= 0)
-		return min(offset, size);
 	return offset;
 }
 EXPORT_SYMBOL_GPL(iomap_seek_hole);
@@ -675,7 +672,6 @@ iomap_seek_data(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
 		length -= ret;
 	}
 
-	/* There is an implicit hole at the end of the file. */
 	if (length <= 0)
 		return -ENXIO;
 	return offset;
