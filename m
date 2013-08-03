Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 941C87F52
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 19:05:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4EC1F304066
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 17:05:13 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id lgCrL6wbCksEEbIv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Aug 2013 17:05:11 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 2 Aug 2013 20:05:11 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 3F7856E803A
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 20:05:03 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r73058sv161664 for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 20:05:08 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r73058Pn001418 for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 20:05:08 -0400
Subject: Re: [PATCH 08/10 v2] xfstests: Add support for sections in config file
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1373539085-8577-9-git-send-email-lczerner@redhat.com>
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
	<1373539085-8577-9-git-send-email-lczerner@redhat.com>
Date: Fri, 02 Aug 2013 19:05:07 -0500
Message-ID: <1375488307.4155.86.camel@chandra-dt.ibm.com>
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
> This patch add support for sections in the config file. Each section can

s/add/adds/

> contain configuration options in the format
> 
> OPTION=value
> 

you can say something along the lines of.... sections would contain
different environment variables that can change
 - mount options
 - mkfs options
 - filesystem type
 - different devices
 - whatever I missed....
and xfs will be run with those options and then next section will be
parsed and the tests will be run with those options etc.,

It would be useful to have see that information in README, not
necessarily in commit log.

> when one section is processed xfstests will proceed to next section
> until all secitons are processed, or an error occur.
> 
> The name of the section can consist of alphanumeric characters + '_',

s/+/and/

