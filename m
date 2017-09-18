Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36922 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932707AbdIRRQt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Sep 2017 13:16:49 -0400
Subject: Re: [PATCH] xfs_repair: handle missing extent states
References: <20170918163944.GC6540@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f19ea1b1-c86c-d745-b725-ac3befa5e0a3@sandeen.net>
Date: Mon, 18 Sep 2017 12:16:48 -0500
MIME-Version: 1.0
In-Reply-To: <20170918163944.GC6540@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, amir73il@gmail.com

On 9/18/17 11:39 AM, Darrick J. Wong wrote:
> Missed a couple of the new extent states in the bmbt processing, so add
> them to avoid aborting xfs_repair.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/dinode.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index f817b5a..b35a523 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -796,6 +796,7 @@ _("%s fork in ino %" PRIu64 " claims free block %" PRIu64 "\n"),
>  			case XR_E_FS_MAP:
>  			case XR_E_INO:
>  			case XR_E_INUSE_FS:
> +			case XR_E_REFC:
>  				do_warn(
>  _("%s fork in inode %" PRIu64 " claims metadata block %" PRIu64 "\n"),
>  					forkname, ino, b);

I already whined about the naming and use of these XR_E #defines on irc,
but I think that since XR_E_REFC is set in process_rmap_rec when it's found
in the rmap btree, this case should be above the /* fallthrough */ so it says 
"rmap claims metadata use!\n" like everything else set there, no?


> @@ -812,6 +813,12 @@ _("%s fork in %s inode %" PRIu64 " claims used block %" PRIu64 "\n"),
>  					forkname, ftype, ino, b);
>  				goto done;
>  
> +			case XR_E_COW:
> +				do_warn(
> +_("%s fork in %s inode %" PRIu64 " claims CoW block %" PRIu64 "\n"),
> +					forkname, ftype, ino, b);
> +				goto done;
> +

why do cow blocks get a special case and custom warning vs the above cases
that just say "metadata?"

Obviously it's just nitpicking over the do_warn message string, just
double checking on the consistency front. 

-Eric
