Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B86B67CBB
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 03:45:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B2BAAC007
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 01:45:28 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id grZjdv4Od6z8yVWg (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Mar 2016 01:45:21 -0800 (PST)
Date: Wed, 2 Mar 2016 01:45:20 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix computation of inode btree maxlevels
Message-ID: <20160302094520.GA18130@infradead.org>
References: <20160302050930.GD27973@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160302050930.GD27973@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 01, 2016 at 09:09:30PM -0800, Darrick J. Wong wrote:
> Commit 88740da18[1] introduced a function to compute the maximum
> height of the inode btree back in 1994.  Back then, apparently, the
> freespace and inode btrees shared the same geometry; however, it has
> long since been the case that the inode and freespace btrees have
> different record and key sizes.

I think that's always been the case, so this has been buggy since
day one.  Congrat for gfinding one of the probably oldest bugs so far!

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
