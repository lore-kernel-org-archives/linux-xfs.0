Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B8EE57F61
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 11:44:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 833938F8037
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 09:44:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BD6vHHrNKguM6yyz for <xfs@oss.sgi.com>;
	Wed, 21 Aug 2013 09:44:48 -0700 (PDT)
Message-ID: <5214EE7F.8090507@sandeen.net>
Date: Wed, 21 Aug 2013 11:44:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: btrfs/003: stat the dev we're removing to make
	sure its' really gone
References: <1377101015-3070-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1377101015-3070-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 8/21/13 11:03 AM, Josef Bacik wrote:
> I've been periodically failing btrfs/003 because my box sometimes takes a little
> longer to unregister the device when we remove it and so the output from btrfs
> dev show doesn't match what we are wanting since it still sees the device.  To
> fix this just stat and sleep if we still see the device node and only continue
> once udev or whatever actually removes the device node so that we don't get
> random failures.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  tests/btrfs/003 |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/tests/btrfs/003 b/tests/btrfs/003
> index 5c88651..dba1a32 100755
> --- a/tests/btrfs/003
> +++ b/tests/btrfs/003
> @@ -145,6 +145,12 @@ _test_replace()
>  	_devmgt_remove ${DEVHTL}
>  	dev_removed=1
>  

This should probably go into _devmgt_remove,
and possibly the reverse in _devmgmt_add as well, with
a comment explaining what it's doing?

Otherwise someone else will run into the same problem down the line.

-Eric

> +	stat $ds >> $seqres.full 2>&1
> +	while [ $? -eq 0 ]; do
> +		sleep 1
> +		stat $ds >> $seqres.full 2>&1
> +	done
> +
>  	$BTRFS_UTIL_PROG fi show $SCRATCH_DEV | grep "Some devices missing" >> $seqres.full || _fail \
>  							"btrfs did not report device missing"
>  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
