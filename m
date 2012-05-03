Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q43JgCAH195650 for <xfs@oss.sgi.com>; Thu, 3 May 2012 14:42:12 -0500
Message-ID: <4FA2DF94.2050805@sgi.com>
Date: Thu, 03 May 2012 14:42:12 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 07/10] xfs: support discontiguous buffers in the
	xfs_buf_log_item
References: <1335249220-22274-1-git-send-email-david@fromorbit.com>
	<1335249220-22274-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1335249220-22274-8-git-send-email-david@fromorbit.com>
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

On 04/24/12 01:33, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
>> From the perspective of the log, we need to keep each segment of a
> discontigous buffer in separate buffer format structures. This means log
> recovery will recover all the changes on a per segment basis without
> requiring any knowledge of the fact that it was logged from a
> compound buffer.
>
> To do this, we need to be able to determine what buffer segment any
> given offset into the compound buffer sits over. This enables us to
> translate the dirty bitmap in the number of separate buffer format
> structures required.
>
> We also need to be able to determine the number of bitmap elements
> that a given buffer segment has, as this determines the size of the
> buffer format structure. Hence we need to be able to determine the
> both the start offset into the buffer and the length of a given
> segment to be able to calculate this.
>
> With this information, we can preallocate, build and format the
> correct log vector array for each segment in a compound buffer to
> appear exactly the same as individually logged buffers in the log.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
