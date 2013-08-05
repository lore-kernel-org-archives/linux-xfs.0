Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E281A7CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 17:16:06 -0500 (CDT)
Date: Mon, 5 Aug 2013 17:16:03 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 10/12] xfs: fully initialise temp leaf in
	xfs_attr3_leaf_compact
Message-ID: <20130805221603.GG3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370607901-11538-11-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:24:59PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_attr3_leaf_compact() uses a temporary buffer for compacting the
> the entries in a leaf. It copies the the original buffer into the
> temporary buffer, then zeros the original buffer completely. It then
> copies the entries back into the original buffer.  However, the
> original buffer has not been correctly initialised, and so the
> movement of the entries goes horribly wrong.
> 
> Make sure the zeroed destination buffer is fully initialised, and
> once we've set up the destination incore header appropriately, write
> is back to the buffer before starting to move entries around.
> 
> While debugging this, the _d/_s prefixes weren't sufficient to
> remind me what buffer was what, so rename then all _src/_dst.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Goes with commit d4c712bcf26a25c2b67c90e44e0b74c7993b5334

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
