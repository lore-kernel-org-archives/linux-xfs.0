Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43420 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbeJWMoy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Oct 2018 08:44:54 -0400
Date: Mon, 22 Oct 2018 21:23:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs_repair: initialize realloced bplist in
 longform_dir2_entry_check
Message-ID: <20181023042314.GA28243@magnolia>
References: <9070c949-2720-75ea-01c3-74261bf62f87@sandeen.net>
 <480fc460-e8cd-cb34-924c-59c874ab393e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480fc460-e8cd-cb34-924c-59c874ab393e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Oct 22, 2018 at 11:04:31PM -0500, Eric Sandeen wrote:
> If we need to realloc the bplist[] array holding buffers for a given
> directory, we don't initialize the new slots.  This causes a problem
> if the directory has holes, because those slots never get filled in.
> 
> At the end of the function we call libxfs_putbuf for every non-null
> slot, and any uninitialized slots are segfault landmines.
> 
> Make sure we initialize all new slots to NULL for this reason.
> 
> Reported-by: Oleg Davydov <burunduk3@gmail.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Yay realloc :P

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index b87c751..9d24a4f 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -2348,6 +2348,8 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
>  
>  		db = xfs_dir2_da_to_db(mp->m_dir_geo, da_bno);
>  		if (db >= num_bps) {
> +			int last_size = num_bps;
> +
>  			/* more data blocks than expected */
>  			num_bps = db + 1;
>  			bplist = realloc(bplist, num_bps * sizeof(struct xfs_buf*));
> @@ -2355,6 +2357,9 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
>  				do_error(_("realloc failed in %s (%zu bytes)\n"),
>  					__func__,
>  					num_bps * sizeof(struct xfs_buf*));
> +			/* Initialize the new elements */
> +			for (i = last_size; i < num_bps; i++)
> +				bplist[i] = NULL;
>  		}
>  
>  		if (isblock)
> 
