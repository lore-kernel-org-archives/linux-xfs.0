Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 33B587CD3
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 06:41:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C0B74AC001
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 04:41:20 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Gg5RVHS8Sx9lxwQ5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jun 2016 04:41:19 -0700 (PDT)
Date: Fri, 17 Jun 2016 04:41:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 002/119] vfs: support FS_XFLAG_REFLINK and
	FS_XFLAG_COWEXTSIZE
Message-ID: <20160617114117.GF19042@infradead.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612628567.12839.3246258786290141903.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612628567.12839.3246258786290141903.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Thu, Jun 16, 2016 at 06:18:05PM -0700, Darrick J. Wong wrote:
> Introduce XFLAGs for the new XFS reflink inode flag and the CoW extent
> size hint, and actually plumb the CoW extent size hint into the fsxattr
> structure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Should go behind all the updates that are useful without any new
rmap or reflink functionality.  In fact it would be great if you
could send out a series with just those little fixes and cleanups
first.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
