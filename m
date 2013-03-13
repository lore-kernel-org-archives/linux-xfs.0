Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 78E027F4E
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 12:42:52 -0500 (CDT)
Message-ID: <5140BAAC.4050508@sgi.com>
Date: Wed, 13 Mar 2013 12:43:08 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfstests: keep newlines out of SCRATCH_DEV_POOL
References: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
	<1363186623-1378-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1363186623-1378-3-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 03/13/2013 09:57 AM, Eric Sandeen wrote:
> SCRATCH_DEV_POOL processing actually takes the first
> device out for SCRATCH_DEV and leaves the rest in
> SCRATCH_DEV_POOL.
>
> I'm not totally sold on that behavior, but for now,
> at least don't populate SCRATCH_DEV_POOL with newlines.

>
> Cc: linux-btrfs@vger.kernel.org
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>   common.config |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/common.config b/common.config
> index ed0f44c..5ac58bf 100644
> --- a/common.config
> +++ b/common.config
> @@ -258,7 +258,7 @@ if [ ! -z "$SCRATCH_DEV_POOL" ]; then
>           exit 1
>       fi
>       SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
> -    SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | awk '{ for (i = 2; i <= NF; i++) print $i}'`
> +    SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | awk '{ ORS=" "; for (i = 2; i <= NF; i++) print $i}'`
>   fi
>
>   echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
>

Is the purpose of this patch is so future improvements will be able to 
parse/use SCRATCH_DEV_POOL easier from within bash?

Looks good Eric.

Reviewed-by: <rjohnston@sgi.com>

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
