Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 693357F51
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 22:02:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 16471AC002
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 20:02:49 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id v6dPKiEHykbDgk14 for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 20:02:45 -0800 (PST)
Message-ID: <52F1B7E4.8050400@sandeen.net>
Date: Tue, 04 Feb 2014 22:02:44 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs/066: stat the test file, not the directory
References: <1391568715-27617-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1391568715-27617-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 2/4/14, 8:51 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Ever since commit 7e2a19504 ("ls -l reports different file size
> depending on platform and user.") xfs/066 has been running stat on
> the dump/restore directory instead of the large file that the test
> is checking can be dumped and restored correctly. IOWs, it's not
> been checking the correct thing for almost 10 years.

heh:

-ls -l $restore_dir/$dump_sdir | _my_ls_filter
+stat $restore_dir/$dump_sdir | _my_stat_filter

cripes!

> This test fails on CRC enabled filesystems because the shortform
> directory entry size is different (an extra byte for the filetype
> filed), and this is where tracking down the failure has lead me.
> 
> Fix this by using the correct target file, and improve it by dumping
> an md5sum of the source and target files to ensure they contain the
> same data.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/xfs/066     | 6 ++++--
>  tests/xfs/066.out | 6 ++++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/xfs/066 b/tests/xfs/066
> index d521ada..db29249 100755
> --- a/tests/xfs/066
> +++ b/tests/xfs/066
> @@ -60,11 +60,13 @@ fi
>  
>  _create_dumpdir_largefile
>  echo "ls dumpdir/largefile"
> -stat $dump_dir | _my_stat_filter
> +stat $dump_dir/largefile | _my_stat_filter
> +md5sum $dump_dir/largefile |_filter_scratch
>  _do_dump_file
>  _do_restore_file
>  echo "ls restoredir/largefile"
> -stat $restore_dir/$dump_sdir | _my_stat_filter
> +stat $restore_dir/$dump_sdir/largefile | _my_stat_filter
> +md5sum $restore_dir/$dump_sdir/largefile |_filter_scratch
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/066.out b/tests/xfs/066.out
> index f84a0b8..0e85143 100644
> --- a/tests/xfs/066.out
> +++ b/tests/xfs/066.out
> @@ -3,7 +3,8 @@ dd a largefile at offset 4294967297
>  10+0 records in
>  10+0 records out
>  ls dumpdir/largefile
> -22 largefile
> +4294967307 largefile
> +e2664609cb95c2215732cf4e71e45017  SCRATCH_MNT/dumpdir/largefile
>  Dumping to file...
>  xfsdump  -f DUMP_FILE -M stress_tape_media -L stress_066 SCRATCH_MNT
>  xfsdump: using file dump (drive_simple) strategy
> @@ -37,4 +38,5 @@ xfsrestore: restoring non-directory files
>  xfsrestore: restore complete: SECS seconds elapsed
>  xfsrestore: Restore Status: SUCCESS
>  ls restoredir/largefile
> -22 largefile
> +4294967307 largefile
> +e2664609cb95c2215732cf4e71e45017  SCRATCH_MNT/restoredir/dumpdir/largefile
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
