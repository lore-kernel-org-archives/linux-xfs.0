Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 33E677F37
	for <xfs@oss.sgi.com>; Sun, 28 Apr 2013 20:40:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1FC9F304066
	for <xfs@oss.sgi.com>; Sun, 28 Apr 2013 18:40:05 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	yzoAVeBIV2FyfTND for <xfs@oss.sgi.com>;
	Sun, 28 Apr 2013 18:40:04 -0700 (PDT)
Date: Mon, 29 Apr 2013 11:40:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: linux-next: build failure after merge of the xfs tree
Message-ID: <20130429014002.GY10481@dastard>
References: <20130429112943.afdd088c7bb8d80046bdfd2f@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130429112943.afdd088c7bb8d80046bdfd2f@canb.auug.org.au>
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
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ben Myers <bpm@sgi.com>, linux-next@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Apr 29, 2013 at 11:29:43AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the xfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> ERROR: "xfs_dquot_buf_ops" [fs/xfs/xfs.ko] undefined!
> 
> Probably caused by commit 3fe58f30b4fc ("xfs: add CRC checks for quota
> blocks").
> 
> I have used the xfs tree from next-20130426 for today.

CONFIG_XFS_QUOTA=y will fix it.

Or, alternatively, apply this patch:

http://oss.sgi.com/pipermail/xfs/2013-April/025434.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
