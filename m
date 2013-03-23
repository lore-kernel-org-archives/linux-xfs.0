Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id F31AF7F6A
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 05:23:47 -0500 (CDT)
Date: Sat, 23 Mar 2013 03:23:46 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 16/25] xfstests: make exclude groups aware of multiple
	subdirectories
Message-ID: <20130323102346.GT25253@caliban.engr.sgi.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-17-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363350489-22257-17-git-send-email-david@fromorbit.com>
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

On Fri, Mar 15, 2013 at 11:28:00PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that there are no tests in the top level directory, the exlude
> group functionality no longer works (-x group) as it cannot find
> tests to build an initial list of tests. Rework the the exclude
> group implementation to operate correctly on the new test locations.
> 
> Also, switch from sed to grep for exclusion because sed has problems
> distnguishing the '/' in path names from regex control...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  check |   35 +++++++++++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/check b/check
> index 620de0f..d7426e5 100755
> --- a/check
> +++ b/check
> @@ -96,6 +96,19 @@ get_group_list()
>  	echo $grpl
>  }
>  
> +# find all tests, excluding files that are test metadata such as group files.
> +# This assumes that tests are defined purely by alphanumeric filenames with no
> +# ".xyz" extensions in the name.
> +get_all_tests()
> +{
> +	touch $tmp.list
> +	for d in $SRC_GROUPS $FSTYP; do
> +		ls $SRC_DIR/$d/* | \
> +			grep -v "\..*" | \
> +			grep -v group >> $tmp.list 2>/dev/null
> +	done
> +}
> +
>  _wallclock()
>  {
>      date "+%H %M %S" | $AWK_PROG '{ print $1*3600 + $2*60 + $3 }'
> @@ -110,7 +123,7 @@ _timestamp()
>  # start the initialisation work now
>  _setenvironment
>  
> -rm -f $tmp.list $tmp.tmp $tmp.sed $here/$iam.out
> +rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out
>  
>  # Autodetect fs type based on what's on $TEST_DEV
>  if [ "$HOSTOS" == "Linux" ]; then
> @@ -150,27 +163,33 @@ while [ $# -gt 0 ]; do
>  		;;
>  
>  	-x)	xgroup=$2 ; shift ;
> -		[ ! -s $tmp.list ] &&  ls $SUPPORTED_TESTS >$tmp.list 2>/dev/null
> +
> +		# Note: behaviour is dependent on command line ordering of
> +		# -g and -x parameters. If there are no preceding -g commands,
> +		# this works on all tests, otherwise just the tests specified by
> +		# the early -g inclusions.
> +		[ ! -s $tmp.list ] && get_all_tests
> +
>  		group_list=$(get_group_list $xgroup)
>  		if [ -z "$group_list" ]; then
>  		    echo "Group \"$xgroup\" is empty or not defined?"
>  		    exit 1
>  		fi
>  
> -		rm -f $tmp.sed
> +		rm -f $tmp.grep
>  		numsed=0
>  		for t in $group_list
>  		do
>  		    if [ $numsed -gt 100 ]; then
> -			sed -f $tmp.sed <$tmp.list >$tmp.tmp
> +			grep -v -f $tmp.grep <$tmp.list >$tmp.tmp
>  			mv $tmp.tmp $tmp.list
>  			numsed=0
> -			rm -f $tmp.sed
> +			rm -f $tmp.grep
>  		    fi
> -		    echo "/^$t\$/d" >>$tmp.sed
> +		    echo "^$t\$" >>$tmp.grep
>  		    numsed=`expr $numsed + 1`
>  		done
> -		sed -f $tmp.sed <$tmp.list >$tmp.tmp
> +		grep -v -f $tmp.grep <$tmp.list >$tmp.tmp
>  		mv $tmp.tmp $tmp.list
>  		;;
>  
> @@ -239,7 +258,7 @@ fi
>  
>  # sort the list of tests into numeric order
>  list=`sort -n $tmp.list`
> -rm -f $tmp.list $tmp.tmp $tmp.sed
> +rm -f $tmp.list $tmp.tmp $tmp.grep
>  
>  if $randomize
>  then
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
