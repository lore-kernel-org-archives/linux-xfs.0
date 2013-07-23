Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 402277F3F
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 13:22:20 -0500 (CDT)
Message-ID: <51EEC9D8.7050005@sgi.com>
Date: Tue, 23 Jul 2013 13:22:16 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 43/49] xfs: return log item size in IOP_SIZE
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-44-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-44-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:25, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> To begin optimising the CIL commit process, we need to have IOP_SIZE
> return both the number of vectors and the size of the data pointed
> to by the vectors. This enables us to calculate the size ofthe
> memory allocation needed before the formatting step and reduces the
> number of memory allocations per item by one.
>
> WhIle there, kill the IOP_SIZE macro.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
