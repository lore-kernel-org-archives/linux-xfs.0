Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ED6E57F37
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 10:33:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A52A78F8059
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 08:33:00 -0700 (PDT)
Received: from mo-p00-ob.rzone.de (mo-p00-ob.rzone.de [81.169.146.161]) by
	cuda.sgi.com with ESMTP id G2uhCHmVFCgiWzFQ for
	<xfs@oss.sgi.com>; Wed, 13 Mar 2013 08:32:58 -0700 (PDT)
Message-ID: <51409C25.70403@giantdisaster.de>
Date: Wed, 13 Mar 2013 16:32:53 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfstests: btrfs tests for basic informational commands
References: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
	<1363186623-1378-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1363186623-1378-4-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, 13 Mar 2013 09:57:03 -0500, Eric Sandeen wrote:
[...]
> +echo "== Show device stats by mountpoint"
> +$BTRFS_UTIL_PROG device stats $SCRATCH_MNT | _filter_btrfs_device_stats

Is the number of devices in SCRATCH_DEV_POOL fixed to 3? Otherwise you
should pipe the device-stats-by-mountpoint through "head -10" to avoid
failures if the number of devices is != 3.
Possible additional checks (but I am not sure that we really need this
additional level of detail in this check) would be:
1. The number of lines is 5 * number of devices.
2. The 5-line block that is printed for each device always looks the
same (after applying _filter_btrfs_device_stats).

> +echo "== Show device stats by first/scratch dev"
> +$BTRFS_UTIL_PROG device stats $SCRATCH_DEV | _filter_btrfs_device_stats
> +echo "== Show device stats by second dev"
> +$BTRFS_UTIL_PROG device stats $FIRST_POOL_DEV | sed -e "s,$FIRST_POOL_DEV,FIRST_POOL_DEV,g"
> +echo "== Show device stats by last dev"
> +$BTRFS_UTIL_PROG device stats $LAST_POOL_DEV | sed -e "s,$LAST_POOL_DEV,LAST_POOL_DEV,g"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/313.out b/313.out
> new file mode 100644
> index 0000000..1aa59a1
> --- /dev/null
> +++ b/313.out
> @@ -0,0 +1,51 @@
> +== QA output created by 313
> +== Set filesystem label to TestLabel.313
> +== Get filesystem label
> +TestLabel.313
> +== Mount.
> +== Show filesystem by label
> +Label: 'TestLabel.313'  uuid: <UUID>
> +	Total devices <EXACTNUM> FS bytes used <SIZE>
> +	devid     <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
> +
> +== Show filesystem by UUID
> +Label: 'TestLabel.313'  uuid: <EXACTUUID>
> +	Total devices <EXACTNUM> FS bytes used <SIZE>
> +	devid     <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
> +
> +== Sync filesystem
> +FSSync 'SCRATCH_MNT'
> +== Show device stats by mountpoint
> +[SCRATCH_DEV].write_io_errs   <NUM>
> +[SCRATCH_DEV].read_io_errs    <NUM>
> +[SCRATCH_DEV].flush_io_errs   <NUM>
> +[SCRATCH_DEV].corruption_errs <NUM>
> +[SCRATCH_DEV].generation_errs <NUM>
> +[SCRATCH_DEV].write_io_errs   <NUM>
> +[SCRATCH_DEV].read_io_errs    <NUM>
> +[SCRATCH_DEV].flush_io_errs   <NUM>
> +[SCRATCH_DEV].corruption_errs <NUM>
> +[SCRATCH_DEV].generation_errs <NUM>
> +[SCRATCH_DEV].write_io_errs   <NUM>
> +[SCRATCH_DEV].read_io_errs    <NUM>
> +[SCRATCH_DEV].flush_io_errs   <NUM>
> +[SCRATCH_DEV].corruption_errs <NUM>
> +[SCRATCH_DEV].generation_errs <NUM>

3 devices in this case.

> +== Show device stats by first/scratch dev
> +[SCRATCH_DEV].write_io_errs   <NUM>
> +[SCRATCH_DEV].read_io_errs    <NUM>
> +[SCRATCH_DEV].flush_io_errs   <NUM>
> +[SCRATCH_DEV].corruption_errs <NUM>
> +[SCRATCH_DEV].generation_errs <NUM>
> +== Show device stats by second dev
> +[FIRST_POOL_DEV].write_io_errs   0
> +[FIRST_POOL_DEV].read_io_errs    0
> +[FIRST_POOL_DEV].flush_io_errs   0
> +[FIRST_POOL_DEV].corruption_errs 0
> +[FIRST_POOL_DEV].generation_errs 0
> +== Show device stats by last dev
> +[LAST_POOL_DEV].write_io_errs   0
> +[LAST_POOL_DEV].read_io_errs    0
> +[LAST_POOL_DEV].flush_io_errs   0
> +[LAST_POOL_DEV].corruption_errs 0
> +[LAST_POOL_DEV].generation_errs 0
[...]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
