Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7GJGUiL181648 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 14:16:30 -0500
Message-ID: <502D4719.9030906@sgi.com>
Date: Thu, 16 Aug 2012 14:16:41 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] xfstests: speed up 227 by using preallocation
References: <1343291706-14882-1-git-send-email-david@fromorbit.com>
	<1343291706-14882-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291706-14882-5-git-send-email-david@fromorbit.com>
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

On 07/26/2012 03:35 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Test 227 (fsr test) creates fragmented fre space by doing lots of
> small writes to sparse offsets ni a file. This seeks the disk heads
> around a lot writing data. We don't need to write data - just
> trigger allocation. Hence use preallocation instead of data writes
> and run at allocation speed rather than data write speed.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>   227 |   46 +++++++++++++++++++++++++++++++++-------------
>   1 file changed, 33 insertions(+), 13 deletions(-)

Looks good to me.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
