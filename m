Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6B3767F3F
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 15:23:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ECFCCAC00D
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 13:22:59 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	QHp2R0EYwYrHSp98 for <xfs@oss.sgi.com>;
	Wed, 17 Dec 2014 13:22:57 -0800 (PST)
Date: Thu, 18 Dec 2014 08:22:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Keep sb_bad_features2 consistent with sb_features2
Message-ID: <20141217212255.GZ24183@dastard>
References: <1418848046-11265-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1418848046-11265-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Wed, Dec 17, 2014 at 09:27:26PM +0100, Jan Kara wrote:
> Currently when we modify sb_features2, we store the same value also in
> sb_bad_features2. However in most places we forget to mark field
> sb_bad_features2 for logging and thus it can happen that a change to it
> is lost. This results in an inconsistent sb_features2 and
> sb_bad_features2 fields e.g. after xfstests test xfs/187.
> 
> Fix the problem by changing XFS_SB_FEATURES2 to actually mean both
> sb_features2 and sb_bad_features2 fields since this is always what we
> want to log. This isn't ideal because the fact that XFS_SB_FEATURES2
> means two fields could cause some problem in future however the code is
> hopefully less error prone that it is now.

Actually, I have patches that fix this differently that I'm planning
to push for the 3.20 cycle.  They get rid of the "update random SB
fields" problem altogether simply by logging and updating the entire
SB every time.

http://oss.sgi.com/archives/xfs/2014-09/msg00448.html

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/libxfs/xfs_format.h | 10 +++++-----
>  fs/xfs/xfs_mount.c         |  5 ++---
>  2 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index fbd6da263571..476273287aaf 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -304,8 +304,8 @@ typedef enum {
>  #define XFS_SB_ICOUNT		XFS_SB_MVAL(ICOUNT)
>  #define XFS_SB_IFREE		XFS_SB_MVAL(IFREE)
>  #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
> -#define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
> -#define XFS_SB_BAD_FEATURES2	XFS_SB_MVAL(BAD_FEATURES2)
> +#define XFS_SB_FEATURES2	(XFS_SB_MVAL(FEATURES2) | \
> +				 XFS_SB_MVAL(BAD_FEATURES2))

That doesn't guarantee that both fields are updated together, just
that the'll get logged and written together. The code still has to
ensure both fields are updated beforehand. I have a patch to address
this as well, and will post them soon.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
