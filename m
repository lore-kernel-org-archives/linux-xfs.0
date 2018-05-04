Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43816 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751709AbeEDTqh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 15:46:37 -0400
Subject: Re: [PATCH 04/11] xfs_repair: zap corrupt remote symlink
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
 <152401961698.13319.6780338835004190495.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <95da5fba-4cb6-ddd2-6111-54f8c2cc77e0@sandeen.net>
Date: Fri, 4 May 2018 14:46:35 -0500
MIME-Version: 1.0
In-Reply-To: <152401961698.13319.6780338835004190495.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 4/17/18 9:46 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If a remote symlink has a corrupted remote block, just zap the symlink.
> Fixes total lack of repair activity in xfs/382.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Huh.  Yup! Weird omission...

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Though I don't think "symlink remote" means much to an admin, *shrug*
I suppose it helps us triage.

> ---
>  repair/dinode.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 9af4f05..ceffc52 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -1330,6 +1330,13 @@ _("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
>  				lino, i, fsbno);
>  			return 1;
>  		}
> +		if (bp->b_error == -EFSCORRUPTED) {
> +			do_warn(
> +_("Corrupt symlink remote, block %" PRIu64 ", inode %" PRIu64 ".\n"),
> +				fsbno, lino);
> +			libxfs_putbuf(bp);
> +			return 1;
> +		}
>  		if (bp->b_error == -EFSBADCRC) {
>  			do_warn(
>  _("Bad symlink buffer CRC, block %" PRIu64 ", inode %" PRIu64 ".\n"
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
