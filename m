Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2UJDanD186190 for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 14:13:36 -0500
Message-ID: <4F7605DF.60703@sgi.com>
Date: Fri, 30 Mar 2012 14:13:35 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 7/8] xfs: use blocks for storing the desired IO size
References: <1333023835-12856-1-git-send-email-david@fromorbit.com>
	<1333023835-12856-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1333023835-12856-8-git-send-email-david@fromorbit.com>
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

On 03/29/12 07:23, Dave Chinner wrote:
> Now that we pass block counts everywhere, and index buffers by block
> number and length in units of blocks, convert the desired IO size
> into block counts rather than bytes. Convert the code to use block
> counts, and those that need byte counts get converted at the time of
> use.
>
> Rename the b_desired_count variable to something closer to it's
> purpose - b_io_length - as it is only used to specify the length of
> an IO for a subset of the buffer.  The only time this is used is for
> log IO - both writing iclogs and during log recovery. In all other
> cases, the b_io_length matches b_length, and hence a lot of code
> confuses the two. e.g. the buf item code uses the io count
> exclusively when it should be using the buffer length. Fix these
> apprpriately as they are found.
>
> Also, remove the XFS_BUF_{SET_}COUNT() macros that are just wrappers
> around the desired IO length. They only serve to make the code
> shouty loud, don't actually add any real value, and are often used
> incorrectly.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
