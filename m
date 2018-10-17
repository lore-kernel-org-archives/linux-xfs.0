Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46380 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbeJQQ2d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 12:28:33 -0400
Date: Wed, 17 Oct 2018 01:33:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/26] vfs: create generic_remap_file_range_touch to
 update inode metadata
Message-ID: <20181017083355.GE16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153965996673.3607.133184523000924340.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153965996673.3607.133184523000924340.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Oct 15, 2018 at 08:19:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a new VFS helper to handle inode metadata updates when remapping
> into a file.  If the operation can possibly alter the file contents, we
> must update the ctime and mtime and remove security privileges, just
> like we do for regular file writes.  Wire up ocfs2 to ensure consistent
> behavior.

Subject line doesn't match the actual function name..

> +/* Update inode timestamps and remove security privileges when remapping. */
> +static int generic_remap_file_range_target(struct file *file,
> +					   unsigned int remap_flags)
> +{
> +	int ret;
> +
> +	/* If can't alter the file contents, we're done. */
> +	if (remap_flags & REMAP_FILE_DEDUP)
> +		return 0;
> +
> +	/* Update the timestamps, since we can alter file contents. */
> +	if (!(file->f_mode & FMODE_NOCMTIME)) {
> +		ret = file_update_time(file);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/*
> +	 * Clear the security bits if the process is not being run by root.
> +	 * This keeps people from modifying setuid and setgid binaries.
> +	 */
> +	return file_remove_privs(file);
> +}
> +
>  /*
>   * Check that the two inodes are eligible for cloning, the ranges make
>   * sense, and then flush all dirty data.  Caller must ensure that the
> @@ -1820,6 +1844,10 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  	if (ret)
>  		return ret;
>  
> +	ret = generic_remap_file_range_target(file_out, remap_flags);
> +	if (ret)
> +		return ret;
> +

Also I find the name still somewhat odd.  Why don't we side-step that
issue by moving the code directly into generic_remap_file_range_prep?

Something like this folded in:

diff --git a/fs/read_write.c b/fs/read_write.c
index 37a7d3fe35d8..6de813cf9e63 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1752,30 +1752,6 @@ static int generic_remap_check_len(struct inode *inode_in,
 	return (remap_flags & REMAP_FILE_DEDUP) ? -EBADE : -EINVAL;
 }
 
-/* Update inode timestamps and remove security privileges when remapping. */
-static int generic_remap_file_range_target(struct file *file,
-					   unsigned int remap_flags)
-{
-	int ret;
-
-	/* If can't alter the file contents, we're done. */
-	if (remap_flags & REMAP_FILE_DEDUP)
-		return 0;
-
-	/* Update the timestamps, since we can alter file contents. */
-	if (!(file->f_mode & FMODE_NOCMTIME)) {
-		ret = file_update_time(file);
-		if (ret)
-			return ret;
-	}
-
-	/*
-	 * Clear the security bits if the process is not being run by root.
-	 * This keeps people from modifying setuid and setgid binaries.
-	 */
-	return file_remove_privs(file);
-}
-
 /*
  * Read a page's worth of file data into the page cache.  Return the page
  * locked.
@@ -1950,9 +1926,25 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	if (ret)
 		return ret;
 
-	ret = generic_remap_file_range_target(file_out, remap_flags);
-	if (ret)
-		return ret;
+	if (!(remap_flags & REMAP_FILE_DEDUP)) {
+		/*
+		 * Update the timestamps, since we can alter file contents.
+		 */
+		if (!(file_out->f_mode & FMODE_NOCMTIME)) {
+			ret = file_update_time(file_out);
+			if (ret)
+				return ret;
+		}
+
+		/*
+		 * Clear the security bits if the process is not being run by
+		 * root.  This keeps people from modifying setuid and setgid
+		 * binaries.
+		 */
+		ret = file_remove_privs(file_out);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
