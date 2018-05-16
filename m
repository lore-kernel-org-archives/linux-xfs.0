Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:41595 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751893AbeEPRcy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 13:32:54 -0400
Received: by mail-pg0-f65.google.com with SMTP id w4-v6so582360pgq.8
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 10:32:54 -0700 (PDT)
Date: Wed, 16 May 2018 10:32:51 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 1/2] iomap: provide more useful errors for invalid
 swap files
Message-ID: <20180516173251.GA29231@vader>
References: <cover.1526488995.git.osandov@fb.com>
 <9faf09627cfa469437b76edb73ac7cc822dc33c8.1526488995.git.osandov@fb.com>
 <20180516172531.GA13464@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516172531.GA13464@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Aleksei Besogonov <cyberax@amazon.com>, kernel-team@fb.com

On Wed, May 16, 2018 at 10:25:31AM -0700, Christoph Hellwig wrote:
> On Wed, May 16, 2018 at 09:45:50AM -0700, Omar Sandoval wrote:
> > +	if ((iomap->type != IOMAP_MAPPED && iomap->type != IOMAP_UNWRITTEN) ||
> > +	    iomap->addr == IOMAP_NULL_ADDR) {
> > +		pr_err("swapon: file has unallocated extents\n");
> > +		return -EINVAL;
> > +	}
> 
> The two are really different cases - IOMAP_NULL_ADDR shouldn't really
> happen for any of the above.  Although we might have to move the
> inline check before the type check above for the message to make sense.
> 
> I have a patch in the local queue that makes inline a type instead of
> a flag, btw as it really isn't a flag.

So something like this, moving the inline check and removing the hole
check since that doesn't make sense for mapped or unwritten? Then the
inline flag check can be converted to a type check.

diff --git a/fs/iomap.c b/fs/iomap.c
index d193390a1c20..89517442e296 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1214,26 +1214,37 @@ static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
 	struct iomap_swapfile_info *isi = data;
 	int error;
 
+	/* No inline data. */
+	if (iomap->flags & IOMAP_F_DATA_INLINE) {
+		pr_err("swapon: file is inline\n");
+		return -EINVAL;
+	}
+
 	/* Skip holes. */
 	if (iomap->type == IOMAP_HOLE)
 		goto out;
 
-	/* Only one bdev per swap file. */
-	if (iomap->bdev != isi->sis->bdev)
-		goto err;
-
 	/* Only real or unwritten extents. */
-	if (iomap->type != IOMAP_MAPPED && iomap->type != IOMAP_UNWRITTEN)
-		goto err;
+	if (iomap->type != IOMAP_MAPPED && iomap->type != IOMAP_UNWRITTEN) {
+		pr_err("swapon: file has unallocated extents\n");
+		return -EINVAL;
+	}
 
-	/* No uncommitted metadata or shared blocks or inline data. */
-	if (iomap->flags & (IOMAP_F_DIRTY | IOMAP_F_SHARED |
-			    IOMAP_F_DATA_INLINE))
-		goto err;
+	/* No uncommitted metadata or shared blocks. */
+	if (iomap->flags & IOMAP_F_DIRTY) {
+		pr_err("swapon: file is not committed\n");
+		return -EINVAL;
+	}
+	if (iomap->flags & IOMAP_F_SHARED) {
+		pr_err("swapon: file has shared extents\n");
+		return -EINVAL;
+	}
 
-	/* No null physical addresses. */
-	if (iomap->addr == IOMAP_NULL_ADDR)
-		goto err;
+	/* Only one bdev per swap file. */
+	if (iomap->bdev != isi->sis->bdev) {
+		pr_err("swapon: file is on multiple devices\n");
+		return -EINVAL;
+	}
 
 	if (isi->iomap.length == 0) {
 		/* No accumulated extent, so just store it. */
@@ -1250,9 +1261,6 @@ static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
 	}
 out:
 	return count;
-err:
-	pr_err("swapon: file cannot be used for swap\n");
-	return -EINVAL;
 }
 
 /*
