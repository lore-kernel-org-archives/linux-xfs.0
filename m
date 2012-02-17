Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HHLY8E098379 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 11:21:34 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	hiJeHnqWBGGZimLV (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 09:21:33 -0800 (PST)
Date: Fri, 17 Feb 2012 12:21:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: skip FSGEOMETRY call in openfile if no geom
	var present
Message-ID: <20120217172132.GB21610@infradead.org>
References: <4F3AAA03.2010305@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F3AAA03.2010305@redhat.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 14, 2012 at 10:37:55AM -0800, Eric Sandeen wrote:
> sendfile_f() calls openfile() with NULL *geom even if it's on an
> xfs filesystem, so we need to skip the ioctl if (!geom).
> 
> Fixes regression from d1b88183bb3fc5e338746db53269310348646753
> 
> Reported-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
