Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54714 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751611AbeEDWiE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 18:38:04 -0400
Subject: Re: [PATCH 10/11] xfs_repair: check inode nsec for obviously garbage
 values
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
 <152401965412.13319.8835868498112431576.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8655c94b-cce9-a37a-92d7-c3d8e624c38f@sandeen.net>
Date: Fri, 4 May 2018 17:38:02 -0500
MIME-Version: 1.0
In-Reply-To: <152401965412.13319.8835868498112431576.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 4/17/18 9:47 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> It makes no sense to have an nsec value that is larger than 1 second,
> so zero the field if this is the case.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/dinode.c |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index c8c1850..9792293 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2233,6 +2233,28 @@ _("would clear obsolete nlink field in version 2 inode %" PRIu64 ", currently %d
>  	return dirty;
>  }
>  
> +/* Check nanoseconds of a timestamp don't exceed 1 second. */
> +static void
> +check_nsec(
> +	const char		*name,
> +	xfs_ino_t		lino,
> +	struct xfs_timestamp	*t,
> +	int			*dirty)
> +{
> +	if (be32_to_cpu(t->t_nsec) < 1000000000)
> +		return;
> +
> +	do_warn(
> +_("Bad %s nsec %u on inode %" PRIu64 ", "), name, be32_to_cpu(t->t_nsec), lino);
> +	if (no_modify) {
> +		do_warn(_("would reset to zero\n"));
> +	} else {
> +		do_warn(_("resetting to zero\n"));
> +		t->t_nsec = 0;
> +		*dirty = 1;
> +	}
> +}
> +
>  /*
>   * returns 0 if the inode is ok, 1 if the inode is corrupt
>   * check_dups can be set to 1 *only* when called by the
> @@ -2749,6 +2771,13 @@ _("Cannot have CoW extent size of zero on cowextsize inode %" PRIu64 ", "),
>  		}
>  	}
>  
> +	/* nsec fields cannot be larger than 1 billion */
> +	check_nsec("atime", lino, &dino->di_atime, dirty);
> +	check_nsec("mtime", lino, &dino->di_mtime, dirty);
> +	check_nsec("ctime", lino, &dino->di_ctime, dirty);
> +	if (dino->di_version >= 3)
> +		check_nsec("crtime", lino, &dino->di_crtime, dirty);
> +
>  	/*
>  	 * general size/consistency checks:
>  	 */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
