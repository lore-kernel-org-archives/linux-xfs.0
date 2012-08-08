Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q787MA9v221477 for <xfs@oss.sgi.com>; Wed, 8 Aug 2012 02:22:11 -0500
Date: Wed, 8 Aug 2012 09:22:01 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2] xfs: check for possible overflow in xfs_ioc_trim
In-Reply-To: <1343828737-5324-1-git-send-email-tracek@redhat.com>
Message-ID: <alpine.LFD.2.00.1208080909330.19417@localhost>
References: <1343828737-5324-1-git-send-email-tracek@redhat.com>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Tomas Racek <tracek@redhat.com>
Cc: Alex Elder <elder@kernel.org>, open list <linux-kernel@vger.kernel.org>, "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org, Ben Myers <bpm@sgi.com>, lczerner@redhat.com

On Wed, 1 Aug 2012, Tomas Racek wrote:

> Date: Wed,  1 Aug 2012 15:45:37 +0200
> From: Tomas Racek <tracek@redhat.com>
> To: linux-xfs@vger.kernel.org
> Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>,
>     Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
>     "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>,
>     open list <linux-kernel@vger.kernel.org>
> Subject: [PATCH v2] xfs: check for possible overflow in xfs_ioc_trim
> 
> If range.start points behind the filesystem, return invalid value error.
> This fixes possible overflow in
> 
> start = BTOBB(range.start)
> 
> when range.start is nearly ULLONG_MAX.
> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>

The fix looks good to me, but I have one comment bellow.

> ---
>  fs/xfs/xfs_discard.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index f9c3fe3..33d367f 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -179,12 +179,13 @@ xfs_ioc_trim(
>  	 * used by the fstrim application.  In the end it really doesn't
>  	 * matter as trimming blocks is an advisory interface.
>  	 */
> +	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks))
> +		return -XFS_ERROR(EINVAL);
> +
>  	start = BTOBB(range.start);
>  	end = start + BTOBBT(range.len) - 1;
>  	minlen = BTOBB(max_t(u64, granularity, range.minlen));

It seems that we have the same problem here with range.minlen. It
is highly unlikely and stupid from the user space to send minlen of
such size, but it is possible.

Thanks!
-Lukas

>  
> -	if (XFS_BB_TO_FSB(mp, start) >= mp->m_sb.sb_dblocks)
> -		return -XFS_ERROR(EINVAL);
>  	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
>  		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)- 1;
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
