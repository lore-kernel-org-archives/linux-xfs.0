Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0QLKKT9165808 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 15:20:20 -0600
Subject: Re: [PATCH 3/8] xfs: speculative delayed allocation uses
	rounddown_power_of_2 badly
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1295945444-29488-4-git-send-email-david@fromorbit.com>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
	<1295945444-29488-4-git-send-email-david@fromorbit.com>
Date: Wed, 26 Jan 2011 15:22:41 -0600
Message-ID: <1296076961.1980.940.camel@doink>
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

On Tue, 2011-01-25 at 19:50 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> rounddown_power_of_2() returns an undefined result when passed a
> value of zero. The specualtive delayed allocation code is doing this
> when the inode is zero length. Hence occasionally the preallocation
> is much, much larger than is necessary (e.g. 8GB for a 270 _byte_
> file). Ensure we don't even pass a zero value to this function so
> the result of preallocation is always the desired size.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
