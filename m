Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 73EA47F3F
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 16:44:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 549B4304059
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 14:44:49 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DrPWgJergEUYtxqC for <xfs@oss.sgi.com>;
	Mon, 28 Oct 2013 14:44:47 -0700 (PDT)
Date: Tue, 29 Oct 2013 08:44:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: tests/generic: added -P option to df
Message-ID: <20131028214444.GE2797@dastard>
References: <1382444035-9502-1-git-send-email-stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1382444035-9502-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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
To: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Cc: vasily.isaenko@oracle.com, xfs@oss.sgi.com

On Tue, Oct 22, 2013 at 04:13:55PM +0400, Stanislav Kholmanskikh wrote:
> Otherwise the testcases will fail if the scratch
> device has a long name (for example, if it's an LVM volume).
> Because df outputs its usage stats with two lines:
> 
> /dev/mapper/xfstests-disk1
>                        3030800      4608   2868908   1% /tmp/mnt/disk1
> 
> Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
> ---
>  tests/generic/251 |    2 +-
>  tests/generic/260 |    2 +-
>  tests/generic/273 |    2 +-
>  tests/generic/275 |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/generic/251 b/tests/generic/251
> index 4126f15..eca3b0d 100755
> --- a/tests/generic/251
> +++ b/tests/generic/251
> @@ -89,7 +89,7 @@ _guess_max_minlen()
>  fstrim_loop()
>  {
>  	trap "_destroy_fstrim; exit \$status" 2 15
> -	fsize=$(df | grep $SCRATCH_MNT | grep $SCRATCH_DEV  | awk '{print $2}')
> +	fsize=$(df -P | grep $SCRATCH_MNT | grep $SCRATCH_DEV  | awk '{print $2}')

Convert to $DF_PROG and add the -P flag to that variable, please.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
