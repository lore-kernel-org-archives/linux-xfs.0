Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8DF2B7CA6
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 10:06:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 55961304039
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 08:06:32 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id trqTmPxby6FDGKJs (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 May 2016 08:06:29 -0700 (PDT)
Date: Mon, 23 May 2016 08:06:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_db: defang frag command
Message-ID: <20160523150628.GA27209@infradead.org>
References: <2d21b9ba-6db7-e239-3be8-a7bd5e1c39cc@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2d21b9ba-6db7-e239-3be8-a7bd5e1c39cc@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, May 11, 2016 at 02:41:28PM -0500, Eric Sandeen wrote:
> Too many people freak out about this fictitious "fragmentation
> factor."  As shown in the fact, it is largely meaningless, because
> the number approaches 100% extremely quickly for just a few
> extents per file.
> 
> I thought about removing it altogether, but perhaps a note
> about its uselessness, and a more soothing metric (avg extents
> per file) might be useful.

Heh.  Looks reasonable:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
