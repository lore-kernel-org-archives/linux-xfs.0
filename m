Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E5B67F6A
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 14:03:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 18851AC004
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 12:03:44 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XXe4TTZhTKecaZoo for <xfs@oss.sgi.com>;
	Wed, 04 Feb 2015 12:03:37 -0800 (PST)
Date: Thu, 5 Feb 2015 07:02:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/20] xfs: pass a 64-bit count argument to
	xfs_iomap_write_unwritten
Message-ID: <20150204200222.GN4251@dastard>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-17-git-send-email-hch@lst.de>
	<20150129205232.GB11064@fieldses.org>
	<20150202073024.GA9399@lst.de> <20150202192404.GI6282@dastard>
	<20150202194300.GN6282@dastard> <20150204075756.GA763@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150204075756.GA763@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Wed, Feb 04, 2015 at 08:57:56AM +0100, Christoph Hellwig wrote:
> On Tue, Feb 03, 2015 at 06:43:00AM +1100, Dave Chinner wrote:
> > As to the pNFSD specific changes, I haven't really looked them over
> > in any great detail yet. My main concern is that there are no
> > specific regression tests for this yet, I'm not sure how we go about
> > verifying it actually works properly and we don't inadvertantly
> > break it in the future. Christoph?
> 
> Any chance you could review them this week so we can get them
> merged in time for 3.20?  In the worst case Bruce will have to pull
> the xfs tree into the nfsd tree so that we have all the dependencies
> available.

I'm working my way through them. I'm just about to pull in the
growfs transaction patch (missed it last time around), and I try to
have a decent look over the other two patches later today.

I'm not sure I have any bandwidth to test them yet, but perhaps if I
add a one-time message "Experimental feature in use" when the code
is first executed then it will be OK to merge (i.e. process similar
to delayed logging and CRC introduction). Once we've got more
confidence that it's all working properly, then we can remove the
experimental tag from it. Does that sound like a reasonable
approach to take?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
