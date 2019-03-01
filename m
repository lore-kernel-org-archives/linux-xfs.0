Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51582 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728172AbfCAPwG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 10:52:06 -0500
Date: Fri, 1 Mar 2019 07:51:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] statx.2: add project support update
Message-ID: <20190301155145.GO21626@magnolia>
References: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
 <1551449184-7942-3-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551449184-7942-3-git-send-email-wshilong1991@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>, linux-man@vger.kernel.org

On Fri, Mar 01, 2019 at 11:06:24PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> Cc: linux-man@vger.kernel.org
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
>  man2/statx.2 | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/man2/statx.2 b/man2/statx.2
> index 7265d8ace..6a9dede8b 100644
> --- a/man2/statx.2
> +++ b/man2/statx.2
> @@ -82,6 +82,7 @@ struct statx {
>         containing the filesystem where the file resides */
>      __u32 stx_dev_major;   /* Major ID */
>      __u32 stx_dev_minor;   /* Minor ID */
> +    __u32 stx_projid;      /* Project ID of file */
>  };
>  .EE
>  .in
> @@ -261,6 +262,7 @@ STATX_SIZE	Want stx_size
>  STATX_BLOCKS	Want stx_blocks
>  STATX_BASIC_STATS	[All of the above]
>  STATX_BTIME	Want stx_btime
> +STATX_PROJID	Want stx_projid
>  STATX_ALL	[All currently available fields]
>  .TE
>  .in
> @@ -412,6 +414,9 @@ The device on which this file (inode) resides.
>  .IR stx_rdev_major " and "  stx_rdev_minor
>  The device that this file (inode) represents if the file is of block or
>  character device type.
> +.TP
> +.I stx_projid
> +The file's project ID.
>  .PP
>  For further information on the above fields, see
>  .BR inode (7).
> @@ -458,6 +463,9 @@ See
>  .TP
>  .B STATX_ATTR_ENCRYPTED
>  A key is required for the file to be encrypted by the filesystem.
> +.TP
> +.B STATX_ATTR_PROJINHERIT
> +Sub directories or files will inherit parent's project ID automatically.

"Newly created files and directories will inherit...", I think?

I appreciate the manpage and fstests updates immensely. :)

--D

>  .SH RETURN VALUE
>  On success, zero is returned.
>  On error, \-1 is returned, and
> -- 
> 2.19.1
> 
