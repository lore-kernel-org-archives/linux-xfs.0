Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:32826 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757886AbcJRGGO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2016 02:06:14 -0400
Subject: Re: [PATCH 1/2] man2/fallocate.2: document behavior with shared
 blocks
References: <147675566778.12400.16090171199161180354.stgit@birch.djwong.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <d4886eaf-3b80-ca55-012f-e5d06d87b8a5@gmail.com>
Date: Tue, 18 Oct 2016 08:06:10 +0200
MIME-Version: 1.0
In-Reply-To: <147675566778.12400.16090171199161180354.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-man@vger.kernel.org

Hi Darrick,

On 10/18/2016 03:54 AM, Darrick J. Wong wrote:
> Add a blurb to the fallocate manpage explaining that the fallocate
> command with the UNSHARE mode flag may use CoW to unshare blocks to
> guarantee that a disk write won't fail with ENOSPC.

Thanks! Applied.

Cheers,

Michael


> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man2/fallocate.2 |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> 
> diff --git a/man2/fallocate.2 b/man2/fallocate.2
> index 54d6340..3ed1460 100644
> --- a/man2/fallocate.2
> +++ b/man2/fallocate.2
> @@ -79,6 +79,16 @@ but the file size will not be changed even if
>  is greater than the file size.
>  Preallocating zeroed blocks beyond the end of the file in this manner
>  is useful for optimizing append workloads.
> +
> +If the
> +.B FALLOC_FL_UNSHARE
> +flag is specified in
> +.IR mode ,
> +shared file data extents will be made private to the file to guarantee
> +that a subsequent write will not fail due to lack of space.
> +Typically, this will be done by performing a copy-on-write operation on
> +all shared data in the file.
> +This flag may not be supported by all filesystems.
>  .PP
>  Because allocation is done in block size chunks,
>  .BR fallocate ()
> 
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
