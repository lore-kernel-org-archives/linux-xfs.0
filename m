Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F21A7F52
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 19:14:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 27926304067
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 17:14:42 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id 81E2nwc5vI1f71Dw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Aug 2013 17:14:41 -0700 (PDT)
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 2 Aug 2013 18:14:41 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 92C8E1FF001C
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 18:09:13 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r730Ebhc211796 for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 18:14:37 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r730EaQE031000
	for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 18:14:37 -0600
Subject: Re: [PATCH 10/10 v2] xfstests: Remount file system if
	MOUNT_OPTIONS changed
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1373539085-8577-11-git-send-email-lczerner@redhat.com>
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
	<1373539085-8577-11-git-send-email-lczerner@redhat.com>
Date: Fri, 02 Aug 2013 19:14:36 -0500
Message-ID: <1375488876.4155.96.camel@chandra-dt.ibm.com>
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

On Thu, 2013-07-11 at 12:38 +0200, Lukas Czerner wrote:
> When MOUNT_OPTIONS change we should remount TEST_DEV to put the changes
> in effect. This will allow us to have different MOUNT_OPTIONS in sections
> in configuration file.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>

> ---
>  README.config-sections | 8 ++++++++
>  check                  | 8 ++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/README.config-sections b/README.config-sections
> index 4d60272..2849fd5 100644
> --- a/README.config-sections
> +++ b/README.config-sections
> @@ -36,6 +36,14 @@ For every section xfstests will run with specified options and will produce
>  separate results in the '$RESULT_BASE/$section_name' directory.
> 
> 
> +Different mount options
> +-----------------------
> +
> +Specifying different mount options in difference config sections is allowed.
> +When MOUNT_OPTIONS differs in the following section TEST_DEV will be remounted
> +with new MOUNT_OPTIONS automatically before running the test.
> +
> +
>  Multiple file systems
>  ---------------------
> 
> diff --git a/check b/check
> index 5775276..ef91260 100755
> --- a/check
> +++ b/check
> @@ -394,6 +394,7 @@ fi
> 
>  for section in $HOST_OPTIONS_SECTIONS; do
>  	OLD_FSTYP=$FSTYP
> +	OLD_MOUNT_OPTIONS=$MOUNT_OPTIONS
>  	get_next_config $section
> 
>  	mkdir -p $RESULT_BASE
> @@ -422,6 +423,13 @@ for section in $HOST_OPTIONS_SECTIONS; do
>  			exit 1
>  		fi
>  		_prepare_test_list
> +	elif [ "$OLD_MOUNT_OPTIONS" != "$MOUNT_OPTIONS" ]; then
> +		_umount_or_remount_ro $TEST_DEV 2>&1> /dev/null
> +		out=`_mount_or_remount_rw "$MOUNT_OPTIONS" $TEST_DEV $TEST_DIR`
> +		if [ $? -ne 1 ]; then
> +			echo $out
> +			exit 1
> +		fi
>  	fi
> 
>  	init_rc


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
