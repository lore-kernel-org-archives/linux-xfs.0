Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D40707CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 17:12:51 -0500 (CDT)
Date: Mon, 5 Aug 2013 17:12:51 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 09/12] xfs: fully initialise temp leaf in
	xfs_attr3_leaf_unbalance
Message-ID: <20130805221251.GF3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370607901-11538-10-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:24:58PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_attr3_leaf_unbalance() uses a temporary buffer for recombining
> the entries in two leaves when the destination leaf requires
> compaction. The temporary buffer ends up being copied back over the
> original destination buffer, so the header in the temporary buffer
> needs to contain all the information that is in the destination
> buffer.
> 
> To make sure the temporary buffer is fully initialised, once we've
> set up the temporary incore header appropriately, write is back to
> the temporary buffer before starting to move entries around.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Goes with commit 8517de2a81da830f5d90da66b4799f4040c76dc9

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
