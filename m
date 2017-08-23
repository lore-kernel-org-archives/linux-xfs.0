Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35676 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdHWWd4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 18:33:56 -0400
Subject: Re: [PATCH] ioctl_getfsmap.2: correct semantics of FMR_OF_LAST flag
References: <20170823195225.GF4794@magnolia>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <613388f9-3e18-f99c-5f80-07d196138f60@gmail.com>
Date: Thu, 24 Aug 2017 00:33:48 +0200
MIME-Version: 1.0
In-Reply-To: <20170823195225.GF4794@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mtk.manpages@gmail.com, linux-api@vger.kernel.org, linux-man@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>

On 08/23/2017 09:52 PM, Darrick J. Wong wrote:
> The FMR_OF_LAST flag is applied to the last record in the returned
> dataset, which is not necessarily the last record in the filesystem.
> Correct the documentation to reflect the actual behavior of both
> getfsmap implementations.

Thanks, Darrick. Applied.

Cheers,

Michael


> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man2/ioctl_getfsmap.2 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/man2/ioctl_getfsmap.2 b/man2/ioctl_getfsmap.2
> index 2a3cf06..047a624 100644
> --- a/man2/ioctl_getfsmap.2
> +++ b/man2/ioctl_getfsmap.2
> @@ -225,7 +225,7 @@ The
>  field contains a special value instead of an inode number.
>  .TP
>  .B FMR_OF_LAST
> -This is the last record in the filesystem.
> +This is the last record in the data set.
>  .RE
>  .PP
>  The
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
