Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9DLKqbW255412 for <xfs@oss.sgi.com>; Sat, 13 Oct 2012 16:20:52 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id pOEym3CSk22ssE9j for <xfs@oss.sgi.com>;
	Sat, 13 Oct 2012 14:22:26 -0700 (PDT)
Message-ID: <5079DB90.2000709@sandeen.net>
Date: Sat, 13 Oct 2012 16:22:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_quota: XFS_XFLAG_PROJINHERIT is only for dirs
References: <5078432B.6050501@redhat.com>
	<20121013155205.GA11037@infradead.org>
In-Reply-To: <20121013155205.GA11037@infradead.org>
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
Cc: nscott@redhat.com, xfs-oss <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>

On 10/13/12 10:52 AM, Christoph Hellwig wrote:
> On Fri, Oct 12, 2012 at 11:19:55AM -0500, Eric Sandeen wrote:
>> xfs_quota has long set XFS_XFLAG_PROJINHERIT on all files,
>> and tested for presence on all files.  However, Dave's semi-recent
>> xfs_repair update is now flagging this as an error:
> 
> I think we should rever that part of the repair patch.  While there
> really is not point to have XFS_XFLAG_PROJINHERIT set on non-directory
> files we have been setting it for year, so repair should cope with that.
> 
> I'd also like to have a test checking that repair does not complain
> about XFS_XFLAG_PROJINHERIT being set on a non-directory to verify this.

Ok, seems reasonable.  Presumably I'd need to remove my change
to check_project() as well.  I should probably send V2, then.

Kind of amazing that this was missed for so long ;)

Thanks,
-Eric

> For the future I'm fine with not setting it on non-directories anymore,
> so:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> for this patch after a slight update to the commit message.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
