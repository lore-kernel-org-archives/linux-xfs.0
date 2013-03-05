Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE2DE8068
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 14:36:15 -0600 (CST)
Date: Tue, 5 Mar 2013 14:36:15 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 07/16] xfs: add CRC checks for quota blocks
Message-ID: <20130305203615.GK22182@sgi.com>
References: <1361755901-12453-1-git-send-email-david@fromorbit.com>
	<1361755901-12453-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1361755901-12453-8-git-send-email-david@fromorbit.com>
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

Hi Dave,

On Mon, Feb 25, 2013 at 12:31:32PM +1100, Dave Chinner wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Use the reserved space in struct xfs_dqblk to store a UUID and a crc
> for the quota blocks.
> 
> [dchinner@redhat.com] Add a LSN field and update for current verifier
> infrastructure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Been over this and it looks fine.

> @@ -897,6 +910,10 @@ xfs_qm_dqiter_bufs(
>  		if (error)
>  			break;
>  
> +		/*
> +		 * XXX(hch): need to figure out if it makes sense to validate
> +		 *	     the CRC here.
> +		 */

What's you're opinion on this?

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
