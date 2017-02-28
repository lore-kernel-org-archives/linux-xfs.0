Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:27058 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdB1Fh3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 00:37:29 -0500
Date: Mon, 27 Feb 2017 21:35:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs/004: relax freespace check
Message-ID: <20170228053548.GH5297@birch.djwong.org>
References: <20170228005235.9839-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228005235.9839-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Feb 27, 2017 at 04:52:35PM -0800, Christoph Hellwig wrote:
> Just check for a greater equals relation so that we don't have
> to adjust the test for every new reservation scheme we add..
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good!

Tired-of-fixing-this-so-hooray: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  tests/xfs/004 | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/tests/xfs/004 b/tests/xfs/004
> index bbc1aee3..f27f4b79 100755
> --- a/tests/xfs/004
> +++ b/tests/xfs/004
> @@ -83,18 +83,15 @@ eval `$XFS_IO_PROG -x -c resblks $SCRATCH_MNT 2>&1 \
>  echo "resblks gave: resblks=$resblks" >>$seqres.full
>  
>  # check the 'blocks' field from freesp command is OK
> -#  - starting with Linux 4.10-rc the bmbt split reservation moved to be per-AG
>  perl -ne '
>  	BEGIN	{ $avail ='$avail' * 512 + ('$resblks' * '$dbsize');
>  		  $answer="(no xfs_db free blocks line?)" }
>  	/free blocks (\d+)$/	|| next;
>  	$freesp = $1 * '$dbsize';
> -	if ($freesp == $avail + ('$agcount') * '$dbsize' * 8) {
> -		$answer = "yes";
> -	} elsif ($freesp == $avail + (('$agcount' + 1) * '$dbsize' * 4)) {
> +	if ($freesp >= $avail) {
>  		$answer = "yes";
>  	} else {
> -		$answer = "no ($freesp != $avail)";
> +		$answer = "no ($freesp < $avail)";
>  	}
>  	END	{ print "$answer\n" }
>  	' <$tmp.xfs_db >$tmp.ans
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
