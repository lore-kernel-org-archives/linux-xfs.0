Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 832B97CA0
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 10:46:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3E5F0304048
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 08:46:45 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id FyS9LeyRcwmD2krO (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 08:46:39 -0700 (PDT)
Date: Mon, 21 Mar 2016 08:46:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: support FS_XFLAG_REFLINK and FS_XFLAG_COWEXTSIZE
Message-ID: <20160321154637.GA15069@infradead.org>
References: <20160302235638.GA27962@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160302235638.GA27962@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, xfs@oss.sgi.com

On Wed, Mar 02, 2016 at 03:56:38PM -0800, Darrick J. Wong wrote:
> Introduce XFLAGs for the new XFS reflink inode flag and the CoW extent
> size hint, and actually plumb the CoW extent size hint into the fsxattr
> structure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
