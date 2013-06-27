Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 97F537F66
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 22:18:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 212BDAC004
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 20:18:56 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id IJoAw3wbTGOSwb1e (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 20:18:54 -0700 (PDT)
Message-ID: <51CBB022.7010703@oracle.com>
Date: Thu, 27 Jun 2013 11:23:14 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix btrfs/264 to not use the scratch dev pool
References: <1372261976-11426-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1372261976-11426-1-git-send-email-jbacik@fusionio.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com




  Reviewed-by: Anand Jain <anand.jain@oracle.com>


On 06/26/2013 11:52 PM, Josef Bacik wrote:
> This test doesn't need the scratch dev pool and it also doesn't call
> _require_scratch_dev_pool, so just kick out the scratch dev pool part of the
> test.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>   tests/btrfs/264 |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/tests/btrfs/264 b/tests/btrfs/264
> index b08667a..8eef43b 100755
> --- a/tests/btrfs/264
> +++ b/tests/btrfs/264
> @@ -46,7 +46,7 @@ _supported_fs btrfs
>   _supported_os Linux
>   _require_scratch
>
> -_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
> +_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
>   _scratch_mount
>
>   # Create and save sha256sum
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
