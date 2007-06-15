Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Jun 2007 23:23:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5F6NcWt005989
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 23:23:43 -0700
Date: Fri, 15 Jun 2007 16:23:35 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: fix test 004 to account for reserved space
Message-ID: <20070615062335.GO86004887@sgi.com>
References: <20070604063328.GT85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604063328.GT85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>, asg-qa <asg-qa@melbourne.sgi.com>

Ping?

On Mon, Jun 04, 2007 at 04:33:28PM +1000, David Chinner wrote:
> With the changes to use some space by default in only in memory
> as a reserved pool, df and statfs will now output a fre block
> count that is slightly different to  what is held in the superblock.
> 
> Update the qa test to account for this change.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 
> ---
>  xfstests/004 |   35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> Index: xfs-cmds/xfstests/004
> ===================================================================
> --- xfs-cmds.orig/xfstests/004	2006-11-14 19:57:39.000000000 +1100
> +++ xfs-cmds/xfstests/004	2007-05-04 16:38:03.957537306 +1000
> @@ -67,21 +67,36 @@ xfs_db -r -c "freesp -s" $SCRATCH_DEV >$
>  echo "xfs_db for $SCRATCH_DEV" >>$seq.full
>  cat $tmp.xfs_db >>$seq.full
>  
> +eval `$XFS_IO_PROG -x -c resblks $SCRATCH_MNT 2>&1 \
> +	| $AWK_PROG '/available/ { printf "resblks=%u\n", $5 }'`
> +echo "resblks gave: resblks=$resblks" >>$seq.full
> +
>  # check the 'blocks' field from freesp command is OK
>  # since 2.6.18, df does not report the 4 blocks per AG that cannot
>  # be allocated, hence we check for that exact mismatch.
> +# since ~2.6.22, reserved blocks are used by default and df does
> +# not report them, hence check for an exact mismatch.
>  perl -ne '
> -	    BEGIN	{ $avail ='$avail' * 512;
> -			  $answer="(no xfs_db free blocks line?)" }
> -	    /free blocks (\d+)$/	|| next;
> -	    $freesp = $1 * '$dbsize';
> -	    if ($freesp == $avail)	{ $answer = "yes"; }
> -	    else {
> +	BEGIN	{ $avail ='$avail' * 512;
> +		  $answer="(no xfs_db free blocks line?)" }
> +	/free blocks (\d+)$/	|| next;
> +	$freesp = $1 * '$dbsize';
> +	if ($freesp == $avail) {
> +		$answer = "yes";
> +	} else {
>  		$avail = $avail + (('$agcount' + 1) * '$dbsize' * 4);
> -		if ($freesp == $avail)	{ $answer = "yes"; }
> -		else			{ $answer = "no ($freesp != $avail)"; }
> -	    }
> -	    END	{ print "$answer\n" }
> +		if ($freesp == $avail) {
> +			$answer = "yes";
> +		} else {
> +			$avail = $avail + ('$resblks' * '$dbsize');
> +			if ($freesp == $avail) {
> +				$answer = "yes";
> +			} else {
> +				$answer = "no ($freesp != $avail)";
> +			}
> +		}
> +	}
> +	END	{ print "$answer\n" }
>  	' <$tmp.xfs_db >$tmp.ans
>  ans="`cat $tmp.ans`"
>  echo "Checking blocks column same as df: $ans"

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
