Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E63717CB4
	for <xfs@oss.sgi.com>; Fri,  1 Apr 2016 02:28:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B671D304039
	for <xfs@oss.sgi.com>; Fri,  1 Apr 2016 00:28:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id B5DlU2KvfWVfuWLI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 01 Apr 2016 00:28:58 -0700 (PDT)
Date: Fri, 1 Apr 2016 15:28:56 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs/133 134 262: limit xfs_quota report to report on
	specific project quota id
Message-ID: <20160401072856.GA3329@dhcp12-237.nay.redhat.com>
References: <1459494050-28330-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459494050-28330-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: sandeen@redhat.com, fstests@vger.kernel.org, xfs@oss.sgi.com

On Fri, Apr 01, 2016 at 03:00:50PM +0800, Eryu Guan wrote:
> With GETNEXTQUOTA support, xfs_quota -c "report" now outputs more quota
> info than before, and this breaks xfs/133 xfs/134 and xfs/262, e.g.
> xfs/133 fails as
> 
>      Filesystem Blocks Quota Limit Warn/Time Mounted on
>      SCRATCH_DEV 0 102400 204800 00 [--------] SCRATCH_MNT
>      === report command output ===
>     +(null) 0 0 0 00 [--------]
>      123456-project 0 102400 204800 00 [--------]
> 
> Fix it by limiting xfs_quota to report on specific project quota number
> using -L & -U option, so only the project quota being tested is
> reported.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> 
> I'm not sure if kernel should be fixed, but limiting the quota report on
> project number being tested seems something worth doing to me anyway. It avoids
> breakage of future changes of quota report output.

Hi,

FYI:
About "+(null) 0 0 0 00 [--------]"problem, it has been talked in:
http://thread.gmane.org/gmane.comp.file-systems.fstests/1852/focus=1968

I think:
1) If we consider that this's a bug, the original test cases can
be the reproducer of this bug, so we shouldn't change the cases.

2) If we think print "(null) 0 0 0 00 [--------]" is right(or not
wrong), then this patch is good.

Thanks,
Zorro

> 
>  tests/xfs/133     |  8 +++++---
>  tests/xfs/133.out |  2 +-
>  tests/xfs/134     | 22 +++++++++++++++-------
>  tests/xfs/262     |  6 ++++--
>  4 files changed, 25 insertions(+), 13 deletions(-)
> 
> diff --git a/tests/xfs/133 b/tests/xfs/133
> index 82c38b1..7a0e55e 100755
> --- a/tests/xfs/133
> +++ b/tests/xfs/133
> @@ -57,16 +57,17 @@ do_project_test()
>  {
>  	local qa_project=123456-project
>  	local dir=$SCRATCH_MNT/project
> +	local proj_num=10
>  
>  	mkdir $dir 2>/dev/null
>  
>  	#project quota files
>  	cat >$tmp.projects <<EOF
> -10:$dir
> +$proj_num:$dir
>  EOF
>  
>  	cat >$tmp.projid <<EOF
> -$qa_project:10
> +$qa_project:$proj_num
>  EOF
>  
>  	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> @@ -81,7 +82,8 @@ EOF
>  
>  	echo "=== report command output ==="
>  	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> -		-c "report -p -N -b" $SCRATCH_MNT | _filter_quota
> +		-c "report -p -N -b -L $proj_num -U $proj_num" \
> +		$SCRATCH_MNT | _filter_quota
>  }
>  
>  # Test project
> diff --git a/tests/xfs/133.out b/tests/xfs/133.out
> index 21cfd0d..8c747bf 100644
> --- a/tests/xfs/133.out
> +++ b/tests/xfs/133.out
> @@ -4,5 +4,5 @@ Disk quotas for Project 123456-project (10)
>  Filesystem Blocks Quota Limit Warn/Time Mounted on
>  SCRATCH_DEV 0 102400 204800 00 [--------] SCRATCH_MNT
>  === report command output ===
> -123456-project 0 102400 204800 00 [--------]
> +#10 0 102400 204800 00 [--------]
>  
> diff --git a/tests/xfs/134 b/tests/xfs/134
> index be18ee8..5ba275c 100755
> --- a/tests/xfs/134
> +++ b/tests/xfs/134
> @@ -54,12 +54,13 @@ _require_xfs_quota
>  dir=$SCRATCH_MNT/project
>  
>  #project quota files
> +proj_num=1
>  cat >$tmp.projects <<EOF
> -1:$dir
> +$proj_num:$dir
>  EOF
>  
>  cat >$tmp.projid <<EOF
> -test:1
> +test:$proj_num
>  EOF
>  
>  cp /dev/null $seqres.full
> @@ -87,17 +88,24 @@ fi
>  src/feature -p $SCRATCH_DEV
>  [ $? -ne 0 ] && _notrun "Installed kernel does not support project quotas"
>  
> +report_quota()
> +{
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> +		-c "repquota -inN -p -L $proj_num -U $proj_num" $SCRATCH_DEV | \
> +		tr -s '[:space:]'
> +}
> +
>  mkdir $dir
>  $XFS_IO_PROG -r -c "chproj -R 1" -c "chattr -R +P" $dir
>  
> -xfs_quota -D $tmp.projects -P $tmp.projid -x \
> +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>      -c "limit -p bsoft=100m bhard=100m 1" $SCRATCH_DEV
> -xfs_quota -D $tmp.projects -P $tmp.projid -x -c "repquota -inN -p" $SCRATCH_DEV | tr -s '[:space:]'
> +report_quota
>  touch $dir/1
>  touch $dir/2
>  cp $dir/2 $dir/3
>  
> -xfs_quota -D $tmp.projects -P $tmp.projid -x -c "repquota -inN -p" $SCRATCH_DEV | tr -s '[:space:]'
> +report_quota
>  
>  if [ "$HOSTOS" == "IRIX" ] ; then
>      mkfile 1M $TEST_DIR/6
> @@ -107,12 +115,12 @@ fi
>  
>  #try cp to dir
>  cp $TEST_DIR/6 $dir/6
> -xfs_quota -D $tmp.projects -P $tmp.projid -x -c "repquota -inN -p" $SCRATCH_DEV | tr -s '[:space:]'
> +report_quota
>  
>  #try mv to dir
>  mv $TEST_DIR/6 $dir/7
>  
> -xfs_quota -D $tmp.projects -P $tmp.projid -x -c "repquota -inN -p" $SCRATCH_DEV | tr -s '[:space:]'
> +report_quota
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/262 b/tests/xfs/262
> index 9d8b838..d3a352c 100755
> --- a/tests/xfs/262
> +++ b/tests/xfs/262
> @@ -138,11 +138,13 @@ _quota_cmd "limit -p bhard=${qlimit_meg}m bsoft=${qlimit_meg}m ${proj_name}" \
>  							2>> "$seqres.full" 1>&2
>  
>  # See what gets reported
> -_quota_cmd "report"		| _filter_quota_rpt	2>> "$seqres.full"
> +_quota_cmd "report -U $proj_num -L $proj_num" | _filter_quota_rpt \
> +							2>> $seqres.full
>  _quota_cmd "df"			| _filter_quota_rpt	2>> "$seqres.full"
>  
>  # This time using "human readable" output
> -_quota_cmd "report -h"		| _filter_quota_rpt	2>> "$seqres.full"
> +_quota_cmd "report -h $proj_num -L $proj_num" | _filter_quota_rpt \
> +							2>> "$seqres.full"
>  _quota_cmd "df -h"		| _filter_quota_rpt	2>> "$seqres.full"
>  
>  # Clean up

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
