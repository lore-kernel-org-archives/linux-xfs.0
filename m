Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q85BxoEb041164 for <xfs@oss.sgi.com>; Wed, 5 Sep 2012 06:59:51 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id C8N0yxKMuBsbEWAW for
	<xfs@oss.sgi.com>; Wed, 05 Sep 2012 05:00:42 -0700 (PDT)
Subject: Re: [PATCH 17/18] xfstests: convert tests to use new results directory
From: Boris Ranto <branto@redhat.com>
In-Reply-To: <1343294892-20991-18-git-send-email-david@fromorbit.com>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
	<1343294892-20991-18-git-send-email-david@fromorbit.com>
Date: Wed, 05 Sep 2012 14:00:35 +0200
Message-ID: <1346846436.1129.20.camel@localhost>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 2012-07-26 at 19:28 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Essentially the change is simply this. Converting:
> 
> ... >> $seq.????
> 
> to:
> 
> .... >> $RESULT_DIR/$seq.????
> 
> so that output files are directed to the defined output directory.
> 
> sed to the rescue:
> 
> $ sed -i -e '/^seq=.*$/a seqres=$RESULT_DIR/$seq' -e 's/seq.full/seqres.full/' tests/*/*
> 
> will do most of the work automatically.
> 
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  new               |    3 ++-
>  tests/btrfs/254   |    1 +
>  tests/btrfs/264   |    1 +
>  tests/btrfs/265   |    1 +
>  tests/btrfs/276   |   31 ++++++++++++++++---------------
>  tests/btrfs/284   |    1 +
>  tests/ext4/271    |    3 ++-
>  tests/generic/001 |    9 +++++----
>  tests/generic/002 |    1 +
>  tests/generic/005 |    1 +
>  tests/generic/006 |    1 +
>  tests/generic/007 |    1 +
>  tests/generic/010 |    5 +++--
>  tests/generic/011 |    7 ++++---
>  tests/generic/013 |   21 +++++++++++----------
>  tests/generic/014 |    1 +
>  tests/generic/015 |    9 +++++----
>  tests/generic/020 |    9 +++++----
>  tests/generic/053 |    1 +
>  tests/generic/062 |   15 ++++++++-------
>  tests/generic/069 |   13 +++++++------
>  tests/generic/070 |    3 ++-
>  tests/generic/074 |   11 ++++++-----
>  tests/generic/075 |    7 ++++---
>  tests/generic/076 |   13 +++++++------
>  tests/generic/077 |   21 +++++++++++----------
>  tests/generic/079 |    1 +
>  tests/generic/083 |   15 ++++++++-------
>  tests/generic/088 |    3 ++-
>  tests/generic/089 |    7 ++++---
>  tests/generic/091 |    9 +++++----
>  tests/generic/093 |    3 ++-
>  tests/generic/097 |    3 ++-
>  tests/generic/099 |    3 ++-
>  tests/generic/100 |   11 ++++++-----
>  tests/generic/105 |   11 ++++++-----
>  tests/generic/112 |    7 ++++---
>  tests/generic/113 |    1 +
>  tests/generic/117 |   15 ++++++++-------
>  tests/generic/120 |    1 +
>  tests/generic/123 |    1 +
>  tests/generic/124 |    1 +
>  tests/generic/125 |    1 +
>  tests/generic/126 |    1 +
>  tests/generic/127 |    1 +
>  tests/generic/128 |    1 +
>  tests/generic/129 |    1 +
>  tests/generic/130 |    1 +
>  tests/generic/131 |    1 +
>  tests/generic/132 |    1 +
>  tests/generic/133 |    1 +
>  tests/generic/135 |    1 +
>  tests/generic/141 |    1 +
>  tests/generic/169 |   15 ++++++++-------
>  tests/generic/184 |    1 +
>  tests/generic/192 |    9 +++++----
>  tests/generic/193 |    3 ++-
>  tests/generic/198 |    3 ++-
>  tests/generic/204 |    5 +++--
>  tests/generic/207 |    1 +
>  tests/generic/208 |    1 +
>  tests/generic/209 |    1 +
>  tests/generic/210 |    1 +
>  tests/generic/211 |    1 +
>  tests/generic/212 |    1 +
>  tests/generic/213 |    3 ++-
>  tests/generic/214 |    3 ++-
>  tests/generic/215 |    3 ++-
>  tests/generic/219 |   15 ++++++++-------
>  tests/generic/221 |    1 +
>  tests/generic/223 |   13 +++++++------
>  tests/generic/224 |    7 ++++---
>  tests/generic/225 |    3 ++-
>  tests/generic/226 |    9 +++++----
>  tests/generic/228 |    3 ++-
>  tests/generic/230 |   41 +++++++++++++++++++++--------------------
>  tests/generic/231 |    9 +++++----
>  tests/generic/232 |   11 ++++++-----
>  tests/generic/233 |   11 ++++++-----
>  tests/generic/234 |    7 ++++---
>  tests/generic/235 |   13 +++++++------
>  tests/generic/236 |    1 +
>  tests/generic/237 |    3 ++-
>  tests/generic/239 |    1 +
>  tests/generic/240 |    3 ++-
>  tests/generic/241 |    5 +++--
>  tests/generic/245 |    1 +
>  tests/generic/246 |    1 +
>  tests/generic/247 |    1 +
>  tests/generic/248 |    1 +
>  tests/generic/249 |    7 ++++---
>  tests/generic/251 |    1 +
>  tests/generic/255 |    1 +
>  tests/generic/256 |    1 +
>  tests/generic/257 |    3 ++-
>  tests/generic/258 |    1 +
>  tests/generic/260 |    1 +
>  tests/generic/263 |    9 +++++----
>  tests/generic/269 |    7 ++++---
>  tests/generic/270 |    7 ++++---
>  tests/generic/273 |    7 ++++---
>  tests/generic/274 |   41 +++++++++++++++++++++--------------------
>  tests/generic/275 |    5 +++--
>  tests/generic/277 |    1 +
>  tests/generic/280 |    3 ++-
>  tests/shared/051  |    3 ++-
>  tests/shared/068  |   29 +++++++++++++++--------------
>  tests/shared/218  |   15 ++++++++-------
>  tests/shared/243  |   23 ++++++++++++-----------
>  tests/shared/272  |   11 ++++++-----
>  tests/udf/098     |    3 ++-
>  tests/udf/101     |    1 +
>  tests/udf/102     |    1 +
>  tests/xfs/003     |    1 +
>  tests/xfs/004     |   17 +++++++++--------
>  tests/xfs/008     |    1 +
>  tests/xfs/009     |    1 +
>  tests/xfs/012     |    1 +
>  tests/xfs/016     |   35 ++++++++++++++++++-----------------
>  tests/xfs/017     |   31 ++++++++++++++++---------------
>  tests/xfs/018     |    3 ++-
>  tests/xfs/019     |    3 ++-
>  tests/xfs/021     |    5 +++--
>  tests/xfs/022     |    1 +
>  tests/xfs/023     |    1 +
>  tests/xfs/024     |    5 +++--
>  tests/xfs/025     |    1 +
>  tests/xfs/026     |    1 +
>  tests/xfs/027     |    1 +
>  tests/xfs/028     |    3 ++-
>  tests/xfs/029     |    1 +
>  tests/xfs/030     |    1 +
>  tests/xfs/031     |   13 +++++++------
>  tests/xfs/032     |   15 ++++++++-------
>  tests/xfs/033     |    1 +
>  tests/xfs/034     |   13 +++++++------
>  tests/xfs/035     |    1 +
>  tests/xfs/036     |    1 +
>  tests/xfs/037     |    1 +
>  tests/xfs/038     |    1 +
>  tests/xfs/039     |    1 +
>  tests/xfs/040     |    7 ++++---
>  tests/xfs/041     |    5 +++--
>  tests/xfs/042     |    7 ++++---
>  tests/xfs/043     |    1 +
>  tests/xfs/044     |    1 +
>  tests/xfs/045     |    1 +
>  tests/xfs/046     |    1 +
>  tests/xfs/047     |    3 ++-
>  tests/xfs/048     |    1 +
>  tests/xfs/049     |   53 +++++++++++++++++++++++++++--------------------------
>  tests/xfs/050     |   31 ++++++++++++++++---------------
>  tests/xfs/052     |   19 ++++++++++---------
>  tests/xfs/054     |    7 ++++---
>  tests/xfs/055     |    1 +
>  tests/xfs/056     |    1 +
>  tests/xfs/057     |    1 +
>  tests/xfs/058     |    1 +
>  tests/xfs/059     |    1 +
>  tests/xfs/060     |    1 +
>  tests/xfs/061     |    1 +
>  tests/xfs/063     |    1 +
>  tests/xfs/064     |    9 +++++----
>  tests/xfs/065     |    1 +
>  tests/xfs/066     |    1 +
>  tests/xfs/067     |    9 +++++----
>  tests/xfs/071     |   17 +++++++++--------
>  tests/xfs/072     |    3 ++-
>  tests/xfs/073     |    1 +
>  tests/xfs/078     |    1 +
>  tests/xfs/080     |    1 +
>  tests/xfs/081     |    3 ++-
>  tests/xfs/082     |    3 ++-
>  tests/xfs/084     |    1 +
>  tests/xfs/085     |   11 ++++++-----
>  tests/xfs/086     |   13 +++++++------
>  tests/xfs/087     |   17 +++++++++--------
>  tests/xfs/090     |    1 +
>  tests/xfs/092     |    1 +
>  tests/xfs/094     |    1 +
>  tests/xfs/095     |    1 +
>  tests/xfs/096     |    5 +++--
>  tests/xfs/103     |    1 +
>  tests/xfs/104     |   15 ++++++++-------
>  tests/xfs/106     |    5 +++--
>  tests/xfs/107     |    5 +++--
>  tests/xfs/108     |   15 ++++++++-------
>  tests/xfs/109     |    3 ++-
>  tests/xfs/110     |    1 +
>  tests/xfs/111     |    1 +
>  tests/xfs/114     |   31 ++++++++++++++++---------------
>  tests/xfs/115     |   11 ++++++-----
>  tests/xfs/116     |    1 +
>  tests/xfs/118     |    3 ++-
>  tests/xfs/119     |    1 +
>  tests/xfs/121     |   17 +++++++++--------
>  tests/xfs/122     |    7 ++++---
>  tests/xfs/134     |    5 +++--
>  tests/xfs/136     |    1 +
>  tests/xfs/137     |    1 +
>  tests/xfs/138     |    1 +
>  tests/xfs/139     |    1 +
>  tests/xfs/140     |    1 +
>  tests/xfs/142     |    1 +
>  tests/xfs/143     |    1 +
>  tests/xfs/144     |    1 +
>  tests/xfs/145     |    1 +
>  tests/xfs/146     |    1 +
>  tests/xfs/147     |    1 +
>  tests/xfs/148     |    1 +
>  tests/xfs/149     |   13 +++++++------
>  tests/xfs/150     |    1 +
>  tests/xfs/151     |    3 ++-
>  tests/xfs/152     |    1 +
>  tests/xfs/153     |    1 +
>  tests/xfs/154     |    1 +
>  tests/xfs/155     |    1 +
>  tests/xfs/156     |    5 +++--
>  tests/xfs/157     |    1 +
>  tests/xfs/158     |    1 +
>  tests/xfs/159     |    1 +
>  tests/xfs/160     |    1 +
>  tests/xfs/161     |    1 +
>  tests/xfs/162     |    1 +
>  tests/xfs/163     |    1 +
>  tests/xfs/164     |    5 +++--
>  tests/xfs/165     |    7 ++++---
>  tests/xfs/166     |    5 +++--
>  tests/xfs/167     |    5 +++--
>  tests/xfs/168     |    5 +++--
>  tests/xfs/170     |    3 ++-
>  tests/xfs/171     |    3 ++-
>  tests/xfs/172     |    3 ++-
>  tests/xfs/173     |    3 ++-
>  tests/xfs/174     |    3 ++-
>  tests/xfs/175     |    3 ++-
>  tests/xfs/176     |    3 ++-
>  tests/xfs/177     |    1 +
>  tests/xfs/178     |    1 +
>  tests/xfs/179     |    1 +
>  tests/xfs/180     |    1 +
>  tests/xfs/181     |   17 +++++++++--------
>  tests/xfs/182     |    1 +
>  tests/xfs/183     |    1 +
>  tests/xfs/185     |    1 +
>  tests/xfs/186     |    7 ++++---
>  tests/xfs/187     |    5 +++--
>  tests/xfs/188     |    3 ++-
>  tests/xfs/189     |    3 ++-
>  tests/xfs/190     |   13 +++++++------
>  tests/xfs/191     |    5 +++--
>  tests/xfs/194     |   19 ++++++++++---------
>  tests/xfs/195     |    3 ++-
>  tests/xfs/196     |    3 ++-
>  tests/xfs/197     |    3 ++-
>  tests/xfs/199     |    3 ++-
>  tests/xfs/200     |    3 ++-
>  tests/xfs/201     |    3 ++-
>  tests/xfs/202     |    3 ++-
>  tests/xfs/203     |    3 ++-
>  tests/xfs/205     |    7 ++++---
>  tests/xfs/206     |    3 ++-
>  tests/xfs/216     |    1 +
>  tests/xfs/217     |    1 +
>  tests/xfs/220     |    1 +
>  tests/xfs/222     |    3 ++-
>  tests/xfs/227     |   25 +++++++++++++------------
>  tests/xfs/229     |    1 +
>  tests/xfs/238     |    1 +
>  tests/xfs/242     |    1 +
>  tests/xfs/244     |   17 +++++++++--------
>  tests/xfs/250     |    1 +
>  tests/xfs/252     |    1 +
>  tests/xfs/253     |    1 +
>  tests/xfs/259     |    1 +
>  tests/xfs/261     |    1 +
>  tests/xfs/262     |    1 +
>  tests/xfs/266     |    1 +
>  tests/xfs/267     |    1 +
>  tests/xfs/268     |    1 +
>  tests/xfs/278     |   25 +++++++++++++------------
>  tests/xfs/279     |   11 ++++++-----
>  tests/xfs/281     |    1 +
>  tests/xfs/282     |    5 +++--
>  tests/xfs/283     |    5 +++--
>  285 files changed, 905 insertions(+), 620 deletions(-)
> 
> diff --git a/new b/new
> index 8dde6c5..94638f6 100755
> --- a/new
> +++ b/new
> @@ -106,6 +106,7 @@ cat <<End-of-File >$id
>  #
>  # creator
>  seq=\`basename \$0\`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by \$seq"
>  
>  here=\`pwd\`
> @@ -134,7 +135,7 @@ exit
>  
>  # optional stuff if your test has verbose output to help resolve problems
>  #echo
> -#echo "If failure, check \$seq.full (this) and \$seq.full.ok (reference)"
> +#echo "If failure, check \$seqres.full (this) and \$seqres.full.ok (reference)"
>  
>  # success, all done
>  status=0
> diff --git a/tests/btrfs/254 b/tests/btrfs/254
> index 73089d1..ec3d2c5 100755
> --- a/tests/btrfs/254
> +++ b/tests/btrfs/254
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/btrfs/264 b/tests/btrfs/264
> index a589c7c..46a4926 100755
> --- a/tests/btrfs/264
> +++ b/tests/btrfs/264
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/btrfs/265 b/tests/btrfs/265
> index f28d4e5..760f383 100755
> --- a/tests/btrfs/265
> +++ b/tests/btrfs/265
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/btrfs/276 b/tests/btrfs/276
> index fc87c28..63dec4d 100755
> --- a/tests/btrfs/276
> +++ b/tests/btrfs/276
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -54,7 +55,7 @@ _require_nobigloopfs
>  _require_btrfs inspect-internal
>  _require_command "/usr/sbin/filefrag"
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  FILEFRAG_FILTER='if (/, blocksize (\d+)/) {$blocksize = $1; next} ($ext, '\
>  '$logical, $physical, $expected, $length, $flags) = (/^\s*(\d+)\s+(\d+)'\
> @@ -68,18 +69,18 @@ FILEFRAG_FILTER='if (/, blocksize (\d+)/) {$blocksize = $1; next} ($ext, '\
>  # sample output: "1234#10#5678" -> physical 1234, length 10, logical 5678
>  _filter_extents()
>  {
> -	tee -a $seq.full | $PERL_PROG -ne "$FILEFRAG_FILTER"
> +	tee -a $seqres.full | $PERL_PROG -ne "$FILEFRAG_FILTER"
>  }
>  
>  _check_file_extents()
>  {
>  	cmd="filefrag -vx $1"
> -	echo "# $cmd" >> $seq.full
> +	echo "# $cmd" >> $seqres.full
>  	out=`$cmd | _filter_extents`
>  	if [ -z "$out" ]; then
>  		return 1
>  	fi
> -	echo "after filter: $out" >> $seq.full
> +	echo "after filter: $out" >> $seqres.full
>  	echo $out
>  	return 0
>  }
> @@ -95,9 +96,9 @@ _btrfs_inspect_addr()
>  	expect_inum=$4
>  	file=$5
>  	cmd="$BTRFS_UTIL_PROG inspect-internal logical-resolve -P $addr $mp"
> -	echo "# $cmd" >> $seq.full
> +	echo "# $cmd" >> $seqres.full
>  	out=`$cmd`
> -	echo "$out" >> $seq.full
> +	echo "$out" >> $seqres.full
>  	grep_expr="inode $expect_inum offset $expect_addr root"
>  	echo "$out" | grep "^$grep_expr 5$" >/dev/null
>  	ret=$?
> @@ -128,9 +129,9 @@ _btrfs_inspect_inum()
>  	snap_name=$3
>  	mp="$SCRATCH_MNT/$snap_name"
>  	cmd="$BTRFS_UTIL_PROG inspect-internal inode-resolve $inum $mp"
> -	echo "# $cmd" >> $seq.full
> +	echo "# $cmd" >> $seqres.full
>  	out=`$cmd`
> -	echo "$out" >> $seq.full
> +	echo "$out" >> $seqres.full
>  	grep_expr="^$file$"
>  	cnt=`echo "$out" | grep "$grep_expr" | wc -l`
>  	if [ $cnt -ge "1" ]; then
> @@ -151,9 +152,9 @@ _btrfs_inspect_check()
>  	logical=$4
>  	snap_name=$5
>  	cmd="stat -c %i $file"
> -	echo "# $cmd" >> $seq.full
> +	echo "# $cmd" >> $seqres.full
>  	inum=`$cmd`
> -	echo "$inum" >> $seq.full
> +	echo "$inum" >> $seqres.full
>  	_btrfs_inspect_addr $SCRATCH_MNT $physical $logical $inum $file
>  	ret=$?
>  	if [ $ret -eq 0 ]; then
> @@ -165,8 +166,8 @@ _btrfs_inspect_check()
>  
>  run_check()
>  {
> -	echo "# $@" >> $seq.full 2>&1
> -	"$@" >> $seq.full 2>&1 || _fail "failed: '$@'"
> +	echo "# $@" >> $seqres.full 2>&1
> +	"$@" >> $seqres.full 2>&1 || _fail "failed: '$@'"
>  }
>  
>  workout()
> @@ -177,9 +178,9 @@ workout()
>  	snap_name=$4
>  
>  	umount $SCRATCH_DEV >/dev/null 2>&1
> -	echo "*** mkfs -dsize=$fsz"    >>$seq.full
> -	echo ""                                     >>$seq.full
> -	_scratch_mkfs_sized $fsz >>$seq.full 2>&1 \
> +	echo "*** mkfs -dsize=$fsz"    >>$seqres.full
> +	echo ""                                     >>$seqres.full
> +	_scratch_mkfs_sized $fsz >>$seqres.full 2>&1 \
>  		|| _fail "size=$fsz mkfs failed"
>  	run_check _scratch_mount
>  	# -w ensures that the only ops are ones which cause write I/O
> diff --git a/tests/btrfs/284 b/tests/btrfs/284
> index f8d0340..41688d3 100644
> --- a/tests/btrfs/284
> +++ b/tests/btrfs/284
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  here="`pwd`"
>  tmp=/tmp/$$
> diff --git a/tests/ext4/271 b/tests/ext4/271
> index 50b4c0b..6a0e7b1 100755
> --- a/tests/ext4/271
> +++ b/tests/ext4/271
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -40,7 +41,7 @@ _supported_os Linux
>  _need_to_be_root
>  _require_scratch
>  
> -_scratch_mkfs_sized $((128 * 1024 * 1024)) >> $seq.full 2>&1
> +_scratch_mkfs_sized $((128 * 1024 * 1024)) >> $seqres.full 2>&1
>  
>  # -onoload and EXT4_SYNC_FL on file is important becase result in
>  # metadata sync writes inside ext4_handle_dirty_metadata()
> diff --git a/tests/generic/001 b/tests/generic/001
> index b9997f3..a6659ab 100755
> --- a/tests/generic/001
> +++ b/tests/generic/001
> @@ -32,6 +32,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  # get standard environment, filters and checks
> @@ -189,7 +190,7 @@ _mark_iteration()
>  #
>  _chain()
>  {
> -    $AWK_PROG -v full_file=$here/$seq.full -v verify=$verify <$tmp.config '
> +    $AWK_PROG -v full_file=$here/$seqres.full -v verify=$verify <$tmp.config '
>  BEGIN	{ nfile = 0 }
>  /^\#/	{ next }
>  	{ file[nfile] = $1
> @@ -237,7 +238,7 @@ END	{ srand('$iter')
>  	    }
>  	  }
>  	}' \
> -	| tee -a $here/$seq.full | sh
> +	| tee -a $here/$seqres.full | sh
>  }
>  
>  _check()
> @@ -291,7 +292,7 @@ _cleanup()
>      fi
>  }
>  
> -rm -f $here/$seq.full
> +rm -f $here/$seqres.full
>  status=0
>  _cleanup
>  status=1
> @@ -305,7 +306,7 @@ _setup
>  for iter in 1 2 3 4 5
>  do
>      echo -n "iter $iter chain ... "
> -    echo "iter $iter" >> $here/$seq.full
> +    echo "iter $iter" >> $here/$seqres.full
>      _chain
>      _check
>      if [ -f $tmp.bad ]
> diff --git a/tests/generic/002 b/tests/generic/002
> index db63fa0..ba1a5cf 100755
> --- a/tests/generic/002
> +++ b/tests/generic/002
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  # get standard environment, filters and checks
> diff --git a/tests/generic/005 b/tests/generic/005
> index 27da3d3..ba28502 100755
> --- a/tests/generic/005
> +++ b/tests/generic/005
> @@ -33,6 +33,7 @@
>  # 
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/006 b/tests/generic/006
> index 1437b46..9949d84 100755
> --- a/tests/generic/006
> +++ b/tests/generic/006
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/007 b/tests/generic/007
> index 2bb981f..2d026a3 100755
> --- a/tests/generic/007
> +++ b/tests/generic/007
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/010 b/tests/generic/010
> index 245f407..3587f21 100755
> --- a/tests/generic/010
> +++ b/tests/generic/010
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -59,11 +60,11 @@ _supported_os IRIX Linux
>  
>  _setup_testdir
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  cd $testdir
>  
> -$here/src/dbtest -l 5 -n 1000 2>&1 | tee -a $here/$seq.full | _filter_dbtest
> +$here/src/dbtest -l 5 -n 1000 2>&1 | tee -a $here/$seqres.full | _filter_dbtest
>  
>  # success, all done
>  exit
> diff --git a/tests/generic/011 b/tests/generic/011
> index 4ede2d8..e5c6bbf 100755
> --- a/tests/generic/011
> +++ b/tests/generic/011
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  out=""
> @@ -51,7 +52,7 @@ _setup_testdir
>  
>  out=$testdir/dirstress.$$
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  _test()
>  {
> @@ -63,8 +64,8 @@ _test()
>      if ! $here/src/dirstress -d $out -f $count $args >$tmp.out 2>&1
>      then
>          echo "    dirstress failed"
> -        echo "*** TEST $test -d $out -f $count $args" >>$seq.full
> -        cat $tmp.out >>$seq.full
> +        echo "*** TEST $test -d $out -f $count $args" >>$seqres.full
> +        cat $tmp.out >>$seqres.full
>          status=1
>      fi
>  }
> diff --git a/tests/generic/013 b/tests/generic/013
> index 0879a2a..984ed09 100755
> --- a/tests/generic/013
> +++ b/tests/generic/013
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -73,15 +74,15 @@ _do_test()
>      echo "fsstress.$_n : $_param"
>      echo "-----------------------------------------------"
>      # -m limits number of users/groups so check doesn't fail (malloc) later
> -    dbgoutfile=$seq.full
> +    dbgoutfile=$seqres.full
>      if ! $FSSTRESS_PROG $_param $FSSTRESS_AVOID -v -m 8 -n $_count -d $out >>$dbgoutfile 2>&1
>      then
> -        echo "    fsstress (count=$_count) returned $? - see $seq.full"
> -        echo "--------------------------------------"       >>$here/$seq.full
> -        echo "$_n - output from fsstress:"                  >>$here/$seq.full
> -        echo "--------------------------------------"       >>$here/$seq.full
> -        echo "<NOT LOGGED>"                                 >>$here/$seq.full
> -        #cat $tmp.out                                       >>$here/$seq.full
> +        echo "    fsstress (count=$_count) returned $? - see $seqres.full"
> +        echo "--------------------------------------"       >>$here/$seqres.full
> +        echo "$_n - output from fsstress:"                  >>$here/$seqres.full
> +        echo "--------------------------------------"       >>$here/$seqres.full
> +        echo "<NOT LOGGED>"                                 >>$here/$seqres.full
> +        #cat $tmp.out                                       >>$here/$seqres.full
>          status=1
>      fi
>  
> @@ -95,7 +96,7 @@ _supported_os IRIX Linux
>  
>  _setup_testdir
>  
> -rm -f $here/$seq.full
> +rm -f $here/$seqres.full
>  echo "brevity is wit..."
>  
>  count=1000
> @@ -115,8 +116,8 @@ _do_test 2 "-p $procs -r" $count
>  
>  _do_test 3 "-p 4 -z -f rmdir=10 -f link=10 -f creat=10 -f mkdir=10 -f rename=30 -f stat=30 -f unlink=30 -f truncate=20" $count
>  
> -# if all ok by here then probably don't need $seq.full
> -rm -f $seq.full
> +# if all ok by here then probably don't need $seqres.full
> +rm -f $seqres.full
>  
>  exit
>  
> diff --git a/tests/generic/014 b/tests/generic/014
> index 93caaa6..096e4e5 100755
> --- a/tests/generic/014
> +++ b/tests/generic/014
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/015 b/tests/generic/015
> index 52ab251..a77d2f7 100755
> --- a/tests/generic/015
> +++ b/tests/generic/015
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -56,7 +57,7 @@ _scratch_mkfs_sized `expr 50 \* 1024 \* 1024` >/dev/null 2>&1 \
>      || _fail "mkfs failed"
>  _scratch_mount || _fail "mount failed"
>  out=$SCRATCH_MNT/fillup.$$
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  free0=`_free`
>  if [ -z "$free0" ]
> @@ -64,7 +65,7 @@ then
>      echo "   *** failed to get free space (0)"
>      exit 1
>  fi
> -echo "free space at start $free0" >> $seq.full
> +echo "free space at start $free0" >> $seqres.full
>  
>  echo "fill disk:"	# well, filesystem really - not disk
>  
> @@ -78,7 +79,7 @@ then
>      echo "   *** failed to get free space (1)"
>      exit 1
>  fi
> -echo "free space after fill $free1" >> $seq.full
> +echo "free space after fill $free1" >> $seqres.full
>  
>  if [ ! -e $out ]
>  then
> @@ -116,7 +117,7 @@ then
>      echo "   *** failed to get free space (2)"
>      exit 1
>  fi
> -echo "free space after delete $free2" >> $seq.full
> +echo "free space after delete $free2" >> $seqres.full
>  
>  echo -n "   !!! "
>  _within_tolerance "free space" $free2 $free0 1% -v
> diff --git a/tests/generic/020 b/tests/generic/020
> index 2bd1d9f..42465d8 100755
> --- a/tests/generic/020
> +++ b/tests/generic/020
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -85,7 +86,7 @@ _require_attrs
>  
>  _setup_testdir
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  testfile=$testdir/attribute_$$
>  
> @@ -120,7 +121,7 @@ v=0
>  
>  while [ $v -lt $MAX_ATTRS ]
>  do
> -    echo -n "value_$v" | attr -s "attribute_$v" $testfile >>$seq.full
> +    echo -n "value_$v" | attr -s "attribute_$v" $testfile >>$seqres.full
>      if [ $? -ne 0 ]
>      then
>          echo "!!! failed to add \"attribute_$v\""
> @@ -133,7 +134,7 @@ done
>  echo "*** check"
>  # don't print it all out...
>  getfattr --absolute-names $testfile \
> -    | tee -a $seq.full \
> +    | tee -a $seqres.full \
>      | $AWK_PROG '
>      	/^#/ { next }
>  	/^[ 	]*$/ { next }
> @@ -145,7 +146,7 @@ echo "*** remove lots of attributes"
>  v=0
>  while [ $v -lt $MAX_ATTRS ]
>  do
> -    if ! $ATTR_PROG -r "attribute_$v" $testfile >>$seq.full
> +    if ! $ATTR_PROG -r "attribute_$v" $testfile >>$seqres.full
>      then
>          echo "!!! failed to remove \"attribute_$v\""
>          exit 1
> diff --git a/tests/generic/053 b/tests/generic/053
> index 388c9b4..99dd1b0 100755
> --- a/tests/generic/053
> +++ b/tests/generic/053
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/062 b/tests/generic/062
> index 5a6081e..27907a9 100755
> --- a/tests/generic/062
> +++ b/tests/generic/062
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -75,7 +76,7 @@ _supported_os Linux
>  _require_scratch
>  _require_attrs
>  
> -rm -f $tmp.backup1 $tmp.backup2 $seq.full
> +rm -f $tmp.backup1 $tmp.backup2 $seqres.full
>  
>  # real QA test starts here
>  _scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
> @@ -181,8 +182,8 @@ _backup()
>  {
>  	# NB: no filtering of scratch here... (need to restore too)
>  	$GETFATTR_PROG --absolute-names -dh -R -m '.' $SCRATCH_MNT >$1
> -	echo BACKUP $1 >>$seq.full
> -	cat $1 >> $seq.full
> +	echo BACKUP $1 >>$seqres.full
> +	cat $1 >> $seqres.full
>  	[ ! -s $1 ] && echo "warning: $1 (backup file) is empty"
>  }
>  
> @@ -191,8 +192,8 @@ _backup $tmp.backup1
>  
>  echo "*** clear out the scratch device"
>  rm -fr $SCRATCH_MNT/*
> -echo "AFTER REMOVE" >>$seq.full
> -getfattr -L -R -m '.' $SCRATCH_MNT >>$seq.full
> +echo "AFTER REMOVE" >>$seqres.full
> +getfattr -L -R -m '.' $SCRATCH_MNT >>$seqres.full
>  
>  echo "*** reset test bed with no extended attributes"
>  _create_test_bed
> @@ -202,8 +203,8 @@ echo "*** restore everything"
>  setfattr -h --restore=$tmp.backup1
>  _backup $tmp.backup2
>  
> -echo "AFTER RESTORE" >>$seq.full
> -getfattr -L -R -m '.' $SCRATCH_MNT >>$seq.full
> +echo "AFTER RESTORE" >>$seqres.full
> +getfattr -L -R -m '.' $SCRATCH_MNT >>$seqres.full
>  
>  echo "*** compare before and after backups"
>  diff $tmp.backup1 $tmp.backup2
> diff --git a/tests/generic/069 b/tests/generic/069
> index 3451715..b2b18a9 100755
> --- a/tests/generic/069
> +++ b/tests/generic/069
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -39,7 +40,7 @@ _supported_fs generic
>  _supported_os IRIX Linux
>  
>  _require_scratch
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  umount $SCRATCH_DEV >/dev/null 2>&1
>  
> @@ -60,19 +61,19 @@ done
>  cd $here
>  
>  wait
> -ls -lh $SCRATCH_MNT >> $seq.full
> -echo "*** PIDs file" >> $seq.full
> -cat $SCRATCH_MNT/pids >> $seq.full
> +ls -lh $SCRATCH_MNT >> $seqres.full
> +echo "*** PIDs file" >> $seqres.full
> +cat $SCRATCH_MNT/pids >> $seqres.full
>  
>  cat $SCRATCH_MNT/pids | while read pid size
>  do
>  	echo "*** checking file with $size integers"
> -	echo checking pid=$pid size=$size >> $seq.full
> +	echo checking pid=$pid size=$size >> $seqres.full
>  	$here/src/append_reader $SCRATCH_MNT/testfile.$pid
>  	status=$?
>  	[ $status -ne 0 ] && \
>  		echo "maybe corrupt O_APPEND to $SCRATCH_MOUNT/testfile.$pid!"
> -	echo status: $status >> $seq.full
> +	echo status: $status >> $seqres.full
>  done
>  
>  # success, all done
> diff --git a/tests/generic/070 b/tests/generic/070
> index 1d978cd..4e86de8 100755
> --- a/tests/generic/070
> +++ b/tests/generic/070
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -60,7 +61,7 @@ $FSSTRESS_PROG \
>  	-f unresvsp=0 \
>  	-f attr_set=100 \
>  	-f attr_remove=100 \
> -        -p 1 -n 10000 -S c >$seq.full 2>&1
> +        -p 1 -n 10000 -S c >$seqres.full 2>&1
>  
>  status=$?
>  exit
> diff --git a/tests/generic/074 b/tests/generic/074
> index 0e5e820..c795dc7 100755
> --- a/tests/generic/074
> +++ b/tests/generic/074
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -64,9 +65,9 @@ _do_test()
>      echo "-----------------------------------------------"
>      echo "fstest.$_n : $_filter_param"
>      echo "-----------------------------------------------"
> -    if ! $here/src/fstest $_param -p $out >>$seq.full
> +    if ! $here/src/fstest $_param -p $out >>$seqres.full
>      then
> -        echo "    fstest ($_param) returned $? - see $seq.full"
> +        echo "    fstest ($_param) returned $? - see $seqres.full"
>          status=1
>  	exit
>      fi
> @@ -107,7 +108,7 @@ _process_args()
>  
> 
>  # real QA test starts here
> -rm -f $here/$seq.full
> +rm -f $here/$seqres.full
>  
>  _supported_fs generic
>  _supported_os IRIX Linux
> @@ -153,8 +154,8 @@ fi
>  # can override the params here
>  _process_args "$@"
>  
> -echo "Params are for $param_type" >>$seq.full
> -echo "Params: n = $numchildren l = $numloops f = $numfiles" >>$seq.full
> +echo "Params are for $param_type" >>$seqres.full
> +echo "Params: n = $numchildren l = $numloops f = $numfiles" >>$seqres.full
>  
>  _setup_testdir
>  
> diff --git a/tests/generic/075 b/tests/generic/075
> index de581b6..8012cc1 100755
> --- a/tests/generic/075
> +++ b/tests/generic/075
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -133,12 +134,12 @@ numops2=10000
>  # can override the params here
>  _process_args "$@"
>  
> -echo "Params are for $param_type" >>$seq.full
> -echo "Params: n = $numops1 N = $numops2 l = $filelen" >>$seq.full
> +echo "Params are for $param_type" >>$seqres.full
> +echo "Params: n = $numops1 N = $numops2 l = $filelen" >>$seqres.full
>  
>  _setup_testdir
>  
> -rm -f $here/$seq.full
> +rm -f $here/$seqres.full
>  echo "brevity is wit..."
>  
>  _check_test_fs
> diff --git a/tests/generic/076 b/tests/generic/076
> index a8b5d4a..b8db582 100755
> --- a/tests/generic/076
> +++ b/tests/generic/076
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -58,13 +59,13 @@ _require_scratch
>  
>  echo "*** init fs"
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  umount $SCRATCH_DEV >/dev/null 2>&1
> -echo "*** MKFS ***"                         >>$seq.full
> -echo ""                                     >>$seq.full
> -_scratch_mkfs                               >>$seq.full 2>&1 \
> +echo "*** MKFS ***"                         >>$seqres.full
> +echo ""                                     >>$seqres.full
> +_scratch_mkfs                               >>$seqres.full 2>&1 \
>  	|| _fail "mkfs failed"
> -_scratch_mount                              >>$seq.full 2>&1 \
> +_scratch_mount                              >>$seqres.full 2>&1 \
>  	|| _fail "mount failed"
>  
>  echo "*** test concurrent block/fs access"
> @@ -72,7 +73,7 @@ echo "*** test concurrent block/fs access"
>  cat $SCRATCH_DEV >/dev/null &
>  pid=$!
>  
> -$FSSTRESS_PROG -d $SCRATCH_MNT -p 2 -n 2000 $FSSTRESS_AVOID >>$seq.full
> +$FSSTRESS_PROG -d $SCRATCH_MNT -p 2 -n 2000 $FSSTRESS_AVOID >>$seqres.full
>  
>  _lets_get_pidst
>  _check_scratch_fs
> diff --git a/tests/generic/077 b/tests/generic/077
> index 2b86a37..3113119 100755
> --- a/tests/generic/077
> +++ b/tests/generic/077
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -56,29 +57,29 @@ _require_user
>  
>  echo "*** create filesystem"
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  umount $SCRATCH_DEV >/dev/null 2>&1
> -echo "*** MKFS ***"                         >>$seq.full
> -echo ""                                     >>$seq.full
> +echo "*** MKFS ***"                         >>$seqres.full
> +echo ""                                     >>$seqres.full
>  SIZE=`expr 50 \* 1024 \* 1024`
> -_scratch_mkfs_sized $SIZE                   >>$seq.full 2>&1 \
> +_scratch_mkfs_sized $SIZE                   >>$seqres.full 2>&1 \
>  	|| _fail "mkfs failed"
> -_scratch_mount                              >>$seq.full 2>&1 \
> +_scratch_mount                              >>$seqres.full 2>&1 \
>  	|| _fail "mount failed"
>  mkdir $SCRATCH_MNT/subdir
>  
>  echo "*** set default ACL"
>  setfacl -R -dm u:fsgqa:rwx,g::rwx,o::r-x,m::rwx $SCRATCH_MNT/subdir
>  
> -echo "*** populate filesystem, pass #1" | tee -a $seq.full
> -cp -rf $filler $SCRATCH_MNT/subdir >$seq.full 2>&1
> +echo "*** populate filesystem, pass #1" | tee -a $seqres.full
> +cp -rf $filler $SCRATCH_MNT/subdir >$seqres.full 2>&1
>  
> -echo "*** populate filesystem, pass #2" | tee -a $seq.full
> -cp -rf $filler $SCRATCH_MNT/subdir >$seq.full 2>&1
> +echo "*** populate filesystem, pass #2" | tee -a $seqres.full
> +cp -rf $filler $SCRATCH_MNT/subdir >$seqres.full 2>&1
>  
>  _check_scratch_fs
>  
>  echo "*** all done"
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=0
>  exit
> diff --git a/tests/generic/079 b/tests/generic/079
> index 048b220..3faf106 100755
> --- a/tests/generic/079
> +++ b/tests/generic/079
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/083 b/tests/generic/083
> index dd60118..f0aab4d 100755
> --- a/tests/generic/083
> +++ b/tests/generic/083
> @@ -33,6 +33,7 @@
>  
> 
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -58,7 +59,7 @@ _supported_os IRIX Linux
>  _require_scratch
>  _require_no_large_scratch_dev
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  workout()
>  {
> @@ -68,22 +69,22 @@ workout()
>  	nops=$4
>  
>  	umount $SCRATCH_DEV >/dev/null 2>&1
> -	echo "*** mkfs -dsize=$fsz,agcount=$ags"    >>$seq.full
> -	echo ""                                     >>$seq.full
> +	echo "*** mkfs -dsize=$fsz,agcount=$ags"    >>$seqres.full
> +	echo ""                                     >>$seqres.full
>  	if [ $FSTYP = xfs ]
>  	then
> -		_scratch_mkfs_xfs -dsize=$fsz,agcount=$ags  >>$seq.full 2>&1 \
> +		_scratch_mkfs_xfs -dsize=$fsz,agcount=$ags  >>$seqres.full 2>&1 \
>  			|| _fail "size=$fsz,agcount=$ags mkfs failed"
>  	else
> -		_scratch_mkfs_sized $fsz >>$seq.full 2>&1 \
> +		_scratch_mkfs_sized $fsz >>$seqres.full 2>&1 \
>  			|| _fail "size=$fsz mkfs failed"
>  	fi
> -	_scratch_mount                              >>$seq.full 2>&1 \
> +	_scratch_mount                              >>$seqres.full 2>&1 \
>  		|| _fail "mount failed"
>  
>  	# -w ensures that the only ops are ones which cause write I/O
>  	$FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n $nops $FSSTRESS_AVOID \
> -		>>$seq.full
> +		>>$seqres.full
>  	_check_scratch_fs
>  }
>  
> diff --git a/tests/generic/088 b/tests/generic/088
> index b6266ef..1386322 100755
> --- a/tests/generic/088
> +++ b/tests/generic/088
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -48,7 +49,7 @@ _supported_fs generic
>  _supported_os IRIX Linux
>  
>  path=$TEST_DIR/t_access
> -src/t_access_root $path | tee $seq.full | _filter
> +src/t_access_root $path | tee $seqres.full | _filter
>  
>  # success, all done
>  status=0
> diff --git a/tests/generic/089 b/tests/generic/089
> index 2653183..5e8210d 100755
> --- a/tests/generic/089
> +++ b/tests/generic/089
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  mtab_output=$TEST_DIR/mtab_output
> @@ -51,7 +52,7 @@ addentries()
>  _supported_fs generic
>  _supported_os Linux
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  [ "X$TEST_DIR" = "X" ] && exit 1
>  cd $TEST_DIR
>  rm -fr test
> @@ -72,8 +73,8 @@ mtab()
>  
>  	echo directory entries:
>  	ls | grep mtab
> -	echo directory entries >> $here/$seq.full
> -	ls -li >> $here/$seq.full
> +	echo directory entries >> $here/$seqres.full
> +	ls -li >> $here/$seqres.full
>  }
>  
>  # directory with only a few entries
> diff --git a/tests/generic/091 b/tests/generic/091
> index ad82b8e..755281e 100755
> --- a/tests/generic/091
> +++ b/tests/generic/091
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -38,16 +39,16 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  _supported_fs generic
>  _supported_os Linux
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  run_fsx()
>  {
> -	echo fsx $@ | tee -a $seq.full
> +	echo fsx $@ | tee -a $seqres.full
>  	args=`echo $@ | sed -e "s/ BSIZE / $bsize /g" -e "s/ PSIZE / $psize /g"`
>  	rm -f $TEST_DIR/junk
> -	$here/ltp/fsx $args $TEST_DIR/junk >>$seq.full 2>&1
> +	$here/ltp/fsx $args $TEST_DIR/junk >>$seqres.full 2>&1
>  	if [ $? -ne 0 ]; then
> -		cat $seq.full
> +		cat $seqres.full
>  		exit 1
>  	fi
>  }
> diff --git a/tests/generic/093 b/tests/generic/093
> index 881a833..12ef580 100755
> --- a/tests/generic/093
> +++ b/tests/generic/093
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  
>  here=`pwd`
>  tmp=/tmp/$$
> @@ -62,7 +63,7 @@ _require_attrs
>  
>  [ -x $runas ] || _notrun "$runas executable not found"
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  _setup_testdir
>  _need_to_be_root
> diff --git a/tests/generic/097 b/tests/generic/097
> index d3174e4..60f7e4d 100755
> --- a/tests/generic/097
> +++ b/tests/generic/097
> @@ -28,6 +28,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -250,7 +251,7 @@ _check_scratch_fs
>  
>  # optional stuff if your test has verbose output to help resolve problems
>  #echo
> -#echo "If failure, check $seq.full (this) and $seq.full.ok (reference)"
> +#echo "If failure, check $seqres.full (this) and $seqres.full.ok (reference)"
>  
>  # success, all done
>  status=0
> diff --git a/tests/generic/099 b/tests/generic/099
> index edd88a9..6efa7a7 100755
> --- a/tests/generic/099
> +++ b/tests/generic/099
> @@ -24,6 +24,7 @@
>  # modifier
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -72,7 +73,7 @@ _cleanup()
>  #   -> this would be done by simultaneously matching on ACEs
>  #   -> interesting if it allows user to specify ACEs in any order
>  #
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  #-------------------------------------------------------
>  # real QA test starts here
> diff --git a/tests/generic/100 b/tests/generic/100
> index 1ba5eb7..34cfde7 100755
> --- a/tests/generic/100
> +++ b/tests/generic/100
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -54,17 +55,17 @@ DEPTH=5
>  POPULATED_DIR=$TEMP_DIR/populate_root
>  SIZE=10
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  # Clean up if file exist from prevous run
>  rm -rf $POPULATED_DIR
>  rm -f $TEMP_DIR/$TAR_FILE
>  
>  # Create the new directory structure
> -_populate_fs -n $NDIRS -f $NFILES -d $DEPTH -r $POPULATED_DIR -s $SIZE >>$here/$seq.full 2>&1
> +_populate_fs -n $NDIRS -f $NFILES -d $DEPTH -r $POPULATED_DIR -s $SIZE >>$here/$seqres.full 2>&1
>  
>  # Then tar up the directory structure
> -tar -cvf $TEMP_DIR/$TAR_FILE $POPULATED_DIR >>$here/$seq.full 2>&1
> +tar -cvf $TEMP_DIR/$TAR_FILE $POPULATED_DIR >>$here/$seqres.full 2>&1
>  
>  # create f/s
>  _require_scratch
> @@ -72,12 +73,12 @@ _setup_testdir
>  
>  # untar on f/s
>  cd $testdir
> -tar -xRvf $TEMP_DIR/$TAR_FILE >>$here/$seq.full 2>&1
> +tar -xRvf $TEMP_DIR/$TAR_FILE >>$here/$seqres.full 2>&1
>  cd $here
>  
> 
>  # use diff -qr to compare
> -ls -R -l ${testdir}${POPULATED_DIR} >>$here/$seq.full 2>&1
> +ls -R -l ${testdir}${POPULATED_DIR} >>$here/$seqres.full 2>&1
>  diff -qr $POPULATED_DIR ${testdir}${POPULATED_DIR}
>  
>  cd /
> diff --git a/tests/generic/105 b/tests/generic/105
> index 01bae98..d5b2cb2 100755
> --- a/tests/generic/105
> +++ b/tests/generic/105
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -49,7 +50,7 @@ _supported_os IRIX Linux
>  
>  # real QA test starts here
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  _require_scratch
>  _require_acls
> @@ -57,11 +58,11 @@ _require_acls
>  _acl_setup_ids
>  
>  umount $SCRATCH_DEV >/dev/null 2>&1
> -echo "*** MKFS ***"                         >>$seq.full
> -echo ""                                     >>$seq.full
> -_scratch_mkfs                               >>$seq.full 2>&1 \
> +echo "*** MKFS ***"                         >>$seqres.full
> +echo ""                                     >>$seqres.full
> +_scratch_mkfs                               >>$seqres.full 2>&1 \
>  	|| _fail "mkfs failed"
> -_scratch_mount                              >>$seq.full 2>&1 \
> +_scratch_mount                              >>$seqres.full 2>&1 \
>  	|| _fail "mount failed"
>  
>  cd $SCRATCH_MNT
> diff --git a/tests/generic/112 b/tests/generic/112
> index bcdcfec..8959c8b 100755
> --- a/tests/generic/112
> +++ b/tests/generic/112
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -134,12 +135,12 @@ numops2=10000
>  # can override the params here
>  _process_args "$@"
>  
> -echo "Params are for $param_type" >>$seq.full
> -echo "Params: n = $numops1 N = $numops2 l = $filelen" >>$seq.full
> +echo "Params are for $param_type" >>$seqres.full
> +echo "Params: n = $numops1 N = $numops2 l = $filelen" >>$seqres.full
>  
>  _setup_testdir
>  
> -rm -f $here/$seq.full
> +rm -f $here/$seqres.full
>  echo "brevity is wit..."
>  
>  _check_test_fs
> diff --git a/tests/generic/113 b/tests/generic/113
> index fd301cd..b2a7317 100755
> --- a/tests/generic/113
> +++ b/tests/generic/113
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/117 b/tests/generic/117
> index 8afc962..624bfd8 100755
> --- a/tests/generic/117
> +++ b/tests/generic/117
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -82,13 +83,13 @@ _setup_testdir
>  _require_scratch
>  _require_attrs
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  umount $SCRATCH_DEV >/dev/null 2>&1
> -echo "*** MKFS ***"                         >>$seq.full
> -echo ""                                     >>$seq.full
> -_scratch_mkfs                               >>$seq.full 2>&1 \
> +echo "*** MKFS ***"                         >>$seqres.full
> +echo ""                                     >>$seqres.full
> +_scratch_mkfs                               >>$seqres.full 2>&1 \
>      || _fail "mkfs failed"
> -_scratch_mount                              >>$seq.full 2>&1 \
> +_scratch_mount                              >>$seqres.full 2>&1 \
>      || _fail "mount failed"
>  
>  mkdir -p $SCRATCH_MNT/fsstress
> @@ -97,10 +98,10 @@ echo
>  echo Running fsstress in serial:
>  i=0
>  while [ $i -lt $ITERATIONS ]; do
> -    echo fsstress iteration: $i | tee -a $seq.full
> +    echo fsstress iteration: $i | tee -a $seqres.full
>      $FSSTRESS_PROG \
>  	-d $SCRATCH_MNT/fsstress \
> -	$fss_ops -S c >>$seq.full 2>&1
> +	$fss_ops -S c >>$seqres.full 2>&1
>  
>      let i=$i+1
>  done
> diff --git a/tests/generic/120 b/tests/generic/120
> index 8389925..c3069f1 100755
> --- a/tests/generic/120
> +++ b/tests/generic/120
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/123 b/tests/generic/123
> index d45c516..2387676 100755
> --- a/tests/generic/123
> +++ b/tests/generic/123
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/124 b/tests/generic/124
> index 6fbb028..65c94b4 100755
> --- a/tests/generic/124
> +++ b/tests/generic/124
> @@ -27,6 +27,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/125 b/tests/generic/125
> index c7215a3..f489e96 100755
> --- a/tests/generic/125
> +++ b/tests/generic/125
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/126 b/tests/generic/126
> index a95c1e4..83671df 100755
> --- a/tests/generic/126
> +++ b/tests/generic/126
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/127 b/tests/generic/127
> index d1101df..021a571 100755
> --- a/tests/generic/127
> +++ b/tests/generic/127
> @@ -27,6 +27,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/128 b/tests/generic/128
> index 85d0f45..165aa00 100755
> --- a/tests/generic/128
> +++ b/tests/generic/128
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/129 b/tests/generic/129
> index 18d891b..e74098f 100755
> --- a/tests/generic/129
> +++ b/tests/generic/129
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/130 b/tests/generic/130
> index 943df72..96491f7 100755
> --- a/tests/generic/130
> +++ b/tests/generic/130
> @@ -32,6 +32,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/131 b/tests/generic/131
> index 176c8b4..02835ab 100755
> --- a/tests/generic/131
> +++ b/tests/generic/131
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/132 b/tests/generic/132
> index 98229a9..2abfccf 100755
> --- a/tests/generic/132
> +++ b/tests/generic/132
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/133 b/tests/generic/133
> index ec225f3..478419c 100755
> --- a/tests/generic/133
> +++ b/tests/generic/133
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/135 b/tests/generic/135
> index f0bf9b9..b5854f4 100755
> --- a/tests/generic/135
> +++ b/tests/generic/135
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/141 b/tests/generic/141
> index 45c1b5e..cb7aae2 100755
> --- a/tests/generic/141
> +++ b/tests/generic/141
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/169 b/tests/generic/169
> index 413a86b..6293654 100755
> --- a/tests/generic/169
> +++ b/tests/generic/169
> @@ -23,11 +23,12 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=1    # failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> @@ -56,10 +57,10 @@ _supported_os Linux
>  
>  _require_scratch
>  
> -_scratch_mkfs >>$seq.full 2>&1 \
> +_scratch_mkfs >>$seqres.full 2>&1 \
>  	|| _fail "mkfs scratch failed"
>  
> -_scratch_mount >>$seq.full 2>&1 \
> +_scratch_mount >>$seqres.full 2>&1 \
>      || _fail "mount failed: $MOUNT_OPTIONS"
>  
>  echo "# creating new file for io"
> @@ -73,11 +74,11 @@ xfs_io -F -a -c "pwrite 0 5k" -c "fsync" \
>  	| _show_wrote_and_stat_only
>  
>  echo "# unmounting scratch"
> -umount $SCRATCH_MNT>>$seq.full 2>&1 \
> +umount $SCRATCH_MNT>>$seqres.full 2>&1 \
>      || _fail "unmount failed"
>  
>  echo "# mounting scratch"
> -_scratch_mount >>$seq.full 2>&1 \
> +_scratch_mount >>$seqres.full 2>&1 \
>      || _fail "mount failed: $MOUNT_OPTIONS"
>  
>  echo "# stating file to confirm correct size"
> @@ -90,11 +91,11 @@ xfs_io -F -f -c "pwrite 0 5" -c s -c "pwrite 5 5" \
>  	| _show_wrote_and_stat_only
>  
>  echo "# unmounting scratch"
> -umount $SCRATCH_MNT>>$seq.full 2>&1 \
> +umount $SCRATCH_MNT>>$seqres.full 2>&1 \
>      || _fail "unmount failed"
>  
>  echo "# mounting scratch"
> -_scratch_mount >>$seq.full 2>&1 \
> +_scratch_mount >>$seqres.full 2>&1 \
>      || _fail "mount failed: $MOUNT_OPTIONS"
>  
>  echo "# stating file to confirm correct size"
> diff --git a/tests/generic/184 b/tests/generic/184
> index a37f700..929e0eb 100755
> --- a/tests/generic/184
> +++ b/tests/generic/184
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq - silence is golden"
>  
>  here=`pwd`
> diff --git a/tests/generic/192 b/tests/generic/192
> index 691ab7d..4b9d0bb 100755
> --- a/tests/generic/192
> +++ b/tests/generic/192
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -53,20 +54,20 @@ delay=40
>  
>  testfile=$TEST_DIR/testfile
>  rm -f $testfile
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  echo test >$testfile
> -time1=`_access_time $testfile | tee -a $seq.full` 
> +time1=`_access_time $testfile | tee -a $seqres.full` 
>  
>  echo "sleep for $delay"
>  sleep $delay # sleep to allow time to move on for access
>  cat $testfile
> -time2=`_access_time $testfile | tee -a $seq.full` 
> +time2=`_access_time $testfile | tee -a $seqres.full` 
>  
>  cd /
>  umount $TEST_DIR
>  _test_mount
> -time3=`_access_time $testfile | tee -a $here/$seq.full`
> +time3=`_access_time $testfile | tee -a $here/$seqres.full`
>  
>  delta1=`expr $time2 - $time1`
>  delta2=`expr $time3 - $time1`
> diff --git a/tests/generic/193 b/tests/generic/193
> index 88ab971..8b3b9db 100755
> --- a/tests/generic/193
> +++ b/tests/generic/193
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -247,5 +248,5 @@ _cleanup_files
>  
>  # success, all done
>  echo "*** done"
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=0
> diff --git a/tests/generic/198 b/tests/generic/198
> index 31de96c..5aac37f 100755
> --- a/tests/generic/198
> +++ b/tests/generic/198
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -47,7 +48,7 @@ _require_aiodio aiodio_sparse2
>  echo "Silence is golden."
>  
>  # real QA test starts here
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  rm -f "$TEST_DIR/aiodio_sparse*"
>  $AIO_TEST "$TEST_DIR/aiodio_sparse"
> diff --git a/tests/generic/204 b/tests/generic/204
> index 6c4a3f0..ae87930 100755
> --- a/tests/generic/204
> +++ b/tests/generic/204
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -44,7 +45,7 @@ _scratch_mount
>  
>  # fix the reserve block pool to a known size so that the enospc calculations
>  # work out correctly.
> -_scratch_resvblks 1024 > $seq.full 2>&1
> +_scratch_resvblks 1024 > $seqres.full 2>&1
>  
>  for i in `seq 1 22500`; do
>      echo -n > $SCRATCH_MNT/$i
> @@ -53,5 +54,5 @@ done
>  
>  # success, all done
>  echo "*** done"
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=0
> diff --git a/tests/generic/207 b/tests/generic/207
> index 6eaf50c..b520bee 100755
> --- a/tests/generic/207
> +++ b/tests/generic/207
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/208 b/tests/generic/208
> index 7ea7514..4c34e7b 100755
> --- a/tests/generic/208
> +++ b/tests/generic/208
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/209 b/tests/generic/209
> index 8b2a4e1..82d5e6a 100755
> --- a/tests/generic/209
> +++ b/tests/generic/209
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/210 b/tests/generic/210
> index 56ac8ad..16908cc 100755
> --- a/tests/generic/210
> +++ b/tests/generic/210
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/211 b/tests/generic/211
> index 5667d20..6d7b996 100755
> --- a/tests/generic/211
> +++ b/tests/generic/211
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/212 b/tests/generic/212
> index e211cc4..6e86e94 100755
> --- a/tests/generic/212
> +++ b/tests/generic/212
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/213 b/tests/generic/213
> index e297fdf..1fa573c 100755
> --- a/tests/generic/213
> +++ b/tests/generic/213
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  _cleanup()
> @@ -51,7 +52,7 @@ _supported_os Linux
>  
>  [ -n "$XFS_IO_PROG" ] || _notrun "xfs_io executable not found"
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  _require_xfs_io_falloc
>  
> diff --git a/tests/generic/214 b/tests/generic/214
> index 0a27fc5..20acca1 100755
> --- a/tests/generic/214
> +++ b/tests/generic/214
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  _cleanup()
> @@ -49,7 +50,7 @@ _supported_os Linux
>  
>  [ -n "$XFS_IO_PROG" ] || _notrun "xfs_io executable not found"
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  rm -f $TEST_DIR/ouch*
>  
>  _require_xfs_io_falloc
> diff --git a/tests/generic/215 b/tests/generic/215
> index 749b27b..73cdd14 100755
> --- a/tests/generic/215
> +++ b/tests/generic/215
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  _cleanup()
> @@ -79,5 +80,5 @@ fi
>  
>  # success, all done
>  echo "*** done"
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=0
> diff --git a/tests/generic/219 b/tests/generic/219
> index 047e285..3a8deb6 100755
> --- a/tests/generic/219
> +++ b/tests/generic/219
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -76,17 +77,17 @@ check_usage()
>  test_accounting()
>  {
>  	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
> -	echo "--- initiating parallel IO..." >>$seq.full
> +	echo "--- initiating parallel IO..." >>$seqres.full
>  	# Small ios here because ext3 will account for indirect blocks too ...
>  	# 48k will fit w/o indirect for 4k blocks (default blocksize)
>  	$XFS_IO_PROG -F -c 'pwrite 0 48k' -c 'fsync' \
> -					$SCRATCH_MNT/buffer >>$seq.full 2>&1 &
> +					$SCRATCH_MNT/buffer >>$seqres.full 2>&1 &
>  	$XFS_IO_PROG -F -c 'pwrite 0 48k' -d \
> -					$SCRATCH_MNT/direct >>$seq.full 2>&1 &
> +					$SCRATCH_MNT/direct >>$seqres.full 2>&1 &
>  	$XFS_IO_PROG -F -c 't 48k' -c 'mm -rw 0 48k' -c 'mw 0 48k' -c 'ms -s' \
> -					$SCRATCH_MNT/mmap   >>$seq.full 2>&1 &
> +					$SCRATCH_MNT/mmap   >>$seqres.full 2>&1 &
>  	wait
> -	echo "--- completed parallel IO ($type)" >>$seq.full
> +	echo "--- completed parallel IO ($type)" >>$seqres.full
>  
>  	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
>  		$here/src/lstat64 $file | head -3 | _filter_scratch
> @@ -101,13 +102,13 @@ test_accounting()
>  }
>  
>  # real QA test starts here
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  uid=1
>  gid=2
>  
>  umount $SCRATCH_DEV 2>/dev/null
> -_scratch_mkfs >> $seq.full 2>&1
> +_scratch_mkfs >> $seqres.full 2>&1
>  _scratch_mount "-o usrquota,grpquota"
>  quotacheck -u -g $SCRATCH_MNT 2>/dev/null
>  quotaon $SCRATCH_MNT 2>/dev/null
> diff --git a/tests/generic/221 b/tests/generic/221
> index 9cab3c4..7fca5bb 100755
> --- a/tests/generic/221
> +++ b/tests/generic/221
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/223 b/tests/generic/223
> index 8eba2d7..a6932da 100755
> --- a/tests/generic/223
> +++ b/tests/generic/223
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -47,7 +48,7 @@ _supported_os Linux
>  _require_scratch
>  _require_xfs_io_falloc
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  BLOCKSIZE=4096
>  
> @@ -57,7 +58,7 @@ for SUNIT_K in 8 16 32 64 128; do
>  
>  	echo "=== mkfs with su $SUNIT_BLOCKS blocks x 4 ==="
>  	export MKFS_OPTIONS=""
> -	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE >> $seq.full 2>&1
> +	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE >> $seqres.full 2>&1
>  	_scratch_mount
>  
>  	for SIZE_MULT in 1 2 8 64 256; do
> @@ -67,10 +68,10 @@ for SUNIT_K in 8 16 32 64 128; do
>  		for FILE in 1 2 3 4; do
>  			xfs_io -F -f -c "falloc 0 $SIZE" \
>  				$SCRATCH_MNT/file-$FILE-$SIZE-falloc \
> -					>> $seq.full 2>&1
> +					>> $seqres.full 2>&1
>  			xfs_io -F -f -c "pwrite 0 $SIZE" \
>  				$SCRATCH_MNT/file-$FILE-$SIZE-write \
> -					>> $seq.full 2>&1
> +					>> $seqres.full 2>&1
>  			src/t_stripealign $SCRATCH_MNT/file-$FILE-$SIZE-falloc \
>  				$SUNIT_BLOCKS | _filter_scratch
>  			src/t_stripealign $SCRATCH_MNT/file-$FILE-$SIZE-write \
> @@ -80,7 +81,7 @@ for SUNIT_K in 8 16 32 64 128; do
>  
>  	echo "=== Testing size 1g falloc on ${SUNIT_K}k stripe ==="
>  	xfs_io -F -f -c "falloc 0 1g" \
> -	    $SCRATCH_MNT/file-1g-falloc >> $seq.full 2>&1
> +	    $SCRATCH_MNT/file-1g-falloc >> $seqres.full 2>&1
>  	src/t_stripealign $SCRATCH_MNT/file-1g-falloc $SUNIT_BLOCKS \
>  	    | _filter_scratch
>  
> @@ -88,7 +89,7 @@ for SUNIT_K in 8 16 32 64 128; do
>  
>  	echo "=== Testing size 1073745920 falloc on ${SUNIT_K}k stripe ==="
>  	xfs_io -F -f -c "falloc 0 1073745920" \
> -		$SCRATCH_MNT/file-1073745920-falloc >> $seq.full 2>&1
> +		$SCRATCH_MNT/file-1073745920-falloc >> $seqres.full 2>&1
>  	src/t_stripealign $SCRATCH_MNT/file-1073745920-falloc \
>  		$SUNIT_BLOCKS | _filter_scratch
>  
> diff --git a/tests/generic/224 b/tests/generic/224
> index 23ee7c2..313d9c2 100755
> --- a/tests/generic/224
> +++ b/tests/generic/224
> @@ -28,6 +28,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -53,12 +54,12 @@ _supported_os Linux
>  _require_scratch
>  
>  # make a 1GB filesystem
> -_scratch_mkfs_sized `expr 1024 \* 1024 \* 1024` > $seq.full 2>&1
> -_scratch_mount >> $seq.full 2>&1
> +_scratch_mkfs_sized `expr 1024 \* 1024 \* 1024` > $seqres.full 2>&1
> +_scratch_mount >> $seqres.full 2>&1
>  
>  # set the reserved block pool to almost empty for XFS
>  if [ "$FSTYP" = "xfs" ]; then
> -	xfs_io -x -c "resblks 4" $SCRATCH_MNT >> $seq.full 2>&1
> +	xfs_io -x -c "resblks 4" $SCRATCH_MNT >> $seqres.full 2>&1
>  fi
>  
>  FILES=1000
> diff --git a/tests/generic/225 b/tests/generic/225
> index c09bd2a..ea44f2e 100755
> --- a/tests/generic/225
> +++ b/tests/generic/225
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -48,7 +49,7 @@ _require_scratch
>  _scratch_mkfs > /dev/null 2>&1
>  _scratch_mount > /dev/null 2>&1
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  fiemapfile=$SCRATCH_MNT/$seq.fiemap
>  fiemaplog=$SCRATCH_MNT/$seq.log
>  
> diff --git a/tests/generic/226 b/tests/generic/226
> index 2179f2a..da45c9e 100755
> --- a/tests/generic/226
> +++ b/tests/generic/226
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -38,11 +39,11 @@ _supported_os Linux IRIX
>  _require_scratch
>  
>  # real QA test starts here
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  umount $SCRATCH_DEV 2>/dev/null
>  echo "--> mkfs 256m filesystem"
> -_scratch_mkfs_sized `expr 256 \* 1024 \* 1024` >> $seq.full 2>&1
> +_scratch_mkfs_sized `expr 256 \* 1024 \* 1024` >> $seqres.full 2>&1
>  _scratch_mount
>  
>  loops=16
> @@ -54,7 +55,7 @@ echo "--> $loops buffered 64m writes in a loop"
>  for I in `seq 1 $loops`; do
>  	echo -n "$I "
>  	xfs_io -F -f \
> -		-c "pwrite ${buffer} 0 64m" $SCRATCH_MNT/test >> $seq.full
> +		-c "pwrite ${buffer} 0 64m" $SCRATCH_MNT/test >> $seqres.full
>  	rm -f $SCRATCH_MNT/test
>  done
>  
> @@ -66,7 +67,7 @@ echo "--> $loops direct 64m writes in a loop"
>  for I in `seq 1 $loops`; do
>  	echo -n "$I "
>  	xfs_io -F -f -d \
> -		-c "pwrite ${buffer} 0 64m" $SCRATCH_MNT/test >> $seq.full
> +		-c "pwrite ${buffer} 0 64m" $SCRATCH_MNT/test >> $seqres.full
>  	rm -f $SCRATCH_MNT/test 
>  done
>  
> diff --git a/tests/generic/228 b/tests/generic/228
> index 2704934..c8af133 100755
> --- a/tests/generic/228
> +++ b/tests/generic/228
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  _cleanup()
> @@ -49,7 +50,7 @@ _supported_os Linux
>  
>  [ -n "$XFS_IO_PROG" ] || _notrun "xfs_io executable not found"
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  # Sanity check to see if fallocate works
>  _require_xfs_io_falloc
> diff --git a/tests/generic/230 b/tests/generic/230
> index a442857..c3db20b 100755
> --- a/tests/generic/230
> +++ b/tests/generic/230
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -58,49 +59,49 @@ test_files()
>  test_enforcement()
>  {
>  	echo "### some buffered IO (type=$type)"
> -	echo "--- initiating IO..." >>$seq.full
> +	echo "--- initiating IO..." >>$seqres.full
>  	# Firstly fit below block soft limit
>  	echo "Write 900k..."
>  	su $qa_user -c "$XFS_IO_PROG -F -c 'pwrite 0 900k' -c fsync \
> -		$SCRATCH_MNT/file1" 2>&1 >>$seq.full | tee -a $seq.full
> -	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seq.full 2>&1
> +		$SCRATCH_MNT/file1" 2>&1 >>$seqres.full | tee -a $seqres.full
> +	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
>  	# Secondly overcome block soft limit
>  	echo "Rewrite 1001k..."
>  	su $qa_user -c "$XFS_IO_PROG -F -c 'pwrite 0 1001k' -c fsync \
> -		$SCRATCH_MNT/file1" 2>&1 >>$seq.full | tee -a $seq.full
> -	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seq.full 2>&1
> +		$SCRATCH_MNT/file1" 2>&1 >>$seqres.full | tee -a $seqres.full
> +	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
>  	# Now try to overcome block hardlimit
>  	echo "Write 1000k..."
>  	su $qa_user -c "$XFS_IO_PROG -F -c 'pwrite 0 1000k' -c fsync \
> -		$SCRATCH_MNT/file2" 2>&1 >>$seq.full | tee -a $seq.full
> -	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seq.full 2>&1
> +		$SCRATCH_MNT/file2" 2>&1 >>$seqres.full | tee -a $seqres.full
> +	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
>  	# Now sleep for grace time and check that softlimit got enforced
>  	sleep $((grace+1))
>  	echo "Write 4096..."
>  	su $qa_user -c "$XFS_IO_PROG -F -c 'truncate 0' -c 'pwrite 0 4096' \
> -		$SCRATCH_MNT/file2" 2>&1 >>$seq.full | tee -a $seq.full
> -	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seq.full 2>&1
> +		$SCRATCH_MNT/file2" 2>&1 >>$seqres.full | tee -a $seqres.full
> +	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
>  	# And now the softlimit test for inodes
>  	# First reset space limits so that we don't have problems with
>  	# space reservations on XFS
>  	setquota -$type $qa_user 0 0 3 5 $SCRATCH_MNT
>  	echo "Touch 3+4"
>  	su $qa_user -c "touch $SCRATCH_MNT/file3 $SCRATCH_MNT/file4" \
> -		2>&1 >>$seq.full | _filter_scratch | tee -a $seq.full
> -	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seq.full 2>&1
> +		2>&1 >>$seqres.full | _filter_scratch | tee -a $seqres.full
> +	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
>  	# Try to exceed inode hardlimit
>  	echo "Touch 5+6"
>  	su $qa_user -c "touch $SCRATCH_MNT/file5 $SCRATCH_MNT/file6" \
> -		2>&1 >>$seq.full | _filter_scratch | tee -a $seq.full
> -	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seq.full 2>&1
> +		2>&1 >>$seqres.full | _filter_scratch | tee -a $seqres.full
> +	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
>  	# Wait and check grace time enforcement
> -	rm -f $SCRATCH_MNT/file5 >>$seq.full 2>&1
> +	rm -f $SCRATCH_MNT/file5 >>$seqres.full 2>&1
>  	sleep $((grace+1))
>  	echo "Touch 5"
> -	su $qa_user -c "touch $SCRATCH_MNT/file5" 2>&1 >>$seq.full |
> -		_filter_scratch | tee -a $seq.full
> -	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seq.full 2>&1
> -	echo "--- completed IO ($type)" >>$seq.full
> +	su $qa_user -c "touch $SCRATCH_MNT/file5" 2>&1 >>$seqres.full |
> +		_filter_scratch | tee -a $seqres.full
> +	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
> +	echo "--- completed IO ($type)" >>$seqres.full
>  }
>  
>  cleanup_files()
> @@ -109,11 +110,11 @@ cleanup_files()
>  }
>  
>  # real QA test starts here
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  grace=2
>  
> -_scratch_mkfs >> $seq.full 2>&1
> +_scratch_mkfs >> $seqres.full 2>&1
>  _scratch_mount "-o usrquota,grpquota"
>  quotacheck -u -g $SCRATCH_MNT 2>/dev/null
>  quotaon $SCRATCH_MNT 2>/dev/null
> diff --git a/tests/generic/231 b/tests/generic/231
> index 6d8bda7..1a434d4 100755
> --- a/tests/generic/231
> +++ b/tests/generic/231
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -45,19 +46,19 @@ _fsx()
>  	echo "=== FSX Standard Mode, Memory Mapping, $tasks Tasks ==="
>  	for (( i = 1; i <= $tasks; i++ )); do
>  		SEED=$RANDOM
> -		echo "ltp/fsx $FSX_ARGS -S $SEED $SCRATCH_MNT/fsx_file$i" >>$seq.full
> +		echo "ltp/fsx $FSX_ARGS -S $SEED $SCRATCH_MNT/fsx_file$i" >>$seqres.full
>  		su $qa_user -c "ltp/fsx $FSX_ARGS -S $SEED \
>  			$SCRATCH_MNT/fsx_file$i" >$tmp.output$i 2>&1 &
>  	done
>  
>  	for (( i = 1; i <= $tasks; i++ )); do
>  		if ! wait %$i; then
> -			cat $tmp.output$i | tee -a $seq.full
> +			cat $tmp.output$i | tee -a $seqres.full
>  			wait
>  			return 1
>  		fi
>  		$XFS_IO_PROG -F -c 'fsync' $SCRATCH_MNT/fsx_file$i
> -		cat $tmp.output$i | tee -a $seq.full
> +		cat $tmp.output$i | tee -a $seqres.full
>  	done
>  	return 0
>  }
> @@ -70,7 +71,7 @@ _require_quota
>  _require_user
>  _need_to_be_root
>  
> -_scratch_mkfs >> $seq.full 2>&1
> +_scratch_mkfs >> $seqres.full 2>&1
>  _scratch_mount "-o usrquota,grpquota"
>  chmod 777 $SCRATCH_MNT
>  quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> diff --git a/tests/generic/232 b/tests/generic/232
> index 81cd3ca..f716ede 100755
> --- a/tests/generic/232
> +++ b/tests/generic/232
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -38,7 +39,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  _filter_num()
>  {
> -	tee -a $here/$seq.full |\
> +	tee -a $here/$seqres.full |\
>  	sed -e 's/[0-9][0-9]* inodes/I inodes/g' \
>  	    -e 's/[0-9][0-9]* paths/P paths/g' \
>  	    -e 's/seed = [0-9][0-9]*/seed = S/'
> @@ -54,11 +55,11 @@ _fsstress()
>  	count=2000
>  	args="-n $count -d $out -p 7"
>  
> -	echo "fsstress $args" | tee -a $here/$seq.full | sed -e "s#$out#outdir#"
> -	if ! $FSSTRESS_PROG $args | tee -a $here/$seq.full | _filter_num
> +	echo "fsstress $args" | tee -a $here/$seqres.full | sed -e "s#$out#outdir#"
> +	if ! $FSSTRESS_PROG $args | tee -a $here/$seqres.full | _filter_num
>  	then
>  		echo "    fsstress $args returned $?"
> -		cat $tmp.out | tee -a $here/$seq.full
> +		cat $tmp.out | tee -a $here/$seqres.full
>  		status=1
>  	fi
>  }
> @@ -70,7 +71,7 @@ _require_scratch
>  _require_quota
>  _need_to_be_root
>  
> -_scratch_mkfs >> $seq.full 2>&1
> +_scratch_mkfs >> $seqres.full 2>&1
>  _scratch_mount "-o usrquota,grpquota"
>  chmod 777 $SCRATCH_MNT
>  quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> diff --git a/tests/generic/233 b/tests/generic/233
> index 52d2259..f0fde22 100755
> --- a/tests/generic/233
> +++ b/tests/generic/233
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -42,7 +43,7 @@ FSX_ARGS="-q -l $FSX_FILE_SIZE -o 65536 -S 191110531 -N 100000"
>  
>  _filter_num()
>  {
> -	tee -a $here/$seq.full |\
> +	tee -a $here/$seqres.full |\
>  	sed -e 's/[0-9][0-9]* inodes/I inodes/g' \
>  	    -e 's/[0-9][0-9]* paths/P paths/g' \
>  	    -e 's/seed = [0-9][0-9]*/seed = S/'
> @@ -61,11 +62,11 @@ _fsstress()
>  -f rename=10 -f fsync=2 -f write=15 -f dwrite=15 \
>  -n $count -d $out -p 7"
>  
> -	echo "fsstress $args" | tee -a $here/$seq.full | sed -e "s#$out#outdir#"
> -	if ! su $qa_user -c "$FSSTRESS_PROG $args" | tee -a $here/$seq.full | _filter_num
> +	echo "fsstress $args" | tee -a $here/$seqres.full | sed -e "s#$out#outdir#"
> +	if ! su $qa_user -c "$FSSTRESS_PROG $args" | tee -a $here/$seqres.full | _filter_num
>  	then
>  		echo "    fsstress $args returned $?"
> -		cat $tmp.out | tee -a $here/$seq.full
> +		cat $tmp.out | tee -a $here/$seqres.full
>  		status=1
>  	fi
>  }
> @@ -78,7 +79,7 @@ _require_quota
>  _require_user
>  _need_to_be_root
>  
> -_scratch_mkfs >> $seq.full 2>&1
> +_scratch_mkfs >> $seqres.full 2>&1
>  _scratch_mount "-o usrquota,grpquota"
>  chmod 777 $SCRATCH_MNT
>  quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> diff --git a/tests/generic/234 b/tests/generic/234
> index dbb13f6..e5c94e9 100755
> --- a/tests/generic/234
> +++ b/tests/generic/234
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -46,7 +47,7 @@ test_setting()
>  	idmod=200000
>  	seed=$RANDOM
>  	RANDOM=$seed
> -	echo "Starting test with procs=$procs, idmod=$idmod, and seed=$seed" >>$seq.full
> +	echo "Starting test with procs=$procs, idmod=$idmod, and seed=$seed" >>$seqres.full
>  
>  	for (( i = 0; i < $procs; i++ )); do
>  		( SETUCOUNT=1; SETGCOUNT=1; SETUIDS[0]=0; SETGIDS[0]=0
> @@ -93,9 +94,9 @@ _require_quota
>  _need_to_be_root
>  
>  # real QA test starts here
> -rm -f $seq.full
> +rm -f $seqres.full
>  
> -_scratch_mkfs >> $seq.full 2>&1
> +_scratch_mkfs >> $seqres.full 2>&1
>  _scratch_mount "-o usrquota,grpquota"
>  quotacheck -u -g $SCRATCH_MNT 2>/dev/null
>  quotaon -u -g $SCRATCH_MNT 2>/dev/null
> diff --git a/tests/generic/235 b/tests/generic/235
> index f4a1fce..85ed782 100755
> --- a/tests/generic/235
> +++ b/tests/generic/235
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -47,9 +48,9 @@ _require_user
>  _need_to_be_root
>  
>  # real QA test starts here
> -rm -f $seq.full
> +rm -f $seqres.full
>  
> -_scratch_mkfs >> $seq.full 2>&1
> +_scratch_mkfs >> $seqres.full 2>&1
>  _scratch_mount "-o usrquota,grpquota"
>  quotacheck -u -g $SCRATCH_MNT 2>/dev/null
>  quotaon $SCRATCH_MNT 2>/dev/null
> @@ -64,12 +65,12 @@ repquota -u -g $SCRATCH_MNT  | grep -v "^root" | _filter_scratch
>  #
>  # We work around it by editing the context out of mtab.  Sigh.
>  sed -i "s#^$SCRATCH_DEV\(.*\),context=\"system_u:object_r:nfs_t:s0\"#$SCRATCH_DEV\1#" /etc/mtab
> -mount -o remount,ro $SCRATCH_DEV 2>&1 | tee -a $seq.full | _filter_scratch
> -touch $SCRATCH_MNT/failed 2>&1 | tee -a $seq.full | _filter_scratch
> -mount -o remount,rw $SCRATCH_DEV 2>&1 | tee -a $seq.full | _filter_scratch
> +mount -o remount,ro $SCRATCH_DEV 2>&1 | tee -a $seqres.full | _filter_scratch
> +touch $SCRATCH_MNT/failed 2>&1 | tee -a $seqres.full | _filter_scratch
> +mount -o remount,rw $SCRATCH_DEV 2>&1 | tee -a $seqres.full | _filter_scratch
>  
>  $XFS_IO_PROG -F -c 'pwrite 0 8k' -c 'fsync' \
> -			$SCRATCH_MNT/testfile >>$seq.full 2>&1
> +			$SCRATCH_MNT/testfile >>$seqres.full 2>&1
>  repquota -u -g $SCRATCH_MNT  | grep -v "^root" | _filter_scratch
>  
>  umount $SCRATCH_DEV 2>/dev/null
> diff --git a/tests/generic/236 b/tests/generic/236
> index ec70cdb..016afae 100755
> --- a/tests/generic/236
> +++ b/tests/generic/236
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  _cleanup()
> diff --git a/tests/generic/237 b/tests/generic/237
> index 7ebb88e..7e54aed 100755
> --- a/tests/generic/237
> +++ b/tests/generic/237
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -52,7 +53,7 @@ _supported_os Linux
>  
>  [ -x $runas ] || _notrun "$runas executable not found"
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  _setup_testdir
>  
> diff --git a/tests/generic/239 b/tests/generic/239
> index 8aa4ed0..e25a6a0 100755
> --- a/tests/generic/239
> +++ b/tests/generic/239
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/240 b/tests/generic/240
> index d5f8940..77fffe8 100755
> --- a/tests/generic/240
> +++ b/tests/generic/240
> @@ -29,6 +29,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -55,7 +56,7 @@ _require_aiodio aiodio_sparse2
>  echo "Silence is golden."
>  
>  # real QA test starts here
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  rm -f $TEST_DIR/aiodio_sparse
>  
> diff --git a/tests/generic/241 b/tests/generic/241
> index ee572a7..b55344b 100755
> --- a/tests/generic/241
> +++ b/tests/generic/241
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -47,12 +48,12 @@ _supported_os Linux
>  echo "Silence is golden."
>  
>  # real QA test starts here
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  rm -rf $TEST_DIR/dbench
>  mkdir $TEST_DIR/dbench
>  
> -dbench -t 60 -D $TEST_DIR/dbench 4 >> $seq.full
> +dbench -t 60 -D $TEST_DIR/dbench 4 >> $seqres.full
>  
>  status=$?
>  exit
> diff --git a/tests/generic/245 b/tests/generic/245
> index fb81d39..9832e92 100755
> --- a/tests/generic/245
> +++ b/tests/generic/245
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/246 b/tests/generic/246
> index d82e27d..872e513 100755
> --- a/tests/generic/246
> +++ b/tests/generic/246
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/247 b/tests/generic/247
> index 3a2f735..8a7e2c6 100755
> --- a/tests/generic/247
> +++ b/tests/generic/247
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/248 b/tests/generic/248
> index f245c1c..7bb42a1 100755
> --- a/tests/generic/248
> +++ b/tests/generic/248
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/249 b/tests/generic/249
> index e72092d..288328c 100755
> --- a/tests/generic/249
> +++ b/tests/generic/249
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -50,11 +51,11 @@ echo "Feel the serenity."
>  
>  SRC=$TEST_DIR/$seq.src
>  DST=$TEST_DIR/$seq.dst
> -rm -f $seq.full
> +rm -f $seqres.full
>  
> -$XFS_IO_PROG -F -f -c "pwrite -S 0xa5a55a5a 0 32768k" -c fsync $SRC >> $seq.full 2>&1
> +$XFS_IO_PROG -F -f -c "pwrite -S 0xa5a55a5a 0 32768k" -c fsync $SRC >> $seqres.full 2>&1
>  [ $? -ne 0 ] && _fail "xfs_io pwrite failed"
> -$XFS_IO_PROG -F -f -c "sendfile -i $SRC 0 32768k" -c fsync $DST >> $seq.full 2>&1
> +$XFS_IO_PROG -F -f -c "sendfile -i $SRC 0 32768k" -c fsync $DST >> $seqres.full 2>&1
>  [ $? -ne 0 ] && _fail "xfs_io sendfile failed"
>  
>  diff -q $SRC $DST
> diff --git a/tests/generic/251 b/tests/generic/251
> index c5fc79e..f49f1e9 100755
> --- a/tests/generic/251
> +++ b/tests/generic/251
> @@ -25,6 +25,7 @@
>  
> 
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/255 b/tests/generic/255
> index e08c726..8db0978 100755
> --- a/tests/generic/255
> +++ b/tests/generic/255
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/256 b/tests/generic/256
> index 0d72795..d60584b 100755
> --- a/tests/generic/256
> +++ b/tests/generic/256
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/257 b/tests/generic/257
> index b58bd56..09a8fd8 100755
> --- a/tests/generic/257
> +++ b/tests/generic/257
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -50,5 +51,5 @@ src/t_dir_offset2 $TEST_DIR/ttt
>  
>  # success, all done
>  echo "*** done"
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=0
> diff --git a/tests/generic/258 b/tests/generic/258
> index 87817bc..ac03bb5 100755
> --- a/tests/generic/258
> +++ b/tests/generic/258
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/260 b/tests/generic/260
> index 5bd3b39..032baa5 100755
> --- a/tests/generic/260
> +++ b/tests/generic/260
> @@ -23,6 +23,7 @@
>  
> 
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/generic/263 b/tests/generic/263
> index 18cd5de..3e86efc 100755
> --- a/tests/generic/263
> +++ b/tests/generic/263
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -38,16 +39,16 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  _supported_fs generic
>  _supported_os Linux
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  run_fsx()
>  {
> -	echo fsx $@ | tee -a $seq.full
> +	echo fsx $@ | tee -a $seqres.full
>  	args=`echo $@ | sed -e "s/ BSIZE / $bsize /g" -e "s/ PSIZE / $psize /g"`
>  	rm -f $TEST_DIR/junk
> -	$here/ltp/fsx $args $TEST_DIR/junk >>$seq.full 2>&1
> +	$here/ltp/fsx $args $TEST_DIR/junk >>$seqres.full 2>&1
>  	if [ $? -ne 0 ]; then
> -		cat $seq.full
> +		cat $seqres.full
>  		exit 1
>  	fi
>  }
> diff --git a/tests/generic/269 b/tests/generic/269
> index 5bf24af..3c5f68a 100755
> --- a/tests/generic/269
> +++ b/tests/generic/269
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -44,7 +45,7 @@ _workout()
>  	enospc_time=2
>  	out=$SCRATCH_MNT/fsstress.$$
>  	args="-p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out"
> -	echo "fsstress $args" >> $here/$seq.full
> +	echo "fsstress $args" >> $here/$seqres.full
>  	$FSSTRESS_PROG $args > /dev/null 2>&1 &
>  	pid=$!
>  	echo "Run dd writers in parallel"
> @@ -52,7 +53,7 @@ _workout()
>  	do
>  		# File will be opened with O_TRUNC each time
>  		dd if=/dev/zero of=$SCRATCH_MNT/SPACE_CONSUMER bs=1M \
> -			>> $here/$seq.full 2>&1
> +			>> $here/$seqres.full 2>&1
>  		sleep $enospc_time
>  	done
>  	kill $pid
> @@ -65,7 +66,7 @@ _supported_os Linux
>  _need_to_be_root
>  _require_scratch
>  
> -_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seq.full 2>&1
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
>  _scratch_mount
>  
>  if ! _workout; then
> diff --git a/tests/generic/270 b/tests/generic/270
> index c095606..8d6555b 100755
> --- a/tests/generic/270
> +++ b/tests/generic/270
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -47,7 +48,7 @@ _workout()
>  	enospc_time=2
>  	out=$SCRATCH_MNT/fsstress.$$
>  	args="-p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out"
> -	echo "fsstress $args" >> $here/$seq.full
> +	echo "fsstress $args" >> $here/$seqres.full
>  	# Grant chown capability 
>  	cp $FSSTRESS_PROG  $tmp.fsstress.bin
>  	if [ "`whereis setcap`" == "setcap:" ]; then
> @@ -64,7 +65,7 @@ _workout()
>  		# File will be opened with O_TRUNC each time
>  		su $qa_user -c "dd if=/dev/zero \
>  			of=$SCRATCH_MNT/SPACE_CONSUMER bs=1M " \
> -			>> $here/$seq.full 2>&1
> +			>> $here/$seqres.full 2>&1
>  		sleep $enospc_time
>  	done
>  
> @@ -80,7 +81,7 @@ _require_user
>  _need_to_be_root
>  _require_scratch
>  
> -_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seq.full 2>&1
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
>  _scratch_mount "-o usrquota,grpquota"
>  chmod 777 $SCRATCH_MNT
>  quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> diff --git a/tests/generic/273 b/tests/generic/273
> index 9a40394..5a8d593 100755
> --- a/tests/generic/273
> +++ b/tests/generic/273
> @@ -24,6 +24,7 @@
>  #creator
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -91,7 +92,7 @@ _porter()
>  		exit
>  	fi
>  
> -	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >$seq.full 2>&1
> +	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >$seqres.full 2>&1
>  	if [ $? -ne 0 ]
>  	then
>  		echo "_porter $_suffix not complete"
> @@ -129,10 +130,10 @@ echo "------------------------------"
>  echo "start the workload"
>  echo "------------------------------"
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  _scratch_unmount 2>/dev/null
> -_scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
> +_scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
>  _scratch_mount
>  
>  _do_workload
> diff --git a/tests/generic/274 b/tests/generic/274
> index 9b0fb71..d5f09a4 100755
> --- a/tests/generic/274
> +++ b/tests/generic/274
> @@ -26,6 +26,7 @@
>  #creator
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -53,48 +54,48 @@ echo "------------------------------"
>  echo "preallocation test"
>  echo "------------------------------"
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  umount $SCRATCH_DEV 2>/dev/null
> -_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
> +_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
>  _scratch_mount
>  
>  # Create a 4k file and Allocate 4M past EOF on that file
>  xfs_io -F -f -c "pwrite 0 4k" -c "falloc -k 4k 4m" $SCRATCH_MNT/test \
> -	>>$seq.full 2>&1 || _fail "failed to create test file"
> +	>>$seqres.full 2>&1 || _fail "failed to create test file"
>  
>  # Fill the rest of the fs completely
> -# Note, this will show ENOSPC errors in $seq.full, that's ok.
> -echo "Fill fs with 1M IOs; ENOSPC expected" >> $seq.full
> -dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=1M >>$seq.full 2>&1
> -echo "Fill fs with 4K IOs; ENOSPC expected" >> $seq.full
> -dd if=/dev/zero of=$SCRATCH_MNT/tmp2 bs=4K >>$seq.full 2>&1
> +# Note, this will show ENOSPC errors in $seqres.full, that's ok.
> +echo "Fill fs with 1M IOs; ENOSPC expected" >> $seqres.full
> +dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=1M >>$seqres.full 2>&1
> +echo "Fill fs with 4K IOs; ENOSPC expected" >> $seqres.full
> +dd if=/dev/zero of=$SCRATCH_MNT/tmp2 bs=4K >>$seqres.full 2>&1
>  sync
>  # Last effort, use O_SYNC
> -echo "Fill fs with 4K DIOs; ENOSPC expected" >> $seq.full
> -dd if=/dev/zero of=$SCRATCH_MNT/tmp3 bs=4K oflag=sync >>$seq.full 2>&1
> +echo "Fill fs with 4K DIOs; ENOSPC expected" >> $seqres.full
> +dd if=/dev/zero of=$SCRATCH_MNT/tmp3 bs=4K oflag=sync >>$seqres.full 2>&1
>  # Save space usage info
> -echo "Post-fill space:" >> $seq.full
> -df $SCRATCH_MNT >>$seq.full 2>&1
> +echo "Post-fill space:" >> $seqres.full
> +df $SCRATCH_MNT >>$seqres.full 2>&1
>  
>  # Now attempt a write into all of the preallocated space -
>  # in a very nasty way, badly fragmenting it and then filling it in.
> -echo "Fill in prealloc space; fragment at offsets:" >> $seq.full
> +echo "Fill in prealloc space; fragment at offsets:" >> $seqres.full
>  for i in `seq 1 2 1023`; do
> -	echo -n "$i " >> $seq.full
> +	echo -n "$i " >> $seqres.full
>  	dd if=/dev/zero of=$SCRATCH_MNT/test seek=$i bs=4K count=1 conv=notrunc \
> -		>>$seq.full 2>/dev/null || _fail "failed to write to test file"
> +		>>$seqres.full 2>/dev/null || _fail "failed to write to test file"
>  done
>  sync
> -echo >> $seq.full
> -echo "Fill in prealloc space; fill holes at offsets:" >> $seq.full
> +echo >> $seqres.full
> +echo "Fill in prealloc space; fill holes at offsets:" >> $seqres.full
>  for i in `seq 2 2 1023`; do
> -	echo -n "$i " >> $seq.full
> +	echo -n "$i " >> $seqres.full
>  	dd if=/dev/zero of=$SCRATCH_MNT/test seek=$i bs=4K count=1 conv=notrunc \
> -		>>$seq.full 2>/dev/null || _fail "failed to fill test file"
> +		>>$seqres.full 2>/dev/null || _fail "failed to fill test file"
>  done
>  sync
> -echo >> $seq.full
> +echo >> $seqres.full
>  
>  echo "done"
>  exit
> diff --git a/tests/generic/275 b/tests/generic/275
> index 5bf06e4..949ffdb 100755
> --- a/tests/generic/275
> +++ b/tests/generic/275
> @@ -25,6 +25,7 @@
>  #creator
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -51,10 +52,10 @@ echo "------------------------------"
>  echo "write lack test"
>  echo "------------------------------"
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  umount $SCRATCH_DEV 2>/dev/null
> -_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
> +_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
>  _scratch_mount
>  
>  rm -rf $SCRATCH_MNT/*
> diff --git a/tests/generic/277 b/tests/generic/277
> index 8ef809c..b85e429 100755
> --- a/tests/generic/277
> +++ b/tests/generic/277
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  status=1	# failure is the default!
> diff --git a/tests/generic/280 b/tests/generic/280
> index 69c9afd..a43c211 100755
> --- a/tests/generic/280
> +++ b/tests/generic/280
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -52,7 +53,7 @@ _supported_os Linux
>  _supported_fs ext3 ext4 xfs
>  
>  umount $SCRATCH_DEV 2>/dev/null
> -_scratch_mkfs >> $seq.full 2>&1
> +_scratch_mkfs >> $seqres.full 2>&1
>  _scratch_mount "-o usrquota,grpquota"
>  quotacheck -u -g $SCRATCH_MNT 2>/dev/null
>  quotaon $SCRATCH_MNT 2>/dev/null
> diff --git a/tests/shared/051 b/tests/shared/051
> index 07d5a9b..0671f83 100755
> --- a/tests/shared/051
> +++ b/tests/shared/051
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  
>  here=`pwd`
>  tmp=/tmp/$$
> @@ -73,7 +74,7 @@ _supported_os Linux
>  
>  [ -x $runas ] || _notrun "$runas executable not found"
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  _setup_testdir
>  
> diff --git a/tests/shared/068 b/tests/shared/068
> index fe4684c..c8128c5 100755
> --- a/tests/shared/068
> +++ b/tests/shared/068
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -56,13 +57,13 @@ _require_scratch
>  
>  echo "*** init FS"
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  umount $SCRATCH_DEV >/dev/null 2>&1
> -echo "*** MKFS ***"                         >>$seq.full
> -echo ""                                     >>$seq.full
> -_scratch_mkfs                               >>$seq.full 2>&1 \
> +echo "*** MKFS ***"                         >>$seqres.full
> +echo ""                                     >>$seqres.full
> +_scratch_mkfs                               >>$seqres.full 2>&1 \
>      || _fail "mkfs failed"
> -_scratch_mount                              >>$seq.full 2>&1 \
> +_scratch_mount                              >>$seqres.full 2>&1 \
>      || _fail "mount failed"
>  
>  touch $tmp.running
> @@ -90,23 +91,23 @@ touch $tmp.running
>  i=0
>  let ITERATIONS=$ITERATIONS-1
>  
> -echo | tee -a $seq.full
> +echo | tee -a $seqres.full
>  while [ $i -le $ITERATIONS ]
>  do
> -        echo "*** iteration: $i" | tee -a $seq.full
> -	echo "*** freezing \$SCRATCH_MNT" | tee -a $seq.full
> -	xfs_freeze -f "$SCRATCH_MNT" | tee -a $seq.full
> +        echo "*** iteration: $i" | tee -a $seqres.full
> +	echo "*** freezing \$SCRATCH_MNT" | tee -a $seqres.full
> +	xfs_freeze -f "$SCRATCH_MNT" | tee -a $seqres.full
>  	[ $? != 0 ] && echo xfs_freeze -f "$SCRATCH_MNT" failed | \
> -	    tee -a $seq.full
> +	    tee -a $seqres.full
>  	sleep 2
>  
> -	echo "*** thawing  \$SCRATCH_MNT" | tee -a $seq.full
> -	xfs_freeze -u "$SCRATCH_MNT" | tee -a $seq.full
> +	echo "*** thawing  \$SCRATCH_MNT" | tee -a $seqres.full
> +	xfs_freeze -u "$SCRATCH_MNT" | tee -a $seqres.full
>  	[ $? != 0 ] && echo xfs_freeze -u "$SCRATCH_MNT" failed | \
> -	    tee -a $seq.full
> +	    tee -a $seqres.full
>  	sleep 2
>  
> -	echo  | tee -a $seq.full
> +	echo  | tee -a $seqres.full
>  	let i=$i+1
>  done
>  
> diff --git a/tests/shared/218 b/tests/shared/218
> index 4b46452..7c2bd53 100755
> --- a/tests/shared/218
> +++ b/tests/shared/218
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -59,36 +60,36 @@ rm -f $fragfile
>  
>  # Craft some fragmented files, defrag them, check the result.
>  
> -echo "zero-length file:" | tee -a $seq.full
> +echo "zero-length file:" | tee -a $seqres.full
>  touch $fragfile
>  _defrag $fragfile
>  
> -echo "Sparse file (no blocks):" | tee -a $seq.full
> +echo "Sparse file (no blocks):" | tee -a $seqres.full
>  xfs_io -F -f -c "truncate 1m" $fragfile
>  _defrag $fragfile
>  
> -echo "Contiguous file:" | tee -a $seq.full
> +echo "Contiguous file:" | tee -a $seqres.full
>  dd if=/dev/zero of=$fragfile bs=4k count=4 &>/dev/null
>  _defrag $fragfile
>  
> -echo "Write backwards sync, but contiguous - should defrag to 1 extent" | tee -a $seq.full
> +echo "Write backwards sync, but contiguous - should defrag to 1 extent" | tee -a $seqres.full
>  for I in `seq 9 -1 0`; do
>  	dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync &>/dev/null
>  done
>  _defrag $fragfile
>  
> -echo "Write backwards sync leaving holes - defrag should do nothing" | tee -a $seq.full
> +echo "Write backwards sync leaving holes - defrag should do nothing" | tee -a $seqres.full
>  for I in `seq 31 -2 0`; do
>  	dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync &>/dev/null
>  done
>  _defrag $fragfile
>  
> -echo "Write forwards sync leaving holes - defrag should do nothing" | tee -a $seq.full
> +echo "Write forwards sync leaving holes - defrag should do nothing" | tee -a $seqres.full
>  for I in `seq 0 2 31`; do
>  	dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync &>/dev/null
>  done
>  _defrag $fragfile
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=0
>  exit
> diff --git a/tests/shared/243 b/tests/shared/243
> index 6a1b6d7..4884e29 100755
> --- a/tests/shared/243
> +++ b/tests/shared/243
> @@ -42,6 +42,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -85,23 +86,23 @@ _check_ext4_eof_flag()
>  
>      # Ensure that the iflags value was parsed correctly.
>      if [ -z ${iflags} ]; then
> -      echo "iFlags value was not parsed successfully." >> $seq.full
> +      echo "iFlags value was not parsed successfully." >> $seqres.full
>        status=1
>        exit ${status}
>      fi
>  
>      # Check if EOFBLOCKS_FL is set.
>      if ((${iflags} & 0x400000)); then
> -      echo "EOFBLOCK_FL bit is set." >> $seq.full
> +      echo "EOFBLOCK_FL bit is set." >> $seqres.full
>        bit_set=1
>      else
> -      echo "EOFBLOCK_FL bit is not set." >> $seq.full
> +      echo "EOFBLOCK_FL bit is not set." >> $seqres.full
>        bit_set=0
>      fi
>  
>      # Check current bit state to expected value.
>      if [ ${bit_set} -ne ${2} ]; then
> -      echo "Error: Current bit state incorrect." >> $seq.full
> +      echo "Error: Current bit state incorrect." >> $seqres.full
>        status=1
>        exit ${status}
>      fi
> @@ -121,14 +122,14 @@ _supported_os Linux
>  _require_xfs_io_falloc
>  
>  # Real QA test starts here.
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  # Remove any leftover files from last run.
>  rm -f ${TEST_DIR}/test_?
>  
>  # Begin test cases.
>  echo "Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io)." \
> -    >> $seq.full
> +    >> $seqres.full
>  ${XFS_IO_PROG} -F -f                    \
>      -c 'falloc -k 0 40960'              \
>      -c 'pwrite 0 4096'                  \
> @@ -136,7 +137,7 @@ ${XFS_IO_PROG} -F -f                    \
>  _check_ext4_eof_flag test_1 ${BIT_SET}
>  
>  echo "Test 2: Fallocate 40960 bytes and write 4096 bytes (direct io)." \
> -    >> $seq.full
> +    >> $seqres.full
>  ${XFS_IO_PROG} -F -f -d                 \
>      -c 'falloc -k 0 40960'              \
>      -c 'pwrite 0 4096'                  \
> @@ -144,7 +145,7 @@ ${XFS_IO_PROG} -F -f -d                 \
>  _check_ext4_eof_flag test_2 ${BIT_SET}
>  
>  echo "Test 3: Fallocate 40960 bytes and write 40960 bytes (buffered io)." \
> -    >> $seq.full
> +    >> $seqres.full
>  ${XFS_IO_PROG} -F -f                    \
>      -c 'falloc -k 0 40960'              \
>      -c 'pwrite 0 40960'                 \
> @@ -152,7 +153,7 @@ ${XFS_IO_PROG} -F -f                    \
>  _check_ext4_eof_flag test_3 ${BIT_NOT_SET}
>  
>  echo "Test 4: Fallocate 40960 bytes and write 40960 bytes (direct io)." \
> -    >> $seq.full
> +    >> $seqres.full
>  ${XFS_IO_PROG} -F -f -d                 \
>      -c 'falloc -k 0 40960'              \
>      -c 'pwrite 0 40960'                 \
> @@ -160,7 +161,7 @@ ${XFS_IO_PROG} -F -f -d                 \
>  _check_ext4_eof_flag test_4 ${BIT_NOT_SET}
>  
>  echo "Test 5: Fallocate 128k, seek 256k and write 4k block (buffered io)." \
> -    >> $seq.full
> +    >> $seqres.full
>  ${XFS_IO_PROG} -F -f                    \
>      -c 'falloc -k 0 128k'               \
>      -c 'pwrite 256k 4k'                 \
> @@ -168,7 +169,7 @@ ${XFS_IO_PROG} -F -f                    \
>  _check_ext4_eof_flag test_5 ${BIT_NOT_SET}
>  
>  echo "Test 6: Fallocate 128k, seek to 256k and write a 4k block (direct io)." \
> -    >> $seq.full
> +    >> $seqres.full
>  ${XFS_IO_PROG} -F -f -d                 \
>      -c 'falloc -k 0 128k'               \
>      -c 'pwrite 256k 4k'                 \
> diff --git a/tests/shared/272 b/tests/shared/272
> index ed85216..f5b826f 100755
> --- a/tests/shared/272
> +++ b/tests/shared/272
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -52,8 +53,8 @@ _workout()
>  chattr_opt: $chattr_opt"
>  			dd if=/dev/zero of=$SCRATCH_MNT/file.$idx \
>  				bs=1M count=4 $write_opt \
> -				>> $seq.full 2>&1 || exit
> -			chattr $chattr_opt $SCRATCH_MNT/file.$idx >> $seq.full \
> +				>> $seqres.full 2>&1 || exit
> +			chattr $chattr_opt $SCRATCH_MNT/file.$idx >> $seqres.full \
>  				|| exit
>  		done
>  	done
> @@ -69,9 +70,9 @@ chattr_opt: $chattr_opt"
>  			echo "OP write_opt: $write_opt ENOSPC, \
>  chattr_opt: $chattr_opt"
>  			dd if=/dev/zero of=$SCRATCH_MNT/file.$idx \
> -				bs=1M $write_opt >> $seq.full 2>&1
> +				bs=1M $write_opt >> $seqres.full 2>&1
>  			chattr $chattr_opt $SCRATCH_MNT/file.$idx \
> -				>> $seq.full || exit
> +				>> $seqres.full || exit
>  		done
>  		sync
>  		unlink $SCRATCH_MNT/file.$idx
> @@ -84,7 +85,7 @@ _supported_os Linux
>  _need_to_be_root
>  _require_scratch
>  
> -_scratch_mkfs_sized $((64 * 1024 * 1024)) >> $seq.full 2>&1
> +_scratch_mkfs_sized $((64 * 1024 * 1024)) >> $seqres.full 2>&1
>  _scratch_mount
>  
>  if ! _workout; then
> diff --git a/tests/udf/098 b/tests/udf/098
> index 58d2a95..dd1e9ad 100755
> --- a/tests/udf/098
> +++ b/tests/udf/098
> @@ -30,6 +30,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -268,7 +269,7 @@ _check_udf_filesystem $SCRATCH_DEV
>  
>  # optional stuff if your test has verbose output to help resolve problems
>  #echo
> -#echo "If failure, check $seq.full (this) and $seq.full.ok (reference)"
> +#echo "If failure, check $seqres.full (this) and $seqres.full.ok (reference)"
>  
>  # success, all done
>  status=0
> diff --git a/tests/udf/101 b/tests/udf/101
> index 0d274e5..89507a9 100755
> --- a/tests/udf/101
> +++ b/tests/udf/101
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/udf/102 b/tests/udf/102
> index 68407a7..bf3edd2 100755
> --- a/tests/udf/102
> +++ b/tests/udf/102
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/003 b/tests/xfs/003
> index 79b6bc5..56dd852 100755
> --- a/tests/xfs/003
> +++ b/tests/xfs/003
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  # get standard environment, filters and checks
> diff --git a/tests/xfs/004 b/tests/xfs/004
> index d75c3c0..fb02b95 100755
> --- a/tests/xfs/004
> +++ b/tests/xfs/004
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -39,8 +40,8 @@ trap "_cleanup" 0 1 2 3 15
>  
>  _populate_scratch()
>  {
> -	echo "=== mkfs output ===" >>$seq.full
> -	_scratch_mkfs_xfs | tee -a $seq.full | _filter_mkfs 2>$tmp.mkfs
> +	echo "=== mkfs output ===" >>$seqres.full
> +	_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
>  	. $tmp.mkfs
>  	_scratch_mount
>  	dd if=/dev/zero of=$SCRATCH_MNT/foo count=200 bs=4096 >/dev/null 2>&1 &
> @@ -64,7 +65,7 @@ _need_to_be_root
>  _require_scratch
>  _require_no_large_scratch_dev
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  _populate_scratch
>  
> @@ -72,16 +73,16 @@ _populate_scratch
>  
>  eval `$DF_PROG $SCRATCH_MNT 2>&1 \
>  	| tail -1 | $AWK_PROG '{ printf "blocks=%u used=%u avail=%u\n", $3, $4, $5 }'`
> -echo "df gave: blocks=$blocks used=$used avail=$avail" >>$seq.full
> -echo "blocksize from mkfs is '$dbsize'" >>$seq.full
> +echo "df gave: blocks=$blocks used=$used avail=$avail" >>$seqres.full
> +echo "blocksize from mkfs is '$dbsize'" >>$seqres.full
>  
>  xfs_db -r -c "freesp -s" $SCRATCH_DEV >$tmp.xfs_db
> -echo "xfs_db for $SCRATCH_DEV" >>$seq.full
> -cat $tmp.xfs_db >>$seq.full
> +echo "xfs_db for $SCRATCH_DEV" >>$seqres.full
> +cat $tmp.xfs_db >>$seqres.full
>  
>  eval `$XFS_IO_PROG -x -c resblks $SCRATCH_MNT 2>&1 \
>  	| $AWK_PROG '/available/ { printf "resblks=%u\n", $5 }'`
> -echo "resblks gave: resblks=$resblks" >>$seq.full
> +echo "resblks gave: resblks=$resblks" >>$seqres.full
>  
>  # check the 'blocks' field from freesp command is OK
>  # since 2.6.18, df does not report the 4 blocks per AG that cannot
> diff --git a/tests/xfs/008 b/tests/xfs/008
> index 0dee9f5..1f66779 100755
> --- a/tests/xfs/008
> +++ b/tests/xfs/008
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/009 b/tests/xfs/009
> index 1883f15..3e74160 100755
> --- a/tests/xfs/009
> +++ b/tests/xfs/009
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/012 b/tests/xfs/012
> index 10498d5..4bd2afc 100755
> --- a/tests/xfs/012
> +++ b/tests/xfs/012
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/016 b/tests/xfs/016
> index 538ba14..fcb0637 100755
> --- a/tests/xfs/016
> +++ b/tests/xfs/016
> @@ -36,6 +36,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -72,7 +73,7 @@ _init()
>      if _scratch_mkfs_xfs -N -K $force_opts >/dev/null 2>&1; then
>          force_opts="-K $force_opts"
>      fi
> -    echo mkfs_xfs $force_opts $SCRATCH_DEV >>$seq.full
> +    echo mkfs_xfs $force_opts $SCRATCH_DEV >>$seqres.full
>      _scratch_mkfs_xfs $force_opts >$tmp.mkfs0 2>&1
>      [ $? -ne 0 ] && \
>          _notrun "Cannot mkfs for this test using MKFS_OPTIONS specified"
> @@ -163,8 +164,8 @@ _check_corrupt()
>  {
>      f="c6c6c6c6"
>      echo "*** check for corruption"
> -    echo "expect $f..." >>$seq.full
> -    xfs_db -r -c "fsblock $2" -c "print" $1 | head | tee -a $seq.full | \
> +    echo "expect $f..." >>$seqres.full
> +    xfs_db -r -c "fsblock $2" -c "print" $1 | head | tee -a $seqres.full | \
>          grep -q -v "$f $f $f $f $f $f $f $f" && \
>              _fail "!!! block $2 corrupted!"
>  }
> @@ -177,7 +178,7 @@ _check_corrupt()
>  _supported_fs xfs
>  _supported_os Linux
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  # mkfs sizes
>  log_size=2097152
> @@ -187,15 +188,15 @@ _require_scratch
>  _init
>  
>  block=`_after_log $SCRATCH_DEV`
> -echo "fsblock after log = $block"               >>$seq.full
> +echo "fsblock after log = $block"               >>$seqres.full
>  _check_corrupt $SCRATCH_DEV $block
>  
>  actual_log_size=`_log_size`
> -echo "log size = $actual_log_size BB"                      >>$seq.full
> +echo "log size = $actual_log_size BB"                      >>$seqres.full
>  head=`_log_head`
> -echo "log position = $head"                     >>$seq.full
> +echo "log position = $head"                     >>$seqres.full
>  lsunit=`_log_sunit`
> -echo "log sunit = $lsunit"			>>$seq.full
> +echo "log sunit = $lsunit"			>>$seqres.full
>  
>  # sanity checks
>  [ $actual_log_size -eq $log_size_bb ] || \
> @@ -206,36 +207,36 @@ echo "log sunit = $lsunit"			>>$seq.full
>  # find how how many blocks per op for 100 ops
>  # ignore the fact that it will also include an unmount record etc...
>  # this should be small overall
> -echo "    lots of traffic for sampling" >>$seq.full
> +echo "    lots of traffic for sampling" >>$seqres.full
>  sample_size_ops=100
>  _log_traffic $sample_size_ops
>  head1=`_log_head`
>  num_blocks=`expr $head1 - $head`
>  blocks_per_op=`echo "scale=3; $num_blocks / $sample_size_ops" | bc`
> -echo "blocks_per_op = $blocks_per_op" >>$seq.full
> +echo "blocks_per_op = $blocks_per_op" >>$seqres.full
>  num_expected_ops=`echo "$log_size_bb / $blocks_per_op" | bc`
> -echo "num_expected_ops = $num_expected_ops" >>$seq.full
> +echo "num_expected_ops = $num_expected_ops" >>$seqres.full
>  num_expected_to_go=`echo "$num_expected_ops - $sample_size_ops" | bc`
> -echo "num_expected_to_go = $num_expected_to_go" >>$seq.full
> +echo "num_expected_to_go = $num_expected_to_go" >>$seqres.full
>  
> -echo "    lots more traffic" >>$seq.full
> +echo "    lots more traffic" >>$seqres.full
>  _log_traffic $num_expected_to_go
>  head=`_log_head`
> -echo "log position = $head"                     >>$seq.full
> +echo "log position = $head"                     >>$seqres.full
>  
>  # e.g. 3891
>  near_end_min=`echo "0.95 * $log_size_bb" | bc | sed 's/\..*//'`
> -echo "near_end_min = $near_end_min" >>$seq.full
> +echo "near_end_min = $near_end_min" >>$seqres.full
>  
>  [ $head -gt $near_end_min -a $head -lt $log_size_bb ] || \
>      _fail "!!! unexpected near end log position $head"
>  
>  for c in `seq 0 20`
>  do
> -    echo "   little traffic"            >>$seq.full
> +    echo "   little traffic"            >>$seqres.full
>      _log_traffic 2
>      head=`_log_head`
> -    echo "log position = $head"         >>$seq.full
> +    echo "log position = $head"         >>$seqres.full
>      _check_corrupt $SCRATCH_DEV $block
>  done
>  
> diff --git a/tests/xfs/017 b/tests/xfs/017
> index 59d092d..7c29d21 100755
> --- a/tests/xfs/017
> +++ b/tests/xfs/017
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -52,13 +53,13 @@ _require_no_large_scratch_dev
>  
>  echo "*** init FS"
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  umount $SCRATCH_DEV >/dev/null 2>&1
> -echo "*** MKFS ***"                         >>$seq.full
> -echo ""                                     >>$seq.full
> -_scratch_mkfs_xfs                           >>$seq.full 2>&1 \
> +echo "*** MKFS ***"                         >>$seqres.full
> +echo ""                                     >>$seqres.full
> +_scratch_mkfs_xfs                           >>$seqres.full 2>&1 \
>      || _fail "mkfs failed"
> -_scratch_mount                              >>$seq.full 2>&1 \
> +_scratch_mount                              >>$seqres.full 2>&1 \
>      || _fail "mount failed"
>  
>  echo "*** test"
> @@ -66,21 +67,21 @@ echo "*** test"
>  for l in 0 1 2 3 4
>  do
>          echo "    *** test $l"
> -        $FSSTRESS_PROG -d $SCRATCH_MNT -n 1000 $FSSTRESS_AVOID >>$seq.full
> +        $FSSTRESS_PROG -d $SCRATCH_MNT -n 1000 $FSSTRESS_AVOID >>$seqres.full
>  
>          _scratch_mount -o remount,ro \
>              || _fail "remount ro failed"
>  
> -        echo ""                                 >>$seq.full
> -        echo "*** xfs_logprint ***"             >>$seq.full
> -        echo ""                                 >>$seq.full
> -        _scratch_xfs_logprint -tb               | tee -a $seq.full \
> +        echo ""                                 >>$seqres.full
> +        echo "*** xfs_logprint ***"             >>$seqres.full
> +        echo ""                                 >>$seqres.full
> +        _scratch_xfs_logprint -tb               | tee -a $seqres.full \
>              | head | grep -q "<CLEAN>" || _fail "DIRTY LOG"
>  
> -        echo ""                             >>$seq.full
> -        echo "*** XFS_CHECK ***"            >>$seq.full
> -        echo ""                             >>$seq.full
> -        _scratch_xfs_check                  >>$seq.full 2>&1 \
> +        echo ""                             >>$seqres.full
> +        echo "*** XFS_CHECK ***"            >>$seqres.full
> +        echo ""                             >>$seqres.full
> +        _scratch_xfs_check                  >>$seqres.full 2>&1 \
>              || _fail "xfs_check failed"
>          _scratch_mount -o remount,rw \
>              || _fail "remount rw failed"
> @@ -88,6 +89,6 @@ done
>  
>  echo "*** done"
>  # happy exit
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=0
>  exit 0
> diff --git a/tests/xfs/018 b/tests/xfs/018
> index 156cc1d..ed99f20 100755
> --- a/tests/xfs/018
> +++ b/tests/xfs/018
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -47,7 +48,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  _supported_fs xfs
>  _supported_os IRIX Linux
>  # prelim
> -rm -f $seq.full $tmp.*
> +rm -f $seqres.full $tmp.*
>  _require_scratch
>  _require_v2log
>  
> diff --git a/tests/xfs/019 b/tests/xfs/019
> index 1fb0d83..c4bb681 100755
> --- a/tests/xfs/019
> +++ b/tests/xfs/019
> @@ -23,11 +23,12 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
> -seqfull="$seq.full"
> +seqfull="$seqres.full"
>  status=1	# failure is the default!
>  # get standard environment, filters and checks
>  . ./common.rc
> diff --git a/tests/xfs/021 b/tests/xfs/021
> index 18fe40e..3cbf088 100755
> --- a/tests/xfs/021
> +++ b/tests/xfs/021
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -78,7 +79,7 @@ _supported_os Linux
>  _require_scratch
>  _require_attrs
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  umount $SCRATCH_DEV >/dev/null 2>&1
>  
>  echo "*** mkfs"
> @@ -124,7 +125,7 @@ echo ""
>  inum_2=`ls -li $testfile.2 | $AWK_PROG '{ print $1 }'`
>  
>  echo "*** unmount FS"
> -umount $SCRATCH_DEV >>$seq.full 2>&1 \
> +umount $SCRATCH_DEV >>$seqres.full 2>&1 \
>  	|| _fail "umount failed"
>  
>  echo "*** dump attributes (1)"
> diff --git a/tests/xfs/022 b/tests/xfs/022
> index 962316f..0251936 100755
> --- a/tests/xfs/022
> +++ b/tests/xfs/022
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/023 b/tests/xfs/023
> index 3e7fdd2..7bb77da 100755
> --- a/tests/xfs/023
> +++ b/tests/xfs/023
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/024 b/tests/xfs/024
> index b7f1c10..ec5edc5 100755
> --- a/tests/xfs/024
> +++ b/tests/xfs/024
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -42,11 +43,11 @@ _require_tape $TAPE_DEV
>  _create_dumpdir_fill
>  # ensure file/dir timestamps precede dump timestamp
>  sleep 2
> -src/bstat $SCRATCH_MNT >>$here/$seq.full
> +src/bstat $SCRATCH_MNT >>$here/$seqres.full
>  _erase_hard
>  _do_dump
>  _append_dumpdir_fill
> -src/bstat $SCRATCH_MNT >>$here/$seq.full
> +src/bstat $SCRATCH_MNT >>$here/$seqres.full
>  _erase_hard
>  _do_dump -l 1
>  _do_restore
> diff --git a/tests/xfs/025 b/tests/xfs/025
> index 4ccb5de..1e44732 100755
> --- a/tests/xfs/025
> +++ b/tests/xfs/025
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/026 b/tests/xfs/026
> index 37a23cc..04bda76 100755
> --- a/tests/xfs/026
> +++ b/tests/xfs/026
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/027 b/tests/xfs/027
> index 772705d..712378d 100755
> --- a/tests/xfs/027
> +++ b/tests/xfs/027
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/028 b/tests/xfs/028
> index 0bf042f..e70bc57 100755
> --- a/tests/xfs/028
> +++ b/tests/xfs/028
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -59,7 +60,7 @@ while [ $i -lt 5 ]; do
>      let i=$i+1
>  done
>  
> -echo "middate = $middate" >>$seq.full
> +echo "middate = $middate" >>$seqres.full
>  
>  #
>  # Now do the xfsinvutil and
> diff --git a/tests/xfs/029 b/tests/xfs/029
> index 70c0d10..4916c33 100755
> --- a/tests/xfs/029
> +++ b/tests/xfs/029
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/030 b/tests/xfs/030
> index 080d3fe..f9c1dfb 100755
> --- a/tests/xfs/030
> +++ b/tests/xfs/030
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/031 b/tests/xfs/031
> index 422a271..3dec089 100755
> --- a/tests/xfs/031
> +++ b/tests/xfs/031
> @@ -23,13 +23,14 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
>  status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  # get standard environment, filters and checks
>  . ./common.rc
> @@ -41,15 +42,15 @@ _link_out_file $seq.out
>  
>  _check_repair()
>  {
> -	echo "Repairing, round 0" >> $seq.full
> -	_scratch_xfs_repair 2>&1 | _filter_repair | tee -a $seq.full >$tmp.0
> +	echo "Repairing, round 0" >> $seqres.full
> +	_scratch_xfs_repair 2>&1 | _filter_repair | tee -a $seqres.full >$tmp.0
>  	for i in 1 2 3 4
>  	do
> -		echo "Repairing, iteration $i" | tee -a $seq.full
> +		echo "Repairing, iteration $i" | tee -a $seqres.full
>  		_scratch_xfs_repair 2>&1 | _filter_repair >$tmp.$i
> -		diff $tmp.0 $tmp.$i >> $seq.full
> +		diff $tmp.0 $tmp.$i >> $seqres.full
>  		if [ $? -ne 0 ]; then
> -			echo "ERROR: repair round $i differs to round 0 (see $seq.full)" | tee -a $seq.full
> +			echo "ERROR: repair round $i differs to round 0 (see $seqres.full)" | tee -a $seqres.full
>  			break
>  		fi
>  		# echo all interesting stuff...
> diff --git a/tests/xfs/032 b/tests/xfs/032
> index ad1909d..9836bcc 100755
> --- a/tests/xfs/032
> +++ b/tests/xfs/032
> @@ -23,13 +23,14 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
>  status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  # get standard environment, filters and checks
>  . ./common.rc
> @@ -69,18 +70,18 @@ do
>  	src/devzero -n 20 $SCRATCH_DEV >/dev/null
>  
>  	# create a filesystem of this type
> -	echo "=== Creating $fs filesystem..." >>$seq.full
> -	echo "    ( $preop mkfs -t $fs $preargs $SCRATCH_DEV $postargs )" >>$seq.full
> -	eval $preop mkfs -t $fs $preargs $SCRATCH_DEV $postargs >>$seq.full 2>&1
> +	echo "=== Creating $fs filesystem..." >>$seqres.full
> +	echo "    ( $preop mkfs -t $fs $preargs $SCRATCH_DEV $postargs )" >>$seqres.full
> +	eval $preop mkfs -t $fs $preargs $SCRATCH_DEV $postargs >>$seqres.full 2>&1
>  
>  	if [ $? -eq 0 ] ; then
>  		# next, ensure we don't overwrite it
> -		echo "=== Attempting XFS overwrite of $fs..." >>$seq.full
> -		/sbin/mkfs.xfs $SCRATCH_DEV >>$seq.full 2>&1
> +		echo "=== Attempting XFS overwrite of $fs..." >>$seqres.full
> +		/sbin/mkfs.xfs $SCRATCH_DEV >>$seqres.full 2>&1
>  
>  		[ $? -eq 0 ] && echo "Failed - overwrote fs type ${fs}!"
>  	else
> -		echo "mkfs of type ${fs} failed" >>$seq.full
> +		echo "mkfs of type ${fs} failed" >>$seqres.full
>  	fi
>  done
>  
> diff --git a/tests/xfs/033 b/tests/xfs/033
> index dc5a32d..1540a1c 100755
> --- a/tests/xfs/033
> +++ b/tests/xfs/033
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/034 b/tests/xfs/034
> index 27f3f22..372dead 100755
> --- a/tests/xfs/034
> +++ b/tests/xfs/034
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -50,13 +51,13 @@ _require_scratch
>  
>  echo "*** init FS"
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  umount $SCRATCH_DEV >/dev/null 2>&1
> -echo "*** MKFS ***"                         >>$seq.full
> -echo ""                                     >>$seq.full
> -_scratch_mkfs_xfs                           >>$seq.full 2>&1 \
> +echo "*** MKFS ***"                         >>$seqres.full
> +echo ""                                     >>$seqres.full
> +_scratch_mkfs_xfs                           >>$seqres.full 2>&1 \
>      || _fail "mkfs failed"
> -_scratch_mount                              >>$seq.full 2>&1 \
> +_scratch_mount                              >>$seqres.full 2>&1 \
>      || _fail "mount failed"
>  
>  echo "*** test"
> @@ -69,7 +70,7 @@ then
>      exit
>  fi
>  
> -if ! src/xfsctl $SCRATCH_MNT $SCRATCH_MNT/fish >>$seq.full 2>&1
> +if ! src/xfsctl $SCRATCH_MNT $SCRATCH_MNT/fish >>$seqres.full 2>&1
>  then
>      echo "!!! failed to run xfsctl test program"
>      exit
> diff --git a/tests/xfs/035 b/tests/xfs/035
> index b2fc417..cd743f6 100755
> --- a/tests/xfs/035
> +++ b/tests/xfs/035
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/036 b/tests/xfs/036
> index e9bb411..5a7ee01 100755
> --- a/tests/xfs/036
> +++ b/tests/xfs/036
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/037 b/tests/xfs/037
> index e2e71c5..ca10429 100755
> --- a/tests/xfs/037
> +++ b/tests/xfs/037
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/038 b/tests/xfs/038
> index b62a4c9..64d2428 100755
> --- a/tests/xfs/038
> +++ b/tests/xfs/038
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/039 b/tests/xfs/039
> index 428e8bb..21574d6 100755
> --- a/tests/xfs/039
> +++ b/tests/xfs/039
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/040 b/tests/xfs/040
> index 0021c22..119a770 100755
> --- a/tests/xfs/040
> +++ b/tests/xfs/040
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -49,9 +50,9 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  # real QA test starts here
>  cd "$WORKAREA/xfstests"
>  echo Silence is golden.
> -perl tools/srcdiff -q >$seq.full
> -if ! diff $seq.full $seq.good >/dev/null; then
> -    echo "FAILED: srcdiff output $seq.full differs to $seq.good"
> +perl tools/srcdiff -q >$seqres.full
> +if ! diff $seqres.full $seq.good >/dev/null; then
> +    echo "FAILED: srcdiff output $seqres.full differs to $seq.good"
>      exit 1
>  fi
>  
> diff --git a/tests/xfs/041 b/tests/xfs/041
> index a9a9a23..dd50301 100755
> --- a/tests/xfs/041
> +++ b/tests/xfs/041
> @@ -25,6 +25,7 @@
>  set +x
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -59,7 +60,7 @@ _fill()
>  }
>  
>  _do_die_on_error=message_only
> -rm -f $seq.full
> +rm -f $seqres.full
>  agsize=32
>  echo -n "Make $agsize megabyte filesystem on SCRATCH_DEV and mount... "
>  _scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 2>&1 >/dev/null || _fail "mkfs failed"
> @@ -84,7 +85,7 @@ do
>      echo "done"
>      echo -n "Check files... "
>      if ! _do "src/fill2fs_check $tmp.manifest"; then
> -      echo "fail (see $seq.full)"
> +      echo "fail (see $seqres.full)"
>        _do "cat $tmp.manifest"
>        _do "ls -altrR $SCRATCH_MNT"
>        _do "dd if=$SCRATCH_DEV bs=4096 count=$grow_size | gzip -9 > $seq.fsimage.gz"
> diff --git a/tests/xfs/042 b/tests/xfs/042
> index 15fa5dc..1127b46 100755
> --- a/tests/xfs/042
> +++ b/tests/xfs/042
> @@ -26,6 +26,7 @@
>  set +x
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -86,7 +87,7 @@ _cull_files()
>  # create 3 minimum sized (16Mb) allocation groups
>  # xfs_repair is going to need three to verify the superblock
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  _do_die_on_error=message_only
>  
>  echo -n "Make a 48 megabyte filesystem on SCRATCH_DEV and mount... "
> @@ -147,7 +148,7 @@ echo -n "Check fill file... "
>  _do "sum $SCRATCH_MNT/fill >$tmp.fillsum2"
>  if ! _do "diff $tmp.fillsum1 $tmp.fillsum2"; then
>      echo "fail"
> -    echo "Fill file is corrupt/missing after fsr. Test failed see $seq.full"
> +    echo "Fill file is corrupt/missing after fsr. Test failed see $seqres.full"
>      status=1; exit
>  fi
>  echo "done"
> @@ -157,7 +158,7 @@ echo -n "Check large file... "
>  _do "sum $SCRATCH_MNT/fragmented >$tmp.sum2"
>  if ! _do "diff $tmp.sum1 $tmp.sum2"; then
>      echo "fail"
> -    echo "File is corrupt/missing after fsr. Test failed see $seq.full"
> +    echo "File is corrupt/missing after fsr. Test failed see $seqres.full"
>      status=1; exit
>  fi
>  echo "done"
> diff --git a/tests/xfs/043 b/tests/xfs/043
> index ef92c0a..75c2d38 100755
> --- a/tests/xfs/043
> +++ b/tests/xfs/043
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/044 b/tests/xfs/044
> index d0d8bd8..3b330b9 100755
> --- a/tests/xfs/044
> +++ b/tests/xfs/044
> @@ -27,6 +27,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/045 b/tests/xfs/045
> index c20e3a8..9d07570 100755
> --- a/tests/xfs/045
> +++ b/tests/xfs/045
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/046 b/tests/xfs/046
> index fb83b7a..d5f4fca 100755
> --- a/tests/xfs/046
> +++ b/tests/xfs/046
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/047 b/tests/xfs/047
> index 7c5e896..18960ea 100755
> --- a/tests/xfs/047
> +++ b/tests/xfs/047
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -59,7 +60,7 @@ while [ $i -lt 5 ]; do
>      let i=$i+1
>  done
>  
> -echo "middate = $middate" >>$seq.full
> +echo "middate = $middate" >>$seqres.full
>  
>  # Only say No to 1st question to prune
>  cat >$tmp.input <<EOF
> diff --git a/tests/xfs/048 b/tests/xfs/048
> index 6139361..a39ec66 100755
> --- a/tests/xfs/048
> +++ b/tests/xfs/048
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/049 b/tests/xfs/049
> index 0a6e69c..e2d1293 100755
> --- a/tests/xfs/049
> +++ b/tests/xfs/049
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  _cleanup()
> @@ -32,10 +33,10 @@ _cleanup()
>      umount -d $SCRATCH_MNT/test > /dev/null 2>&1
>      rm -f $tmp.*
>  
> -    if [ -w $seq.full ]
> +    if [ -w $seqres.full ]
>      then
> -        echo "--- mounts at end (after cleanup)" >> $seq.full
> -        mount >> $seq.full
> +        echo "--- mounts at end (after cleanup)" >> $seqres.full
> +        mount >> $seqres.full
>      fi
>  }
>  
> @@ -55,7 +56,7 @@ _supported_os Linux
>  _log()
>  {
>      echo "--- $*"
> -    echo "--- $*" >> $seq.full
> +    echo "--- $*" >> $seqres.full
>  }
>  
>  _require_nonexternal
> @@ -64,75 +65,75 @@ _require_no_large_scratch_dev
>  _require_loop
>  _require_ext2
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
> -echo "(dev=$SCRATCH_DEV, mount=$SCRATCH_MNT)" >> $seq.full
> -echo "" >> $seq.full
> +echo "(dev=$SCRATCH_DEV, mount=$SCRATCH_MNT)" >> $seqres.full
> +echo "" >> $seqres.full
>  
> -echo "--- mounts" >> $seq.full
> -mount >> $seq.full
> +echo "--- mounts" >> $seqres.full
> +mount >> $seqres.full
>  
>  _log "Create ext2 fs on scratch"
> -mkfs -t ext2 -F $SCRATCH_DEV >> $seq.full 2>&1 \
> +mkfs -t ext2 -F $SCRATCH_DEV >> $seqres.full 2>&1 \
>      || _fail "!!! failed to mkfs ext2"
>  
>  _log "Mount ext2 fs on scratch"
> -mount -t ext2 $SCRATCH_DEV $SCRATCH_MNT >> $seq.full 2>&1 \
> +mount -t ext2 $SCRATCH_DEV $SCRATCH_MNT >> $seqres.full 2>&1 \
>      || _fail "!!! failed to mount"
>  
>  _log "Create xfs fs in file on scratch"
>  /sbin/mkfs.xfs -f -dfile,name=$SCRATCH_MNT/test.xfs,size=40m \
> -    >> $seq.full 2>&1 \
> +    >> $seqres.full 2>&1 \
>      || _fail "!!! failed to mkfs xfs"
>  
>  _log "Make mount points"
> -mkdir $SCRATCH_MNT/test $SCRATCH_MNT/test2 >> $seq.full 2>&1 \
> +mkdir $SCRATCH_MNT/test $SCRATCH_MNT/test2 >> $seqres.full 2>&1 \
>      || _fail "!!! failed to make mount points"
>  
>  _log "Mount xfs via loop"
> -mount -t xfs -o loop $SCRATCH_MNT/test.xfs $SCRATCH_MNT/test >> $seq.full 2>&1 \
> +mount -t xfs -o loop $SCRATCH_MNT/test.xfs $SCRATCH_MNT/test >> $seqres.full 2>&1 \
>      || _fail "!!! failed to loop mount xfs"
>  
>  _log "stress"
> -$FSSTRESS_PROG -d $SCRATCH_MNT/test -n 1000 $FSSTRESS_AVOID >> $seq.full 2>&1 \
> +$FSSTRESS_PROG -d $SCRATCH_MNT/test -n 1000 $FSSTRESS_AVOID >> $seqres.full 2>&1 \
>      || _fail "!!! stress failed"
>  
>  _log "clean"
> -rm -rf $SCRATCH_MNT/test/* >> $seq.full 2>&1 \
> +rm -rf $SCRATCH_MNT/test/* >> $seqres.full 2>&1 \
>      || _fail "!!! clean failed"
>  
>  _log "create file for ext2 fs"
> -dd if=/dev/zero of=$SCRATCH_MNT/test/test.ext2 bs=1024 count=10240 >> $seq.full 2>&1 \
> +dd if=/dev/zero of=$SCRATCH_MNT/test/test.ext2 bs=1024 count=10240 >> $seqres.full 2>&1 \
>      || _fail "!!! create file failed"
>  
>  _log "Create ext2 fs in file on looped xfs"
> -echo y | mkfs -t ext2 $SCRATCH_MNT/test/test.ext2 >> $seq.full 2>&1 \
> +echo y | mkfs -t ext2 $SCRATCH_MNT/test/test.ext2 >> $seqres.full 2>&1 \
>      || _fail "!!! failed to mkfs ext2 on xfs"
>  
>  _log "Mount ext2 on xfs via loop"
> -mount -t ext2 -o loop $SCRATCH_MNT/test/test.ext2 $SCRATCH_MNT/test2 >> $seq.full 2>&1 \
> +mount -t ext2 -o loop $SCRATCH_MNT/test/test.ext2 $SCRATCH_MNT/test2 >> $seqres.full 2>&1 \
>      || _fail "!!! failed to loop mount xfs"
>  
>  _log "stress ext2 on xfs via loop"
> -$FSSTRESS_PROG -d $SCRATCH_MNT/test2 -n 1000 $FSSTRESS_AVOID >> $seq.full 2>&1 \
> +$FSSTRESS_PROG -d $SCRATCH_MNT/test2 -n 1000 $FSSTRESS_AVOID >> $seqres.full 2>&1 \
>      || _fail "!!! stress ext2 failed"
>  
>  _log "clean"
> -rm -rf $SCRATCH_MNT/test/* >> $seq.full 2>&1 \
> +rm -rf $SCRATCH_MNT/test/* >> $seqres.full 2>&1 \
>      || _fail "!!! clean failed"
>  
>  _log "umount ext2 on xfs"
> -umount -d $SCRATCH_MNT/test2 >> $seq.full 2>&1 \
> +umount -d $SCRATCH_MNT/test2 >> $seqres.full 2>&1 \
>      || _fail "!!! umount ext2 failed"
>  
>  _log "umount xfs"
> -umount -d $SCRATCH_MNT/test >> $seq.full 2>&1 \
> +umount -d $SCRATCH_MNT/test >> $seqres.full 2>&1 \
>      || _fail "!!! umount xfs failed"
>  
> -echo "--- mounts at end (before cleanup)" >> $seq.full
> -mount >> $seq.full
> +echo "--- mounts at end (before cleanup)" >> $seqres.full
> +mount >> $seqres.full
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  # success, all done
>  status=0
>  exit
> diff --git a/tests/xfs/050 b/tests/xfs/050
> index 6a66032..d402cbf 100755
> --- a/tests/xfs/050
> +++ b/tests/xfs/050
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -49,8 +50,8 @@ _supported_fs xfs
>  _supported_os Linux IRIX
>  
> 
> -cp /dev/null $seq.full
> -chmod a+rwx $seq.full	# arbitrary users will write here
> +cp /dev/null $seqres.full
> +chmod a+rwx $seqres.full	# arbitrary users will write here
>  
>  _require_scratch
>  _require_xfs_quota
> @@ -94,7 +95,7 @@ _filter_and_check_blks()
>  _exercise()
>  {
>  	_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
> -	cat $tmp.mkfs >>$seq.full
> +	cat $tmp.mkfs >>$seqres.full
>  
>  	# keep the blocksize and data size for dd later
>  	. $tmp.mkfs
> @@ -111,20 +112,20 @@ _exercise()
>  
>  	_qsetup
>  
> -	echo "Using output from '" `ls -l $seq.out` "'" >>$seq.full
> -	echo "and using type=$type id=$id" >>$seq.full
> +	echo "Using output from '" `ls -l $seq.out` "'" >>$seqres.full
> +	echo "and using type=$type id=$id" >>$seqres.full
>  
>  	echo
> -	echo "*** report no quota settings" | tee -a $seq.full
> +	echo "*** report no quota settings" | tee -a $seqres.full
>  	xfs_quota -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
>  		_filter_report | LC_COLLATE=POSIX sort -ru
>  
>  	echo
> -	echo "*** report initial settings" | tee -a $seq.full
> +	echo "*** report initial settings" | tee -a $seqres.full
>  	_file_as_id $SCRATCH_MNT/initme $id $type 1024 0
> -	echo "ls -l $SCRATCH_MNT" >>$seq.full
> -	ls -l $SCRATCH_MNT >>$seq.full
> +	echo "ls -l $SCRATCH_MNT" >>$seqres.full
> +	ls -l $SCRATCH_MNT >>$seqres.full
>  	xfs_quota -D $tmp.projects -P $temp.projid -x \
>  		-c "limit -$type bsoft=${bsoft}k bhard=${bhard}k $id" \
>  		-c "limit -$type isoft=$isoft ihard=$ihard $id" \
> @@ -134,7 +135,7 @@ _exercise()
>  		_filter_report | LC_COLLATE=POSIX sort -ru
>  
>  	echo
> -	echo "*** push past the soft inode limit" | tee -a $seq.full
> +	echo "*** push past the soft inode limit" | tee -a $seqres.full
>  	_file_as_id $SCRATCH_MNT/softie1 $id $type 1024 0
>  	_file_as_id $SCRATCH_MNT/softie2 $id $type 1024 0
>  	_qmount
> @@ -143,7 +144,7 @@ _exercise()
>  		_filter_report | LC_COLLATE=POSIX sort -ru
>  
>  	echo
> -	echo "*** push past the soft block limit" | tee -a $seq.full
> +	echo "*** push past the soft block limit" | tee -a $seqres.full
>  	_file_as_id $SCRATCH_MNT/softie $id $type 1024 140
>  	_qmount
>  	xfs_quota -D $tmp.projects -P $tmp.projid -x \
> @@ -152,7 +153,7 @@ _exercise()
>  
>  	echo
>  	# Note: for quota accounting (not enforcement), EDQUOT is not expected
> -	echo "*** push past the hard inode limit (expect EDQUOT)" | tee -a $seq.full
> +	echo "*** push past the hard inode limit (expect EDQUOT)" | tee -a $seqres.full
>  	for i in 1 2 3 4 5 6 7 8 9 10 11 12
>  	do
>  		_file_as_id $SCRATCH_MNT/hard$i $id $type 1024 0
> @@ -164,10 +165,10 @@ _exercise()
>  
>  	echo
>  	# Note: for quota accounting (not enforcement), EDQUOT is not expected
> -	echo "*** push past the hard block limit (expect EDQUOT)" | tee -a $seq.full
> +	echo "*** push past the hard block limit (expect EDQUOT)" | tee -a $seqres.full
>  	_file_as_id $SCRATCH_MNT/softie $id $type 1024 540
> -	echo "ls -l $SCRATCH_MNT" >>$seq.full
> -	ls -l $SCRATCH_MNT >>$seq.full
> +	echo "ls -l $SCRATCH_MNT" >>$seqres.full
> +	ls -l $SCRATCH_MNT >>$seqres.full
>  	_qmount
>  	xfs_quota -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
> diff --git a/tests/xfs/052 b/tests/xfs/052
> index 01d5469..2abd78d 100755
> --- a/tests/xfs/052
> +++ b/tests/xfs/052
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -49,7 +50,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  _supported_fs xfs
>  _supported_os IRIX Linux
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  _require_scratch
>  _require_xfs_quota
> @@ -59,8 +60,8 @@ _require_nobody
>  _qmount_option uquota
>  
>  _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
> -cat $tmp.mkfs >>$seq.full
> -chmod a+w $seq.full     # arbitrary users will write here
> +cat $tmp.mkfs >>$seqres.full
> +chmod a+w $seqres.full     # arbitrary users will write here
>  
>  # keep the blocksize from mkfs ($dbsize)
>  . $tmp.mkfs
> @@ -94,7 +95,7 @@ xfs_quota -x \
>  
>  # cross check blks, softblks, hardblks <-> quota, xfs_db
>  xfs_quota -c "quota -$type -birnN $id" $SCRATCH_DEV |
> -			tr -d '\n' | tr -s '[:space:]' | tee -a $seq.full |
> +			tr -d '\n' | tr -s '[:space:]' | tee -a $seqres.full |
>  	perl -ne 'if (m[^\s*'$SCRATCH_DEV'\s+(\d+)\s+(\d+)\s+(\d+)]) {
>  		print "used_blocks=", $1, "\n";
>  		print "soft_blocks=", $2, "\n";
> @@ -102,14 +103,14 @@ xfs_quota -c "quota -$type -birnN $id" $SCRATCH_DEV |
>  		$next = 0;
>  	}' | LC_COLLATE=POSIX sort >$tmp.quota
>  
> -echo ===quota output >> $seq.full
> -cat $tmp.quota >> $seq.full
> +echo ===quota output >> $seqres.full
> +cat $tmp.quota >> $seqres.full
>  [ ! -s $tmp.quota ] && echo "warning: quota output file is empty"
>  
>  umount $SCRATCH_MNT
>  
>  # note - does (insitu) conversion from fs blocks to 1K blocks
> -xfs_db -rc "dquot -$type $id" -c p $SCRATCH_DEV | tee -a $seq.full | perl -ne '
> +xfs_db -rc "dquot -$type $id" -c p $SCRATCH_DEV | tee -a $seqres.full | perl -ne '
>  	if (/^diskdq.bcount = (\d+)$/) {
>  		 print "used_blocks=", $1 * '$dbsize' / 1024, "\n";
>  	}
> @@ -120,8 +121,8 @@ xfs_db -rc "dquot -$type $id" -c p $SCRATCH_DEV | tee -a $seq.full | perl -ne '
>  		print "soft_blocks=", $1 * '$dbsize' / 1024, "\n";
>  	}' | LC_COLLATE=POSIX sort >$tmp.xfs_db
>  
> -echo ===xfs_db output >> $seq.full
> -cat $tmp.xfs_db >> $seq.full
> +echo ===xfs_db output >> $seqres.full
> +cat $tmp.xfs_db >> $seqres.full
>  [ ! -s $tmp.xfs_db ] && echo "warning: xfs_db output file is empty"
>  
>  echo Comparing out of xfs_quota and xfs_db
> diff --git a/tests/xfs/054 b/tests/xfs/054
> index 1ce6180..97590e8 100755
> --- a/tests/xfs/054
> +++ b/tests/xfs/054
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -46,8 +47,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  _supported_fs xfs
>  _supported_os Linux IRIX
>  
> -cp /dev/null $seq.full
> -chmod ugo+rwx $seq.full
> +cp /dev/null $seqres.full
> +chmod ugo+rwx $seqres.full
>  
>  _require_scratch
>  _require_xfs_quota
> @@ -98,7 +99,7 @@ _exercise()
>  	umount $SCRATCH_MNT 2>/dev/null
>  }
>  
> -_scratch_mkfs_xfs >> $seq.full 2>&1 || _fail "mkfs failed!"
> +_scratch_mkfs_xfs >> $seqres.full 2>&1 || _fail "mkfs failed!"
>  
>  _qmount_option "uquota,gquota"
>  _qmount
> diff --git a/tests/xfs/055 b/tests/xfs/055
> index 965b43a..1804727 100755
> --- a/tests/xfs/055
> +++ b/tests/xfs/055
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/056 b/tests/xfs/056
> index be65bfb..8ab61f9 100755
> --- a/tests/xfs/056
> +++ b/tests/xfs/056
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/057 b/tests/xfs/057
> index faa4776..fd856d7 100755
> --- a/tests/xfs/057
> +++ b/tests/xfs/057
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/058 b/tests/xfs/058
> index dfce43b..c800286 100755
> --- a/tests/xfs/058
> +++ b/tests/xfs/058
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/059 b/tests/xfs/059
> index a2a07c9..c26fa4d 100755
> --- a/tests/xfs/059
> +++ b/tests/xfs/059
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/060 b/tests/xfs/060
> index f0d9870..6adce78 100755
> --- a/tests/xfs/060
> +++ b/tests/xfs/060
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/061 b/tests/xfs/061
> index fa98085..e5a8413 100755
> --- a/tests/xfs/061
> +++ b/tests/xfs/061
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/063 b/tests/xfs/063
> index cdaf524..a2ee188 100755
> --- a/tests/xfs/063
> +++ b/tests/xfs/063
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/064 b/tests/xfs/064
> index c7e727c..9ba542e 100755
> --- a/tests/xfs/064
> +++ b/tests/xfs/064
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -66,14 +67,14 @@ while [ $i -le 9 ]; do
>      _stable_fs
>      sleep 2
>  
> -    echo "********* level $i ***********" >>$seq.full
> -    date >>$seq.full
> +    echo "********* level $i ***********" >>$seqres.full
> +    date >>$seqres.full
>      find $SCRATCH_MNT -exec $here/src/lstat64 {} \; | sed 's/(00.*)//' >$tmp.dates.$i
>      if [ $i -gt 0 ]; then
>         let level_1=$i-1
> -       diff -c $tmp.dates.$level_1 $tmp.dates.$i >>$seq.full
> +       diff -c $tmp.dates.$level_1 $tmp.dates.$i >>$seqres.full
>      else
> -       cat $tmp.dates.$i >>$seq.full
> +       cat $tmp.dates.$i >>$seqres.full
>      fi
>  
>      _do_dump_file -f $tmp.df.level$i -l $i
> diff --git a/tests/xfs/065 b/tests/xfs/065
> index 12f2ac9..ef1d10f 100755
> --- a/tests/xfs/065
> +++ b/tests/xfs/065
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/066 b/tests/xfs/066
> index 7a68f79..8709a2b 100755
> --- a/tests/xfs/066
> +++ b/tests/xfs/066
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/067 b/tests/xfs/067
> index baaed77..87b3cc9 100755
> --- a/tests/xfs/067
> +++ b/tests/xfs/067
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -46,14 +47,14 @@ _require_scratch
>  
>  # set up fs for 1K inodes
>  isize=0
> -_scratch_mkfs_xfs | _filter_mkfs >$seq.full 2>$tmp.mkfs
> +_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
>  [ $? -eq 0 ] && source $tmp.mkfs
>  if [ "$isize" -lt 1024 ]; then
> -    _scratch_mkfs_xfs -i size=1024 >>$here/$seq.full \
> +    _scratch_mkfs_xfs -i size=1024 >>$here/$seqres.full \
>  	|| _notrun "Cannot mkfs for this test using MKFS_OPTIONS specified"
>  fi
> -_scratch_mount >>$here/$seq.full || _fail "mount failed"
> -xfs_info $SCRATCH_MNT >>$here/$seq.full
> +_scratch_mount >>$here/$seqres.full || _fail "mount failed"
> +xfs_info $SCRATCH_MNT >>$here/$seqres.full
>  cd $SCRATCH_MNT
>  
>  echo ""
> diff --git a/tests/xfs/071 b/tests/xfs/071
> index c135d1a..b22dd6d 100755
> --- a/tests/xfs/071
> +++ b/tests/xfs/071
> @@ -22,8 +22,9 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  here=`pwd`
>  tmp=/tmp/$$
> @@ -81,19 +82,19 @@ write_block()
>      [ `$direct` ] && flags=-d
>  
>      echo "Writing $bytes bytes, offset is $words (direct=$direct)" | _filter_io
> -    echo "Writing $bytes bytes at $location $words (direct=$direct)" >>$seq.full
> +    echo "Writing $bytes bytes at $location $words (direct=$direct)" >>$seqres.full
>      $XFS_IO_PROG -c "pwrite $offset 512" $flags $SCRATCH_MNT/$seq \
> -	2>&1 | _filter_off $offset | tee -a $seq.full | _filter_pwrite
> -    xfs_bmap -v $SCRATCH_MNT/$seq >>$seq.full
> +	2>&1 | _filter_off $offset | tee -a $seqres.full | _filter_pwrite
> +    xfs_bmap -v $SCRATCH_MNT/$seq >>$seqres.full
>  
>      echo "Reading $bytes bytes (direct=$direct)" | _filter_io
> -    echo "Reading $bytes bytes at $location (direct=$direct)" >>$seq.full
> +    echo "Reading $bytes bytes at $location (direct=$direct)" >>$seqres.full
>      $XFS_IO_PROG -c "pread $offset $bytes" $flags $SCRATCH_MNT/$seq \
> -	2>&1 | _filter_off $offset | tee -a $seq.full | _filter_pread
> +	2>&1 | _filter_off $offset | tee -a $seqres.full | _filter_pread
>  
> -    $XFS_IO_PROG -c "pread -v $offset $bytes" $flags $SCRATCH_MNT/$seq >>$seq.full 2>&1
> +    $XFS_IO_PROG -c "pread -v $offset $bytes" $flags $SCRATCH_MNT/$seq >>$seqres.full 2>&1
>  
> -    echo | tee -a $seq.full
> +    echo | tee -a $seqres.full
>  }
>  
>  # real QA test starts here
> diff --git a/tests/xfs/072 b/tests/xfs/072
> index 930a983..d5bec3c 100755
> --- a/tests/xfs/072
> +++ b/tests/xfs/072
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  _cleanup()
> @@ -49,7 +50,7 @@ _supported_os IRIX Linux
>  
>  _require_scratch
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  umount $SCRATCH_DEV >/dev/null 2>&1
>  
>  _scratch_mkfs_xfs >/dev/null	|| _fail "mkfs failed"
> diff --git a/tests/xfs/073 b/tests/xfs/073
> index d19c8f5..336cb89 100755
> --- a/tests/xfs/073
> +++ b/tests/xfs/073
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/078 b/tests/xfs/078
> index 901723e..df4fc6f 100755
> --- a/tests/xfs/078
> +++ b/tests/xfs/078
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/080 b/tests/xfs/080
> index 3243fe1..fb5b6a6 100755
> --- a/tests/xfs/080
> +++ b/tests/xfs/080
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/081 b/tests/xfs/081
> index f0ee819..44018bc 100755
> --- a/tests/xfs/081
> +++ b/tests/xfs/081
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -50,7 +51,7 @@ _cleanup()
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # prelim
> -rm -f $seq.full $tmp.*
> +rm -f $seqres.full $tmp.*
>  _require_scratch
>  _require_xfs_quota
>  _require_v2log
> diff --git a/tests/xfs/082 b/tests/xfs/082
> index e21a793..652f362 100755
> --- a/tests/xfs/082
> +++ b/tests/xfs/082
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -48,7 +49,7 @@ _supported_fs xfs
>  _supported_os IRIX Linux
>  
>  # prelim
> -rm -f $seq.full $tmp.*
> +rm -f $seqres.full $tmp.*
>  _require_scratch
>  _require_v2log 
>  
> diff --git a/tests/xfs/084 b/tests/xfs/084
> index ba5743a..46aa837 100755
> --- a/tests/xfs/084
> +++ b/tests/xfs/084
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/085 b/tests/xfs/085
> index 44123ad..a02c42d 100755
> --- a/tests/xfs/085
> +++ b/tests/xfs/085
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -42,24 +43,24 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  _supported_fs xfs
>  _supported_os IRIX Linux
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  rm -f $tmp.log
>  
>  _require_scratch
>  
>  echo "mkfs"
> -_scratch_mkfs_xfs >>$seq.full 2>&1 \
> +_scratch_mkfs_xfs >>$seqres.full 2>&1 \
>      || _fail "mkfs scratch failed"
>  
>  echo "mount"
> -_scratch_mount >>$seq.full 2>&1 \
> +_scratch_mount >>$seqres.full 2>&1 \
>      || _fail "mount failed: $MOUNT_OPTIONS"
>  
>  echo "touch files"
>  touch $SCRATCH_MNT/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
>  
>  echo "godown"
> -src/godown -v -f $SCRATCH_MNT >> $seq.full
> +src/godown -v -f $SCRATCH_MNT >> $seqres.full
>  
>  echo "unmount"
>  umount $SCRATCH_MNT
> @@ -75,7 +76,7 @@ if false; then
>  fi
>  
>  echo "mount with replay"
> -_scratch_mount $mnt >>$seq.full 2>&1 \
> +_scratch_mount $mnt >>$seqres.full 2>&1 \
>      || _fail "mount failed: $mnt $MOUNT_OPTIONS"
>  
>  echo "ls SCRATCH_MNT"
> diff --git a/tests/xfs/086 b/tests/xfs/086
> index b59ad0a..2e2d4cf 100755
> --- a/tests/xfs/086
> +++ b/tests/xfs/086
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -41,7 +42,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  _supported_fs xfs
>  _supported_os IRIX Linux
>  
> -rm -f $seq.full $tmp.*
> +rm -f $seqres.full $tmp.*
>  _require_scratch
>  _require_v2log
>  
> @@ -83,7 +84,7 @@ for s in sync nosync ; do
>  
>  	# mkfs the FS
>  	_echofull "mkfs"
> -	_scratch_mkfs_xfs >>$seq.full 2>&1
> +	_scratch_mkfs_xfs >>$seqres.full 2>&1
>  	if [ $? -ne 0 ] ; then 
>  	    _echofull "mkfs failed: $MKFS_OPTIONS"
>  	    continue
> @@ -91,7 +92,7 @@ for s in sync nosync ; do
>  
>  	# mount the FS
>  	_echofull "mount"
> -	if ! _scratch_mount >>$seq.full 2>&1; then
> +	if ! _scratch_mount >>$seqres.full 2>&1; then
>  	    _echofull "mount failed: $MOUNT_OPTIONS"
>  	    continue
>  	fi
> @@ -116,17 +117,17 @@ for s in sync nosync ; do
>  	ls $SCRATCH_MNT
>  
>  	_echofull "godown"
> -	src/godown -v -f $SCRATCH_MNT >> $seq.full
> +	src/godown -v -f $SCRATCH_MNT >> $seqres.full
>  
>  	_echofull "unmount"
> -	umount $SCRATCH_DEV >>$seq.full 2>&1 \
> +	umount $SCRATCH_DEV >>$seqres.full 2>&1 \
>  	    || _fail "umount failed"
>  
>  	_echofull "logprint after going down..."
>  	_print_logstate
>  
>  	_echofull "mount with replay"
> -	_scratch_mount >>$seq.full 2>&1 \
> +	_scratch_mount >>$seqres.full 2>&1 \
>  	    || _fail "mount failed: $MOUNT_OPTIONS"
>  
>  	# check on what FS looks like after log recovery
> diff --git a/tests/xfs/087 b/tests/xfs/087
> index 30e117b..3e51fcb 100755
> --- a/tests/xfs/087
> +++ b/tests/xfs/087
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -45,7 +46,7 @@ _do_meta()
>      param="-p 4 -z -f rmdir=10 -f link=10 -f creat=10 -f mkdir=10 \
>             -f rename=30 -f stat=30 -f unlink=30 -f truncate=20"
>      _echofull "calling fsstress $param -m8 -n $count"
> -    if ! $FSSTRESS_PROG $param $FSSTRESS_AVOID -m 8 -n $count -d $out >>$seq.full 2>&1
> +    if ! $FSSTRESS_PROG $param $FSSTRESS_AVOID -m 8 -n $count -d $out >>$seqres.full 2>&1
>      then
>  	_echofull "fsstress failed"
>      fi
> @@ -55,7 +56,7 @@ _do_meta()
>  _supported_fs xfs
>  _supported_os IRIX Linux
>  
> -rm -f $seq.full $tmp.*
> +rm -f $seqres.full $tmp.*
>  _require_scratch
>  _require_v2log 
>  _require_xfs_quota
> @@ -90,7 +91,7 @@ do
>  
>      # mkfs the FS
>      _echofull "mkfs"
> -    _scratch_mkfs_xfs >>$seq.full 2>&1
> +    _scratch_mkfs_xfs >>$seqres.full 2>&1
>      if [ $? -ne 0 ] ; then 
>  	_echofull "mkfs failed: $MKFS_OPTIONS"
>  	continue
> @@ -98,7 +99,7 @@ do
>  
>      # mount the FS
>      _echofull "mount"
> -    if ! _scratch_mount -o uquota >>$seq.full 2>&1; then
> +    if ! _scratch_mount -o uquota >>$seqres.full 2>&1; then
>  	_echofull "mount failed: $MOUNT_OPTIONS"
>  	continue
>      fi
> @@ -111,20 +112,20 @@ do
>      ls -RF $SCRATCH_MNT >$tmp.ls1
>  
>      _echofull "godown"
> -    src/godown -v -f $SCRATCH_MNT >> $seq.full
> +    src/godown -v -f $SCRATCH_MNT >> $seqres.full
>  
>      _echofull "unmount"
> -    umount $SCRATCH_DEV >>$seq.full 2>&1 \
> +    umount $SCRATCH_DEV >>$seqres.full 2>&1 \
>  	|| _fail "umount failed"
>  
>      _echofull "logprint after going down..."
>      _print_logstate
>  
>      _full "logprint headers"
> -    _scratch_xfs_logprint -n >>$seq.full 2>&1
> +    _scratch_xfs_logprint -n >>$seqres.full 2>&1
>  
>      _echofull "mount with replay"
> -    _scratch_mount -o uquota >>$seq.full 2>&1 \
> +    _scratch_mount -o uquota >>$seqres.full 2>&1 \
>  	|| _fail "mount failed: $MOUNT_OPTIONS"
>  
>      # check on what FS looks like after log recovery
> diff --git a/tests/xfs/090 b/tests/xfs/090
> index 8ce50c0..8477329 100755
> --- a/tests/xfs/090
> +++ b/tests/xfs/090
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/092 b/tests/xfs/092
> index 2f849f3..e65fe27 100755
> --- a/tests/xfs/092
> +++ b/tests/xfs/092
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/094 b/tests/xfs/094
> index 4f4cf34..6aa2d74 100755
> --- a/tests/xfs/094
> +++ b/tests/xfs/094
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/095 b/tests/xfs/095
> index 9de4476..9a74d5f 100755
> --- a/tests/xfs/095
> +++ b/tests/xfs/095
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/096 b/tests/xfs/096
> index ecadd73..0fef425 100755
> --- a/tests/xfs/096
> +++ b/tests/xfs/096
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -63,7 +64,7 @@ _cleanup()
>  #
>  _mkfs_filter()
>  {
> -   tee -a $seq.full | \
> +   tee -a $seqres.full | \
>     sed \
>  	-e 's/extsz=[0-9][0-9]*[ ]*/extsz=N, /' \
>  	-e 's/blocks=[0-9][0-9]*/blocks=N/' \
> @@ -88,7 +89,7 @@ _mkfs_filter()
>  }
>  
>  # real QA test starts here
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  # Modify as appropriate.
>  _supported_fs xfs
> diff --git a/tests/xfs/103 b/tests/xfs/103
> index 9750153..753b14d 100755
> --- a/tests/xfs/103
> +++ b/tests/xfs/103
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/104 b/tests/xfs/104
> index 4e61837..0968daa 100755
> --- a/tests/xfs/104
> +++ b/tests/xfs/104
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -37,7 +38,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  _create_scratch()
>  {
>  	echo "*** mkfs"
> -	_scratch_mkfs_xfs $@ | tee -a $seq.full | _filter_mkfs 2>$tmp.mkfs
> +	_scratch_mkfs_xfs $@ | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
>  	. $tmp.mkfs
>  
>  	echo "*** mount"
> @@ -68,7 +69,7 @@ _stress_scratch()
>  # real QA test starts here
>  _supported_fs xfs
>  _require_scratch
> -_scratch_mkfs_xfs | tee -a $seq.full | _filter_mkfs 2>$tmp.mkfs
> +_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
>  . $tmp.mkfs	# extract blocksize and data size for scratch device
>  
>  endsize=`expr 550 \* 1048576`	# stop after growing this big
> @@ -93,19 +94,19 @@ _fill_scratch $fillsize
>  #
>  while [ $size -le $endsize ]; do
>  	echo "*** stressing a ${size} byte filesystem"
> -	echo "*** stressing a ${sizeb} block filesystem" >> $seq.full
> +	echo "*** stressing a ${sizeb} block filesystem" >> $seqres.full
>  	_stress_scratch
>  	sleep 1
>  	size=`expr $size + $incsize`
>  	sizeb=`expr $size / $dbsize`	# in data blocks
>  	echo "*** growing to a ${size} byte filesystem"
> -	echo "*** growing to a ${sizeb} block filesystem" >> $seq.full
> +	echo "*** growing to a ${sizeb} block filesystem" >> $seqres.full
>  	xfs_growfs -D ${sizeb} $SCRATCH_MNT \
> -		| tee -a $seq.full | _filter_mkfs 2>$tmp.growfs
> +		| tee -a $seqres.full | _filter_mkfs 2>$tmp.growfs
>  	. $tmp.growfs
>  	[ `expr $size % $modsize` -eq 0 ] && wait	# every 4th iteration
> -	echo AGCOUNT=$agcount | tee -a $seq.full
> -	echo && echo >> $seq.full
> +	echo AGCOUNT=$agcount | tee -a $seqres.full
> +	echo && echo >> $seqres.full
>  done
>  wait	# stop for any remaining stress processes
>  
> diff --git a/tests/xfs/106 b/tests/xfs/106
> index 613b12c..667115d 100755
> --- a/tests/xfs/106
> +++ b/tests/xfs/106
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -44,7 +45,7 @@ _require_xfs_quota
>  
>  # real QA test starts here
>  _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
> -cat $tmp.mkfs >$seq.full
> +cat $tmp.mkfs >$seqres.full
>  . $tmp.mkfs
>  
>  # setup a default run
> @@ -86,7 +87,7 @@ s/Inode: \#\d+ \(\d+ blocks, \d+ extents\)/Inode: #[INO] (X blocks, Y extents)/;
>  test_quot()
>  {
>  	echo "checking quot command (type=$type)"  # not deterministic on blks
> -	xfs_quota -x -c "quot -n -$type" $SCRATCH_MNT >>$seq.full 2>&1
> +	xfs_quota -x -c "quot -n -$type" $SCRATCH_MNT >>$seqres.full 2>&1
>  }
>  
>  test_report()
> diff --git a/tests/xfs/107 b/tests/xfs/107
> index e887384..7124dc2 100755
> --- a/tests/xfs/107
> +++ b/tests/xfs/107
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -56,7 +57,7 @@ _require_xfs_quota
>  
>  # real QA test starts here
>  _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
> -cat $tmp.mkfs >$seq.full
> +cat $tmp.mkfs >$seqres.full
>  . $tmp.mkfs
>  
>  # setup a default run
> @@ -72,7 +73,7 @@ _require_prjquota $SCRATCH_DEV
>  echo "### create projects file"
>  rm -f $tmp.projects
>  target=$SCRATCH_MNT/project
> -echo "6:$target" | tee -a $seq.full > $tmp.projects
> +echo "6:$target" | tee -a $seqres.full > $tmp.projects
>  
>  echo "### populate filesystem"
>  mkdir $target		|| exit
> diff --git a/tests/xfs/108 b/tests/xfs/108
> index 6b656e6..809659d 100755
> --- a/tests/xfs/108
> +++ b/tests/xfs/108
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -57,15 +58,15 @@ test_files()
>  test_accounting()
>  {
>  	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
> -	echo "--- initiating parallel IO..." >>$seq.full
> +	echo "--- initiating parallel IO..." >>$seqres.full
>  	$XFS_IO_PROG -c 'pwrite -b 1m 0 16m' -c 'fsync' \
> -					$SCRATCH_MNT/buffer >>$seq.full 2>&1 &
> +					$SCRATCH_MNT/buffer >>$seqres.full 2>&1 &
>  	$XFS_IO_PROG -c 'pwrite -b 1m 0 16m' -d \
> -					$SCRATCH_MNT/direct >>$seq.full 2>&1 &
> +					$SCRATCH_MNT/direct >>$seqres.full 2>&1 &
>  	$XFS_IO_PROG -c 't 16m' -c 'mm -rw 0 16m' -c 'mw 0 16m' -c 'ms -s' \
> -					$SCRATCH_MNT/mmap   >>$seq.full 2>&1 &
> +					$SCRATCH_MNT/mmap   >>$seqres.full 2>&1 &
>  	wait
> -	echo "--- completed parallel IO ($type)" >>$seq.full
> +	echo "--- completed parallel IO ($type)" >>$seqres.full
>  
>  	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
>  		$here/src/lstat64 $file | head -3 | _filter_scratch
> @@ -80,10 +81,10 @@ _qmount
>  _require_prjquota $SCRATCH_DEV
>  
>  # real QA test starts here
> -rm -f $tmp.projects $seq.full
> +rm -f $tmp.projects $seqres.full
>  umount $SCRATCH_DEV 2>/dev/null
>  _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
> -cat $tmp.mkfs >>$seq.full
> +cat $tmp.mkfs >>$seqres.full
>  _scratch_mount
>  
>  uid=1
> diff --git a/tests/xfs/109 b/tests/xfs/109
> index 56364f4..2e36d0f 100755
> --- a/tests/xfs/109
> +++ b/tests/xfs/109
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -102,7 +103,7 @@ fi
>  umount $SCRATCH_DEV
>  
>  _scratch_mkfs_xfs -dsize=160m,agcount=4 $faststart | _filter_mkfs 2>$tmp.mkfs
> -cat $tmp.mkfs >>$seq.full
> +cat $tmp.mkfs >>$seqres.full
>  _scratch_mount
>  
>  populate
> diff --git a/tests/xfs/110 b/tests/xfs/110
> index 8749afa..a2790c8 100755
> --- a/tests/xfs/110
> +++ b/tests/xfs/110
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/111 b/tests/xfs/111
> index 8f4c142..af7cd65 100755
> --- a/tests/xfs/111
> +++ b/tests/xfs/111
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/114 b/tests/xfs/114
> index fa64093..5228eca 100755
> --- a/tests/xfs/114
> +++ b/tests/xfs/114
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -79,8 +80,8 @@ _test_create()
>  	p=dir2/dir3/dir4/file4
>  	touch $p
>  
> -	#_print_names $p >>$here/$seq.full
> -	_print_names $p | tee -a $here/$seq.full
> +	#_print_names $p >>$here/$seqres.full
> +	_print_names $p | tee -a $here/$seqres.full
>  
>  	_check_paths $SCRATCH_MNT/$p
>  }
> @@ -130,13 +131,13 @@ _test_hardlink()
>  		ln $p $x
>  	done
>  
> -	_print_names $p >>$here/$seq.full
> +	_print_names $p >>$here/$seqres.full
>  
>  	echo ""
>  	echo "print out names and check after created hardlinks"
>  	echo ""
>  	for x in $paths; do
> -		_print_names $x | tee -a $here/$seq.full
> +		_print_names $x | tee -a $here/$seqres.full
>  		_check_paths $SCRATCH_MNT/$x
>  	done
>  
> @@ -160,7 +161,7 @@ _test_hardlink()
>  	echo ""
>  	for x in $paths; do
>  		if [ -e $x ]; then 
> -			_print_names $x | tee -a $here/$seq.full
> +			_print_names $x | tee -a $here/$seqres.full
>  			_check_paths $SCRATCH_MNT/$x
>  		fi
>  	done
> @@ -229,7 +230,7 @@ _test_rename()
>  
>  _filter_num()
>  {
> -	tee -a $here/$seq.full |\
> +	tee -a $here/$seqres.full |\
>  	sed -e 's/[0-9][0-9]* inodes/I inodes/g' \
>  	    -e 's/[0-9][0-9]* paths/P paths/g' \
>  	    -e 's/seed = [0-9][0-9]*/seed = S/'
> @@ -254,7 +255,7 @@ _test_fsstress()
>  	if ! $FSSTRESS_PROG $args | _filter_num
>  	then
>  		echo "    fsstress $args returned $?"
> -		cat $tmp.out | tee -a $here/$seq.full
> +		cat $tmp.out | tee -a $here/$seqres.full
>  		status=1
>  	fi
>  
> @@ -283,8 +284,8 @@ _test_dirstress()
>  	if ! $here/src/dirstress $args >$tmp.out 2>&1 | _filter_num
>  	then
>  		echo "    dirstress failed"
> -		echo "*** dirstress $args" | tee -a $here/$seq.full
> -		cat $tmp.out >>$here/$seq.full
> +		echo "*** dirstress $args" | tee -a $here/$seqres.full
> +		cat $tmp.out >>$here/$seqres.full
>  		status=1
>  		exit
>  	fi
> @@ -294,8 +295,8 @@ _test_dirstress()
>  	if ! $here/src/dirstress $args >$tmp.out 2>&1 | _filter_num
>  	then
>  		echo "    dirstress failed"
> -		echo "*** dirstress $args" | tee -a $here/$seq.full
> -		cat $tmp.out >>$here/$seq.full
> +		echo "*** dirstress $args" | tee -a $here/$seqres.full
> +		cat $tmp.out >>$here/$seqres.full
>  		status=1
>  		exit
>  	fi
> @@ -315,16 +316,16 @@ _require_scratch
>  _require_attrs
>  _need_to_be_root
>  
> -rm -f $here/$seq.full
> +rm -f $here/$seqres.full
>  
>  echo "mkfs"
> -_scratch_mkfs_xfs >>$here/$seq.full 2>&1 \
> +_scratch_mkfs_xfs >>$here/$seqres.full 2>&1 \
>      || _fail "mkfs scratch failed"
> -_scratch_mkfs_xfs -i parent=1 >>$here/$seq.full 2>&1 \
> +_scratch_mkfs_xfs -i parent=1 >>$here/$seqres.full 2>&1 \
>      || _notrun "parent inodes not supported"
>  
>  echo "mount"
> -_scratch_mount >>$here/$seq.full 2>&1 \
> +_scratch_mount >>$here/$seqres.full 2>&1 \
>      || _fail "mount failed: $MOUNT_OPTIONS"
>  
>  # real QA test starts here
> diff --git a/tests/xfs/115 b/tests/xfs/115
> index ebcc995..aa281d6 100755
> --- a/tests/xfs/115
> +++ b/tests/xfs/115
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -101,16 +102,16 @@ _supported_os IRIX
>  _require_scratch
>  _require_attrs
>  
> -rm -f $here/$seq.full
> +rm -f $here/$seqres.full
>  
>  echo "mkfs"
> -_scratch_mkfs_xfs >>$here/$seq.full 2>&1 \
> +_scratch_mkfs_xfs >>$here/$seqres.full 2>&1 \
>      || _fail "mkfs scratch failed"
> -_scratch_mkfs_xfs -i paths=1 >>$here/$seq.full 2>&1 \
> +_scratch_mkfs_xfs -i paths=1 >>$here/$seqres.full 2>&1 \
>      || _notrun "i_paths not supported"
>  
>  echo "mount"
> -_scratch_mount >>$here/$seq.full 2>&1 \
> +_scratch_mount >>$here/$seqres.full 2>&1 \
>      || _fail "mount failed: $MOUNT_OPTIONS"
>  
>  # real QA test starts here
> @@ -251,7 +252,7 @@ _do_test()
>  	xfs_repair_ipaths -n $SCRATCH_MNT
>  }
>  
> -_do_test 2>&1 | tee $seq.full | _filter_inodes
> +_do_test 2>&1 | tee $seqres.full | _filter_inodes
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/116 b/tests/xfs/116
> index 2c3ab92..4554d20 100755
> --- a/tests/xfs/116
> +++ b/tests/xfs/116
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/118 b/tests/xfs/118
> index d140a8b..e4ce711 100755
> --- a/tests/xfs/118
> +++ b/tests/xfs/118
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -72,7 +73,7 @@ _chowning_file()
>  
> 
>  echo "mkfs on scratch"
> -_scratch_mkfs_xfs >$seq.full
> +_scratch_mkfs_xfs >$seqres.full
>  
>  echo "mount with quotas"
>  export MOUNT_OPTIONS="-o uquota"
> diff --git a/tests/xfs/119 b/tests/xfs/119
> index 85af211..066ddbd 100755
> --- a/tests/xfs/119
> +++ b/tests/xfs/119
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/121 b/tests/xfs/121
> index a590bb0..f6dc83a 100755
> --- a/tests/xfs/121
> +++ b/tests/xfs/121
> @@ -27,6 +27,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -43,17 +44,17 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  _supported_fs xfs
>  _supported_os IRIX Linux
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  rm -f $tmp.log
>  
>  _require_scratch
>  
>  echo "mkfs"
> -_scratch_mkfs_xfs >>$seq.full 2>&1 \
> +_scratch_mkfs_xfs >>$seqres.full 2>&1 \
>      || _fail "mkfs scratch failed"
>  
>  echo "mount"
> -_scratch_mount >>$seq.full 2>&1 \
> +_scratch_mount >>$seqres.full 2>&1 \
>      || _fail "mount failed: $MOUNT_OPTIONS"
>  
>  # num_files must be greater than 64 (XFS_AGI_UNLINKED_BUCKETS)
> @@ -68,7 +69,7 @@ src/multi_open_unlink -f $SCRATCH_MNT/test_file -n $num_files -s $delay &
>  sleep 3
>  
>  echo "godown"
> -src/godown -v -f $SCRATCH_MNT >> $seq.full
> +src/godown -v -f $SCRATCH_MNT >> $seqres.full
>  
>  # time for multi_open_unlink to exit out after its delay
>  # so we have no references and can unmount
> @@ -81,11 +82,11 @@ echo "logprint after going down..."
>  _print_logstate
>  
>  echo "mount with replay"
> -_scratch_mount $mnt >>$seq.full 2>&1 \
> +_scratch_mount $mnt >>$seqres.full 2>&1 \
>      || _fail "mount failed: $mnt $MOUNT_OPTIONS"
>  
>  echo "godown"
> -src/godown -v -f $SCRATCH_MNT >> $seq.full
> +src/godown -v -f $SCRATCH_MNT >> $seqres.full
>  
>  echo "unmount"
>  umount $SCRATCH_MNT
> @@ -94,7 +95,7 @@ echo "logprint after going down..."
>  _print_logstate
>  
>  echo "logprint to check for CLEAR_AGI_BUCKET..."
> -if _scratch_xfs_logprint -t | tee -a $seq.full | grep CLEAR; then
> +if _scratch_xfs_logprint -t | tee -a $seqres.full | grep CLEAR; then
>  	echo 'CLEAR_AGI_BUCKET transactions found!!'
>  	echo 'Are you running with an old xfs kernel - where the bug still exists?'
>  else
> @@ -102,7 +103,7 @@ else
>  fi
>  
>  # clean up dirty log with log recovery on mount
> -_scratch_mount >> $seq.full 2>&1 \
> +_scratch_mount >> $seqres.full 2>&1 \
>      || _fail "mount failed"
>  
>  # should now be peaches
> diff --git a/tests/xfs/122 b/tests/xfs/122
> index 1c4f3a4..2a81728 100755
> --- a/tests/xfs/122
> +++ b/tests/xfs/122
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -176,7 +177,7 @@ echo 'int main(int argc, char *argv[]) {' >>$cprog
>  #
>  cat /usr/include/xfs/xfs*.h | indent |\
>  _attribute_filter |\
> -tee $seq.full |\
> +tee $seqres.full |\
>  egrep '} *xfs_.*_t' |\
>  egrep -v -f $tmp.ignore |\
>  awk '{sub(/[;,]/,"",$2); print "printf(\"sizeof(", $2, ") = %d\\n\", sizeof(", $2, "));"}' \
> @@ -198,8 +199,8 @@ awk '
>  echo 'return 0; }' >>$cprog
>  
>  # create and run program
> -cc -o $oprog $cprog >> $seq.full 2>&1 || \
> -  _notrun "Could not compile test program (see end of $seq.full)"
> +cc -o $oprog $cprog >> $seqres.full 2>&1 || \
> +  _notrun "Could not compile test program (see end of $seqres.full)"
>  $oprog | _type_size_filter | _type_name_filter > $progout
>  
>  #
> diff --git a/tests/xfs/134 b/tests/xfs/134
> index 2117b4a..f38fc6e 100755
> --- a/tests/xfs/134
> +++ b/tests/xfs/134
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -60,8 +61,8 @@ cat >$tmp.projid <<EOF
>  test:1
>  EOF
>  
> -cp /dev/null $seq.full
> -chmod a+rwx $seq.full	# arbitrary users will write here
> +cp /dev/null $seqres.full
> +chmod a+rwx $seqres.full	# arbitrary users will write here
>  
>  _require_scratch
>  _scratch_mkfs_xfs >/dev/null 2>&1
> diff --git a/tests/xfs/136 b/tests/xfs/136
> index 6479c8c..ec3f71a 100755
> --- a/tests/xfs/136
> +++ b/tests/xfs/136
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/137 b/tests/xfs/137
> index 0f65d08..5c0fc51 100755
> --- a/tests/xfs/137
> +++ b/tests/xfs/137
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/138 b/tests/xfs/138
> index f8af8dd..a0aeb82 100755
> --- a/tests/xfs/138
> +++ b/tests/xfs/138
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/139 b/tests/xfs/139
> index 7d2e409..9de1fca 100755
> --- a/tests/xfs/139
> +++ b/tests/xfs/139
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/140 b/tests/xfs/140
> index a8cbd09..8564b28 100755
> --- a/tests/xfs/140
> +++ b/tests/xfs/140
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/142 b/tests/xfs/142
> index 526167d..e09ae3f 100755
> --- a/tests/xfs/142
> +++ b/tests/xfs/142
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/143 b/tests/xfs/143
> index 63281f9..686be64 100755
> --- a/tests/xfs/143
> +++ b/tests/xfs/143
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/144 b/tests/xfs/144
> index 52123cc..cf5eca7 100755
> --- a/tests/xfs/144
> +++ b/tests/xfs/144
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/145 b/tests/xfs/145
> index 54b8198..2a4b2f6 100755
> --- a/tests/xfs/145
> +++ b/tests/xfs/145
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/146 b/tests/xfs/146
> index bb4975c..2091db1 100755
> --- a/tests/xfs/146
> +++ b/tests/xfs/146
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/147 b/tests/xfs/147
> index e366dc7..c65dde9 100755
> --- a/tests/xfs/147
> +++ b/tests/xfs/147
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/148 b/tests/xfs/148
> index abc516a..49892ab 100755
> --- a/tests/xfs/148
> +++ b/tests/xfs/148
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/149 b/tests/xfs/149
> index b1793b7..d345f4a 100755
> --- a/tests/xfs/149
> +++ b/tests/xfs/149
> @@ -24,13 +24,14 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
>  status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  # get standard environment, filters and checks
>  . ./common.rc
> @@ -44,15 +45,15 @@ export XFS_REPAIR_PROG=$XFS_PARALLEL_REPAIR_PROG
>  
>  _check_repair()
>  {
> -	echo "Repairing, round 0" >> $seq.full
> -	_scratch_xfs_repair 2>&1 | _filter_repair | tee -a $seq.full >$tmp.0
> +	echo "Repairing, round 0" >> $seqres.full
> +	_scratch_xfs_repair 2>&1 | _filter_repair | tee -a $seqres.full >$tmp.0
>  	for i in 1 2 3 4
>  	do
> -		echo "Repairing, iteration $i" | tee -a $seq.full
> +		echo "Repairing, iteration $i" | tee -a $seqres.full
>  		_scratch_xfs_repair 2>&1 | _filter_repair >$tmp.$i
> -		diff $tmp.0 $tmp.$i >> $seq.full
> +		diff $tmp.0 $tmp.$i >> $seqres.full
>  		if [ $? -ne 0 ]; then
> -			echo "ERROR: repair round $i differs to round 0 (see $seq.full)" | tee -a $seq.full
> +			echo "ERROR: repair round $i differs to round 0 (see $seqres.full)" | tee -a $seqres.full
>  			break
>  		fi
>  		# echo all interesting stuff...
> diff --git a/tests/xfs/150 b/tests/xfs/150
> index b6a04c5..529b6b4 100755
> --- a/tests/xfs/150
> +++ b/tests/xfs/150
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/151 b/tests/xfs/151
> index 4bfaff3..9de8ab4 100755
> --- a/tests/xfs/151
> +++ b/tests/xfs/151
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -55,7 +56,7 @@ _check_sids()
>  			| perl -ne "if (/^sids.*[\"|\s]($i)[\"|\s].*/) {print \$1} ;"`
>  		if [ -z "$CHECKED_SID" ] ; then
>  			echo "ERROR: SID(s) not created"
> -			${DMAPI_QASUITE1_DIR}../simple/dm_getall_sessions >>$seq.full
> +			${DMAPI_QASUITE1_DIR}../simple/dm_getall_sessions >>$seqres.full
>  			return
>  		fi
>  	done
> diff --git a/tests/xfs/152 b/tests/xfs/152
> index 2317291..4b9d471 100755
> --- a/tests/xfs/152
> +++ b/tests/xfs/152
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/153 b/tests/xfs/153
> index 81be175..86df036 100755
> --- a/tests/xfs/153
> +++ b/tests/xfs/153
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/154 b/tests/xfs/154
> index 62e79c2..528ec9c 100755
> --- a/tests/xfs/154
> +++ b/tests/xfs/154
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/155 b/tests/xfs/155
> index 949bd98..1c4ea6c 100755
> --- a/tests/xfs/155
> +++ b/tests/xfs/155
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/156 b/tests/xfs/156
> index 549cac8..0a73b6b 100755
> --- a/tests/xfs/156
> +++ b/tests/xfs/156
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -48,8 +49,8 @@ _require_scratch
>  _scratch_mkfs_xfs >/dev/null 2>&1
>  _dmapi_scratch_mount
>  
> -${DMAPI_QASUITE1_DIR}cmd/get_dirattrs $SCRATCH_MNT > $seq.full
> -[ $? -ne 0 ] && echo "get_dirattrs failed - see $seq.full"
> +${DMAPI_QASUITE1_DIR}cmd/get_dirattrs $SCRATCH_MNT > $seqres.full
> +[ $? -ne 0 ] && echo "get_dirattrs failed - see $seqres.full"
>  
>  status=0
>  exit 
> diff --git a/tests/xfs/157 b/tests/xfs/157
> index 9ae3c40..91819ef 100755
> --- a/tests/xfs/157
> +++ b/tests/xfs/157
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/158 b/tests/xfs/158
> index e740654..ef8d4d1 100755
> --- a/tests/xfs/158
> +++ b/tests/xfs/158
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/159 b/tests/xfs/159
> index bfc225d..8f80482 100755
> --- a/tests/xfs/159
> +++ b/tests/xfs/159
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/160 b/tests/xfs/160
> index 3900299..2323697 100755
> --- a/tests/xfs/160
> +++ b/tests/xfs/160
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/161 b/tests/xfs/161
> index c419380..45210c7 100755
> --- a/tests/xfs/161
> +++ b/tests/xfs/161
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/162 b/tests/xfs/162
> index acd70e0..67aec9a 100755
> --- a/tests/xfs/162
> +++ b/tests/xfs/162
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/163 b/tests/xfs/163
> index d4eef64..434f100 100755
> --- a/tests/xfs/163
> +++ b/tests/xfs/163
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/164 b/tests/xfs/164
> index 1ef4aaf..8af0b0d 100755
> --- a/tests/xfs/164
> +++ b/tests/xfs/164
> @@ -29,6 +29,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -44,7 +45,7 @@ _cleanup()
>  
>  _filter_io()
>  {
> -    tee -a $seq.full | sed 's/ops;.*/ops/'
> +    tee -a $seqres.full | sed 's/ops;.*/ops/'
>  }
>  
>  #
> @@ -55,7 +56,7 @@ _filter_bmap()
>  {
>      awk '$3 ~ /hole/ { print $1, $2, $3; next }
>           $7 ~ /10000/ { print $1, $2, "unwritten"; next }
> -         {print $1, $2}' >> $seq.full
> +         {print $1, $2}' >> $seqres.full
>  }
>  
> 
> diff --git a/tests/xfs/165 b/tests/xfs/165
> index 3b321b9..72376f3 100755
> --- a/tests/xfs/165
> +++ b/tests/xfs/165
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -41,7 +42,7 @@ _cleanup()
>  
>  _filter_io()
>  {
> -    tee -a $seq.full | _filter_xfs_io
> +    tee -a $seqres.full | _filter_xfs_io
>  }
>  
>  #
> @@ -52,7 +53,7 @@ _filter_io()
>  _filter_bmap()
>  {
>      awk '$3 ~ /hole/ { print $1, $2, $3; next }
> -         {print $1, $2}' >> $seq.full
> +         {print $1, $2}' >> $seqres.full
>  }
>  
>  # get standard environment, filters and checks
> @@ -68,7 +69,7 @@ _supported_os IRIX Linux
>  # io tests 
>  testfile=$TEST_DIR/file.$seq
>  rm -f $testfile
> -rm -f $seq.full
> +rm -f $seqres.full
>  len=4
>  end=`expr 10 \* $len`
>  
> diff --git a/tests/xfs/166 b/tests/xfs/166
> index 527686f..3170fa6 100755
> --- a/tests/xfs/166
> +++ b/tests/xfs/166
> @@ -23,13 +23,14 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
>  status=1    # failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  _cleanup()
>  {
> @@ -91,7 +92,7 @@ FILE_SIZE=1048576
>  rm -f $TEST_FILE
>  $TEST_PROG $FILE_SIZE $TEST_FILE
>  
> -xfs_bmap -vp $TEST_FILE >> $seq.full
> +xfs_bmap -vp $TEST_FILE >> $seqres.full
>  xfs_bmap -vp $TEST_FILE | _filter_blocks
>  
>  status=0
> diff --git a/tests/xfs/167 b/tests/xfs/167
> index c2e15e8..84bbe09 100755
> --- a/tests/xfs/167
> +++ b/tests/xfs/167
> @@ -23,11 +23,12 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=1    # failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> @@ -43,7 +44,7 @@ workout()
>  	procs=100
>  	nops=15000
>  	$FSSTRESS_PROG -d $SCRATCH_MNT -p $procs -n $nops $FSSTRESS_AVOID \
> -		>>$seq.full &
> +		>>$seqres.full &
>  	sleep 2
>  }
>  
> diff --git a/tests/xfs/168 b/tests/xfs/168
> index 8980f9b..67f1e19 100755
> --- a/tests/xfs/168
> +++ b/tests/xfs/168
> @@ -24,11 +24,12 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=1    # failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> @@ -106,7 +107,7 @@ wait
>  # dmapi destroy events are asyncronous,  don't rely on fixed ordering of events
>  # in print_event output, use sort.
>  echo "# here comes the dmapi print_event filtered and sorted output"
> -cat $tmp.print_event_out | tee -a $here/$seq.full | _filter_dmapi_print_event | LC_COLLATE=POSIX sort
> +cat $tmp.print_event_out | tee -a $here/$seqres.full | _filter_dmapi_print_event | LC_COLLATE=POSIX sort
>  rm $tmp.print_event_out
>  
>  status=0
> diff --git a/tests/xfs/170 b/tests/xfs/170
> index b725d3a..f470946 100755
> --- a/tests/xfs/170
> +++ b/tests/xfs/170
> @@ -25,11 +25,12 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=1    # failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> diff --git a/tests/xfs/171 b/tests/xfs/171
> index 4f77a41..af7a216 100755
> --- a/tests/xfs/171
> +++ b/tests/xfs/171
> @@ -24,11 +24,12 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=1    # failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> diff --git a/tests/xfs/172 b/tests/xfs/172
> index b6b496c..50eda81 100755
> --- a/tests/xfs/172
> +++ b/tests/xfs/172
> @@ -24,11 +24,12 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=1    # failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> diff --git a/tests/xfs/173 b/tests/xfs/173
> index 7146d2f..6761a8a 100755
> --- a/tests/xfs/173
> +++ b/tests/xfs/173
> @@ -24,11 +24,12 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=1    # failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> diff --git a/tests/xfs/174 b/tests/xfs/174
> index 7745a6a..ffb6754 100755
> --- a/tests/xfs/174
> +++ b/tests/xfs/174
> @@ -24,11 +24,12 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=1    # failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> diff --git a/tests/xfs/175 b/tests/xfs/175
> index 4fc3ffb..4753f21 100755
> --- a/tests/xfs/175
> +++ b/tests/xfs/175
> @@ -26,11 +26,12 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=1    # failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> diff --git a/tests/xfs/176 b/tests/xfs/176
> index 93083c4..3fe9f04 100755
> --- a/tests/xfs/176
> +++ b/tests/xfs/176
> @@ -23,11 +23,12 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=1    # failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> diff --git a/tests/xfs/177 b/tests/xfs/177
> index ec8aca7..49ca282 100755
> --- a/tests/xfs/177
> +++ b/tests/xfs/177
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/178 b/tests/xfs/178
> index 8856656..084aeb9 100755
> --- a/tests/xfs/178
> +++ b/tests/xfs/178
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/179 b/tests/xfs/179
> index f3facca..451d7cc 100755
> --- a/tests/xfs/179
> +++ b/tests/xfs/179
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/180 b/tests/xfs/180
> index 0f82306..15e0221 100755
> --- a/tests/xfs/180
> +++ b/tests/xfs/180
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/181 b/tests/xfs/181
> index fb65100..35e808f 100755
> --- a/tests/xfs/181
> +++ b/tests/xfs/181
> @@ -27,6 +27,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  _cleanup()
> @@ -50,17 +51,17 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  _supported_fs xfs
>  _supported_os IRIX Linux
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  rm -f $tmp.log
>  
>  _require_scratch
>  
>  echo "mkfs"
> -_scratch_mkfs_xfs >>$seq.full 2>&1 \
> +_scratch_mkfs_xfs >>$seqres.full 2>&1 \
>      || _fail "mkfs scratch failed"
>  
>  echo "mount"
> -_scratch_mount >>$seq.full 2>&1 \
> +_scratch_mount >>$seqres.full 2>&1 \
>      || _fail "mount failed: $MOUNT_OPTIONS"
>  
>  # num_files must be greater than 64 (XFS_AGI_UNLINKED_BUCKETS)
> @@ -81,7 +82,7 @@ pid=$!
>  sleep 10
>  
>  echo "godown"
> -src/godown -v -f $SCRATCH_MNT >> $seq.full
> +src/godown -v -f $SCRATCH_MNT >> $seqres.full
>  
>  # kill the multi_open_unlink
>  kill $pid 2>/dev/null
> @@ -95,11 +96,11 @@ echo "logprint after going down..."
>  _print_logstate
>  
>  echo "mount with replay"
> -_scratch_mount $mnt >>$seq.full 2>&1 \
> +_scratch_mount $mnt >>$seqres.full 2>&1 \
>      || _fail "mount failed: $mnt $MOUNT_OPTIONS"
>  
>  echo "godown"
> -src/godown -v -f $SCRATCH_MNT >> $seq.full
> +src/godown -v -f $SCRATCH_MNT >> $seqres.full
>  
>  echo "unmount"
>  umount $SCRATCH_MNT
> @@ -108,7 +109,7 @@ echo "logprint after going down..."
>  _print_logstate
>  
>  echo "logprint to check for CLEAR_AGI_BUCKET..."
> -if _scratch_xfs_logprint -t | tee -a $seq.full | grep CLEAR; then
> +if _scratch_xfs_logprint -t | tee -a $seqres.full | grep CLEAR; then
>  	echo 'CLEAR_AGI_BUCKET transactions found!!'
>  	echo 'Are you running with an old xfs kernel - where the bug still exists?'
>  else
> @@ -116,7 +117,7 @@ else
>  fi
>  
>  # clean up dirty log with log recovery on mount
> -_scratch_mount >> $seq.full 2>&1 \
> +_scratch_mount >> $seqres.full 2>&1 \
>      || _fail "mount failed"
>  
>  # should now be peaches
> diff --git a/tests/xfs/182 b/tests/xfs/182
> index 33e8010..7495eb1 100755
> --- a/tests/xfs/182
> +++ b/tests/xfs/182
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/183 b/tests/xfs/183
> index 4624ab4..5a7587f 100755
> --- a/tests/xfs/183
> +++ b/tests/xfs/183
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/185 b/tests/xfs/185
> index 928eb24..f00858b 100755
> --- a/tests/xfs/185
> +++ b/tests/xfs/185
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/186 b/tests/xfs/186
> index 2c66026..46cd087 100755
> --- a/tests/xfs/186
> +++ b/tests/xfs/186
> @@ -34,6 +34,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -77,7 +78,7 @@ _rmv_eas()
>  
>  _filter_inode()
>  {
> -	tee -a $here/$seq.full | \
> +	tee -a $here/$seqres.full | \
>  		sed -e "s/core.forkoff/forkoff/g" | \
>  		egrep '^u.sfdir2|^a.sfattr|forkoff' | \
>  		egrep -v 'inumber|parent'
> @@ -85,7 +86,7 @@ _filter_inode()
>  
>  _filter_version()
>  {
> -	tee -a $here/$seq.full | tr ',' '\n' | grep ATTR
> +	tee -a $here/$seqres.full | tr ',' '\n' | grep ATTR
>  }
>  
>  _print_inode()
> @@ -148,7 +149,7 @@ _supported_os Linux
>  _require_scratch
>  _require_attrs
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  _scratch_mkfs -i attr=2,size=512 -l lazy-count=1 >/dev/null 2>&1
>  
> diff --git a/tests/xfs/187 b/tests/xfs/187
> index bff0caa..c414017 100755
> --- a/tests/xfs/187
> +++ b/tests/xfs/187
> @@ -28,6 +28,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -43,7 +44,7 @@ _cleanup()
>  
>  _filter_version()
>  {
> -	tee -a $seq.full | tr ',' '\n' | egrep 'ATTR|MORE|LAZY'
> +	tee -a $seqres.full | tr ',' '\n' | egrep 'ATTR|MORE|LAZY'
>  }
>  
>  # get standard environment, filters and checks
> @@ -58,7 +59,7 @@ _supported_os Linux
>  _require_scratch
>  _require_attrs
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  # lazysb and attr2 are in features2 and will require morebitsbit on
>  # So test with lazysb and without it to see if the morebitsbit is
> diff --git a/tests/xfs/188 b/tests/xfs/188
> index 4ebbfc1..a8fe431 100755
> --- a/tests/xfs/188
> +++ b/tests/xfs/188
> @@ -30,6 +30,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -57,7 +58,7 @@ if [ $XFSPROGS_VERSION -lt 21000 ]; then
>  fi
>  
>  _require_scratch
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  _scratch_mkfs -n version=ci >/dev/null 2>&1
>  _scratch_mount
> diff --git a/tests/xfs/189 b/tests/xfs/189
> index a5a5682..24cc29e 100755
> --- a/tests/xfs/189
> +++ b/tests/xfs/189
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -220,5 +221,5 @@ _test_remount_barrier
>  
>  # success, all done
>  echo "*** done"
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=0
> diff --git a/tests/xfs/190 b/tests/xfs/190
> index 5bb4743..c760ee6 100755
> --- a/tests/xfs/190
> +++ b/tests/xfs/190
> @@ -35,12 +35,13 @@ filesize=10
>  filename=test-190
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
>  status=0    # success is the default!
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  # get standard environment, filters and checks
>  . ./common.rc
> @@ -55,20 +56,20 @@ _scratch_mkfs_xfs >/dev/null 2>&1
>  _scratch_mount
>  fsblocksize=`xfs_info $SCRATCH_MNT|sed 's/=/ /g'|awk '/^data / { print $3 }'`
>  
> -dd if=/dev/zero of=$SCRATCH_MNT/$filename bs=1024k count=10 >> $seq.full 2>&1
> +dd if=/dev/zero of=$SCRATCH_MNT/$filename bs=1024k count=10 >> $seqres.full 2>&1
>  
>  # run DMAPI test using verbose output
>  echo Punching holes in file
> -echo Punching holes in file >> $seq.full
> +echo Punching holes in file >> $seqres.full
>  for i in $holes ; do
> -	echo xfs_io -c "unresvsp `echo $i |$SED_PROG 's/:/ /g'`" $SCRATCH_MNT/$filename >> $seq.full
> +	echo xfs_io -c "unresvsp `echo $i |$SED_PROG 's/:/ /g'`" $SCRATCH_MNT/$filename >> $seqres.full
>  	xfs_io -c "unresvsp `echo $i |$SED_PROG 's/:/ /g'`" $SCRATCH_MNT/$filename ;
>  done
>  
>  echo Verifying holes are in the correct spots:
>  
>  xfs_bmap=`xfs_bmap $SCRATCH_MNT/$filename`
> -xfs_bmap $SCRATCH_MNT/$filename >> $seq.full
> +xfs_bmap $SCRATCH_MNT/$filename >> $seqres.full
>  for i in $holes ; do
>  	holeStart=$[`echo $i|$SED_PROG 's/:/ /g'|awk '{print $1}'`];
>  	holeEnd=$[`echo $i|$SED_PROG 's/:/ /g'|awk '{print $2}'`];
> @@ -83,7 +84,7 @@ for i in $holes ; do
>  	#xfs_bmap prints holes in the following format
>  	#                1: [8..15]: hole
>  	bmap="\[$[$holeStart/512]..$[($holeEnd/512) -1]\]";
> -	echo $bmap >> $seq.full
> +	echo $bmap >> $seqres.full
>  	if [ $holeEnd == $holeStart ] ; then
>  		continue #there is no hole
>  	fi
> diff --git a/tests/xfs/191 b/tests/xfs/191
> index 3120dcb..d3b227c 100755
> --- a/tests/xfs/191
> +++ b/tests/xfs/191
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -41,7 +42,7 @@ _supported_fs xfs
>  _supported_os Linux
>  
>  _require_scratch
> -_scratch_mkfs_xfs -i nfs4acl 1>$tmp.mkfs 2>$seq.full
> +_scratch_mkfs_xfs -i nfs4acl 1>$tmp.mkfs 2>$seqres.full
>  if [ $? -ne 0 ]
>  then
>  	_notrun "no mkfs support for NFS v4 ACLs"
> @@ -53,7 +54,7 @@ then
>  	_notrun "no kernel mount support for NFS v4 ACLs"
>  fi
>  
> -set_prog_path nfs4acl >>$seq.full
> +set_prog_path nfs4acl >>$seqres.full
>  if [ $? -ne 0 ]
>  then
>  	_notrun "no nfs4acl utility found"
> diff --git a/tests/xfs/194 b/tests/xfs/194
> index 595da25..4609a17 100755
> --- a/tests/xfs/194
> +++ b/tests/xfs/194
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -44,7 +45,7 @@ _supported_fs xfs
>  _supported_os IRIX Linux
>  
>  # real QA test starts here
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  # For this test we use block size = 1/8 page size
>  pgsize=`$here/src/feature -s`
> @@ -63,7 +64,7 @@ blksize=`expr $pgsize / 8`
>  
>  _filter_bmap()
>  {
> -    tee -a $seq.full | \
> +    tee -a $seqres.full | \
>      sed "s#$SCRATCH_MNT#SCRATCH_MNT#g" | \
>      awk \
>          '$3 ~ /hole/     { print $1 "\t" $3 "\t" ($4 * 512) / blksize; next }
> @@ -75,7 +76,7 @@ _filter_bmap()
>  # Filter out offsets, which vary by blocksize
>  _filter_od()
>  {
> -    tee -a $seq.full | \
> +    tee -a $seqres.full | \
>      sed -e "s/^[0-9A-Fa-f ]\{7,8\}//"
>  }
>  
> @@ -118,12 +119,12 @@ xfs_io \
>  -c "pwrite -S 0x11 -b `expr $pgsize / 2`  0 `expr $pgsize / 2`" \
>  -c "truncate `expr $blksize / 2`" \
>  -c "truncate $pgsize" \
> --t -f $SCRATCH_MNT/testfile1 >> $seq.full
> +-t -f $SCRATCH_MNT/testfile1 >> $seqres.full
>  
>  # directio read of entire file
>  xfs_io \
>  -c "pread 0 $pgsize" \
> --d $SCRATCH_MNT/testfile1 >> $seq.full
> +-d $SCRATCH_MNT/testfile1 >> $seqres.full
>  
>  xfs_bmap -v $SCRATCH_MNT/testfile1 | _filter_bmap
>  od -x $SCRATCH_MNT/testfile1 | _filter_od
> @@ -137,12 +138,12 @@ xfs_io \
>  -c "truncate `expr $blksize / 2`" \
>  -c "truncate $pgsize" \
>  -c "pwrite -S 0x22 -b $blksize `expr $blksize \* 4` $blksize" \
> --t -f $SCRATCH_MNT/testfile2 >> $seq.full
> +-t -f $SCRATCH_MNT/testfile2 >> $seqres.full
>  
>  # directio read of entire file
>  xfs_io \
>  -c "pread 0 $pgsize" \
> --d $SCRATCH_MNT/testfile2 >> $seq.full
> +-d $SCRATCH_MNT/testfile2 >> $seqres.full
>  
>  xfs_bmap -v $SCRATCH_MNT/testfile2 | _filter_bmap
>  od -x $SCRATCH_MNT/testfile2 | _filter_od
> @@ -187,7 +188,7 @@ xfs_io \
>  -c "truncate `expr $blksize / 2`" \
>  -c "truncate `expr $blksize + 1`" \
>  -c "pwrite -S 0x22 -b $blksize `expr $pgsize / 2` $blksize" \
> --t -d -f $SCRATCH_MNT/testfile3 >> $seq.full
> +-t -d -f $SCRATCH_MNT/testfile3 >> $seqres.full
>  
>  xfs_bmap -v $SCRATCH_MNT/testfile3 | _filter_bmap
>  od -x $SCRATCH_MNT/testfile3 | _filter_od
> @@ -207,7 +208,7 @@ xfs_io \
>  -c "truncate `expr $blksize + 1`" \
>  -c "pwrite -S 0x22 -b $blksize `expr $pgsize / 2` $blksize" \
>  -c "pwrite -S 0x33 -b 512 `expr $blksize \* 2` 512" \
> --t -d -f $SCRATCH_MNT/testfile4 >> $seq.full
> +-t -d -f $SCRATCH_MNT/testfile4 >> $seqres.full
>  
>  xfs_bmap -v $SCRATCH_MNT/testfile4 | _filter_bmap
>  od -x $SCRATCH_MNT/testfile4 | _filter_od
> diff --git a/tests/xfs/195 b/tests/xfs/195
> index cd64db1..e0755f4 100755
> --- a/tests/xfs/195
> +++ b/tests/xfs/195
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -82,5 +83,5 @@ _do_dump
>  
>  # success, all done
>  echo "*** done"
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=0
> diff --git a/tests/xfs/196 b/tests/xfs/196
> index 321fe47..20b20b2 100755
> --- a/tests/xfs/196
> +++ b/tests/xfs/196
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -93,5 +94,5 @@ done
>  
>  # success, all done
>  echo "*** done"
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=0
> diff --git a/tests/xfs/197 b/tests/xfs/197
> index 8c2ebd2..b17ea37 100755
> --- a/tests/xfs/197
> +++ b/tests/xfs/197
> @@ -28,6 +28,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -61,5 +62,5 @@ src/t_dir_offset $TEST_DIR/ttt
>  
>  # success, all done
>  echo "*** done"
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=0
> diff --git a/tests/xfs/199 b/tests/xfs/199
> index 127f307..fbca7c6 100755
> --- a/tests/xfs/199
> +++ b/tests/xfs/199
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -86,5 +87,5 @@ xfs_db -x $SCRATCH_DEV -c 'sb' -c 'print features2'
>  
>  # success, all done
>  echo "*** done"
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=0
> diff --git a/tests/xfs/200 b/tests/xfs/200
> index 34139cc..a70fcfe 100755
> --- a/tests/xfs/200
> +++ b/tests/xfs/200
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -121,5 +122,5 @@ _scratch_mount -o ro 2>&1 | _filter_scratch
>  
>  # success, all done
>  echo "*** done"
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=0
> diff --git a/tests/xfs/201 b/tests/xfs/201
> index e868d99..3f5b1fb 100755
> --- a/tests/xfs/201
> +++ b/tests/xfs/201
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -94,5 +95,5 @@ sync
>  
>  # success, all done
>  echo "*** done"
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=0
> diff --git a/tests/xfs/202 b/tests/xfs/202
> index 27f9e67..b0591d3 100755
> --- a/tests/xfs/202
> +++ b/tests/xfs/202
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -56,5 +57,5 @@ _scratch_xfs_repair -o force_geometry 2>&1 | _filter_repair
>  
>  # success, all done
>  echo "*** done"
> -rm -f $seq.full
> +rm -f $seqres.full
>  status=0
> diff --git a/tests/xfs/203 b/tests/xfs/203
> index ed89600..98ee792 100755
> --- a/tests/xfs/203
> +++ b/tests/xfs/203
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -61,7 +62,7 @@ _cleanup()
>  }
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  # get standard environment, filters and checks
>  . ./common.rc
> diff --git a/tests/xfs/205 b/tests/xfs/205
> index 7c953db..8b973c2 100755
> --- a/tests/xfs/205
> +++ b/tests/xfs/205
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -38,14 +39,14 @@ _supported_os Linux
>  
>  _require_scratch
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
> -_scratch_mkfs_xfs -d size=16m -b size=512 >> $seq.full 2>&1
> +_scratch_mkfs_xfs -d size=16m -b size=512 >> $seqres.full 2>&1
>  _scratch_mount
>  
>  # fix the reserve block pool to a known size so that the enospc calculations
>  # work out correctly.
> -_scratch_resvblks 1024 >> $seq.full 2>&1
> +_scratch_resvblks 1024 >> $seqres.full 2>&1
>  
>  # on a 16MB filesystem, there's 32768x512byte blocks. used is:
>  #	- 4944 in the log,
> diff --git a/tests/xfs/206 b/tests/xfs/206
> index 1c25305..7f822cc 100755
> --- a/tests/xfs/206
> +++ b/tests/xfs/206
> @@ -28,6 +28,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -58,7 +59,7 @@ if [ "$bitsperlong" -ne 64 ]; then
>  	_notrun "This test is only valid on 64 bit machines"
>  fi
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  tmpfile=$TEST_DIR/fsfile.$$
>  tmpdir=$TEST_DIR/tmpdir.$$
> diff --git a/tests/xfs/216 b/tests/xfs/216
> index a997d5a..486bd9d 100755
> --- a/tests/xfs/216
> +++ b/tests/xfs/216
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/217 b/tests/xfs/217
> index b33c2e7..25d3a15 100755
> --- a/tests/xfs/217
> +++ b/tests/xfs/217
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/220 b/tests/xfs/220
> index 061b395..a696aa0 100755
> --- a/tests/xfs/220
> +++ b/tests/xfs/220
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/222 b/tests/xfs/222
> index 133f221..bb22756 100755
> --- a/tests/xfs/222
> +++ b/tests/xfs/222
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -49,7 +50,7 @@ _supported_os Linux
>  
>  [ "$XFS_FSR_PROG" = "" ] && _notrun "xfs_fsr not found"
>  
> -xfs_fsr -d -v $TEST_MNT > $seq.full 2>&1
> +xfs_fsr -d -v $TEST_MNT > $seqres.full 2>&1
>  
>  echo "--- silence is golden ---"
>  status=0 ; exit
> diff --git a/tests/xfs/227 b/tests/xfs/227
> index 8403724..650c72e 100755
> --- a/tests/xfs/227
> +++ b/tests/xfs/227
> @@ -28,6 +28,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -50,7 +51,7 @@ _supported_fs xfs
>  _supported_os Linux
>  _require_scratch
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  [ "$XFS_FSR_PROG" = "" ] && _notrun "xfs_fsr not found"
>  
> @@ -152,10 +153,10 @@ create_target_attr_last()
>  	create_attrs $nattrs $target
>  }
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  # use a small filesystem so we can control freespace easily
> -_scratch_mkfs_sized $((50 * 1024 * 1024)) >> $seq.full 2>&1
> +_scratch_mkfs_sized $((50 * 1024 * 1024)) >> $seqres.full 2>&1
>  _scratch_mount
>  fragment_freespace
>  
> @@ -187,20 +188,20 @@ _scratch_mount
>  
>  targ=$SCRATCH_MNT/fsr_test_file.$$
>  for n in `seq 4 1 12`; do
> -	echo "*** n == $n ***" >> $seq.full
> +	echo "*** n == $n ***" >> $seqres.full
>  	for i in `seq 5 1 15`; do
>  		for j in `seq 5 1 20`; do
> -			create_target_attr_first $i $j $targ.$i.$j >> $seq.full 2>&1
> +			create_target_attr_first $i $j $targ.$i.$j >> $seqres.full 2>&1
>  		done
> -		xfs_bmap -vp $targ.$i.* >> $seq.full 2>&1
> -		FSRXFSTEST=true xfs_fsr -d -v -C $n $targ.$i.* >> $seq.full 2>&1
> -		xfs_bmap -vp $targ.$i.* >> $seq.full 2>&1
> +		xfs_bmap -vp $targ.$i.* >> $seqres.full 2>&1
> +		FSRXFSTEST=true xfs_fsr -d -v -C $n $targ.$i.* >> $seqres.full 2>&1
> +		xfs_bmap -vp $targ.$i.* >> $seqres.full 2>&1
>  		for j in `seq 5 1 20`; do
> -			create_target_attr_last $i $j $targ.$i.$j >> $seq.full 2>&1
> +			create_target_attr_last $i $j $targ.$i.$j >> $seqres.full 2>&1
>  		done
> -		xfs_bmap -vp $targ.$i.* >> $seq.full 2>&1
> -		FSRXFSTEST=true xfs_fsr -d -v -C $n $targ.$i.* >> $seq.full 2>&1
> -		xfs_bmap -vp $targ.$i.* >> $seq.full 2>&1
> +		xfs_bmap -vp $targ.$i.* >> $seqres.full 2>&1
> +		FSRXFSTEST=true xfs_fsr -d -v -C $n $targ.$i.* >> $seqres.full 2>&1
> +		xfs_bmap -vp $targ.$i.* >> $seqres.full 2>&1
>  	done
>  done
>  
> diff --git a/tests/xfs/229 b/tests/xfs/229
> index 52be5c3..eef6a2d 100755
> --- a/tests/xfs/229
> +++ b/tests/xfs/229
> @@ -29,6 +29,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/238 b/tests/xfs/238
> index e1a8749..00dd620 100755
> --- a/tests/xfs/238
> +++ b/tests/xfs/238
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/242 b/tests/xfs/242
> index eb5f9df..6476d5a 100755
> --- a/tests/xfs/242
> +++ b/tests/xfs/242
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/244 b/tests/xfs/244
> index c96d4eb..566caaa 100755
> --- a/tests/xfs/244
> +++ b/tests/xfs/244
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -51,7 +52,7 @@ _require_projid32bit
>  export MOUNT_OPTIONS="-opquota"
>  
>  # make fs with no projid32bit
> -_scratch_mkfs_xfs -i projid32bit=0 >> $seq.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs -i projid32bit=0 >> $seqres.full || _fail "mkfs failed"
>  _qmount
>  # make sure project quota is supported
>  _require_prjquota ${SCRATCH_DEV}
> @@ -68,7 +69,7 @@ mkdir $dir
>  touch $dir/below16bit
>  # below 16bit value
>  $XFS_QUOTA_PROG -x -c "project -s -p $dir/below16bit 3422" $SCRATCH_DEV \
> -		>> $seq.full
> +		>> $seqres.full
>  projid=$($XFS_IO_PROG -r -c "lsproj" $dir/below16bit)
>  if [ "projid = 3422" != "$projid" ]; then
>  	echo "FAIL: projid32bit disabled: returned projid value ($projid)"
> @@ -79,7 +80,7 @@ fi
>  # 32bit value, should fail
>  touch $dir/over16bit
>  if $XFS_QUOTA_PROG -x -c "project -s -p $dir/over16bit 108545" $SCRATCH_DEV \
> -		>> $seq.full 2>&1; then
> +		>> $seqres.full 2>&1; then
>  	echo "FAIL: projid32bit disabled: setting 32bit projid succeeded"
>  	echo "      while it should fail"
>  	status=1
> @@ -87,7 +88,7 @@ fi
>  
>  # over 32bit value, should fail
>  touch $dir/over32bit
> -if $XFS_QUOTA_PROG -x -c "project -s -p $dir/over32bit 5344967296" $SCRATCH_DEV >> $seq.full 2>&1; then
> +if $XFS_QUOTA_PROG -x -c "project -s -p $dir/over32bit 5344967296" $SCRATCH_DEV >> $seqres.full 2>&1; then
>  	echo "FAIL: projid32bit disabled: setting over 32bit projid succeeded"
>  	echo "      while it should fail"
>  	status=1
> @@ -95,14 +96,14 @@ fi
>  
>  #  Do testing on filesystem with projid32bit feature enabled
>  umount $SCRATCH_DEV 2>/dev/null
> -_scratch_mkfs_xfs -i projid32bit=1 >> $seq.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs -i projid32bit=1 >> $seqres.full || _fail "mkfs failed"
>  _qmount
>  mkdir $dir
>  
>  touch $dir/below16bit
>  # below 16bit value, should succeed
>  $XFS_QUOTA_PROG -x -c "project -s -p $dir/below16bit 3422" $SCRATCH_DEV \
> -		>> $seq.full
> +		>> $seqres.full
>  projid=$($XFS_IO_PROG -r -c "lsproj" $dir/below16bit)
>  if [ "projid = 3422" != "$projid" ]; then
>  	echo "FAIL: projid32bit enabled: returned projid value ($projid)"
> @@ -113,7 +114,7 @@ fi
>  # 32bit value, should succeed
>  touch $dir/over16bit
>  if $XFS_QUOTA_PROG -x -c "project -s -p $dir/over16bit 108545" $SCRATCH_DEV \
> -		>> $seq.full 2>&1; then
> +		>> $seqres.full 2>&1; then
>  	projid=$($XFS_IO_PROG -r -c "lsproj" $dir/over16bit)
>  	if [ "projid = 108545" != "$projid" ]; then
>  		echo "FAIL: projid32bit enabled: returned projid value ($projid)"
> @@ -129,7 +130,7 @@ fi
>  # over 32bit value, should fail
>  touch $dir/over32bit
>  if $XFS_QUOTA_PROG -x -c "project -s -p $dir/over32bit 5344967296" $SCRATCH_DEV \
> -		>> $seq.full 2>&1; then
> +		>> $seqres.full 2>&1; then
>  	echo "FAIL: projid32bit enabled: setting over 32bit projid succeeded"
>  	echo "      while it should fail"
>  	status=1
> diff --git a/tests/xfs/250 b/tests/xfs/250
> index 2dd12e8..a6edc2d 100755
> --- a/tests/xfs/250
> +++ b/tests/xfs/250
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/252 b/tests/xfs/252
> index 9f0424d..be3bfcf 100755
> --- a/tests/xfs/252
> +++ b/tests/xfs/252
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/253 b/tests/xfs/253
> index b63b7f6..b73cf6d 100755
> --- a/tests/xfs/253
> +++ b/tests/xfs/253
> @@ -33,6 +33,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/259 b/tests/xfs/259
> index 91503a0..6a29230 100755
> --- a/tests/xfs/259
> +++ b/tests/xfs/259
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  status=1	# failure is the default!
> diff --git a/tests/xfs/261 b/tests/xfs/261
> index 8903ec8..7c575aa 100755
> --- a/tests/xfs/261
> +++ b/tests/xfs/261
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=$(basename $0)
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by ${seq}"
>  
>  here=$(pwd)
> diff --git a/tests/xfs/262 b/tests/xfs/262
> index 5a060f1..2ed7123 100755
> --- a/tests/xfs/262
> +++ b/tests/xfs/262
> @@ -27,6 +27,7 @@
>  #
>  
>  seq=$(basename $0)
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by ${seq}"
>  
>  here=$(pwd)
> diff --git a/tests/xfs/266 b/tests/xfs/266
> index 89c590f..3efbb75 100755
> --- a/tests/xfs/266
> +++ b/tests/xfs/266
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/267 b/tests/xfs/267
> index c52d810..05360a9 100755
> --- a/tests/xfs/267
> +++ b/tests/xfs/267
> @@ -22,6 +22,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/268 b/tests/xfs/268
> index 36391a3..c0c45f2 100755
> --- a/tests/xfs/268
> +++ b/tests/xfs/268
> @@ -24,6 +24,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/278 b/tests/xfs/278
> index 559e174..6439eb4 100755
> --- a/tests/xfs/278
> +++ b/tests/xfs/278
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -60,22 +61,22 @@ _scratch_unmount
>  echo "Silence is goodness..."
>  
>  # Corrupt DIR
> -xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].inumber.i4 0" $SCRATCH_DEV >> $seq.full
> -xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].name 0" $SCRATCH_DEV >> $seq.full
> -xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].offset 0" $SCRATCH_DEV >> $seq.full
> -xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].namelen 0" $SCRATCH_DEV >> $seq.full
> -xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.hdr.parent.i4 0" $SCRATCH_DEV >> $seq.full
> -xfs_db -x -c "inode $DIR_INO" -c "write core.nlinkv2 0" $SCRATCH_DEV >> $seq.full
> +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].inumber.i4 0" $SCRATCH_DEV >> $seqres.full
> +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].name 0" $SCRATCH_DEV >> $seqres.full
> +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].offset 0" $SCRATCH_DEV >> $seqres.full
> +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].namelen 0" $SCRATCH_DEV >> $seqres.full
> +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.hdr.parent.i4 0" $SCRATCH_DEV >> $seqres.full
> +xfs_db -x -c "inode $DIR_INO" -c "write core.nlinkv2 0" $SCRATCH_DEV >> $seqres.full
>  
>  # Corrupt SUBDIR
> -xfs_db -x -c "inode $SUBDIR_INO" -c "write u.sfdir2.hdr.parent.i4 0" $SCRATCH_DEV >> $seq.full
> -xfs_db -x -c "inode $SUBDIR_INO" -c "write core.nlinkv2 0" $SCRATCH_DEV >> $seq.full
> +xfs_db -x -c "inode $SUBDIR_INO" -c "write u.sfdir2.hdr.parent.i4 0" $SCRATCH_DEV >> $seqres.full
> +xfs_db -x -c "inode $SUBDIR_INO" -c "write core.nlinkv2 0" $SCRATCH_DEV >> $seqres.full
>  
> -echo "===== BEGIN of xfs_repair =====" >> $seq.full
> -echo "" >>$seq.full
> +echo "===== BEGIN of xfs_repair =====" >> $seqres.full
> +echo "" >>$seqres.full
>  
> -xfs_repair  $SCRATCH_DEV >> $seq.full 2>&1
> -echo "===== END of xfs_repair =====" >> $seq.full
> +xfs_repair  $SCRATCH_DEV >> $seqres.full 2>&1
> +echo "===== END of xfs_repair =====" >> $seqres.full
>  
>  #if _check_scratch_fs; then
>  #	status=0
> diff --git a/tests/xfs/279 b/tests/xfs/279
> index 8ee3328..e96c823 100755
> --- a/tests/xfs/279
> +++ b/tests/xfs/279
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -48,7 +49,7 @@ _supported_os Linux
>  
>  _require_scsi_debug
>  
> -rm -f $seq.full
> +rm -f $seqres.full
>  
>  # Remove xfs signature so -f isn't needed to re-mkfs
>  _wipe_device()
> @@ -67,7 +68,7 @@ _check_mkfs()
>  		return
>  	fi
>  	echo "Passed."
> -	cat $tmp.mkfs.full | _filter_mkfs >> $seq.full 2>$tmp.mkfs
> +	cat $tmp.mkfs.full | _filter_mkfs >> $seqres.full 2>$tmp.mkfs
>  	. $tmp.mkfs
>  	echo "Got sector size: $sectsz"
>  	device=`echo $@ | awk '{print $NF}'`
> @@ -83,7 +84,7 @@ SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 128`
>  _check_mkfs $SCSI_DEBUG_DEV
>  # blocksize smaller than physical sectorsize should revert to logical sectorsize
>  _check_mkfs -b size=2048 -f $SCSI_DEBUG_DEV
> -) | tee -a $seq.full
> +) | tee -a $seqres.full
>  _put_scsi_debug_dev
>  
>  # === 4k physical 512b logical unaligned
> @@ -99,7 +100,7 @@ _check_mkfs -f $SCSI_DEBUG_DEV
>  _check_mkfs -s size=4096 $SCSI_DEBUG_DEV
>  # with 4k sector specified should fall back to logical sector size with force
>  _check_mkfs -s size=4096 -f $SCSI_DEBUG_DEV
> -) | tee -a $seq.full
> +) | tee -a $seqres.full
>  _put_scsi_debug_dev
>  
>  # === hard 4k physical / 4k logical
> @@ -111,7 +112,7 @@ SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 4096 0 128`
>  _check_mkfs -b size=2048 $SCSI_DEBUG_DEV
>  # sector size smaller than physical sector size should fail
>  _check_mkfs -s size=512 $SCSI_DEBUG_DEV
> -) | tee -a $seq.full
> +) | tee -a $seqres.full
>  _put_scsi_debug_dev
>  
>  status=0
> diff --git a/tests/xfs/281 b/tests/xfs/281
> index 2af3533..7aae2a5 100755
> --- a/tests/xfs/281
> +++ b/tests/xfs/281
> @@ -23,6 +23,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/xfs/282 b/tests/xfs/282
> index 4938408..0680b9c 100755
> --- a/tests/xfs/282
> +++ b/tests/xfs/282
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -45,13 +46,13 @@ _require_legacy_v2_format
>  _create_dumpdir_fill
>  # ensure file/dir timestamps precede dump timestamp
>  sleep 2
> -src/bstat $SCRATCH_MNT >>$here/$seq.full
> +src/bstat $SCRATCH_MNT >>$here/$seqres.full
>  
>  echo "*** Level 0 dump, format 2"
>  _do_dump_file -f $tmp.l0 -K
>  
>  _append_dumpdir_fill
> -src/bstat $SCRATCH_MNT >>$here/$seq.full
> +src/bstat $SCRATCH_MNT >>$here/$seqres.full
>  
>  echo "*** Level 1 dump, current format"
>  _do_dump_file -l 1 -f $tmp.l1
> diff --git a/tests/xfs/283 b/tests/xfs/283
> index d1ce8ad..75ee26e 100755
> --- a/tests/xfs/283
> +++ b/tests/xfs/283
> @@ -25,6 +25,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> @@ -45,13 +46,13 @@ _require_legacy_v2_format
>  _create_dumpdir_fill
>  # ensure file/dir timestamps precede dump timestamp
>  sleep 2
> -src/bstat $SCRATCH_MNT >>$here/$seq.full
> +src/bstat $SCRATCH_MNT >>$here/$seqres.full
>  
>  echo "*** Level 0 dump, current format"
>  _do_dump_file -f $tmp.l0
>  
>  _append_dumpdir_fill
> -src/bstat $SCRATCH_MNT >>$here/$seq.full
> +src/bstat $SCRATCH_MNT >>$here/$seqres.full
>  
>  echo "*** Level 1 dump, format 2"
>  _do_dump_file -l 1 -f $tmp.l1 -K

Quite a lot of tests use $here/$seq.full. This results in
$here/$seqres.full after the sed. $seqres is just a $RESULT_DIR/$seq.
This would break if RESULT_DIR was set to an absolute path instead of
relative path.

This sed command could probably be better for the conversion:

sed -i -e '/^seq=.*$/a seqres=$RESULT_DIR/$seq' -e
's/[^/]seq.full/seqres.full/' -e 's;here/\$seq;RESULT_DIR/\$seq;g'
tests/*/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
