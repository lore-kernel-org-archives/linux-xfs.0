Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 494DA801F
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 07:11:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DB01FAC01F
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 05:11:00 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id bljGablGWQ87GbIU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 05:10:56 -0800 (PST)
Message-ID: <52A86458.9030001@oracle.com>
Date: Wed, 11 Dec 2013 21:10:48 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: prevent range.len underflow in xfs_ioc_trim()
References: <1386763525-18584-1-git-send-email-lczerner@redhat.com>
In-Reply-To: <1386763525-18584-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

Hi Lukas,

Thanks for the fix.  We have corrected this problem with the blow patch
which got merged intwo weeks ago. :)
[ commit f9fd013561 ]
xfs: don't perform discard if the given range length is less than block size

That is also discovered by generic/288 you contributed.

Thanks,
-Jeff

On 12/11 2013 20:05 PM, Lukas Czerner wrote:
> Currently when range.len is set to 0 it will underflow. Fix it by
> checking for this scenario and return EINVAL in case range.len is
> smaller than block size.
> 
> This was discovered by the xfstests generic/288 and with this patch
> the problem goes away.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/xfs/xfs_discard.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 8367d6d..9029082 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -180,7 +180,8 @@ xfs_ioc_trim(
>  	 * matter as trimming blocks is an advisory interface.
>  	 */
>  	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks) ||
> -	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)))
> +	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)) ||
> +	    range.len < XFS_FSB_TO_B(mp, 1))
>  		return -XFS_ERROR(EINVAL);
>  
>  	start = BTOBB(range.start);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
