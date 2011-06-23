Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5NLx1IQ219077 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 16:59:01 -0500
Subject: Re: [PATCH 1/3] xfs: reset inode per-lifetime state when recycling it
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1308792901-22880-2-git-send-email-david@fromorbit.com>
References: <1308792901-22880-1-git-send-email-david@fromorbit.com>
	<1308792901-22880-2-git-send-email-david@fromorbit.com>
Date: Thu, 23 Jun 2011 16:58:05 -0500
Message-ID: <1308866285.2010.32.camel@doink>
MIME-Version: 1.0
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

On Thu, 2011-06-23 at 11:34 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS inodes has several per-lifetime state fields that determine the
> behaviour of the inode. These state fields are not all reset when an
> inode is reused from the reclaimable state.
> 
> This can lead to unexpected behaviour of the new inode such as
> speculative preallocation not being truncated away in the expected
> manner for local files until the inode is subsequently truncated,
> freed or cycles out of the cache. It can also lead to an inode being
> considered to be a filestream inode or having been truncated when
> that is not the case.
> 
> Rework the reinitialisation of the inode when it is recycled to
> ensure that it is pristine before it is reused. While there, also
> fix the resetting of state flags in the recycling error paths so the
> inode does not become unreclaimable.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
