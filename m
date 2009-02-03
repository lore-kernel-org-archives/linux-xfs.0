Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1389tgl046104 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 02:09:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDC9F18ACEE3
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 00:09:16 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5vhM59peqPcMNb1t for
	<xfs@oss.sgi.com>; Tue, 03 Feb 2009 00:09:16 -0800 (PST)
Date: Tue, 3 Feb 2009 03:09:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for January 2009
Message-ID: <20090203080915.GA8921@infradead.org>
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

January has been an extremely busy month on the userspace front.  Many
smaller and medium updates went into xfsprogs, xfstests and to a lesser
extent xfsdump.  xfsprogs and xfsdump are ramping up for getting a 3.0.0
release out in early February which will include the first major re-sync
with the kernel code in libxfs, a cleanup of the exported library interfaces
and the move of two tools (xfs_fsr and xfs_estimate) from the xfsdump
package to xfsprogs.  After this the xfsprogs package will contain all
tools that use internal libxfs interfaces which fortunately equates to those
needed for normal administration.  The xfsdump package now only contains
the xfsdump/xfsrestore tools needed for backing up and restoring XFS
filesystems.  In addition it grew a fix to support dump/restore on systems
with a 64k page size.  A large number of acl/attr package patches was
posted to the list, but pending a possible split of these packages from the
XFS project these weren't processed yet.

On the kernel side the big excitement in January was an in-memory corruption
introduced in the btree refactoring which hit people running 32bit platforms
without support for large block devices.  This issue was fixed and pushed
to the 2.6.29 development tree after a long collaborative debugging effort
at linux.conf.au.  Besides that about a dozen minor fixes were pushed to
2.6.29 and the first batch of misc patches for the 2.6.30 release cycle
was sent out.

At the end of December the SGI group in Melbourne which the previous
XFS maintainer and some other developers worked for has been closed down
and they will be missed greatly.  As a result maintainership has been passed
on in a way that has been slightly controversial in the community, and the
first patchset of work in progress in Melbourne have been posted to the list
to be picked up by others.

The xfs.org wiki has gotten a little facelift on it's front page making it
a lot easier to read.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
