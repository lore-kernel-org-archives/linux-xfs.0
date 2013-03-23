Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id F195A7F74
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 05:23:40 -0500 (CDT)
Date: Sat, 23 Mar 2013 03:23:39 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 15/25] xfstests: rework CLI individual test specification
Message-ID: <20130323102339.GS25253@caliban.engr.sgi.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363350489-22257-16-git-send-email-david@fromorbit.com>
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

On Fri, Mar 15, 2013 at 11:27:59PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that tests are in separate subdirectories, they cannot be selected purely by
> test number on the command line. We need to specify the test by subdir and test
> name, so effectively we move to specifying them by regexes on the command line
> rather than by expanding a range internally. This is needed to support
> non-numeric test names as well, so the change may as well be made here.
> 
> This means the command line parsing needs to change from trying to detect tests
> by a regex match to a processing loop that simply parses the tests and checks
> for there existence. Hence the moment we find an argument that is not a switch
> (i.e no preceeding "-"), we move from the arg processing loop to the test name
> processing loop. IOWs, tests must be specified last on the command line.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  check |   86 ++++++++++++++++++++++++++++-------------------------------------
>  1 file changed, 37 insertions(+), 49 deletions(-)
> 
> diff --git a/check b/check
> index 195c25d..620de0f 100755
> --- a/check
> +++ b/check
> @@ -71,8 +71,7 @@ check options
>  testlist options
>      -g group[,group...]	include tests from these groups
>      -x group[,group...]	exclude tests from these groups
> -    NNN			include test NNN
> -    NNN-NNN		include test range (eg. 012-021)
> +    [testlist]		include tests matching names in testlist
>  '
>  	    exit 0
>  }
> @@ -97,26 +96,6 @@ get_group_list()
>  	echo $grpl
>  }
>  
> -expand_test_numbers()
> -{
> -	# strip leading zeros, could be considered octal.
> -	start=`echo $1 | sed 's/^0*//'`
> -	end=`echo $2 | sed 's/^0*//'`
> -
> -	$AWK_PROG </dev/null '
> -BEGIN	{ for (t='$start'; t<='$end'; t++) printf "%03d\n",t }' \
> -	| while read id
> -	do
> -		if grep -s "^$id " group >/dev/null ; then
> -			# in group file ... OK
> -			echo $id >>$tmp.list
> -		else
> -			# oops
> -			echo "$id - unknown test, ignored"
> -		fi
> -	done
> -}
> -
>  _wallclock()
>  {
>      date "+%H %M %S" | $AWK_PROG '{ print $1*3600 + $2*60 + $3 }'
> @@ -146,6 +125,7 @@ then
>      exit 1
>  fi
>  
> +# Process command arguments first.
>  while [ $# -gt 0 ]; do
>  	case "$1" in
>  	-\? | -h | --help) usage ;;
> @@ -202,42 +182,50 @@ while [ $# -gt 0 ]; do
>  
>  	-T)	timestamp=true ;;
>  
> -	"$SUPPORTED_TESTS")
> -		echo "No tests?"
> -		status=1
> -		exit $status
> -		;;
> -
> -	[0-9]*-[0-9]*)
> -		eval `echo $1 | sed -e 's/^/start=/' -e 's/-/ end=/'`
> -		expand_test_numbers $start $end
> -		have_test_arg=true
> -		;;
> -
> -	[0-9]*-)
> -		eval `echo $1 | sed -e 's/^/start=/' -e 's/-//'`
> -		end=`echo $SUPPORTED_TESTS | sed -e 's/\[0-9]//g' -e 's/  *$//' -e 's/.* //'`
> -		if [ -z "$end" ]; then
> -			echo "No tests in range \"$1\"?"
> -			status=1
> -			exit $status
> -		fi
> -		expand_test_numbers $start $end
> -		have_test_arg=true
> -		;;
> -
>  	--large-fs) export LARGE_SCRATCH_DEV=yes ;;
>  	--extra-space=*) export SCRATCH_DEV_EMPTY_SPACE=${r#*=} ;;
>  
>  	-*)	usage ;;
> -	*)	expand_test_numbers $1 $1 ;
> -		have_test_arg=true
> -		;;
> +	*)	# not an argument, we've got tests now.
> +		have_test_arg=true ;;
>  	esac
>  
> +	# if we've found a test specification, the break out of the processing
> +	# loop before we shift the arguments so that this is the first argument
> +	# that we process in the test arg loop below.
> +	if $have_test_arg; then
> +		break;
> +	fi
> +
>  	shift
>  done
>  
> +# Process tests from command line now.
> +if $have_test_arg; then
> +	while [ $# -gt 0 ]; do
> +		case "$1" in
> +		-*)	echo "Argments before tests, please!"
> +			status=1
> +			exit $status
> +			;;
> +		*)	test_dir=`dirname $1`
> +			test_name=`basename $1`
> +			group_file=$SRC_DIR/$test_dir/group
> +
> +			if grep "^$testname" $group_file >/dev/null ; then
> +				# in group file ... OK
> +				echo $SRC_DIR/$1 >>$tmp.list
> +			else
> +				# oops
> +				echo "$1 - unknown test, ignored"
> +			fi
> +			;;
> +		esac
> +
> +		shift
> +	done
> +fi
> +
>  if [ -s $tmp.list ]; then
>      # found some valid test numbers ... this is good
>      :
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
