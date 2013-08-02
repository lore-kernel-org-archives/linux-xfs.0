Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0D3FB7F52
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 18:49:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E87438F8037
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 16:49:52 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id j3czi41C82ELVq2g (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Aug 2013 16:49:51 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 2 Aug 2013 19:49:51 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id B2BC4C90045
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 19:49:46 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r72Nnmp1135882 for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 19:49:48 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r72NnlB0013482 for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 19:49:47 -0400
Subject: Re: [PATCH 03/10 v2] xfstests: Refactor code for obtaining test list
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1373539085-8577-4-git-send-email-lczerner@redhat.com>
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
	<1373539085-8577-4-git-send-email-lczerner@redhat.com>
Date: Fri, 02 Aug 2013 18:49:46 -0500
Message-ID: <1375487386.4155.70.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>

On Thu, 2013-07-11 at 12:37 +0200, Lukas Czerner wrote:
> Put the code for obtaining the list of test into one place which makes
> things more readable. It will also allow us to re-init the list in the
> future if we need it.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  check | 100 ++++++++++++++++++++++++++++++++++++------------------------------
>  1 file changed, 54 insertions(+), 46 deletions(-)
> 
> diff --git a/check b/check
> index 71b179b..dc972d7 100755
> --- a/check
> +++ b/check
> @@ -154,6 +154,56 @@ _timestamp()
>      echo -n " [$now]"
>  }
> 
> +_prepare_test_list()
> +{
> +	unset list
> +	# Tests specified on the command line
> +	if [ -s $tmp.arglist ]; then
> +		cat $tmp.arglist > $tmp.list
> +	else
> +		touch $tmp.list
> +	fi
> +
> +	# Specified groups to include
> +	for group in $GROUP_LIST; do
> +		list=$(get_group_list $group)
> +		if [ -z "$list" ]; then
> +			echo "Group \"$group\" is empty or not defined?"
> +			exit 1
> +		fi
> +
> +		for t in $list; do
> +			grep -s "^$t\$" $tmp.list >/dev/null || \
> +							echo "$t" >>$tmp.list
> +		done
> +	done
> +
> +	if ! $have_test_arg && [ -z "$GROUP_LIST" ]; then
> +		# no test numbers, do everything
> +		get_all_tests
> +	fi
> +
> +	# Specified groups to exclude
> +	for xgroup in $XGROUP_LIST; do
> +		list=$(get_group_list $xgroup)
> +		if [ -z "$list" ]; then
> +			echo "Group \"$xgroup\" is empty or not defined?"
> +			exit 1
> +		fi
> +
> +		trim_test_list $list
> +	done
> +
> +	# sort the list of tests into numeric order
> +	list=`sort -n $tmp.list | uniq`
> +	rm -f $tmp.list $tmp.tmp $tmp.grep
> +
> +	if $randomize
> +	then
> +		list=`echo $list | awk -f randomize.awk`
> +	fi
> +}
> +
>  # Process command arguments first.
>  while [ $# -gt 0 ]; do
>  	case "$1" in
> @@ -164,35 +214,11 @@ while [ $# -gt 0 ]; do
>  	-nfs)	FSTYP=nfs ;;
> 
>  	-g)	group=$2 ; shift ;
> -		group_list=$(get_group_list $group)
> -		if [ -z "$group_list" ]; then
> -		    echo "Group \"$group\" is empty or not defined?"
> -		    exit 1
> -		fi
> -
> -		[ ! -s $tmp.list ] && touch $tmp.list
> -		for t in $group_list; do
> -			grep -s "^$t\$" $tmp.list >/dev/null || \
> -							echo "$t" >>$tmp.list
> -		done
> -
> +		GROUP_LIST="$GROUP_LIST $group"
>  		;;
> 
>  	-x)	xgroup=$2 ; shift ;
> -
> -		# Note: behaviour is dependent on command line ordering of
> -		# -g and -x parameters. If there are no preceding -g commands,
> -		# this works on all tests, otherwise just the tests specified by
> -		# the early -g inclusions.
> -		[ ! -s $tmp.list ] && get_all_tests
> -
> -		group_list=$(get_group_list $xgroup)
> -		if [ -z "$group_list" ]; then
> -		    echo "Group \"$xgroup\" is empty or not defined?"
> -		    exit 1
> -		fi
> -
> -		trim_test_list $group_list
> +		XGROUP_LIST="$XGROUP_LIST $xgroup"
>  		;;
> 
>  	-X)	xfile=$2; shift ;
> @@ -244,7 +270,7 @@ if $have_test_arg; then
> 
>  			if egrep "^$test_name" $group_file >/dev/null ; then
>  				# in group file ... OK
> -				echo $SRC_DIR/$1 >>$tmp.list
> +				echo $SRC_DIR/$1 >>$tmp.arglist
>  			else
>  				# oops
>  				echo "$1 - unknown test, ignored"
> @@ -256,25 +282,7 @@ if $have_test_arg; then
>  	done
>  fi
> 
> -if [ -s $tmp.list ]; then
> -    # found some valid test numbers ... this is good
> -    :
> -elif $have_test_arg; then
> -	# had test numbers, but none in group file ... do nothing
> -	touch $tmp.list
> -else
> -	# no test numbers, do everything
> -	get_all_tests
> -fi
> -
> -# sort the list of tests into numeric order
> -list=`sort -n $tmp.list`
> -rm -f $tmp.list $tmp.tmp $tmp.grep
> -
> -if $randomize
> -then
> -    list=`echo $list | awk -f randomize.awk`
> -fi
> +_prepare_test_list
> 
>  # we need common/rc
>  if ! . ./common/rc


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
