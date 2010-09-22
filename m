Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MJvB07081280 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 14:57:11 -0500
Subject: Re: [PATCH 01/16] xfs: reduce the number of CIL lock round trips
	during commit
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1285137869-10310-2-git-send-email-david@fromorbit.com>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-2-git-send-email-david@fromorbit.com>
Date: Wed, 22 Sep 2010 14:57:59 -0500
Message-ID: <1285185479.2211.42.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 2010-09-22 at 16:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When commiting a transaction, we do a lock CIL state lock round trip
> on every single log vector we insert into the CIL. This is resulting
> in the lock being as hot as the inode and dcache locks on 8-way
> create workloads. Rework the insertion loops to bring the number
> of lock round trips to one per transaction for log vectors, and one
> more do the busy extents.
> 
> Also change the allocation of the log vector buffer not to zero it
> as we copy over the entire allocated buffer anyway.
> 
> This patch also includes a structural cleanup to the CIL item
> insertion provided by Christoph Hellwig.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
