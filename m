Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 45D987CA1
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 09:56:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0B84C304032
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 07:56:27 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id VU3pfBcduJRQ7eic (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 05 Sep 2016 07:56:25 -0700 (PDT)
Date: Mon, 5 Sep 2016 07:56:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] vfs: support FS_XFLAG_REFLINK and FS_XFLAG_COWEXTSIZE
Message-ID: <20160905145622.GB7662@infradead.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
	<147216786073.525.16014208838990530622.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216786073.525.16014208838990530622.stgit@birch.djwong.org>
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
Cc: linux-api@vger.kernel.org, xfs@oss.sgi.com, linux-xfs@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org

On Thu, Aug 25, 2016 at 04:31:00PM -0700, Darrick J. Wong wrote:
> Introduce XFLAGs for the new XFS reflink inode flag and the CoW extent
> size hint, and actually plumb the CoW extent size hint into the fsxattr
> structure.

Just curious, but why would we even bother to expose the reflink flag
to userspace?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