note: no comments below
> nothing else is allowed. Name of the section is also used to create
> results subdirectory for each section. After all the sections are
> processed summary of all runs is printed out.
> 
> If the config file does not contain sections, or we're not using config
> file at all, nothing is changed and xfstests will work the same way as
> it used to.
> 
> This is very useful for testing file system with different options. Here
> is an example of the config file with sections:
> 
> [ext4_4k_block_size]
> TEST_DEV=/dev/sda
> TEST_DIR=/mnt/test
> SCRATCH_DEV=/dev/sdb
> SCRATCH_MNT=/mnt/test1
> MKFS_OPTIONS="-q -F -b4096"
> FSTYP=ext4
> 
> [ext4_1k_block_size]
> MKFS_OPTIONS="-q -F -b1024"
> 
> [ext4_nojournal]
> MKFS_OPTIONS="-q -F -b4096 -O ^has_journal"
> 
> [ext4_discard_ssd]
> MKFS_OPTIONS="-q -F -b4096"
> TEST_DEV=/dev/sdc
> SCRATCH_DEV=/dev/sdd
> MOUNT_OPTIONS="-o discard"
> 
> Note that once the variable is set it remains set across the sections, so
> you do not have to specify all the options in all sections. However one
> have to make sure that unwanted options are not set from previous
> sections.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  README.config-sections | 50 ++++++++++++++++++++++++++++++++++
>  check                  | 73 +++++++++++++++++++++++++++++++++++++++++---------
>  common/config          | 49 +++++++++++++++++++++++++++++++--
>  3 files changed, 158 insertions(+), 14 deletions(-)
>  create mode 100644 README.config-sections
> 
> diff --git a/README.config-sections b/README.config-sections
> new file mode 100644
> index 0000000..6d88a6f
> --- /dev/null
> +++ b/README.config-sections
> @@ -0,0 +1,50 @@
> +Configuration file with sections
> +================================
> +
> +Configuration file with sections is useful for running xfstests on multiple
> +file systems, or multiple file system setups in a single run without any
> +help of external scripts.
> +
> +Syntax for defining a section is the following:
> +
> +[section_name]
> +
> +Section name should consist of alphanumeric characters and '_'. Anything
> +else is forbidden and the section will not be recognised.
> +
> +Each section in the configuration file should contain options in the format
> +
> +OPTION=value
> +
> +'OPTION' must not contain any white space characters. 'value' can contain
> +any character you want with one simple limitation - characters ' and " can
> +only appear at the start and end of the 'value', however it is not required.
> +
> +Note that options are carried between sections so the same options does not
> +have to be specified in each and every sections. However caution should be
> +exercised not to leave unwanted options set from previous sections.
> +
> +For every section xfstests will run with specified options and will produce
> +separate results in the '$RESULT_BASE/$section_name' directory.
> +
> +Here is an example of config file with sections:
> +
> +[ext4_4k_block_size]
> +TEST_DEV=/dev/sda
> +TEST_DIR=/mnt/test
> +SCRATCH_DEV=/dev/sdb
> +SCRATCH_MNT=/mnt/test1
> +MKFS_OPTIONS="-q -F -b4096"
> +FSTYP=ext4
> +
> +[ext4_1k_block_size]
> +MKFS_OPTIONS="-q -F -b1024"
> +
> +[ext4_nojournal]
> +MKFS_OPTIONS="-q -F -b4096 -O ^has_journal"
> +
> +[ext4_discard_ssd]
> +MKFS_OPTIONS="-q -F -b4096"
> +TEST_DEV=/dev/sdc
> +SCRATCH_DEV=/dev/sdd
> +MOUNT_OPTIONS="-o discard"
> diff --git a/check b/check
> index 677650c..1df7a37 100755
> --- a/check
> +++ b/check
> @@ -22,9 +22,11 @@
>  tmp=/tmp/$$
>  status=0
>  needwrap=true
> +needsum=true
>  n_try=0
>  try=""
>  n_bad=0
> +sum_bad=0
>  bad=""
>  notrun=""
>  interrupt=true
> @@ -296,7 +298,12 @@ then
>      exit 1
>  fi
> 
> -# Ok, time to start running...
> +_wipe_counters()
> +{
> +	n_try="0"
> +	n_bad="0"
> +	unset try notrun bad
> +}
> 
>  _wrapup()
>  {
> @@ -325,16 +332,20 @@ END	{ if (NR > 0) {
>  	date >>$check.log
>  	echo $list | fmt | sed -e 's/^/    /' -e "s;$SRC_DIR/;;g" >>$check.log
>  	$interrupt && echo "Interrupted!" >>$check.log
> -        
> +
> +	echo "SECTION       -- $section" >>$tmp.summary
> +	echo "=========================" >>$tmp.summary
>          if [ ! -z "$n_try" -a $n_try != 0 ]
>  	then
>  	    echo "Ran:$try"
> +	    echo "Ran:$try" >>$tmp.summary
>  	fi
> 
>  	if [ ! -z "$notrun" ]
>  	then
>  	    echo "Not run:$notrun"
>  	    echo "Not run:$notrun" >>$check.log
> +	    echo "Not run:$notrun" >>$tmp.summary
>  	fi
> 
>          if [ ! -z "$n_bad" -a $n_bad != 0 ]
> @@ -343,20 +354,48 @@ END	{ if (NR > 0) {
>  	    echo "Failed $n_bad of $n_try tests"
>  	    echo "Failures:$bad" | fmt >>$check.log
>  	    echo "Failed $n_bad of $n_try tests" >>$check.log
> +	    echo "Failures:$bad" >>$tmp.summary
> +	    echo "Failed $n_bad of $n_try tests" >>$tmp.summary
>  	else
>  	    echo "Passed all $n_try tests"
>  	    echo "Passed all $n_try tests" >>$check.log
> +	    echo "Passed all $n_try tests" >>$tmp.summary
>  	fi
> +	echo "" >>$tmp.summary
>  	needwrap=false
>      fi
> 
> +    sum_bad=`expr $sum_bad + $n_bad`
> +    _wipe_counters
>      rm -f /tmp/*.rawout /tmp/*.out /tmp/*.err /tmp/*.time
> -    rm -f $tmp.*
> +    if ! $OPTIONS_HAVE_SECTIONS; then
> +        rm -f $tmp.*
> +    fi
>  }
> 
> -trap "_wrapup; exit \$status" 0 1 2 3 15
> +_summary()
> +{
> +	_wrapup
> +	if $showme; then
> +		:
> +	elif $needsum; then
> +		count=`wc -L $tmp.summary | cut -f1 -d" "`
> +		cat $tmp.summary
> +		needsum=false
> +	fi
> +	rm -f $tmp.*
> +}
> +
> +if $OPTIONS_HAVE_SECTIONS; then
> +	trap "_summary; exit \$status" 0 1 2 3 15
> +else
> +	trap "_wrapup; exit \$status" 0 1 2 3 15
> +fi
> +
> +for section in $HOST_OPTIONS_SECTIONS; do
> +	get_next_config $section
> +	init_rc
> 
> -if true; then
>  	mkdir -p $RESULT_BASE
>  	if [ ! -d $RESULT_BASE ]; then
>  		echo "failed to create results directory $RESULTS_BASE"
> @@ -366,12 +405,15 @@ if true; then
>  	seq="check"
>  	check="$RESULT_BASE/check"
> 
> -# don't leave old full output behind on a clean run
> +	# don't leave old full output behind on a clean run
>  	rm -f $check.full
> 
>  	[ -f $check.time ] || touch $check.time
> 
> -# print out our test configuration
> +	# print out our test configuration
> +	if $OPTIONS_HAVE_SECTIONS; then
> +		echo "SECTION       -- $section"
> +	fi
>  	echo "FSTYP         -- `_full_fstyp_details`"
>  	echo "PLATFORM      -- `_full_platform_details`"
>  	if [ ! -z "$SCRATCH_DEV" ]; then
> @@ -379,7 +421,7 @@ if true; then
>  		echo "MOUNT_OPTIONS -- `_scratch_mount_options`"
>  	fi
>  	echo
> -
> +	needwrap=true
> 
>  	if [ ! -z "$SCRATCH_DEV" ]; then
>  		umount $SCRATCH_DEV 2>/dev/null
> @@ -419,9 +461,14 @@ if true; then
>  		# Similarly, the result directory needs to replace the tests/
>  		# part of the test location.
>  		group=`dirname $seq`
> -		export RESULT_DIR=`echo $group | sed -e "s;$SRC_DIR;$RESULT_BASE;"`
> +		if $OPTIONS_HAVE_SECTIONS; then
> +			export RESULT_DIR=`echo $group | sed -e "s;$SRC_DIR;${RESULT_BASE}/$section;"`
> +			seqres="$RESULT_BASE/$section/$seqnum"
> +		else
> +			export RESULT_DIR=`echo $group | sed -e "s;$SRC_DIR;$RESULT_BASE;"`
> +			seqres="$RESULT_BASE/$seqnum"
> +		fi
>  		mkdir -p $RESULT_DIR
> -		seqres="$RESULT_BASE/$seqnum"
> 
>  		echo -n "$seqnum"
> 
> @@ -535,8 +582,10 @@ if true; then
> 
>  		 seq="after_$seqnum"
>  	done
> -fi
> +	_wrapup
> +	echo
> +done
> 
>  interrupt=false
> -status=`expr $n_bad`
> +status=`expr $sum_bad`
>  exit
> diff --git a/common/config b/common/config
> index 39dd469..8011ec4 100644
> --- a/common/config
> +++ b/common/config
> @@ -221,15 +221,57 @@ known_hosts()
>  	[ -f $HOST_CONFIG_DIR/$HOST.config ] && export HOST_OPTIONS=$HOST_CONFIG_DIR/$HOST.config
>  }
> 
> +# Returns a list of sections in config file
> +# Each section starts with the section name in the format
> +# [section_name1]. Only alphanumeric characters and '_' is allowed
> +# in the section name otherwise the section will not be resognised.
> +# Section name must be contained between square brackets.
> +get_config_sections() {
> +	sed -n -e "s/^\[\([[:alnum:]_]*\)\]/\1/p" < $1
> +}
> +
>  if [ ! -f "$HOST_OPTIONS" ]; then
>  	known_hosts
>  fi
> 
> +export HOST_OPTIONS_SECTIONS="-no-sections-"
> +export OPTIONS_HAVE_SECTIONS=false
>  if [ -f "$HOST_OPTIONS" ]; then
> -	. $HOST_OPTIONS
> +	export HOST_OPTIONS_SECTIONS=`get_config_sections $HOST_OPTIONS`
> +	if [ -z "$HOST_OPTIONS_SECTIONS" ]; then
> +		. $HOST_OPTIONS
> +		export HOST_OPTIONS_SECTIONS="-no-sections-"
> +	else
> +		export OPTIONS_HAVE_SECTIONS=true
> +	fi
>  fi
> 
> +# Parse config section options. This function will parse all the configuration
> +# within a single section which name is passed as an argument. For section
> +# name format see comments in get_config_sections().
> +# Empty lines and everything after '#' will be ignored.
> +# Configuration options should be defined in the format
> +#
> +# CONFIG_OPTION=value
> +#
> +# This 'CONFIG_OPTION' variable and will be exported as an environment variable.
> +parse_config_section() {
> +	SECTION=$1
> +	if ! $OPTIONS_HAVE_SECTIONS; then
> +		return 0
> +	fi
> +	eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
> +		-e 's/#.*$//' \
> +		-e 's/[[:space:]]*$//' \
> +		-e 's/^[[:space:]]*//' \
> +		-e "s/^\(.*\)=\"\?'\?\([^\"']*\)\"\?'\?$/export \1=\"\2\"/" \
> +		< $HOST_OPTIONS \
> +		| sed -n -e "/^\[$SECTION\]/,/^\s*\[/{/^[^#].*\=.*/p;}"`
> +}
> +
>  get_next_config() {
> +	parse_config_section $1
> +
>  	# set default RESULT_BASE
>  	if [ -z "$RESULT_BASE" ]; then
>  		export RESULT_BASE="$here/results/"
> @@ -282,7 +324,10 @@ get_next_config() {
>  	fi
>  }
> 
> -get_next_config
> +if [ -z "$CONFIG_INCLUDED" ]; then
> +	get_next_config `echo $HOST_OPTIONS_SECTIONS | cut -f1 -d" "`
> +	export CONFIG_INCLUDED=true
> +fi
> 
>  # make sure this script returns success
>  /bin/true


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
