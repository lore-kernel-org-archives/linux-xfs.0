Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2AA5F7F52
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 18:50:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1131D304053
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 16:50:31 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id c2uCh1bKA34hzMel (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Aug 2013 16:50:30 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 2 Aug 2013 19:50:29 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 49E0DC90026
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 19:50:26 -0400 (EDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r72NoR8x204634 for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 19:50:27 -0400
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r72NoQ4Z031178
	for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 17:50:26 -0600
Subject: Re: [PATCH 04/10 v2] xfstests: Allow to recheck options in common/rc
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1373539085-8577-5-git-send-email-lczerner@redhat.com>
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
	<1373539085-8577-5-git-send-email-lczerner@redhat.com>
Date: Fri, 02 Aug 2013 18:50:26 -0500
Message-ID: <1375487426.4155.71.camel@chandra-dt.ibm.com>
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
> Move configuration checks into separate function to allow us to recheck
> the options without the need to reinclude the whole source file which is
> ugly. We still run the check on include.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  common/rc | 74 ++++++++++++++++++++++++++++++++-------------------------------
>  1 file changed, 38 insertions(+), 36 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index fe6bbfc..0dd30a3 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2131,46 +2131,48 @@ run_check()
>  	"$@" >> $seqres.full 2>&1 || _fail "failed: '$@'"
>  }
> 
> -################################################################################
> -
> -if [ "$iam" != new ]
> -then
> -    # make some further configuration checks here
> -
> -    if [ "$TEST_DEV" = ""  ]
> -    then
> -        echo "common/rc: Error: \$TEST_DEV is not set"
> -        exit 1
> -    fi
> -
> -    # if $TEST_DEV is not mounted, mount it now as XFS
> -    if [ -z "`_fs_type $TEST_DEV`" ]
> -    then
> -        # $TEST_DEV is not mounted
> -        if ! _test_mount
> -        then
> -            echo "common/rc: retrying test device mount with external set"
> -            [ "$USE_EXTERNAL" != "yes" ] && export USE_EXTERNAL=yes
> -            if ! _test_mount
> -            then
> -                echo "common/rc: could not mount $TEST_DEV on $TEST_DIR"
> -                exit 1
> -            fi
> -        fi
> -    fi
> +init_rc()
> +{
> +	if [ "$iam" == new ]
> +	then
> +		return
> +	fi
> +	# make some further configuration checks here
> +	if [ "$TEST_DEV" = ""  ]
> +	then
> +		echo "common/rc: Error: \$TEST_DEV is not set"
> +		exit 1
> +	fi
> 
> -    if [ "`_fs_type $TEST_DEV`" != "$FSTYP" ]
> -    then
> -        echo "common/rc: Error: \$TEST_DEV ($TEST_DEV) is not a MOUNTED $FSTYP filesystem"
> -        $DF_PROG $TEST_DEV
> -        exit 1
> -    fi
> +	# if $TEST_DEV is not mounted, mount it now as XFS
> +	if [ -z "`_fs_type $TEST_DEV`" ]
> +	then
> +		# $TEST_DEV is not mounted
> +		if ! _test_mount
> +		then
> +			echo "common/rc: retrying test device mount with external set"
> +			[ "$USE_EXTERNAL" != "yes" ] && export USE_EXTERNAL=yes
> +			if ! _test_mount
> +			then
> +				echo "common/rc: could not mount $TEST_DEV on $TEST_DIR"
> +				exit 1
> +			fi
> +		fi
> +	fi
> 
> -    # Figure out if we need to add -F ("foreign", deprecated) option to xfs_io
> -    xfs_io -c stat $TEST_DIR 2>&1 | grep -q "is not on an XFS filesystem" && \
> +	if [ "`_fs_type $TEST_DEV`" != "$FSTYP" ]
> +	then
> +		echo "common/rc: Error: \$TEST_DEV ($TEST_DEV) is not a MOUNTED $FSTYP filesystem"
> +		$DF_PROG $TEST_DEV
> +		exit 1
> +	fi
> +	# Figure out if we need to add -F ("foreign", deprecated) option to xfs_io
> +	xfs_io -c stat $TEST_DIR 2>&1 | grep -q "is not on an XFS filesystem" && \
>  	export XFS_IO_PROG="$XFS_IO_PROG -F"
> +}
> 
> -fi
> +init_rc
> 
> +################################################################################
>  # make sure this script returns success
>  /bin/true


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
