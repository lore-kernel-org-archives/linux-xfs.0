Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45286 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729908AbfG3Ol4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jul 2019 10:41:56 -0400
Date: Tue, 30 Jul 2019 07:41:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: design: Fix typo
Message-ID: <20190730144151.GQ1561054@magnolia>
References: <20190730123648.GA20126@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730123648.GA20126@localhost>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sheriff Esseson <sheriffesseson@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 30, 2019 at 01:36:48PM +0100, Sheriff Esseson wrote:
> Replace "possible" with "possibly" and improve the flow of the phrase.
> 
> Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  design/XFS_Filesystem_Structure/overview.asciidoc | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>  mode change 100644 => 100755 design/XFS_Filesystem_Structure/overview.asciidoc
> 
> diff --git a/design/XFS_Filesystem_Structure/overview.asciidoc b/design/XFS_Filesystem_Structure/overview.asciidoc
> old mode 100644
> new mode 100755
> index d15b50a..7628a7d
> --- a/design/XFS_Filesystem_Structure/overview.asciidoc
> +++ b/design/XFS_Filesystem_Structure/overview.asciidoc
> @@ -28,7 +28,7 @@ record.  Both forks associate a logical offset with an extent of physical
>  blocks, which makes sparse files and directories possible.  Directory entries
>  and extended attributes are contained inside a second-level data structure
>  within the blocks that are mapped by the forks.  This structure consists of
> -variable-length directory or attribute records and possible a second B+tree to
> +variable-length directory or attribute records and, possibly, a second B+tree to
>  index these records.
>  
>  XFS employs a journalling log in which metadata changes are collected so that
> -- 
> 2.22.0
> 
