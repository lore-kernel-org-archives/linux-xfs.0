Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id B14E47F51
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 05:23:33 -0500 (CDT)
Date: Sat, 23 Mar 2013 03:23:32 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 14/25] xfstests: move remaining tests out of top level
	directory
Message-ID: <20130323102331.GR25253@caliban.engr.sgi.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-15-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363350489-22257-15-git-send-email-david@fromorbit.com>
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

On Fri, Mar 15, 2013 at 11:27:58PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> These are tests that are shared between multiple filesystems (moved
> to shared), and udf/btrfs/ext4 specific tests, moved to appropriate
> directories.
> 
> I created the "shared" directory to indicate tests that are not
> truly generic, but also not filesystem specific. They might rely on
> a feature that is only implmented in a few filesystems and so can't
> be truly generic.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  check                           |   16 +++++++---------
>  group                           |   26 --------------------------
>  254 => tests/btrfs/254          |    0
>  254.out => tests/btrfs/254.out  |    0
>  264 => tests/btrfs/264          |    0
>  264.out => tests/btrfs/264.out  |    0
>  265 => tests/btrfs/265          |    0
>  265.out => tests/btrfs/265.out  |    0
>  276 => tests/btrfs/276          |    0
>  276.out => tests/btrfs/276.out  |    0
>  284 => tests/btrfs/284          |    0
>  284.out => tests/btrfs/284.out  |    0
>  313 => tests/btrfs/313          |    0
>  313.out => tests/btrfs/313.out  |    0
>  tests/btrfs/group               |   11 +++++++++++
>  271 => tests/ext4/271           |    0
>  271.out => tests/ext4/271.out   |    0
>  301 => tests/ext4/301           |    0
>  301.out => tests/ext4/301.out   |    0
>  302 => tests/ext4/302           |    0
>  302.out => tests/ext4/302.out   |    0
>  303 => tests/ext4/303           |    0
>  303.out => tests/ext4/303.out   |    0
>  304 => tests/ext4/304           |    0
>  304.out => tests/ext4/304.out   |    0
>  tests/ext4/group                |   10 ++++++++++
>  051 => tests/shared/051         |    0
>  051.out => tests/shared/051.out |    0
>  218 => tests/shared/218         |    0
>  218.out => tests/shared/218.out |    0
>  243 => tests/shared/243         |    0
>  243.out => tests/shared/243.out |    0
>  272 => tests/shared/272         |    0
>  272.out => tests/shared/272.out |    0
>  289 => tests/shared/289         |    0
>  289.out => tests/shared/289.out |    0
>  298 => tests/shared/298         |    0
>  298.out => tests/shared/298.out |    0
>  305 => tests/shared/305         |    0
>  305.out => tests/shared/305.out |    0
>  tests/shared/group              |   13 +++++++++++++
>  098 => tests/udf/098            |    0
>  098.out => tests/udf/098.out    |    0
>  101 => tests/udf/101            |    0
>  101.out => tests/udf/101.out    |    0
>  102 => tests/udf/102            |    0
>  102.out => tests/udf/102.out    |    0
>  tests/udf/group                 |    8 ++++++++
>  040 => tests/xfs/040            |    0
>  040.good => tests/xfs/040.good  |    0
>  040.out => tests/xfs/040.out    |    0
>  177 => tests/xfs/177            |    0
>  177.out => tests/xfs/177.out    |    0
>  tests/xfs/group                 |    2 ++
>  54 files changed, 51 insertions(+), 35 deletions(-)
>  rename 254 => tests/btrfs/254 (100%)
>  rename 254.out => tests/btrfs/254.out (100%)
>  rename 264 => tests/btrfs/264 (100%)
>  rename 264.out => tests/btrfs/264.out (100%)
>  rename 265 => tests/btrfs/265 (100%)
>  rename 265.out => tests/btrfs/265.out (100%)
>  rename 276 => tests/btrfs/276 (100%)
>  rename 276.out => tests/btrfs/276.out (100%)
>  rename 284 => tests/btrfs/284 (100%)
>  rename 284.out => tests/btrfs/284.out (100%)
>  rename 313 => tests/btrfs/313 (100%)
>  rename 313.out => tests/btrfs/313.out (100%)
>  create mode 100644 tests/btrfs/group
>  rename 271 => tests/ext4/271 (100%)
>  rename 271.out => tests/ext4/271.out (100%)
>  rename 301 => tests/ext4/301 (100%)
>  rename 301.out => tests/ext4/301.out (100%)
>  rename 302 => tests/ext4/302 (100%)
>  rename 302.out => tests/ext4/302.out (100%)
>  rename 303 => tests/ext4/303 (100%)
>  rename 303.out => tests/ext4/303.out (100%)
>  rename 304 => tests/ext4/304 (100%)
>  rename 304.out => tests/ext4/304.out (100%)
>  create mode 100644 tests/ext4/group
>  rename 051 => tests/shared/051 (100%)
>  rename 051.out => tests/shared/051.out (100%)
>  rename 218 => tests/shared/218 (100%)
>  rename 218.out => tests/shared/218.out (100%)
>  rename 243 => tests/shared/243 (100%)
>  rename 243.out => tests/shared/243.out (100%)
>  rename 272 => tests/shared/272 (100%)
>  rename 272.out => tests/shared/272.out (100%)
>  rename 289 => tests/shared/289 (100%)
>  rename 289.out => tests/shared/289.out (100%)
>  rename 298 => tests/shared/298 (100%)
>  rename 298.out => tests/shared/298.out (100%)
>  rename 305 => tests/shared/305 (100%)
>  rename 305.out => tests/shared/305.out (100%)
>  create mode 100644 tests/shared/group
>  rename 098 => tests/udf/098 (100%)
>  rename 098.out => tests/udf/098.out (100%)
>  rename 101 => tests/udf/101 (100%)
>  rename 101.out => tests/udf/101.out (100%)
>  rename 102 => tests/udf/102 (100%)
>  rename 102.out => tests/udf/102.out (100%)
>  create mode 100644 tests/udf/group
>  rename 040 => tests/xfs/040 (100%)
>  rename 040.good => tests/xfs/040.good (100%)
>  rename 040.out => tests/xfs/040.out (100%)
>  rename 177 => tests/xfs/177 (100%)
>  rename 177.out => tests/xfs/177.out (100%)
> 
> diff --git a/check b/check
> index 42b25b5..195c25d 100755
> --- a/check
> +++ b/check
> @@ -36,9 +36,8 @@ here=`pwd`
>  FSTYP=xfs
>  
>  SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
> -TEST_GROUP_DIR="tests"
> -GENERIC_GROUP_DIR="$TEST_GROUP_DIR/generic"
> -XFS_GROUP_DIR="$TEST_GROUP_DIR/xfs"
> +SRC_DIR="tests"
> +SRC_GROUPS="generic shared"
>  
>  # generic initialization
>  iam=check
> @@ -87,13 +86,12 @@ _setenvironment()
>  get_group_list()
>  {
>  	grp=$1
> -	dirs=". $GENERIC_GROUP_DIR $XFS_GROUP_DIR"
>  
> -	for d in $dirs; do
> -		l=$(sed -n < $d/group \
> +	for d in $SRC_GROUPS $FSTYP; do
> +		l=$(sed -n < $SRC_DIR/$d/group \
>  			-e 's/#.*//' \
>  			-e 's/$/ /' \
> -			-e "s;\(^[0-9][0-9][0-9]\).* $grp .*;$d/\1;p")
> +			-e "s;\(^[0-9][0-9][0-9]\).* $grp .*;$SRC_DIR/$d/\1;p")
>  		grpl="$grpl $l"
>  	done
>  	echo $grpl
> @@ -297,7 +295,7 @@ END	{ if (NR > 0) {
>  
>  	echo "" >>check.log
>  	date >>check.log
> -	echo $list | fmt | sed -e 's/^/    /' -e 's;tests/;;g' >>check.log
> +	echo $list | fmt | sed -e 's/^/    /' -e "s;$SRC_DIR/;;g" >>check.log
>  	$interrupt && echo "Interrupted!" >>check.log
>          
>          if [ ! -z "$n_try" -a $n_try != 0 ]
> @@ -378,7 +376,7 @@ do
>  
>      # the filename for the test and the name output are different.
>      # we don't include the tests/ directory in the name output.
> -    seqnum=`echo $seq | sed -e 's;tests/;;'`
> +    seqnum=`echo $seq | sed -e "s;$SRC_DIR/;;"`
>  
>      echo -n "$seqnum"
>  
> diff --git a/group b/group
> index af02cce..e378121 100644
> --- a/group
> +++ b/group
> @@ -119,29 +119,3 @@ deprecated
>  # TIME_FACTOR: Usually means factor of run time, or number of operations
>  stress
>  
> -# test-group association ... one line per test
> -#
> -040 other auto
> -051 acl udf auto quick
> -098 udf auto
> -101 udf
> -102 udf
> -177 rw other auto
> -218 auto fsr quick
> -243 auto quick prealloc
> -254 auto quick
> -264 auto
> -265 auto
> -271 auto rw quick
> -272 auto enospc rw
> -276 auto rw metadata
> -284 auto
> -289 auto quick
> -298 auto trim
> -301 aio dangerous ioctl rw stress
> -302 aio dangerous ioctl rw stress
> -303 aio dangerous ioctl rw stress
> -304 aio dangerous ioctl rw stress
> -305 aio dangerous enospc rw stress
> -313 auto quick
> -
> diff --git a/254 b/tests/btrfs/254
> similarity index 100%
> rename from 254
> rename to tests/btrfs/254
> diff --git a/254.out b/tests/btrfs/254.out
> similarity index 100%
> rename from 254.out
> rename to tests/btrfs/254.out
> diff --git a/264 b/tests/btrfs/264
> similarity index 100%
> rename from 264
> rename to tests/btrfs/264
> diff --git a/264.out b/tests/btrfs/264.out
> similarity index 100%
> rename from 264.out
> rename to tests/btrfs/264.out
> diff --git a/265 b/tests/btrfs/265
> similarity index 100%
> rename from 265
> rename to tests/btrfs/265
> diff --git a/265.out b/tests/btrfs/265.out
> similarity index 100%
> rename from 265.out
> rename to tests/btrfs/265.out
> diff --git a/276 b/tests/btrfs/276
> similarity index 100%
> rename from 276
> rename to tests/btrfs/276
> diff --git a/276.out b/tests/btrfs/276.out
> similarity index 100%
> rename from 276.out
> rename to tests/btrfs/276.out
> diff --git a/284 b/tests/btrfs/284
> similarity index 100%
> rename from 284
> rename to tests/btrfs/284
> diff --git a/284.out b/tests/btrfs/284.out
> similarity index 100%
> rename from 284.out
> rename to tests/btrfs/284.out
> diff --git a/313 b/tests/btrfs/313
> similarity index 100%
> rename from 313
> rename to tests/btrfs/313
> diff --git a/313.out b/tests/btrfs/313.out
> similarity index 100%
> rename from 313.out
> rename to tests/btrfs/313.out
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> new file mode 100644
> index 0000000..6ad497d
> --- /dev/null
> +++ b/tests/btrfs/group
> @@ -0,0 +1,11 @@
> +# QA groups control file
> +# Defines test groups and nominal group owners
> +# - do not start group names with a digit
> +# - comment line before each group is "new" description
> +#
> +254 auto quick
> +264 auto
> +265 auto
> +276 auto rw metadata
> +284 auto
> +313 auto quick
> diff --git a/271 b/tests/ext4/271
> similarity index 100%
> rename from 271
> rename to tests/ext4/271
> diff --git a/271.out b/tests/ext4/271.out
> similarity index 100%
> rename from 271.out
> rename to tests/ext4/271.out
> diff --git a/301 b/tests/ext4/301
> similarity index 100%
> rename from 301
> rename to tests/ext4/301
> diff --git a/301.out b/tests/ext4/301.out
> similarity index 100%
> rename from 301.out
> rename to tests/ext4/301.out
> diff --git a/302 b/tests/ext4/302
> similarity index 100%
> rename from 302
> rename to tests/ext4/302
> diff --git a/302.out b/tests/ext4/302.out
> similarity index 100%
> rename from 302.out
> rename to tests/ext4/302.out
> diff --git a/303 b/tests/ext4/303
> similarity index 100%
> rename from 303
> rename to tests/ext4/303
> diff --git a/303.out b/tests/ext4/303.out
> similarity index 100%
> rename from 303.out
> rename to tests/ext4/303.out
> diff --git a/304 b/tests/ext4/304
> similarity index 100%
> rename from 304
> rename to tests/ext4/304
> diff --git a/304.out b/tests/ext4/304.out
> similarity index 100%
> rename from 304.out
> rename to tests/ext4/304.out
> diff --git a/tests/ext4/group b/tests/ext4/group
> new file mode 100644
> index 0000000..97b1efe
> --- /dev/null
> +++ b/tests/ext4/group
> @@ -0,0 +1,10 @@
> +# QA groups control file
> +# Defines test groups and nominal group owners
> +# - do not start group names with a digit
> +# - comment line before each group is "new" description
> +#
> +271 auto rw quick
> +301 aio dangerous ioctl rw stress
> +302 aio dangerous ioctl rw stress
> +303 aio dangerous ioctl rw stress
> +304 aio dangerous ioctl rw stress
> diff --git a/051 b/tests/shared/051
> similarity index 100%
> rename from 051
> rename to tests/shared/051
> diff --git a/051.out b/tests/shared/051.out
> similarity index 100%
> rename from 051.out
> rename to tests/shared/051.out
> diff --git a/218 b/tests/shared/218
> similarity index 100%
> rename from 218
> rename to tests/shared/218
> diff --git a/218.out b/tests/shared/218.out
> similarity index 100%
> rename from 218.out
> rename to tests/shared/218.out
> diff --git a/243 b/tests/shared/243
> similarity index 100%
> rename from 243
> rename to tests/shared/243
> diff --git a/243.out b/tests/shared/243.out
> similarity index 100%
> rename from 243.out
> rename to tests/shared/243.out
> diff --git a/272 b/tests/shared/272
> similarity index 100%
> rename from 272
> rename to tests/shared/272
> diff --git a/272.out b/tests/shared/272.out
> similarity index 100%
> rename from 272.out
> rename to tests/shared/272.out
> diff --git a/289 b/tests/shared/289
> similarity index 100%
> rename from 289
> rename to tests/shared/289
> diff --git a/289.out b/tests/shared/289.out
> similarity index 100%
> rename from 289.out
> rename to tests/shared/289.out
> diff --git a/298 b/tests/shared/298
> similarity index 100%
> rename from 298
> rename to tests/shared/298
> diff --git a/298.out b/tests/shared/298.out
> similarity index 100%
> rename from 298.out
> rename to tests/shared/298.out
> diff --git a/305 b/tests/shared/305
> similarity index 100%
> rename from 305
> rename to tests/shared/305
> diff --git a/305.out b/tests/shared/305.out
> similarity index 100%
> rename from 305.out
> rename to tests/shared/305.out
> diff --git a/tests/shared/group b/tests/shared/group
> new file mode 100644
> index 0000000..8e18d80
> --- /dev/null
> +++ b/tests/shared/group
> @@ -0,0 +1,13 @@
> +# QA groups control file
> +# Defines test groups and nominal group owners
> +# - do not start group names with a digit
> +# - comment line before each group is "new" description
> +#
> +051 acl udf auto quick
> +218 auto fsr quick
> +243 auto quick prealloc
> +272 auto enospc rw
> +289 auto quick
> +298 auto trim
> +305 aio dangerous enospc rw stress
> +
> diff --git a/098 b/tests/udf/098
> similarity index 100%
> rename from 098
> rename to tests/udf/098
> diff --git a/098.out b/tests/udf/098.out
> similarity index 100%
> rename from 098.out
> rename to tests/udf/098.out
> diff --git a/101 b/tests/udf/101
> similarity index 100%
> rename from 101
> rename to tests/udf/101
> diff --git a/101.out b/tests/udf/101.out
> similarity index 100%
> rename from 101.out
> rename to tests/udf/101.out
> diff --git a/102 b/tests/udf/102
> similarity index 100%
> rename from 102
> rename to tests/udf/102
> diff --git a/102.out b/tests/udf/102.out
> similarity index 100%
> rename from 102.out
> rename to tests/udf/102.out
> diff --git a/tests/udf/group b/tests/udf/group
> new file mode 100644
> index 0000000..24f682c
> --- /dev/null
> +++ b/tests/udf/group
> @@ -0,0 +1,8 @@
> +# QA groups control file
> +# Defines test groups and nominal group owners
> +# - do not start group names with a digit
> +# - comment line before each group is "new" description
> +#
> +098 udf auto
> +101 udf
> +102 udf
> diff --git a/040 b/tests/xfs/040
> similarity index 100%
> rename from 040
> rename to tests/xfs/040
> diff --git a/040.good b/tests/xfs/040.good
> similarity index 100%
> rename from 040.good
> rename to tests/xfs/040.good
> diff --git a/040.out b/tests/xfs/040.out
> similarity index 100%
> rename from 040.out
> rename to tests/xfs/040.out
> diff --git a/177 b/tests/xfs/177
> similarity index 100%
> rename from 177
> rename to tests/xfs/177
> diff --git a/177.out b/tests/xfs/177.out
> similarity index 100%
> rename from 177.out
> rename to tests/xfs/177.out
> diff --git a/tests/xfs/group b/tests/xfs/group
> index e70bd3b..c93fc89 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -33,6 +33,7 @@
>  037 dump ioctl remote tape
>  038 dump ioctl remote tape
>  039 dump ioctl remote tape
> +040 other auto
>  041 growfs ioctl auto
>  042 fsr ioctl auto
>  043 dump ioctl tape
> @@ -133,6 +134,7 @@
>  174 rw filestreams auto
>  175 dmapi auto
>  176 dmapi auto
> +177 rw other auto
>  178 mkfs other auto
>  179 metadata rw auto
>  180 metadata rw auto
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
