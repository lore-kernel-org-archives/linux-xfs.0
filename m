Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B80C67CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 03:33:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C21F8F804C
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 01:33:52 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id t3w21qpYuTHZMmIt (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 01:33:49 -0800 (PST)
Date: Mon, 8 Feb 2016 01:33:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] xfs: reinitialise recycled VFS inode correctly
Message-ID: <20160208093348.GE28146@infradead.org>
References: <1454905461-2773-1-git-send-email-david@fromorbit.com>
	<1454905461-2773-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454905461-2773-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 08, 2016 at 03:24:17PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we keep certain on-disk information in the VFS inode rather
> than in a separate XFS specific stucture, we have to be careful of
> the VFS code clearing that information when we re-initialise
> reclaimable cached inodes during lookup. If we don't do this, then
> we lose critical information from the inode and that results in
> corruption being detected.

Might be worth to use future tense here?  Or maybe just fold it
into the next patch.

Either way:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
