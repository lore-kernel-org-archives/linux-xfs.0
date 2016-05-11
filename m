Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1E03B7CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 03:26:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 77BA4AC006
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 01:26:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D2rgCoaFimvj0Nwj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 01:26:24 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id C280F2EBCED
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 08:26:23 +0000 (UTC)
Date: Wed, 11 May 2016 16:26:21 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs/133 134 262: limit xfs_quota report to report on
	specific project quota id
Message-ID: <20160511082621.GA17859@dhcp12-143.nay.redhat.com>
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
Cc: xfs@oss.sgi.com

Hi,

After the below xfsprogs patch has been merged:
3d607a1 xfs_quota: print quota id number if the name can't be found

so we can talk about this patch now. Please check below:

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

The case used to reproduced some bugs caused by project name beginning
with digits. The "limit" and "quota" all maybe trigger this bug. The
last "report" command is used to help to sure the bug is in "limit"
or "quota" commands(It's not necessary but helpful).

If "quota" command can't print "123456-project", but "report" command
can, that means "quota" command can't deal with this project name
correctly.

If "quota" and "report" commands all can't print "123456-project", that
means "limit" can't create a limit for this project name correctly.

So we'd better keep report project name, not project ID (Although report
ID is OK too, but if the original one is better, why we change it.)

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

Due to this case hope to print ID number, so this change is OK.

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

The _filter_quota_rpt() in this case already can deal with
this problem. It will check "if ($1 =~ proj_name)". So I think
we don't need more change on this case which can work well.

>  _quota_cmd "df -h"		| _filter_quota_rpt	2>> "$seqres.full"
>  
>  # Clean up
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
