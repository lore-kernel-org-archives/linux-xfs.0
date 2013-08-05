Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 098DA7CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 16:54:36 -0500 (CDT)
Date: Mon, 5 Aug 2013 16:54:35 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 05/12] xfs: remote attribute allocation may be contiguous
Message-ID: <20130805215435.GB3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370607901-11538-6-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 10:24:54PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When CRCs are enabled, there may be multiple allocations made if the
> headers cause a length overflow. This, however, does not mean that
> the number of headers required increases, as the second and
> subsequent extents may be contiguous with the previous extent. Hence
> when we map the extents to write the attribute data, we may end up
> with less extents than allocations made. Hence the assertion that we
> consume th enumber of headers we calculated in the allocation loop
> is incorrect and needs to be removed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Goes with commit 90253cf142469a40f89f989904abf0a1e500e1a6

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
