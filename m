Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6ODf1hp115495 for <xfs@oss.sgi.com>; Tue, 24 Jul 2012 08:41:01 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	JowpNuyYcKUu9T3p (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jul 2012 06:41:00 -0700 (PDT)
Date: Tue, 24 Jul 2012 09:40:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for June 2012
Message-ID: <20120724134059.GA25901@infradead.org>
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

June has been a pretty slow month for XFS in Linus tree, as June saw the
stabilization of the Linux 3.5 and thus only a handful of important XFS
fixes.  Development of the tree destined for the next merge window has been
a bit more busy with the addition of discontinuous buffers that replace the
dabuf layer which has performance issues and isn't easy to deal with in the
upcoming metadata checksumming as well as a few smaller cleanups.

The list saw various other patches not applied yet, most notable a
refactoring and speedup of the inode allocator, and a heavily discussed
rewrite of the mount option parsing.

On the user space side a small number of fixes to the handling of fragmented
directories were applied to xfs_repair, and xfstests saw a fix for handling
different versions of xfsdump.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
