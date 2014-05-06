Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 542B97FDF
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 03:43:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2EA4D304032
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 01:43:30 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id Ys1asU1TWCkURQyT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 01:43:29 -0700 (PDT)
Date: Tue, 6 May 2014 01:43:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] libxfs kernel infrastructure (was [XFS updates] XFS
	development tree branch, xfs-libxfs-in-kernel-RFC, created.
	xfs-for-linus-3.15-rc2-52-g6579dd8)
Message-ID: <20140506084328.GA30444@infradead.org>
References: <20140506071855.F152E7FBC@oss.sgi.com>
	<20140506075905.GA5421@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140506075905.GA5421@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Getting rid of the need for xfs_mount.h in xfs_ialloc.h xfs_da_format.h
should be simple:

 - inline xfs_make_iptr into the only caller
 - move xfs_icluster_size_fsb to xfs_ialloc.c and just provide a
   prototype for it.
 - the various conversion routines for the directory blocks really
   shouldn't be in xfs_da_format.h anyway as they don't define the
   format.  Just have some other header that requires a version of
   xfs_mount included first.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
