Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 18E587F7E
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 05:24:25 -0500 (CDT)
Date: Sat, 23 Mar 2013 03:24:23 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 21/25] xfstests: Reintroduce configurable test expunging.
Message-ID: <20130323102423.GY25253@caliban.engr.sgi.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-22-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363350489-22257-22-git-send-email-david@fromorbit.com>
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

On Fri, Mar 15, 2013 at 11:28:05PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It is definitely handy to be able to disabdle certain tests (e.g. tests that are
> known to hang or crash the test machine on certain kernels), so re-introducing
> the capability of avoiding certain tests just by placing them in a file is
> useful.
> 
> Introduce a command line option to specify the expunged file name. The file will
> exist in each tests/* sub-directory so that only the testname is required, and
> can be managed independently. The use of a command line parameter allows
> multiple expunge files to exist simultaneously in the one xfstests tree which
> simplifies management of a source repository used for multiple versions of a
> distro.
> 
> Typical usage:
> 
> $ cat tests/generic/3.0-stable-avoid
> 280
> $ sudo ./check -X 3.0-stable-avoid generic/280
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 test-1 3.0.39-dgc+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
> MOUNT_OPTIONS -- /dev/vdb /mnt/scratch
> 
> generic/280     [expunged]
> Passed all 0 tests
> $
> 
> Eventually we should be able to automate setting up expunged files based on
> distro release or kernel version through this infrastructure.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  check |   59 ++++++++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 44 insertions(+), 15 deletions(-)
> 
> diff --git a/check b/check
> index cc426db..17bc004 100755
> --- a/check
> +++ b/check
> @@ -34,6 +34,7 @@ have_test_arg=false
>  randomize=false
>  here=`pwd`
>  FSTYP=xfs
> +xfile=""
>  
>  SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
>  SRC_GROUPS="generic shared"
> @@ -72,6 +73,7 @@ check options
>  testlist options
>      -g group[,group...]	include tests from these groups
>      -x group[,group...]	exclude tests from these groups
> +    -X file		exclude individual tests
>      [testlist]		include tests matching names in testlist
>  '
>  	    exit 0
> @@ -110,6 +112,30 @@ get_all_tests()
>  	done
>  }
>  
> +# takes the list of tests to run in $tmp.list, and removes the tests passed to
> +# the function from that list.
> +trim_test_list()
> +{
> +	test_list="$*"
> +
> +	rm -f $tmp.grep
> +	numsed=0
> +	for t in $test_list
> +	do
> +	    if [ $numsed -gt 100 ]; then
> +		grep -v -f $tmp.grep <$tmp.list >$tmp.tmp
> +		mv $tmp.tmp $tmp.list
> +		numsed=0
> +		rm -f $tmp.grep
> +	    fi
> +	    echo "^$t\$" >>$tmp.grep
> +	    numsed=`expr $numsed + 1`
> +	done
> +	grep -v -f $tmp.grep <$tmp.list >$tmp.tmp
> +	mv $tmp.tmp $tmp.list
> +}
> +
> +
>  _wallclock()
>  {
>      date "+%H %M %S" | $AWK_PROG '{ print $1*3600 + $2*60 + $3 }'
> @@ -124,7 +150,7 @@ _timestamp()
>  # start the initialisation work now
>  _setenvironment
>  
> -rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out
> +rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out $tmp.xlist
>  
>  # Autodetect fs type based on what's on $TEST_DEV
>  if [ "$HOSTOS" == "Linux" ]; then
> @@ -177,21 +203,16 @@ while [ $# -gt 0 ]; do
>  		    exit 1
>  		fi
>  
> -		rm -f $tmp.grep
> -		numsed=0
> -		for t in $group_list
> -		do
> -		    if [ $numsed -gt 100 ]; then
> -			grep -v -f $tmp.grep <$tmp.list >$tmp.tmp
> -			mv $tmp.tmp $tmp.list
> -			numsed=0
> -			rm -f $tmp.grep
> -		    fi
> -		    echo "^$t\$" >>$tmp.grep
> -		    numsed=`expr $numsed + 1`
> +		trim_test_list $group_list
> +		;;
> +
> +	-X)	xfile=$2; shift ;
> +		for d in $SRC_GROUPS $FSTYP; do
> +			[ -f $SRC_DIR/$d/$xfile ] || continue
> +			for f in `cat $SRC_DIR/$d/$xfile`; do
> +				echo $d/$f >> $tmp.xlist
> +			done
>  		done
> -		grep -v -f $tmp.grep <$tmp.list >$tmp.tmp
> -		mv $tmp.tmp $tmp.list
>  		;;
>  
>  	-l)	diff="diff" ;;
> @@ -413,6 +434,14 @@ do
>  	#
>  	rm -f $seqres.out.bad
>  
> +	# check if we really should run it
> +	if [ -s $tmp.xlist ]; then
> +		if grep $seqnum $tmp.xlist > /dev/null 2>&1 ; then
> +			echo "       [expunged]"
> +			continue
> +		fi
> +	fi
> +
>  	# slashes now in names, sed barfs on them so use grep
>  	lasttime=`grep -w ^$seq check.time | awk '// {print $2}'`
>  	if [ "X$lasttime" != X ]; then
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
