Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45085 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726972AbfCDNxM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Mar 2019 08:53:12 -0500
MIME-Version: 1.0
References: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com> <1551449184-7942-3-git-send-email-wshilong1991@gmail.com>
In-Reply-To: <1551449184-7942-3-git-send-email-wshilong1991@gmail.com>
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 4 Mar 2019 14:52:59 +0100
Message-ID: <CAKgNAkitiDEYSZDnJ5iQ6coaE=q45BHxnG2z_bZtWs=kk+2g3w@mail.gmail.com>
Subject: Re: [PATCH 2/2] statx.2: add project support update
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, lixi@ddn.com, Andreas Dilger <adilger@dilger.ca>, Wang Shilong <wshilong@ddn.com>, linux-man <linux-man@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

Hello Wang Shilong,

On Fri, 1 Mar 2019 at 15:06, Wang Shilong <wangshilong1991@gmail.com> wrote:
>
> From: Wang Shilong <wshilong@ddn.com>

I take it that these patches relate to some API changes that are not
yet merged into the kernel, right?

Also, I think we need some accompanying info to describe project IDs.
Can you point me at any documents/resources?

Thanks,

Michael

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
> @@ -261,6 +262,7 @@ STATX_SIZE  Want stx_size
>  STATX_BLOCKS   Want stx_blocks
>  STATX_BASIC_STATS      [All of the above]
>  STATX_BTIME    Want stx_btime
> +STATX_PROJID   Want stx_projid
>  STATX_ALL      [All currently available fields]
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
>  .SH RETURN VALUE
>  On success, zero is returned.
>  On error, \-1 is returned, and
> --
> 2.19.1
>


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
