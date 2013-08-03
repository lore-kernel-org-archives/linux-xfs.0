Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C3A467F52
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 19:13:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2799EAC002
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 17:13:56 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id kxICe2AG2aS7WJA2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Aug 2013 17:13:54 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 2 Aug 2013 20:13:54 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 01DAAC90026
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 20:13:50 -0400 (EDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r730DpXt166244 for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 20:13:51 -0400
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r730DoGS016470
	for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 18:13:50 -0600
Subject: Re: [PATCH 09/10 v2] xfstests: Allow to recreate TEST_DEV
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1373539085-8577-10-git-send-email-lczerner@redhat.com>
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
	<1373539085-8577-10-git-send-email-lczerner@redhat.com>
Date: Fri, 02 Aug 2013 19:13:50 -0500
Message-ID: <1375488830.4155.95.camel@chandra-dt.ibm.com>
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
> Add config option RECREATE_TEST_DEV to allow to recreate file system on
> the TEST_DEV device. Permitted values are true and false.
> 
> If RECREATE_TEST_DEV is set to true the TEST_DEV device will be
> unmounted and FSTYP file system will be created on it. Afterwards it
> will be mounted to TEST_DIR again with the default, or specified mount
> options.
> 
> Also recreate the file system if FSTYP differs from the previous
> section.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  README.config-sections |  43 ++++++++++++++++----
>  check                  |  33 ++++++++++++---
>  common/config          | 106 +++++++++++++++++++++++++++++++++++++++++++++++++
>  common/rc              |  26 +++++++++---
>  4 files changed, 189 insertions(+), 19 deletions(-)
> 
> diff --git a/README.config-sections b/README.config-sections
> index 6d88a6f..4d60272 100644
> --- a/README.config-sections
> +++ b/README.config-sections
> @@ -5,16 +5,20 @@ Configuration file with sections is useful for running xfstests on multiple
>  file systems, or multiple file system setups in a single run without any
>  help of external scripts.
> 
> +
> +Syntax
> +------
> +
>  Syntax for defining a section is the following:
> 
> -[section_name]
> +	[section_name]
> 
>  Section name should consist of alphanumeric characters and '_'. Anything
>  else is forbidden and the section will not be recognised.
> 
>  Each section in the configuration file should contain options in the format
> 
> -OPTION=value
> +	OPTION=value

>  'OPTION' must not contain any white space characters. 'value' can contain
>  any character you want with one simple limitation - characters ' and " can
> @@ -24,9 +28,31 @@ Note that options are carried between sections so the same options does not
>  have to be specified in each and every sections. However caution should be
>  exercised not to leave unwanted options set from previous sections.
> 
> +
> +Results
> +-------
> +
>  For every section xfstests will run with specified options and will produce
>  separate results in the '$RESULT_BASE/$section_name' directory.

Above changes can be moved to previous patch

> 
> +
> +Multiple file systems
> +---------------------
> +
> +Having different file systems in different config sections is allowed. When
> +FSTYP differs in the following section the FSTYP file system will be created
> +automatically before running the test.
> +
> +Note that if MOUNT_OPTIONS, MKFS_OPTIONS, or FSCK_OPTIONS are not directly
> +specified in the section it will be reset to the default for a given file
> +system.
> +
> +You can also force the file system recreation by specifying RECREATE_TEST_DEV.
> +
> +
> +Example
> +-------
> +

This too (can be moved to previous patch).
>  Here is an example of config file with sections:
> 
>  [ext4_4k_block_size]
> @@ -36,6 +62,7 @@ SCRATCH_DEV=/dev/sdb
>  SCRATCH_MNT=/mnt/test1
>  MKFS_OPTIONS="-q -F -b4096"
>  FSTYP=ext4
> +RESULT_BASE="`pwd`/results/`date +%d%m%y_%H%M%S`"

This too (can be moved to previous patch). 
> 
>  [ext4_1k_block_size]
>  MKFS_OPTIONS="-q -F -b1024"
> @@ -43,8 +70,10 @@ MKFS_OPTIONS="-q -F -b1024"
>  [ext4_nojournal]
>  MKFS_OPTIONS="-q -F -b4096 -O ^has_journal"
> 
> -[ext4_discard_ssd]
> -MKFS_OPTIONS="-q -F -b4096"
> -TEST_DEV=/dev/sdc
> -SCRATCH_DEV=/dev/sdd
> -MOUNT_OPTIONS="-o discard"
> +[xfs_filesystem]
> +MKFS_OPTIONS="-f"
> +FSTYP=xfs
> +
> +[ext3_filesystem]
> +FSTYP=ext3
> +MOUNT_OPTIONS="-o noatime"
> diff --git a/check b/check
> index 1df7a37..5775276 100755
> --- a/check
> +++ b/check
> @@ -283,8 +283,6 @@ if $have_test_arg; then
>  	done
>  fi
> 
> -_prepare_test_list
> -
>  # we need common/rc
>  if ! . ./common/rc
>  then
> @@ -386,6 +384,8 @@ _summary()
>  	rm -f $tmp.*
>  }
> 
> +_prepare_test_list
> +
>  if $OPTIONS_HAVE_SECTIONS; then
>  	trap "_summary; exit \$status" 0 1 2 3 15
>  else
> @@ -393,8 +393,8 @@ else
>  fi
> 
>  for section in $HOST_OPTIONS_SECTIONS; do
> +	OLD_FSTYP=$FSTYP
>  	get_next_config $section
> -	init_rc
> 
>  	mkdir -p $RESULT_BASE
>  	if [ ! -d $RESULT_BASE ]; then
> @@ -402,6 +402,30 @@ for section in $HOST_OPTIONS_SECTIONS; do
>  		exit 1;
>  	fi
> 
> +	if $OPTIONS_HAVE_SECTIONS; then
> +		echo "SECTION       -- $section"
> +	fi
> +
> +	if $RECREATE_TEST_DEV || [ "$OLD_FSTYP" != "$FSTYP" ]; then
> +		echo "RECREATING    -- $FSTYP on $TEST_DEV"
> +		_umount_or_remount_ro $TEST_DEV 2>&1> /dev/null
> +		if ! _test_mkfs >$tmp.err 2>&1
> +		then
> +			echo "our local _test_mkfs routine ..."
> +			cat $tmp.err
> +			echo "check: failed to mkfs \$TEST_DEV using specified options"
> +			exit 1
> +		fi
> +		out=`_mount_or_remount_rw "$MOUNT_OPTIONS" $TEST_DEV $TEST_DIR`
> +		if [ $? -ne 1 ]; then
> +			echo $out
> +			exit 1
> +		fi
> +		_prepare_test_list
> +	fi
> +
> +	init_rc
> +
>  	seq="check"
>  	check="$RESULT_BASE/check"
> 
> @@ -411,9 +435,6 @@ for section in $HOST_OPTIONS_SECTIONS; do
>  	[ -f $check.time ] || touch $check.time
> 
>  	# print out our test configuration
> -	if $OPTIONS_HAVE_SECTIONS; then
> -		echo "SECTION       -- $section"
> -	fi
>  	echo "FSTYP         -- `_full_fstyp_details`"
>  	echo "PLATFORM      -- `_full_platform_details`"
>  	if [ ! -z "$SCRATCH_DEV" ]; then
> diff --git a/common/config b/common/config
> index 8011ec4..a0b650b 100644
> --- a/common/config
> +++ b/common/config
> @@ -82,6 +82,8 @@ export PWD=`pwd`
>  export MALLOCLIB=${MALLOCLIB:=/usr/lib/libefence.a}
>  export LOCAL_CONFIGURE_OPTIONS=${LOCAL_CONFIGURE_OPTIONS:=--enable-readline=yes}
> 
> +export RECREATE_TEST_DEV=false
> +
>  # $1 = prog to look for, $2* = default pathnames if not found in $PATH
>  set_prog_path()
>  {
> @@ -212,6 +214,91 @@ case "$HOSTOS" in
>          ;;
>  esac
> 
> +_mount_opts()
> +{
> +	# SELinux adds extra xattrs which can mess up our expected output.
> +	# So, mount with a context, and they won't be created
> +	# # nfs_t is a "liberal" context so we can use it.
> +	if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
> +		SELINUX_MOUNT_OPTIONS="-o context=system_u:object_r:nfs_t:s0"
> +		export SELINUX_MOUNT_OPTIONS
> +	fi
> +
> +	case $FSTYP in
> +	xfs)
> +		export MOUNT_OPTIONS=$XFS_MOUNT_OPTIONS
> +		;;
> +	udf)
> +		export MOUNT_OPTIONS=$UDF_MOUNT_OPTIONS
> +		;;
> +	nfs)
> +		export MOUNT_OPTIONS=$NFS_MOUNT_OPTIONS
> +		;;

