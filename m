Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9DFoYut203097 for <xfs@oss.sgi.com>; Sat, 13 Oct 2012 10:50:35 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	1P6UPiOGXBvalFk5 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 13 Oct 2012 08:52:07 -0700 (PDT)
Date: Sat, 13 Oct 2012 11:52:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_quota: XFS_XFLAG_PROJINHERIT is only for dirs
Message-ID: <20121013155205.GA11037@infradead.org>
References: <5078432B.6050501@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5078432B.6050501@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: nscott@redhat.com, Dave Chinner <dchinner@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 12, 2012 at 11:19:55AM -0500, Eric Sandeen wrote:
> xfs_quota has long set XFS_XFLAG_PROJINHERIT on all files,
> and tested for presence on all files.  However, Dave's semi-recent
> xfs_repair update is now flagging this as an error:

I think we should rever that part of the repair patch.  While there
really is not point to have XFS_XFLAG_PROJINHERIT set on non-directory
files we have been setting it for year, so repair should cope with that.

I'd also like to have a test checking that repair does not complain
about XFS_XFLAG_PROJINHERIT being set on a non-directory to verify this.

For the future I'm fine with not setting it on non-directories anymore,
so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

for this patch after a slight update to the commit message.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
