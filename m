Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p27ILfvF172418 for <xfs@oss.sgi.com>; Mon, 7 Mar 2011 12:21:42 -0600
Date: Mon, 7 Mar 2011 13:24:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] xfsprogs: sync up with 2.6.38 kernel code V2
Message-ID: <20110307182431.GA3527@infradead.org>
References: <1294649091-27174-1-git-send-email-david@fromorbit.com>
	<20110214063042.GL2559@dastard> <1299521684.2578.457.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299521684.2578.457.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Mar 07, 2011 at 12:14:44PM -0600, Alex Elder wrote:
> 3) Why are you dropping the use of the symbols
>    XFS_DINODE_VERSION_1 and XFS_DINODE_VERSION_2 in
>   favor of just using 1 and 2?  (I guess I'm OK with
>   it, but wanted to call it out anyway.)

Because we dropped them from the kernel a while ago.  The removal
in kernel land was my patch and the reason is that it simply doesn't buy
anything over using the numerical constants.

> - XFS_IOC_FREEZE and XFS_IOC_THAW are still defined in
>   this version.  The code that uses it here could possibly
>   be converted to use the Linux generic FIFREEZE and FITHAW
>   instead.

That would require all users to include <linux/fs.h> first.  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
