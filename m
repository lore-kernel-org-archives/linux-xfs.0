Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3AJAO7259820 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 05:19:10 -0500
Date: Thu, 3 Nov 2011 06:19:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/8] xfsdump: enable support for multiple streams
Message-ID: <20111103101908.GA8572@infradead.org>
References: <1320268254-20583-1-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320268254-20583-1-git-send-email-wkendall@sgi.com>
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

On Wed, Nov 02, 2011 at 04:10:46PM -0500, Bill Kendall wrote:
> This series resurrects the IRIX multi-stream support for splitting a
> backup among several output files/tapes. This offers some nice
> performance improvements, particularly in xfsrestore where a single
> stream often cannot keep the filesystem/disks busy. I've observed
> a 1.7x improvement on a backup and a 5x improvement on restore.
> 
> I have a couple of xfstests for this, and will submit those once
> a few outstanding xfsdump test patches have been reviewed.

I've put both your two previous xfsdump patches and the all your
xfstests changes into the kernel.org repositories.  They all look
fine to me.

Btw, one thing I'd love to see is a script that uses the userspace
iscsi target (tgt) infrastructure to emulate a tape, and thus allow to
run the tape tests in any VM without requiring a real tape device.

Maybe there is someone on the list feels challenged by this?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
