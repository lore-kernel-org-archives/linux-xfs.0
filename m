Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55620 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727821AbeLSUZ4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Dec 2018 15:25:56 -0500
Date: Wed, 19 Dec 2018 14:25:50 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 8/8] xfs_repair: fix uninitialized variable warnings
Message-ID: <20181219202550.GB22276@redhat.com>
References: <154524776457.28646.3004453037075812416.stgit@magnolia>
 <154524782350.28646.8296184601173040680.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154524782350.28646.8296184601173040680.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Dec 19, 2018 at 11:30:23AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix some uninitialized variable warnings because ASSERT disappears if
> DEBUG is not defined.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks fine.
Reviewed-by <billodo@redhat.com>

>  repair/dinode.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index f670bf87..c0a56daa 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -1176,8 +1176,8 @@ process_quota_inode(
>  	struct xfs_buf		*bp;
>  	xfs_filblks_t		dqchunklen;
>  	uint			dqperchunk;
> -	int			quota_type;
> -	char			*quota_string;
> +	int			quota_type = 0;
> +	char			*quota_string = NULL;
>  	xfs_dqid_t		dqid;
>  	xfs_fileoff_t		qbno;
>  	int			i;
> 
