Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id CB5577F6F
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 05:24:39 -0500 (CDT)
Date: Sat, 23 Mar 2013 03:24:38 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 23/25] xfstests: Decomplicate quota setup in 050
Message-ID: <20130323102438.GA25253@caliban.engr.sgi.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-24-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363350489-22257-24-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Looks OK.

Reviewed-by: Phil White <pwhite@sgi.com>

On Fri, Mar 15, 2013 at 11:28:07PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Only test 050 uses the _qsetup function, and it only uses the ID
> part of it in the test. the attempts to link output files is useless
> as there are no different output files used by the test.
> 
> Hence kill the _qsetup function, and move the code into test 050,
> simplifying it down to the minimum needed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  common/quota  |   47 +----------------------------------------------
>  tests/xfs/050 |   36 +++++++++++++++++++++++++++---------
>  2 files changed, 28 insertions(+), 55 deletions(-)
> 
> diff --git a/common/quota b/common/quota
> index 7f349ab..fd5374f 100644
> --- a/common/quota
> +++ b/common/quota
> @@ -92,7 +92,7 @@ _require_nobody()
>  #
>  _file_as_id()
>  {
> -    [ $# != 5 ] && _notrun "broken call to _file_as_id in test $seq"
> +    [ $# != 5 ] && _fail "broken call to _file_as_id in test $seq"
>  
>      parent=`dirname $1`
>      if [ $3 = p ]; then
> @@ -157,51 +157,6 @@ _qmount()
>      chmod ugo+rwx $SCRATCH_MNT
>  }
>  
> -_qsetup()
> -{
> -    # setup exactly what it is we'll be testing
> -    enforce=1
> -    if src/feature -u $SCRATCH_DEV
> -    then
> -	type=u ;
> -	eval `_choose_uid`
> -	[ ! -f $seq.out ] && ln -s $seq.usrquota $seq.out
> -    elif src/feature -g $SCRATCH_DEV
> -    then
> -	type=g
> -	eval `_choose_gid`
> -	[ ! -f $seq.out ] && ln -s $seq.grpquota $seq.out
> -    elif src/feature -p $SCRATCH_DEV
> -    then
> -	type=p
> -	eval `_choose_prid`
> -	[ ! -f $seq.out ] && ln -s $seq.prjquota $seq.out
> -    elif src/feature -U $SCRATCH_DEV
> -    then
> -	type=u
> -	eval `_choose_uid`
> -	[ ! -f $seq.out ] && ln -s $seq.uqnoenforce $seq.out
> -	enforce=0
> -    elif src/feature -G $SCRATCH_DEV
> -    then
> -	type=g
> -	eval `_choose_gid`
> -	[ ! -f $seq.out ] && ln -s $seq.gqnoenforce $seq.out
> -	enforce=0
> -    elif src/feature -P $SCRATCH_DEV
> -    then
> -	type=p
> -	eval `_choose_prid`
> -	[ ! -f $seq.out ] && ln -s $seq.pqnoenforce $seq.out
> -	enforce=0
> -    else
> -	_notrun "No quota support at mount time"
> -    fi
> -
> -    echo "Using output from '" `ls -l $seq.out` "'" >>$seqres.full
> -    echo "and using type=$type id=$id" >>$seqres.full
> -}
> -
>  #
>  # Ensures only the given quota mount option is used
>  #
> diff --git a/tests/xfs/050 b/tests/xfs/050
> index 774ed28..e2009a8 100755
> --- a/tests/xfs/050
> +++ b/tests/xfs/050
> @@ -98,6 +98,25 @@ _filter_and_check_blks()
>  	' | _filter_report
>  }
>  
> +_qsetup()
> +{
> +	opt=$1
> +	enforce=0
> +	if [ $opt = "u" -o $opt = "uno" ]; then
> +		type=u
> +		eval `_choose_uid`
> +	elif [ $opt = "g" -o $opt = "gno" ]; then
> +		type=g
> +		eval `_choose_gid`
> +	elif [ $opt = "p" -o $opt = "pno" ]; then
> +		type=p
> +		eval `_choose_prid`
> +	fi
> +	[ $opt = "u" -o $opt = "g" -o $opt = "p" ] && enforce=1
> +
> +	echo "Using type=$type id=$id" >> $seqres.full
> +}
> +
>  _exercise()
>  {
>  	_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
> @@ -116,10 +135,9 @@ _exercise()
>  	[ $extsize -ge 512000 ] && \
>  		_notrun "Extent size hint is too large ($extsize bytes)"
>  
> -	_qsetup
> +	_qsetup $1
>  
> -	echo "Using output from '" `ls -l $seq.out` "'" >>$seqres.full
> -	echo "and using type=$type id=$id" >>$seqres.full
> +	echo "Using type=$type id=$id" >>$seqres.full
>  
>  	echo
>  	echo "*** report no quota settings" | tee -a $seqres.full
> @@ -204,11 +222,11 @@ then
>  else
>  	_qmount_option "uquota"
>  fi
> -_exercise
> +_exercise u
>  
>  echo "*** group"
>  _qmount_option "gquota"
> -_exercise
> +_exercise g
>  
>  echo "*** uqnoenforce"
>  if [ "$HOSTOS" == "IRIX" ]
> @@ -217,19 +235,19 @@ then
>  else
>  	_qmount_option "uqnoenforce"
>  fi
> -_exercise
> +_exercise uno
>  
>  echo "*** gqnoenforce"
>  _qmount_option "gqnoenforce"
> -_exercise
> +_exercise gno
>  
>  echo "*** pquota"
>  _qmount_option "pquota"
> -_exercise
> +_exercise p
>  
>  echo "*** pqnoenforce"
>  _qmount_option "pqnoenforce"
> -_exercise
> +_exercise pno
>  
>  # success, all done
>  status=0
> -- 
> 1.7.10.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
