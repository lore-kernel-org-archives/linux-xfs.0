Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBRECDfE022858 for <xfs@oss.sgi.com>; Mon, 27 Dec 2010 08:12:13 -0600
Date: Tue, 28 Dec 2010 01:13:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: Compare, don't assign in ASSERT() in
	xfs_trans_unreserve_and_mod_sb()
Message-ID: <20101227141357.GC24828@dastard>
References: <alpine.LNX.2.00.1012252110490.10759@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012252110490.10759@swampdragon.chaosbits.net>
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
To: Jesper Juhl <jj@chaosbits.net>
Cc: xfs-masters@oss.sgi.com, Alex Elder <aelder@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sat, Dec 25, 2010 at 09:14:53PM +0100, Jesper Juhl wrote:
> Hi,
> 
> In fs/xfs/xfs_trans.c::xfs_trans_unreserve_and_mod_sb() at the out: label 
> we have this:
> 	ASSERT(error = 0);
> I believe a comparison was intended, not an assignment. If I'm right, the 
> patch below fixes that up.

Already fixed in this patch pending for 2.6.38:

http://git.kernel.org/?p=linux/kernel/git/dgc/xfsdev.git;a=commitdiff;h=831ef3cf682a1f9d8fc7c16dace55137751c0410

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
