Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 66C727F50
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 10:08:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 478A88F8033
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 08:08:09 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id h65pdS0GoilXWP5W for <xfs@oss.sgi.com>;
	Sun, 03 Feb 2013 08:08:08 -0800 (PST)
Message-ID: <510E8B66.9040803@sandeen.net>
Date: Sun, 03 Feb 2013 10:08:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfstests: Add new standard loop handling functions
References: <1359886798-8818-1-git-send-email-tracek@redhat.com>
	<1359886798-8818-2-git-send-email-tracek@redhat.com>
In-Reply-To: <1359886798-8818-2-git-send-email-tracek@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On 2/3/13 4:19 AM, Tomas Racek wrote:
> Add _create_loop_device and _destroy_loop_device to uniformly handle
> loopback devices.

Good idea, small comment below

> Signed-off-by: Tomas Racek <tracek@redhat.com>
> ---
>  common.rc | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/common.rc b/common.rc
> index 0cccb94..67a5e3a 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -1833,6 +1833,20 @@ _require_dumpe2fs()
>  	fi
>  }
>  
> +_create_loop_device()
> +{
> +	file=$1
> +	dev=`losetup -f`
> +	losetup $dev $file || _fail "Cannot associate $file with $dev"
> +	echo $dev

In theory this is a little racy, right?  the loop device could become
used in between.

I wonder if something like:

_create_loop_device()
{
	dev=`losetup -f --show $file` || _fail "Cannot associate $file with $dev"
	echo $dev
}

would work better?  From the manpage:

       -f, --find
              find the first unused loop device. If a file argument is present,
               use this device. Otherwise, print its name

       --show print device name if the -f option and a file argument are present.

So this will set up the first available loop device and print its name.

Thanks,
-Eric	

> +}
> +
> +_destroy_loop_device()
> +{
> +	dev=$1
> +	losetup -d $dev || _fail "Cannot destroy loop device $dev"
> +}
> +
>  ################################################################################
>  
>  if [ "$iam" != new -a "$iam" != bench ]
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
