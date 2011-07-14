Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6EMVUQ6168915 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 17:31:30 -0500
Date: Thu, 14 Jul 2011 18:31:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: failure mapping nfs fh to inode should return ESTALE
Message-ID: <20110714223126.GA28694@infradead.org>
References: <20110714205036.GA19457@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110714205036.GA19457@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: xfs-masters@oss.sgi.com, linux-nfs@vger.kernel.org, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Thu, Jul 14, 2011 at 04:50:36PM -0400, J. Bruce Fields wrote:
> From: J. Bruce Fields <bfields@redhat.com>
> 
> On xfs exports, nfsd is incorrectly returning ENOENT instead of ESTALE
> on attempts to use a filehandle of a deleted file (spotted with pynfs
> test PUTFH3).  The ENOENT was coming from xfs_iget.

With that you mean the ip->i_d.di_mode checks?  Given that we should
only be bale to get these from NFS or the handle ioctls I suspect just
turning them into ESTALE should be fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
