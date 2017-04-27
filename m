Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22292 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030771AbdD0Ter (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 15:34:47 -0400
Date: Thu, 27 Apr 2017 12:34:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/5] vfs: define a flag to indicate sb->s_uuid is
 available
Message-ID: <20170427193429.GI23371@birch.djwong.org>
References: <1493283574-1497-1-git-send-email-amir73il@gmail.com>
 <1493283574-1497-2-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493283574-1497-2-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Mark Fasheh <mfasheh@versity.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Apr 27, 2017 at 11:59:30AM +0300, Amir Goldstein wrote:
> Overlayfs would like to make use of underlying filesystem's
> sb->s_uuid, but not all filesytems fill this field.
> 
> Define a flag to be set by filesystems that do fill the s_uuid
> field, so let consumers like overlayfs know that the content
> of this field is valid.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  include/linux/fs.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 80daadf..de913b4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1272,6 +1272,9 @@ struct mm_struct;
>  /* sb->s_iflags to limit user namespace mounts */
>  #define SB_I_USERNS_VISIBLE		0x00000010 /* fstype already mounted */
>  
> +/* sb->s_iflags for optional information available in super_block struct */
> +#define SB_I_HAVE_UUID			0x00000100 /* s_uuid */

SB_I_CAN_HAZ_UUID, heh. :)

There seems to be demand for a "Yes I really filled this out" flag, so
for the vfs and xfs parts,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(I wonder why we can't just leave s_uuid as nil and to heck with anyone
who deliberately sets their fs to have a nil uuid (like we do now), but
whatever... :))

--D

> +
>  /* Possible states of 'frozen' field */
>  enum {
>  	SB_UNFROZEN = 0,		/* FS is unfrozen */
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
