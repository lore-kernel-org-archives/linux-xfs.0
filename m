Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2HqcVD093127 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 11:52:38 -0600
Date: Fri, 2 Dec 2011 12:29:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/4] xfs: fix nfs export of 64-bit inodes numbers on
	32-bit kernels
Message-ID: <20111202172908.GA10803@infradead.org>
References: <20111128081732.350228200@bombadil.infradead.org>
	<20111130085817.GA22471@infradead.org>
	<20111202160712.GO29840@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111202160712.GO29840@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Dec 02, 2011 at 10:07:12AM -0600, Ben Myers wrote:
> To what extent did you test this one?  Anything in particular I should
> look for when I test it?

Create a large filesystem, mount it using -o inode64 on a 32-bit kernel,
find an inode that actually uses more than 32-bits, and try to access
it from an nfs client.

Alternatively you could probably reproduce it using the open by handle
system calls, I have an idea how to turn that into a test case for
xfstests using a large loopback filesystem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
