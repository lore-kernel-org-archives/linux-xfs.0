Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id E48DB7F3F
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 05:19:48 -0500 (CDT)
Date: Sat, 23 Mar 2013 03:19:47 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 08/25] xfstests: remove test expunge file support
Message-ID: <20130323101947.GL25253@caliban.engr.sgi.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363350489-22257-9-git-send-email-david@fromorbit.com>
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

On Fri, Mar 15, 2013 at 11:27:52PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Check supports an expunge file for tests - a way of marking tests
> not to run even if you specify it to run. Use is like this:
> 
> $ echo 002 > expunged
> test-2:~/src/xfstests-dev$ sudo ./check 001-003
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 test-2 3.5.0-rc1-dgc+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
> MOUNT_OPTIONS -- /dev/vdb /mnt/scratch
> 
> 001 4s ... 4s
> 002 - expunged
> 003 0s ... 0s
> Ran: 001 002 003
> Not run:1
> Passed all 2 tests
> 
> This is arguably useful(*), but gets in the way of splitting up the
> tests into multiple directories. Remove it for now, but such
> functionality should be considered for re-implementation at a later
> date.
> 
> (*) e.g. having a different "expunged" file for each distro release
> you have to test to avoid the tests known to fail due to fixes or
> features that will never be back ported to older releases....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  check |   18 ------------------
>  1 file changed, 18 deletions(-)
> 
> diff --git a/check b/check
> index d69f948..8a998c4 100755
> --- a/check
> +++ b/check
> @@ -30,7 +30,6 @@ notrun=""
>  interrupt=true
>  diff="diff -u"
>  showme=false
> -expunge=true
>  have_test_arg=false
>  randomize=false
>  here=`pwd`
> @@ -106,10 +105,6 @@ BEGIN	{ for (t='$start'; t<='$end'; t++) printf "%03d\n",t }' \
>  		if grep -s "^$id " group >/dev/null ; then
>  			# in group file ... OK
>  			echo $id >>$tmp.list
> -		elif [ -f expunged ] && $expunge && \
> -				egrep "^$id([ 	]|\$)" expunged >/dev/null ; then
> -			# expunged ... will be reported, but not run, later
> -			echo $id >>$tmp.list
>  		else
>  			# oops
>  			echo "$id - unknown test, ignored"
> @@ -293,13 +288,6 @@ END	{ if (NR > 0) {
>  	    mv $tmp.out check.time
>  	fi
>  
> -	if [ -f $tmp.expunged ]
> -	then
> -	    notrun=`wc -l <$tmp.expunged | sed -e 's/  *//g'`
> -	    n_try=`expr $n_try - $notrun`
> -	    list=`echo "$list" | sed -f $tmp.expunged`
> -	fi
> -
>  	echo "" >>check.log
>  	date >>check.log
>  	echo $list | fmt | sed -e 's/^/    /' >>check.log
> @@ -393,15 +381,9 @@ do
>      then
>  	echo
>  	continue
> -    elif [ -f expunged ] && $expunge && egrep "^$seq([ 	]|\$)" expunged >/dev/null
> -    then
> -	echo " - expunged"
> -	rm -f $seq.out.bad
> -	echo "/^$seq\$/d" >>$tmp.expunged
>      elif [ ! -f $seq ]
>      then
>  	echo " - no such test?"
> -	echo "/^$seq\$/d" >>$tmp.expunged
>      else
>  	# really going to try and run this one
>  	#
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