If we need to have these as default for these filesystem below (in these
scenario), shouldn't we change them to be the default for other
invocations too ? 

Basically, change what is default for those filesystems and use them
directly (as xfs, udf and nfs above) here. What do you think ?
 
> 
> +	ext2|ext3|ext4|ext4dev)
> +		# acls & xattrs aren't turned on by default on ext$FOO
> +		export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
> +		;;
> +	reiserfs)
> +		# acls & xattrs aren't turned on by default on reiserfs
> +		export MOUNT_OPTIONS="-o acl,user_xattr $REISERFS_MOUNT_OPTIONS"
> +		;;
> +	gfs2)
> +		# acls aren't turned on by default on gfs2
> +		export MOUNT_OPTIONS="-o acl $GFS2_MOUNT_OPTIONS"
> +		;;
> +	*)
> +		;;
> +	esac
> +}
> +
> +_mkfs_opts()
> +{
> +	case $FSTYP in
> +	xfs)
> +		export MKFS_OPTIONS=$XFS_MKFS_OPTIONS
> +		;;

Same comment as above here too

> +	udf)
> +		[ ! -z "$udf_fsize" ] && \
> +			UDF_MKFS_OPTIONS="$UDF_MKFS_OPTIONS -s $udf_fsize"
> +		export MKFS_OPTIONS=$UDF_MKFS_OPTIONS
> +		;;
> +	nfs)
> +		export MKFS_OPTIONS=$NFS_MKFS_OPTIONS
> +		;;
> +	reiserfs)
> +		export MKFS_OPTIONS="$REISERFS_MKFS_OPTIONS -q"
> +		;;
> +	gfs2)
> +		export MKFS_OPTIONS="$GFS2_MKFS_OPTIONS -O -p lock_nolock"
> +		;;
> +	jfs)
> +		export MKFS_OPTIONS="$JFS_MKFS_OPTIONS -q"
> +		;;
> +	*)
> +		;;
> +	esac
> +}
> +
> +_fsck_opts()
> +{
> +	case $FSTYP in
> +	ext2|ext3|ext4|ext4dev)
> +		export FSCK_OPTIONS="-nf"
> +		;;
> +	reiserfs)
> +		export FSCK_OPTIONS="--yes"
> +		;;
> +	*)
> +		export FSCK_OPTIONS="-n"
> +		;;
> +	esac
> +}
> +
> +[ -z "$FSTYP" ] && export FSTYP=xfs
> +[ -z "$MOUNT_OPTIONS" ] && _mount_opts
> +[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
> +[ -z "$FSCK_OPTIONS" ] && _fsck_opts
> +
>  known_hosts()
>  {
>  	[ "$HOST_CONFIG_DIR" ] || HOST_CONFIG_DIR=`pwd`/configs
> @@ -270,8 +357,27 @@ parse_config_section() {
>  }
> 
>  get_next_config() {
> +	local OLD_FSTYP=$FSTYP
> +	local OLD_MOUNT_OPTIONS=$MOUNT_OPTIONS
> +	local OLD_MKFS_OPTIONS=$MKFS_OPTIONS
> +	local OLD_FSCK_OPTIONS=$FSCK_OPTIONS
> +
> +	unset MOUNT_OPTIONS
> +	unset MKFS_OPTIONS
> +	unset FSCK_OPTIONS
> +
>  	parse_config_section $1
> 
> +	if [ -n "$OLD_FSTYP" ] && [ $OLD_FSTYP != $FSTYP ]; then
> +		[ -z "$MOUNT_OPTIONS" ] && _mount_opts
> +		[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
> +		[ -z "$FSCK_OPTIONS" ] && _fsck_opts
> +	else
> +		[ -z "$MOUNT_OPTIONS" ] && export MOUNT_OPTIONS=$OLD_MOUNT_OPTIONS
> +		[ -z "$MKFS_OPTIONS" ] && export MKFS_OPTIONS=$OLD_MKFS_OPTIONS
> +		[ -z "$FSCK_OPTIONS" ] && export FSCK_OPTIONS=$OLD_FSCK_OPTIONS
> +	fi
> +
>  	# set default RESULT_BASE
>  	if [ -z "$RESULT_BASE" ]; then
>  		export RESULT_BASE="$here/results/"
> diff --git a/common/rc b/common/rc
> index 0dd30a3..10116a6 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -152,12 +152,6 @@ _fsck_opts()
>      esac
>  }
> 
> -[ -z "$FSTYP" ] && FSTYP=xfs
> -[ -z "$MOUNT_OPTIONS" ] && _mount_opts
> -[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
> -[ -z "$FSCK_OPTIONS" ] && _fsck_opts
> -
> -
>  # we need common/config
>  if [ "$iam" != "check" ]
>  then
> @@ -490,6 +484,7 @@ _setup_large_ext4_fs()
>  	fi
>  	return 0
>  }
> +
>  _scratch_mkfs_ext4()
>  {
>  	local tmp_dir=/tmp/
> @@ -518,6 +513,24 @@ _scratch_mkfs_ext4()
>  	return $mkfs_status
>  }
> 
> +_test_mkfs()
> +{
> +    case $FSTYP in
> +    nfs*)
> +	# do nothing for nfs
> +	;;
> +    udf)
> +        $MKFS_UDF_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null
> +	;;
> +    btrfs)
> +        $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null
> +	;;
> +    *)
> +	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* $TEST_DEV
> +	;;
> +    esac
> +}
> +
>  _scratch_mkfs()
>  {
>      case $FSTYP in
> @@ -919,6 +932,7 @@ _supported_fs()
>      _notrun "not suitable for this filesystem type: $FSTYP"
>  }
> 
> +
>  # tests whether $FSTYP is one of the supported OSes for a test
>  #
>  _supported_os()


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
