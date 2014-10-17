Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 765887F3F
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2014 04:38:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 05696AC005
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2014 02:38:44 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id lwCKkSliLf1u8rvr (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Oct 2014 02:38:42 -0700 (PDT)
Date: Fri, 17 Oct 2014 02:38:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: splice read/write pipe lock ordering issues (was Re: XFS lockdep
	with Linux v3.17-5503-g35a9ad8af0bb)
Message-ID: <20141017093836.GB9146@infradead.org>
References: <CA+5PVA4FqAUXbtTtC-hZnAaw=869kfrAjM1vRrqcP=zgveAKJg@mail.gmail.com>
	<20141016221434.GF7169@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141016221434.GF7169@dastard>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Josh Boyer <jwboyer@fedoraproject.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org

On Fri, Oct 17, 2014 at 09:14:34AM +1100, Dave Chinner wrote:
> That smells like a splice architecture bug. splice write puts the
> pipe lock outside the inode locks, but splice read puts the pipes
> locks *inside* the inode locks.
> 
> The recent commit 8d02076 "(->splice_write() via ->write_iter()")
> which went into 3.16 will be what is causing this. It replaced a
> long standing splice lock inversion problem (XFS iolock vs i_mutex
> http://oss.sgi.com/archives/xfs/2011-08/msg00122.html) by moving
> to a ->write_iter call under the pipe_lock.
> 
> Only XFS reports this issue because XFS is the only filesystem that
> serialises splice reads against truncate, concurrent writes into the
> same region, extent manipulation functions via fallocate() (e.g.
> hole punch), etc. and it does so via the inode iolock that it takes
> in shared (read) mode during xfs_file_splice_read().

Actually ocfs2 and nfs will have the same issue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
