Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7SE1vxS104152 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 09:01:57 -0500
Message-ID: <503CCF8F.8070806@sgi.com>
Date: Tue, 28 Aug 2012 09:02:55 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 07/10] xfstests: always us test option when checking large
	scratch device
References: <1343291989-14987-1-git-send-email-david@fromorbit.com>
	<1343291989-14987-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291989-14987-8-git-send-email-david@fromorbit.com>
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
> Some tests call _check_scratch_device directly and when using a
> large filesystem this needs to run with a -t option to avoid
> consuming large amounts of memory. Make this happen in all cases
> that the scratch device is checked.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>   017       |    7 ++-----
>   common.rc |    2 ++
>   2 files changed, 4 insertions(+), 5 deletions(-)
>


Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
