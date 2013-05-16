Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B93E67F53
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 07:34:27 -0500 (CDT)
Message-ID: <5194D273.80202@sgi.com>
Date: Thu, 16 May 2013 07:34:59 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfstests: quota not supported on realtime filesystems
References: <1368062501-15046-1-git-send-email-david@fromorbit.com>
	<1368062501-15046-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1368062501-15046-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/08/2013 08:21 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Realtime XFS filesystems do not support quotas, so quota tests
> always fail on such filesystems. Add a check to _require_quota to
> detect this situation and notrun the quota tests...
>
> Also, fix _require_xfs_quota and _require_prjquota to have the same
> checks.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

This patch has been committed:

commit 4e787f8fd42fdfdc6e988a8667119a21ab3b194e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 16 06:52:05 2013 -0500

     xfstests: quota not supported on realtime filesystems

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
