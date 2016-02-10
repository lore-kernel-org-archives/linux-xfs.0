Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B99AF7CBC
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 15:45:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 422F1AC006
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 13:45:12 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mD5OlwsfYFHdWXS5 for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 13:45:09 -0800 (PST)
Date: Thu, 11 Feb 2016 08:44:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_nondir_ilock_class lockdep warning
Message-ID: <20160210214452.GO14668@dastard>
References: <201602101953.HEB13075.HFLOOFQVStOJFM@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201602101953.HEB13075.HFLOOFQVStOJFM@I-love.SAKURA.ne.jp>
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
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: xfs@oss.sgi.com

On Wed, Feb 10, 2016 at 07:53:21PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I'm getting xfs_nondir_ilock_class lockdep warning.
> I reported this because google hits little.
> Please reply if this is not a known false positive.

False positive. The XFS inode memory reclaim code will never try to
reclaim (and hence lock) an inode with an active reference. Hence no
deadlock is possible.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
