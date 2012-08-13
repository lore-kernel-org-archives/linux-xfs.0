Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7D9FIvd243166 for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 04:15:21 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	i8EBkEymCivPVmid (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Aug 2012 02:15:17 -0700 (PDT)
Date: Mon, 13 Aug 2012 05:15:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for July 2012
Message-ID: <20120813091517.GA27609@infradead.org>
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

July saw the release of Linux 3.5, which included an average sized XFS
update:

    81 files changed, 2633 insertions(+), 3004 deletions(-)

Noteworthy updates in Linux 3.5 include the removal of the xfsbufd
background thread which writes metadata buffers, background processing
of CIL flushes and thus lower average latency for metadata heavy
workloads, as well a a reduction of lock hold times and frequency during
reads and writes.  The large XFS update for the Linux 3.6 merge window
did not get merged yet by the end of July, but will bring better support
for large directory block sizes, a faster inode allocator and a large
amount of bug fixes in different areas of the code.  Development on the list
has been fairly busy on the patchsets to support group and project quotas
at the same time, as well as improved SEEK_HOLE/SEEK_DATA support but
otherwise mostly limited to bug fixes and smaller cleanups.

Userpace development has been rather slow with a single fix for xfs_db
and another single fix in xfstests.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
