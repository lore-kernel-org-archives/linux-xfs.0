Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 66BF07F6F
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 05:24:45 -0500 (CDT)
Date: Sat, 23 Mar 2013 03:24:44 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 24/25] xfstests: clean up test 262 output file use.
Message-ID: <20130323102444.GB25253@caliban.engr.sgi.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-25-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363350489-22257-25-git-send-email-david@fromorbit.com>
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

On Fri, Mar 15, 2013 at 11:28:08PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Test 262 uses ${} notation for some variables, and so is resistant
> to grep and sed matches. Change it to use the same notation as the
> rest of xfstests and fix up the output file redirections made in
> previous patches.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  tests/xfs/262 |   36 ++++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/tests/xfs/262 b/tests/xfs/262
> index 01f7f8b..0c15787 100755
> --- a/tests/xfs/262
> +++ b/tests/xfs/262
> @@ -28,15 +28,15 @@
>  
>  seq=$(basename $0)
>  seqres=$RESULT_DIR/$seq
> -echo "QA output created by ${seq}"
> +echo "QA output created by $seq"
>  
>  here=$(pwd)
>  
> -cp /dev/null "${seq}.full"
> +rm -f $seqres.full
>  
>  tmp=/tmp/$$
> -my_projects=${tmp}.projects
> -my_projid=${tmp}.projid
> +my_projects=$tmp.projects
> +my_projid=$tmp.projid
>  proj_name=test_project
>  proj_num=1
>  
> @@ -48,7 +48,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  _cleanup()
>  {
>      cd /
> -    rm -f ${tmp}.*
> +    rm -f $tmp.*
>  }
>  
>  # get standard environment, filters and checks
> @@ -60,7 +60,7 @@ echo "Silence is golden."
>  
>  # real QA test starts here
>  
> -proj_dir="${SCRATCH_MNT}/test"
> +proj_dir="$SCRATCH_MNT/test"
>  
>  # Modify as appropriate.
>  _supported_fs xfs
> @@ -108,38 +108,38 @@ _filter_quota_rpt() {
>  }
>  
>  _quota_cmd() {
> -	xfs_quota -P "${my_projid}" -D "${my_projects}" -x \
> -		-c "$@" "${SCRATCH_MNT}"
> +	xfs_quota -P "$my_projid" -D "$my_projects" -x \
> +		-c "$@" "$SCRATCH_MNT"
>  }
>  
>  # Set up--mount scratch and create the project directory
>  
> -echo ${proj_name}:${proj_num} > "${my_projid}"
> -echo ${proj_num}:${proj_dir} > "${my_projects}"
> +echo $proj_name:$proj_num > "$my_projid"
> +echo $proj_num:$proj_dir > "$my_projects"
>  
> -_scratch_mkfs						>> "${seq}.full" 2>&1
> +_scratch_mkfs						>> "$seqres.full" 2>&1
>  
>  export MOUNT_OPTIONS="-opquota"
>  _qmount
>  mkdir -p "${proj_dir}"
>  
>  # Setup the project quota directory
> -_quota_cmd "project -s ${proj_name}"			>> "${seq}.full" 2>&1
> +_quota_cmd "project -s ${proj_name}"			>> "$seqres.full" 2>&1
>  
>  # Assign block quota limits
>  _quota_cmd "limit -p bhard=${qlimit_meg}m bsoft=${qlimit_meg}m ${proj_name}" \
> -							2>> "${seq}.full" 1>&2
> +							2>> "$seqres.full" 1>&2
>  
>  # See what gets reported
> -_quota_cmd "report"		| _filter_quota_rpt	2>> "${seq}.full"
> -_quota_cmd "df"			| _filter_quota_rpt	2>> "${seq}.full"
> +_quota_cmd "report"		| _filter_quota_rpt	2>> "$seqres.full"
> +_quota_cmd "df"			| _filter_quota_rpt	2>> "$seqres.full"
>  
>  # This time using "human readable" output
> -_quota_cmd "report -h"		| _filter_quota_rpt	2>> "${seq}.full"
> -_quota_cmd "df -h"		| _filter_quota_rpt	2>> "${seq}.full"
> +_quota_cmd "report -h"		| _filter_quota_rpt	2>> "$seqres.full"
> +_quota_cmd "df -h"		| _filter_quota_rpt	2>> "$seqres.full"
>  
>  # Clean up
> -rm -rf "${proj_dir}"
> +rm -rf "$proj_dir"
>  _scratch_unmount
>  
>  status=0	# success, all done
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
