Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:26921 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1036135AbdD2XCJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Apr 2017 19:02:09 -0400
Date: Sun, 30 Apr 2017 09:01:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] VFS API for getting filesystem's UUID
Message-ID: <20170429230159.GM12369@dastard>
References: <1493283574-1497-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493283574-1497-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Mark Fasheh <mfasheh@versity.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Apr 27, 2017 at 11:59:29AM +0300, Amir Goldstein wrote:
> Miklos,
> 
> As you observed, the sb->s_uuid field is not always filled by filesystems.
> 
> Consumers, like overlayfs, that wish to use this field can check if is
> zeroed out as an indication for valid value.
> 
> Christoph suggested to make the test more explicit and require the
> filesystems that fill the s_uuid field to set a super block flag.
> 
> Do you agree with the proposed API?
> 
> The first patch in the series defines the flag.
> If you push this patch through your tree to Al or Linus, then filesystem
> maintainers could later pick the individual patches to their trees.
> 
> The xfs patch is based on a patch I already sent to Darrick for filling
> out the s_uuid field.
> 
> Thanks,
> Amir.
> 
> Amir Goldstein (5):
>   vfs: define a flag to indicate sb->s_uuid is available
>   ext4: set the super block SB_I_HAVE_UUID flag
>   f2fs: set the super block SB_I_HAVE_UUID flag
>   ocfs2: set the super block SB_I_HAVE_UUID flag
>   xfs: set the super block SB_I_HAVE_UUID flag
> 
>  fs/ext4/super.c    | 1 +
>  fs/f2fs/super.c    | 1 +
>  fs/ocfs2/super.c   | 1 +
>  fs/xfs/xfs_mount.c | 1 +
>  include/linux/fs.h | 3 +++
>  5 files changed, 7 insertions(+)

Doesn't this make the struct export_opierations .get_uuid method
somewhat redundant?  Shouldn't that now be replaced with generic
functions that looks at SB_I_HAVE_UUID before allowing PNFS export
is allowed and then just use s_uuid directly in the PNFS code?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
