Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2UJDBL8186113 for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 14:13:11 -0500
Message-ID: <4F7605C6.6090506@sgi.com>
Date: Fri, 30 Mar 2012 14:13:10 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 6/8] xfs: use blocks for counting length of buffers
References: <1333023835-12856-1-git-send-email-david@fromorbit.com>
	<1333023835-12856-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1333023835-12856-7-git-send-email-david@fromorbit.com>
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
> From: Dave Chinner<dchinner@redhat.com>
>
> Now that we pass block counts everywhere, and index buffers by block
> number, track the length of the buffer in units of blocks rather
> than bytes. Convert the code to use block counts, and those that
> need byte counts get converted at the time of use.
>
> Also, remove the XFS_BUF_{SET_}SIZE() macros that are just wrappers
> around the buffer length. They onyl serve to make the code shouty
> loud and don't actually add any real value.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
