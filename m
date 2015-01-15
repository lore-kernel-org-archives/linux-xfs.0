Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF5D37F4E
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2015 15:44:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CCEE3304048
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2015 13:44:51 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pcpCohwbYAk5QNhs for <xfs@oss.sgi.com>;
	Thu, 15 Jan 2015 13:44:44 -0800 (PST)
Message-ID: <54B834CB.2030400@sandeen.net>
Date: Thu, 15 Jan 2015 15:44:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] repair: fix unnecessary secondary scan if only last
	sb is corrupt
References: <1421179693-17227-1-git-send-email-bfoster@redhat.com>
	<1421179693-17227-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1421179693-17227-2-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On 1/13/15 2:08 PM, Brian Foster wrote:
> verify_set_primary_sb() scans the secondary superbocks based on the
> geometry specified in the primary and determines the most likely correct
> geometry by tracking how many superblocks are consistent across the set.
> The most frequent geometry is copied into the primary superblock. The
> return value is checked by the caller (phase1()) to determine whether a
> brute force secondary scan is necessary.
> 
> This generally occurs when not enough secondary sb's are consistent to
> declare the geometry correct. If enough secondaries are consistent,
> verify_set_primary_sb() returns the status of the last secondary sb that
> was scanned. Corruptions to secondary supers other than the last are
> thus resolved fine. If the last secondary is corrupt, however, an error
> is returned to phase1(). This causes a brute force scan even if enough
> supers were found to repair the last secondary.
> 
> Move the initialization of retval to after the sb scan to return an
> error only if not enough secondary supers were found to declare a
> correct geometry.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Nice.  Brute-force scan is awful, doing it when unnecessary stinks!  :)

could this be fstest-ed?

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/sb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/repair/sb.c b/repair/sb.c
> index ad27756..dc154f7 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -724,7 +724,6 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
>  	 * sector size rather than the sector size in @rsb.
>  	 */
>  	size = NUM_AGH_SECTS * (1 << (XFS_MAX_SECTORSIZE_LOG));
> -	retval = 0;
>  	list = NULL;
>  	num_ok = 0;
>  	*sb_modified = 0;
> @@ -779,6 +778,7 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
>  	/*
>  	 * see if we have enough superblocks to bother with
>  	 */
> +	retval = 0;
>  	if (num_ok < num_sbs / 2) {
>  		retval = XR_INSUFF_SEC_SB;
>  		goto out_free_list;
> @@ -868,5 +868,5 @@ out_free_list:
>  	free_geo(list);
>  	free(sb);
>  	free(checked);
> -	return(retval);
> +	return retval;
>  }
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
