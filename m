Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6CGZVtF038819 for <xfs@oss.sgi.com>; Mon, 12 Jul 2010 11:35:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EAB0815BCA9D
	for <xfs@oss.sgi.com>; Mon, 12 Jul 2010 09:44:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DlHDt3rRoEzvlHFn for
	<xfs@oss.sgi.com>; Mon, 12 Jul 2010 09:44:26 -0700 (PDT)
Date: Mon, 12 Jul 2010 12:38:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for June 2010
Message-ID: <20100712163826.GA17164@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

The month of June saw a few important bug fixes for the Linux 2.6.35
release candidates.  That includes ensuring that files used for the
swapext ioctl are writable to the user, and doing proper validation
of inodes coming from untrusted sources, such as NFS exporting and
the open by handle system calls.  The main work however has been
focused on development for the Linux 2.6.36 merge window, including
merging various patches that have been out on the mainline list
for a long time.  Highlights include further performance improvements
for sync heavy metadata workloads, stack space reduction in the
writeback path and improvements of the XFS tracing infrastructure.
Also after some discussion the remaining hooks for DMAPI are going
to be dropped in mainline.   As a replacement a tree containing
full DMAPI support with a slightly cleaner XFS interaction will be
hosted by SGI.

On the userspace side June was a rather slow month, with no updates
to xfsprogs and xfsdump at all, and just one new test case and a cleanup
applied to xfstests.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
