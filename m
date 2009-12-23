Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBNDErMT236748 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 07:14:58 -0600
Date: Wed, 23 Dec 2009 08:15:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2]  add lpath_to_handle to libhandle
Message-ID: <20091223131535.GA23394@infradead.org>
References: <4AE08DC7.7000200@sgi.com> <20091024133904.GB23125@infradead.org>
	<4B300B2F.7080305@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B300B2F.7080305@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

> Based on Christoph's suggestion here's a rework of the patch
> (that I've been sitting on for a while). This requires no change
> to the libhandle API and no changes in xfsdump (and hence just
> this one patch. The previously posted patch 2/2 is dropped).

The patch looks good for me from review, but fails to apply probably due
to whitespace damage in the mailer.

One thing that could be changes is to also do the fspath conversion for
block and chacater special files.  While we can open those they will not
end up in the xfs file operations and thus not provide the nessecary
ioctl.


Reviewed-by: Christoph Hellwig <hch@lst.de>


Btw, it would be nice if you could write a testcase for xfstests that
fails with the old version on links but works with the new one.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
