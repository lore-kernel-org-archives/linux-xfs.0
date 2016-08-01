Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D41637CE0
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 01:33:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A5B0E8F8033
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:33:59 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Zmnp3HFcrA1kyn0W (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:33:58 -0700 (PDT)
Date: Sun, 31 Jul 2016 23:33:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/47] vfs: support FS_XFLAG_REFLINK and
	FS_XFLAG_COWEXTSIZE
Message-ID: <20160801063355.GD15590@infradead.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907697404.25461.4210564656872865210.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907697404.25461.4210564656872865210.stgit@birch.djwong.org>
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

On Wed, Jul 20, 2016 at 09:56:14PM -0700, Darrick J. Wong wrote:
> Introduce XFLAGs for the new XFS reflink inode flag and the CoW extent
> size hint, and actually plumb the CoW extent size hint into the fsxattr
> structure.

This has nothing to do with rmap support, please move it to the reflink
series.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
