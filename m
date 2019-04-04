Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52656 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729935AbfDDVaj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 17:30:39 -0400
Subject: Re: [PATCH 39/36] misc: fix strncpy length complaints
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320193542.GC1183@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a238d47e-3867-8f85-7534-985a6e79058a@sandeen.net>
Date: Thu, 4 Apr 2019 16:30:38 -0500
MIME-Version: 1.0
In-Reply-To: <20190320193542.GC1183@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/20/19 2:35 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix a number of complaints about feeding sizeof(dest) directly to
> strncpy.  We do this by declaring the char arrays to be one larger
> than necessary and subtracting one, to ensure that we never overfill
> the buffer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  mkfs/xfs_mkfs.c |   13 +++++++++++--
>  quota/edit.c    |    9 ++++++---
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 9e1c6ec5..e87c692c 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3251,8 +3251,17 @@ finish_superblock_setup(
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

Heh, comparing this to the patch I wrote in <checks notes> December and never
sent *cough*, it seems like it might be wise to memset the whole thing to 0,
to be sure we're not leaking bytes here and there in a short label?

+               memset(sbp->sb_fname, 0, sizeof(sbp->sb_fname));

Although, I suppose the prior strncpy had the same issue... *shrug*

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

Ok.

I had something in io/label.c: label_f() as well.  Do you not get complaints
about strncpy(label, optarg, sizeof(label)); ?

I essentially did the same thing as for mkfs, though with my gratuitous
memset:

                        break;
                case 's':
-                       strncpy(label, optarg, sizeof(label));
+                       len = min(strlen(optarg), sizeof(label));
+                       /* Kernel doesn't care about null termination */
+                       memset(label, 0, sizeof(label));
+                       memcpy(label, optarg, len);
                        break;
                default:
