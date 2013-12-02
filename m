Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2520F29DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 17:25:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 066258F808F
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 15:25:09 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7LGyM78FoJm908gx for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 15:25:08 -0800 (PST)
Date: Tue, 3 Dec 2013 10:25:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs: fix iversion handling
Message-ID: <20131202232506.GG10988@dastard>
References: <20131119151707.GA13412@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131119151707.GA13412@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Nov 19, 2013 at 07:17:07AM -0800, Christoph Hellwig wrote:
> Currently notify_change directly updates i_version for size updates,
> which not only is counter to how all other fields are updated through
> struct iattr, but also breaks XFS, which need inode updates to happen
> under its own lock, and synchronized to the structure that gets written
> to the log.
> 
> Remove the update in the common code, and it to btrfs and ext4,
> XFS already does a proper updaste internally and currently gets a
> double update with the existing code.
> 
> IMHO this is 3.13 and -stable material and should go in through the XFS
> tree.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
