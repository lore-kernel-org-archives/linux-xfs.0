Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAEHwsmn154217 for <xfs@oss.sgi.com>; Wed, 14 Nov 2012 11:58:54 -0600
Message-ID: <50A3DC58.4080704@sgi.com>
Date: Wed, 14 Nov 2012 12:00:56 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 2/2 V2] xfstests: xfs_tosspages() test addition
References: <20121108222315.505370321@sgi.com>
	<20121108222315.709683665@sgi.com>
	<20121108232726.GV6434@dastard> <50A19EC0.4040405@sgi.com>
In-Reply-To: <50A19EC0.4040405@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andrew Dahl <adahl@sgi.com>
Cc: xfs@oss.sgi.com

On 11/12/12 19:13, Andrew Dahl wrote:
>
> Tests the XFS_IOC_ZERO_RANGE ioctl by way of the "xfs_io zero" utility
> to ensure it is tossing the expected ranges.
>
> The ranges tested are [0,1] [0,4095] [0,4096] [0,4097] [4095,8191]
>    [4095,8192] [4095,8193] [4096,8192] [1024,4096]
>
> Signed-off-by: Andrew Dahl<adahl@sgi.com>
>
> ---
>

...


> +
> +	$XFS_IO_PROG -F -f -t -c "pwrite -S 0x41 0 4096" \

-F is deprecated in xfs_io.

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
