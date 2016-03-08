Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3CD907CA0
	for <xfs@oss.sgi.com>; Tue,  8 Mar 2016 01:57:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B19F9AC002
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 23:57:03 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id EPrgimsIyGYXdgcC (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Mar 2016 23:57:02 -0800 (PST)
Date: Mon, 7 Mar 2016 23:57:01 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [NOPATCH v5]: XFS reverse-mapping, reflink, and dedupe support
Message-ID: <20160308075701.GA24365@infradead.org>
References: <20160305011530.GG27973@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160305011530.GG27973@birch.djwong.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Mar 04, 2016 at 05:15:30PM -0800, Darrick J. Wong wrote:
> Soooo... stuff I'm hoping to get upstream for 4.6:
> https://github.com/djwong/linux/tree/for-dave-for-4.6
> https://github.com/djwong/xfsprogs/tree/for-dave-for-4.6
> 
> Stuff I hope to get upstream:
> https://github.com/djwong/xfs-documentation/tree/reflink-devel
> https://github.com/djwong/xfstests/tree/reflink-dev
> 
> Development branch, not for upstream:
> https://github.com/djwong/linux/tree/rmap-reflink-devel
> https://github.com/djwong/xfsprogs/tree/rmap-reflink-devel

I've been testing or-dave-for-4.6 + the increased log reservation for
rmap-reflink-devel for a couple days now and it's doing fine both on
XFS itself, as well as NFS over XFS so far.  Great work!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
