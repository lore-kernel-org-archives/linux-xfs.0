Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7LdBYd077662 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 15:39:11 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3954022903D
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 13:25:32 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	isJRHpVsLnEyeiiH for <xfs@oss.sgi.com>;
	Mon, 07 Nov 2011 13:25:32 -0800 (PST)
Date: Tue, 8 Nov 2011 08:25:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/12] xfstests: add a new test that runs fsstress under
	ENOSPC conditions
Message-ID: <20111107212530.GI5534@dastard>
References: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
	<1320330301-2682-10-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320330301-2682-10-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, aelder@sgi.com, tytso@mit.edu, hch@lst.de, xfs@oss.sgi.com

On Thu, Nov 03, 2011 at 06:24:58PM +0400, Dmitry Monakhov wrote:
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_need_to_be_root
> +
> +umount $SCRATCH_DEV 2>/dev/null
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seq.full 2>&1
> +_scratch_mount

_require_scratch unmounts the SCRATCH_DEV. no need to do it
explicitly. Same for the next new test in the series, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
