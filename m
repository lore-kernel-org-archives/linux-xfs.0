Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C235F7CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 10:29:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 911628F8033
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 08:29:53 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id r5qbwrPu8OgQFcOe (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 08:29:51 -0700 (PDT)
Date: Tue, 6 Sep 2016 08:29:48 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 67/71] xfs: fail ->bmap for reflink inodes
Message-ID: <20160906152948.GB9760@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216835350.867.14512964799631563964.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216835350.867.14512964799631563964.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Aug 25, 2016 at 04:39:13PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Have xfs_vm_bmap return zero for reflinked files.  This hack prevents
> using a file with shared blocks as a swap file, because we don't want
> to deal with CoW when we're (probably) low on memory.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [darrick.wong@oracle.com: add a more descriptive changelog]

Which happens to be incorrect :)  The swap code uses ->bmap to build
a logical to physical block map at swapon time (to avoid allocations
or even just block mappings under memory pressure I suspect).  This
means we'd get reliable data corruption when COWing a swap file.

> +	 * The swap code (ab-)uses ->bmap to get a block mapping and then
> +	 * bypasse?? the file system for actual I/O.  We really can't allow

Also it seems like I introduced some weird character instead of an
"s" here..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
