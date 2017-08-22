Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16875 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdHVQYT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2017 12:24:19 -0400
Date: Tue, 22 Aug 2017 09:24:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: test xfs_db fuzz command verbs
Message-ID: <20170822162415.GE4794@magnolia>
References: <20170819154645.GD4794@magnolia>
 <20170822070614.GG31418@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170822070614.GG31418@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Tue, Aug 22, 2017 at 03:06:14PM +0800, Eryu Guan wrote:
> Hi Darrick,
> 
> On Sat, Aug 19, 2017 at 08:46:45AM -0700, Darrick J. Wong wrote:
> > Ensure that the fuzz command does what it says.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I applied your patch "[PATCH] xfs_db: bit fuzzing should read the right
> bit when flipping" on top of xfsprogs for-next branch (which contains
> commit ef209a960d82 "xfs_db: make write/fuzz -c and -d work on non-crc
> filesystems") and tested this patch. All worked fine on CRC enabled XFS,
> but test failed with non-CRC xfs as it missed lines like:
> 
> Allowing fuzz of corrupted data with good CRC
> 
> I did the following modifications and test passed with both CRC and
> non-CRC XFS, if you think it's OK then I can fold the changes to your
> patch and no need for a resend :)

Looks fine to me, go ahead and fold it in.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Thanks,
> Eryu
> 
> diff --git a/tests/xfs/058 b/tests/xfs/058
> index 4a39942..32ceb0d 100755
> --- a/tests/xfs/058
> +++ b/tests/xfs/058
> @@ -50,21 +50,31 @@ _require_xfs_db_command "fuzz"
>  rm -f "$seqres.full"
>  
>  echo "Format"
> -_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mkfs | _filter_mkfs 2>$tmp.mkfs >> "$seqres.full"
> +source $tmp.mkfs
> +
> +do_xfs_db()
> +{
> +       local cmd=$1
> +       if [ $_fs_has_crcs -eq 0 ]; then
> +               echo "Allowing $cmd of corrupted data with good CRC"
> +       fi
> +       _scratch_xfs_db -x -c 'sb 0' -c "$*"
> +}
>  
>  # Make sure that each fuzz verb works.  For the firstbit/middlebit/lastbit
>  # tests, we depend on 'ones' having set the field to all ones.
>  field="fdblocks"
> -_scratch_xfs_db -x -c 'sb 0' -c "write -d ${field} 0"
> +do_xfs_db write -d ${field} 0
>  SCRATCH_XFS_LIST_FUZZ_VERBS= _scratch_xfs_list_fuzz_verbs | while read verb; do
>         test "${verb}" = "random" && continue
>         echo "Test verb ${verb}"
> -       _scratch_xfs_db -x -c 'sb 0' -c "fuzz -d ${field} ${verb}"
> +       do_xfs_db fuzz -d ${field} ${verb}
>  done
>  
>  echo "Test verb random"
>  before="$(_scratch_xfs_get_metadata_field "${field}" 'sb 0')"
> -_scratch_xfs_db -x -c 'sb 0' -c "fuzz -d ${field} random" >> $seqres.full
> +do_xfs_db fuzz -d ${field} random >> $seqres.full
>  after="$(_scratch_xfs_get_metadata_field "${field}" 'sb 0')"
>  test "${before}" != "${after}" && echo "${field} changed"
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
