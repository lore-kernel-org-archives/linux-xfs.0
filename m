Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 748407F3F
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 09:48:18 -0500 (CDT)
Date: Thu, 27 Jun 2013 09:48:14 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 01/15] xfs: update mount options documentation
Message-ID: <20130627144814.GM20932@sgi.com>
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
	<1372313099-8121-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372313099-8121-2-git-send-email-david@fromorbit.com>
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

On Thu, Jun 27, 2013 at 04:04:45PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because it's horribly out of date.
> 
> And mark various deprecated options as deprecated and give them a
> removal date.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

Regarding removal of these mount options and sysctls:  initially these all look
pretty reasonable but we need to be very careful here.  I've read some
discussions on lkml that seem to suggest that such interfaces which have been
exported to userspace shouldn't be removed at all.  Not that I want to keep
around a bunch of worn out interfaces...

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
