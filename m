Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36180 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754925AbcJRGME (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2016 02:12:04 -0400
Subject: Re: [PATCH 2/2] man2/ioctl_fideduperange.2: clarify operation some
 more
References: <147675566778.12400.16090171199161180354.stgit@birch.djwong.org>
 <147675567514.12400.12489294497404900248.stgit@birch.djwong.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <d63502f6-2485-0d36-18d4-bbd636ba497a@gmail.com>
Date: Tue, 18 Oct 2016 08:11:58 +0200
MIME-Version: 1.0
In-Reply-To: <147675567514.12400.12489294497404900248.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-man@vger.kernel.org

Hi Darrick,

On 10/18/2016 03:54 AM, Darrick J. Wong wrote:
> Clarify the behavior of the dedupe ioctl.

Thanks! Applied.

Cheers,

Michael


> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man2/ioctl_ficlonerange.2  |    2 +-
>  man2/ioctl_fideduperange.2 |   26 ++++++++++++++++++++++----
>  2 files changed, 23 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/man2/ioctl_ficlonerange.2 b/man2/ioctl_ficlonerange.2
> index ac0738a..0e3ae0e 100644
> --- a/man2/ioctl_ficlonerange.2
> +++ b/man2/ioctl_ficlonerange.2
> @@ -114,7 +114,7 @@ regions in directories.
>  .TP
>  .B EOPNOTSUPP
>  This can appear if the filesystem does not support reflinking either file
> -descriptor.
> +descriptor, or if either file descriptor refers to special inodes.
>  .TP
>  .B EPERM
>  .IR dest_fd
> diff --git a/man2/ioctl_fideduperange.2 b/man2/ioctl_fideduperange.2
> index c52fa2a..2112d10 100644
> --- a/man2/ioctl_fideduperange.2
> +++ b/man2/ioctl_fideduperange.2
> @@ -99,21 +99,39 @@ Each deduplication operation targets
>  bytes in file descriptor
>  .IR dest_fd
>  at offset
> -.IR logical_offset ".
> +.IR dest_offset ".
>  The field
>  .IR reserved
>  must be zero.
> +During the call,
> +.IR src_fd
> +must be open for reading and
> +.IR dest_fd
> +must be open for writing.
> +For any call to this ioctl, there may not be more than 65,536
> +requests attached; each request may not exceed 16MiB.
> +By convention, the storage used by
> +.IR src_fd
> +is mapped into
> +.IR dest_fd
> +and the previous contents in
> +.IR dest_fd
> +are freed.
>  
>  Upon successful completion of this ioctl, the number of bytes successfully
>  deduplicated is returned in
>  .IR bytes_deduped
>  and a status code for the deduplication operation is returned in
>  .IR status ".
> -
> +If even a single byte in the range does not match, the deduplication
> +request will be ignored and
> +.IR status
> +set to
> +.BR FILE_DEDUPE_RANGE_DIFFERS .
>  The
>  .IR status
>  code is set to
> -.B 0
> +.B FILE_DEDUPE_RANGE_SAME
>  for success, a negative error code in case of error, or
>  .B FILE_DEDUPE_RANGE_DIFFERS
>  if the data did not match.
> @@ -150,7 +168,7 @@ regions in directories.
>  .TP
>  .B EOPNOTSUPP
>  This can appear if the filesystem does not support deduplicating either file
> -descriptor.
> +descriptor, or if either file descriptor refers to special inodes.
>  .TP
>  .B EPERM
>  .IR dest_fd
> 
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
