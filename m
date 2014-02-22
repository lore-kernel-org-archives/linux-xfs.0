Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7C2847F87
	for <xfs@oss.sgi.com>; Sat, 22 Feb 2014 11:09:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 682B1304059
	for <xfs@oss.sgi.com>; Sat, 22 Feb 2014 09:09:42 -0800 (PST)
Date: Sat, 22 Feb 2014 12:09:30 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v6] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
Message-ID: <20140222170930.GE26637@thunk.org>
References: <1392908861-3563-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392908861-3563-1-git-send-email-linkinjeon@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jack@suse.cz, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, adilger.kernel@dilger.ca, mtk.manpages@gmail.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk

On Fri, Feb 21, 2014 at 12:07:41AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This patch implements fallocate's FALLOC_FL_COLLAPSE_RANGE for Ext4.
> 
> The semantics of this flag are following:
> 1) It collapses the range lying between offset and length by removing any data
>    blocks which are present in this range and than updates all the logical
>    offsets of extents beyond "offset + len" to nullify the hole created by
>    removing blocks. In short, it does not leave a hole.
> 2) It should be used exclusively. No other fallocate flag in combination.
> 3) Offset and length supplied to fallocate should be fs block size aligned
>    in case of xfs and ext4.
> 4) Collaspe range does not work beyond i_size.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> Tested-by: Dongsu Park <dongsu.park@profitbricks.com>

In terms of how to get this upstream, it looks like if we do something
like this, we can let this patch go via the ext4 tree and we don't
need to worry about whether the vfs level changes have gone in our
not.

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad13359..d7a78ed 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -46,6 +46,10 @@
 
 #include <trace/events/ext4.h>
 
+#ifndef FALLOC_FL_COLLAPSE_RANGE
+#define FALLOC_FL_COLLAPSE_RANGE	0x08
+#endif
+
 /*
  * used by extent splitting.
  */


> +	ret = ext4_es_remove_extent(inode, punch_start,
> +				    EXT_MAX_BLOCKS - punch_start - 1);
> +	if (ret) {
> +		up_write(&EXT4_I(inode)->i_data_sem);
> +		goto out_stop;
> +	}

Doing this at first is probably a bad idea; you should do this at the
end, and then completely invalidate the es cache for that inode.  That
way, the right thing happens if you get an error in the middle
releasing the boxes and shifting the extents:

> +
> +	ret = ext4_ext_remove_space(inode, punch_start, punch_stop - 1);
> +	if (ret) {
> +		up_write(&EXT4_I(inode)->i_data_sem);
> +		goto out_stop;
> +	}
> +
> +	ret = ext4_ext_shift_extents(inode, handle, punch_stop,
> +				     punch_stop - punch_start);
> +	if (ret) {
> +		up_write(&EXT4_I(inode)->i_data_sem);
> +		goto out_stop;
> +	}

The fact that you are doing these two as two separate steps is
dangerous; what if you've already released the blocks in
ext4_ext_remove_space(), and ext4_ext_shift_extents() fails in the
middle of the processing?  That will leave the file system
inconsistent, which would be bad.

Making sure that the right happens if there is a failure in the middle
of the operation is Really Important....

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
