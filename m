Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CBB827CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 11:34:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3DD94AC003
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 09:34:44 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 7AMuCt7aQi4mDiLE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 09:34:42 -0700 (PDT)
Date: Tue, 6 Sep 2016 09:34:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 34/71] xfs: support bmapping delalloc extents in the CoW
	fork
Message-ID: <20160906163413.GC16696@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216814006.867.6404376654574855233.stgit@birch.djwong.org>
	<20160906152553.GA9760@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160906152553.GA9760@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 06, 2016 at 08:25:53AM -0700, Christoph Hellwig wrote:
> FYI, this has some major conflicts with the iomap updates - we'll need
> to know from Dave which one should go in first.

While we're combining patches, I think it makes sense to modify
_iomap_write_allocate so that when it's converting a data fork
delalloc reservation into a real extent that it should look for an
adjacent (file offset-wise) real extent in the CoW fork and feed that
to the allocator in the hopes of allocating all the blocks in the same
part of the disk.  Or better yet as one big(ger) extent record.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
