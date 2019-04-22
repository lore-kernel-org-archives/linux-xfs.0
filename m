Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33012 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728710AbfDVUsJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Apr 2019 16:48:09 -0400
Subject: Re: [PATCH 06/10] misc: fix strncpy length complaints
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
 <155594792809.115924.2016290538799986694.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5e7bcc5e-7f54-f64e-e76e-94f57ed64e08@sandeen.net>
Date: Mon, 22 Apr 2019 15:48:03 -0500
MIME-Version: 1.0
In-Reply-To: <155594792809.115924.2016290538799986694.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 4/22/19 10:45 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix a number of complaints about feeding sizeof(dest) directly to
> strncpy.  We do this by declaring the char arrays to be one larger
> than necessary and subtracting one, to ensure that we never overfill
> the buffer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Hm, you don't actually do what the changelog says, do you?  No buffer
changes size in this patch.

And FWIW, neither of these was actually a real problem (fgets guarantees
a null in the string) but hey, whatever makes gcc happy I guess?

(I think we lose a char in the quota array, but 511 chars ought to be
enough for anybody right?)

Patch seems fine, though.

> ---
>  mkfs/xfs_mkfs.c |   13 +++++++++++--
>  quota/edit.c    |    9 ++++++---
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 3e2ef92d..db3ad38e 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3270,8 +3270,17 @@ finish_superblock_setup(
>  	struct xfs_mount	*mp,
>  	struct xfs_sb		*sbp)
>  {
> -	if (cfg->label)
> -		strncpy(sbp->sb_fname, cfg->label, sizeof(sbp->sb_fname));
> +	if (cfg->label) {
> +		size_t		label_len;
> +
> +		/*
> +		 * Labels are null terminated unless the string fits exactly
> +		 * in the label field, so assume sb_fname is zeroed and then
> +		 * do a memcpy because the destination isn't a normal C string.
> +		 */
> +		label_len = min(sizeof(sbp->sb_fname), strlen(cfg->label));
> +		memcpy(sbp->sb_fname, cfg->label, label_len);
> +	}
>  
>  	sbp->sb_dblocks = cfg->dblocks;
>  	sbp->sb_rblocks = cfg->rtblocks;
> diff --git a/quota/edit.c b/quota/edit.c
> index b10a5b34..f9938b8a 100644
> --- a/quota/edit.c
> +++ b/quota/edit.c
> @@ -368,8 +368,7 @@ restore_file(
>  	uint		type)
>  {
>  	char		buffer[512];
> -	char		devbuffer[512];
> -	char		*dev = NULL;
> +	char		dev[512];
>  	uint		mask;
>  	int		cnt;
>  	uint32_t	id;
> @@ -377,7 +376,11 @@ restore_file(
>  
>  	while (fgets(buffer, sizeof(buffer), fp) != NULL) {
>  		if (strncmp("fs = ", buffer, 5) == 0) {
> -			dev = strncpy(devbuffer, buffer+5, sizeof(devbuffer));
> +			/*
> +			 * Copy the device name to dev, strip off the trailing
> +			 * newline, and move on to the next line.
> +			 */
> +			strncpy(dev, buffer + 5, sizeof(dev) - 1);
>  			dev[strlen(dev) - 1] = '\0';
>  			continue;
>  		}
> 
