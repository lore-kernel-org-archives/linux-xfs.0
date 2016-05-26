Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 65F777CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 03:24:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DD7BFAC005
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 01:24:28 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id XBnfpSsfxtkDFum7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 01:24:26 -0700 (PDT)
Date: Thu, 26 May 2016 01:24:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] reflink: test interaction with swap files
Message-ID: <20160526082423.GC10683@infradead.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
	<146424225618.6278.13884344251723851779.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146424225618.6278.13884344251723851779.stgit@birch.djwong.org>
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
Cc: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, xfs@oss.sgi.com

On Wed, May 25, 2016 at 10:57:36PM -0700, Darrick J. Wong wrote:
> Since none of the current filesystems support reflinked swap files,
> make sure that we prohibit reflinking of swapfiles and swapon of
> reflinked files.

Ah, thanks.  I've actually prepared a patch to fix swapon in the kernel
and was about to start writing test cases for it.  I hope you haven't
also done the kernel work already :)

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
