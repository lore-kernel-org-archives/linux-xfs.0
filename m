Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4RKBeWt208876 for <xfs@oss.sgi.com>; Wed, 27 May 2009 15:11:41 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 321332B4063
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 13:11:54 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id WlHhA7PaV0t1PGzn for <xfs@oss.sgi.com>;
	Wed, 27 May 2009 13:11:54 -0700 (PDT)
Message-ID: <4A1D9E80.4030606@sandeen.net>
Date: Wed, 27 May 2009 15:11:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/7] xfs: split inode flushing from xfs_sync_inodes_ag
References: <20090514171233.942489000@bombadil.infradead.org>	<20090514171558.298098000@bombadil.infradead.org>	<4A1C54FB.2080705@sandeen.net>
	<20090527105841.GA10545@infradead.org>
In-Reply-To: <20090527105841.GA10545@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Tue, May 26, 2009 at 03:45:47PM -0500, Eric Sandeen wrote:
>> What happened to the XFS_IFLUSH_DELWRI case?
>>
>> You mentioned "keep the current behavior exactly" but this seems like a
>> change, no?
> 
> Yeah, this got lost when playing with variations of the patch.  Correct
> version below:
> 
> Subject: xfs: split inode flushing from xfs_sync_inodes_ag
> From: Christoph Hellwig <hch@lst.de>
> 
> 
> In many cases we only want to sync inode metadata. Split out the inode
> flushing into a separate helper to prepare factoring the inode sync code.
> 
> Based on a patch from Dave Chinner, but redone to keep the current behaviour
> exactly and leave changes to the flushing logic to another patch.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
