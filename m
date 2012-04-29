Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3TLwVED163213 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 16:58:31 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	LANm9DJRFnbnLuhJ (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 14:58:30 -0700 (PDT)
Date: Sun, 29 Apr 2012 17:58:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/3] xfs: make largest supported offset less shouty
Message-ID: <20120429215830.GQ19889@infradead.org>
References: <1335519922-14371-1-git-send-email-david@fromorbit.com>
	<20120429125729.GU9541@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120429125729.GU9541@dastard>
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

On Sun, Apr 29, 2012 at 10:57:29PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS_MAXIOFFSET() is just a simple macro that resolves to
> mp->m_maxioffset. It doesn't need to exist, and it just makes the
> code unnecessarily loud and shouty.
> 
> Make it quiet and easy to read.

Do we actually need to keep around a value in our superblock?
s_maxbytes in the VFS superblock already does this, and it seems like
at least our checks in the read path are superflous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
