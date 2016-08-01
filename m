Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C4B7E7CE0
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 01:33:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 966298F8033
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:33:31 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id mmAuwqCxfYHYfdnB (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:33:30 -0700 (PDT)
Date: Sun, 31 Jul 2016 23:33:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/47] vfs: fix return type of ioctl_file_dedupe_range
Message-ID: <20160801063322.GC15590@infradead.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907696757.25461.13451944377009612990.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907696757.25461.13451944377009612990.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

On Wed, Jul 20, 2016 at 09:56:07PM -0700, Darrick J. Wong wrote:
> All the VFS functions in the dedupe ioctl path return int status, so
> the ioctl handler ought to as well.
> 
> Found by Coverity, CID 1350952.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Nothing to do with rmap, or XFS for that matter.  Please send it
directly to Al.  Otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
