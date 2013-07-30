Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E8DA67CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 16:08:40 -0500 (CDT)
Date: Tue, 30 Jul 2013 16:08:37 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 23/48] xfsprogs: introduce CRC support into mkfs.xfs
Message-ID: <20130730210836.GQ3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-24-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-24-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 10:25:46AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libxfs/xfs_mount.c   |   10 +++--
>  libxfs/xfs_symlink.c |    4 +-
>  mkfs/maxtrres.c      |    4 +-
>  mkfs/xfs_mkfs.c      |  114 ++++++++++++++++++++++++++++++++++++++++----------
>  mkfs/xfs_mkfs.h      |   12 +++---
>  5 files changed, 111 insertions(+), 33 deletions(-)
> 
> diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_mount.c
> index f66f63d..e7e7445 100644
> --- a/libxfs/xfs_mount.c
> +++ b/libxfs/xfs_mount.c
> @@ -369,7 +369,8 @@ xfs_sb_to_disk(
>  
>  static int
>  xfs_sb_verify(
> -	struct xfs_buf	*bp)
> +	struct xfs_buf	*bp,
> +	bool		verbose)

xfs_sb_verify in userspace and xfs_sb_verify in the kernel both have a boolean
arg but they mean different things.  Could get confusing.

Anyway, looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
