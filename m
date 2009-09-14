Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8E0aU4K000979 for <xfs@oss.sgi.com>; Sun, 13 Sep 2009 19:36:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A80BD1319755
	for <xfs@oss.sgi.com>; Sun, 13 Sep 2009 17:37:42 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	zAWsP6ASDKAvx04n for <xfs@oss.sgi.com>;
	Sun, 13 Sep 2009 17:37:42 -0700 (PDT)
Date: Mon, 14 Sep 2009 10:37:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] [PATCH 5/5] xfs: fix xfs_quiesce_data
Message-ID: <20090914003739.GB6889@discord.disaster>
References: <20090827231558.701516609@bombadil.infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE83ABF5@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABF5@cf--amer001e--3.americas.sgi.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Aug 28, 2009 at 06:18:45PM -0500, Alex Elder wrote:
> Christoph Hellwig wrote:
> > From: Dave Chinner <david@fromorbit.com>
> > 
> > We need to do a synchronous xfs_sync_fsdata to make sure the superblock
> > actually is on disk when we return.
> > 
> > Also remove SYNC_BDFLUSH flag to xfs_sync_inodes because that particular
> > flag is never checked.
> > 
> > Move xfs_filestream_flush call later [hch: why?  seems unrelated].
> 
> I concur with your question.  Why not release the inode references early?

Because if you drop the filestreams references before you write the
data, the data doesn't get put where the filestreams allocator
decided it should go when it created the reference....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
