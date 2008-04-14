Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 20:09:31 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3E39BtA002815
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 20:09:12 -0700
From: Niv Sardi <xaiki@cxhome.ath.cx>
Subject: Re: [patch] xfsqa - 166 - fix filter for stripe aligned filesystems
References: <20080411033628.GN103491721@sgi.com>
Date: Mon, 14 Apr 2008 13:09:43 +1000
In-Reply-To: <20080411033628.GN103491721@sgi.com> (David Chinner's message of
	"Fri, 11 Apr 2008 13:36:28 +1000")
Message-ID: <nccprstf7yg.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>


Looks good, one minor comment.

David Chinner <dgc@sgi.com> writes:

> Flags has extra bits set in it xfs_bmap output when
> the filesyste is using stripe alignment. Fix the test
> to only look at the unwritten flag. Capture the xfs_bmap
> output as well so failures can be debugged easily.
>
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  xfstests/166 |   17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
>
> Index: xfs-cmds/xfstests/166
> ===================================================================
> --- xfs-cmds.orig/xfstests/166	2008-03-25 15:29:35.000000000 +1100
> +++ xfs-cmds/xfstests/166	2008-04-11 13:33:31.220068950 +1000
> @@ -17,6 +17,7 @@ here=`pwd`
>  tmp=/tmp/$$
>  status=1    # failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
> +rm $seq.full

rm -f ? so that it doesn't complain when file is not there ?
  
>  _cleanup()
>  {
> @@ -39,9 +40,14 @@ _filter_blocks()
>  		unwritten2 = ((1048576/512) / 2) - 2 * written_size
>  	}
>  
> -	if ($7) {
> -		size = "RIGHT"
> -		flags = "GOOD"
> +	/* is the extent unwritten? */
> +	unwritten_ext = 0;
> +	if ($7 >= 10000)
> +		unwritten_ext = 1;
> +
> +	size = "RIGHT"
> +	flags = "GOOD"
> +	if (unwritten_ext) {
>  		if (unwritten1) {
>  			if ($6 != unwritten1)
>  				size = "WRONG"
> @@ -49,11 +55,7 @@ _filter_blocks()
>  		} else if ($6 != unwritten2) {
>  			size = "WRONG"
>  		}
> -		if ($7 < 10000)
> -			flags = "BAD"
>  	} else {
> -		size = "RIGHT"
> -		flags = "GOOD"
>  		if ($6 != written_size)
>  			size = "WRONG"
>  	}
> @@ -77,6 +79,7 @@ FILE_SIZE=1048576
>  rm -f $TEST_FILE
>  $TEST_PROG $FILE_SIZE $TEST_FILE
>  
> +xfs_bmap -vp $TEST_FILE >> $seq.full
>  xfs_bmap -vp $TEST_FILE | _filter_blocks
>  
>  status=0

-- 
Niv Sardi
