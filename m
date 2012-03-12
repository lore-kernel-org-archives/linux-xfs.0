Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2CDUgRb083072 for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 08:30:43 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	2iBprmBe2ghB5fRT (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Mar 2012 06:30:41 -0700 (PDT)
Date: Mon, 12 Mar 2012 09:30:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/10] xfs: remove MS_ACTIVE guard from inode reclaim work
Message-ID: <20120312133040.GF25944@infradead.org>
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
	<1331095828-28742-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1331095828-28742-10-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 07, 2012 at 03:50:27PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We need to be able to queue inode reclaim work during the mount
> process as quotacheck can cause large amounts of inodes to be read
> and we need to clean them up periodically as the shrinkers can not
> run until after the mount process has completed.
> 
> The reclaim work is currently protected from running during the
> unmount process by a check against MS_ACTIVE. Unfortunately, this
> also means that the relcaim work cannot run during mount.  The
> unmount process should stop the reclaim cleanly before freeing
> anything that the reclaim work depends on, so there is no need to
> have this guard in place.
> 
> Also, the inode reclaim work is demand driven, so ther eis no need
> to start it immediately during mount. It will be started the moment
> an inode is queued for reclaim, so qutoacheck will trigger it just
> fine.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
