Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q85GQ8UH086908 for <xfs@oss.sgi.com>; Wed, 5 Sep 2012 11:26:08 -0500
Message-ID: <50477D60.8000604@sgi.com>
Date: Wed, 5 Sep 2012 11:27:12 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 08/10] xfstests: enable large fs testing on ext4
References: <1343291989-14987-1-git-send-email-david@fromorbit.com>
	<1343291989-14987-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291989-14987-9-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/26/2012 03:39 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Now that setting up large filesystem testing on sparse loopback
> devices uses a generic method for filling the filesystem, extent
> support to ext4 filesystems.
>
> ext4 is slightly more complex to fill as it does not support files
> larger than 16TB. Hence a slightly more complex method of using
> multiple smaller files to fill the space is necessary.
>
> WARNING: be prepeared for ext4 to take forever to prepare large
> filesystems as allocation of large amounts of space (especially as
> it approaches ENOSPC) is can take minutes rather than milliseconds
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>   common.rc |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 90 insertions(+)
>

Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
