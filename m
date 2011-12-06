Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6GcpmG241295 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 10:38:51 -0600
Date: Tue, 6 Dec 2011 10:39:13 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 5/4] xfs: fix nfs export of 64-bit inodes numbers on
	32-bit kernels
Message-ID: <20111206163913.GP29840@sgi.com>
References: <20111128081732.350228200@bombadil.infradead.org>
	<20111130085817.GA22471@infradead.org>
	<20111202160712.GO29840@sgi.com>
	<20111202172908.GA10803@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111202172908.GA10803@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Dec 02, 2011 at 12:29:08PM -0500, Christoph Hellwig wrote:
> On Fri, Dec 02, 2011 at 10:07:12AM -0600, Ben Myers wrote:
> > To what extent did you test this one?  Anything in particular I should
> > look for when I test it?
> 
> Create a large filesystem, mount it using -o inode64 on a 32-bit kernel,
> find an inode that actually uses more than 32-bits, and try to access
> it from an nfs client.
> 
> Alternatively you could probably reproduce it using the open by handle
> system calls, I have an idea how to turn that into a test case for
> xfstests using a large loopback filesystem.

I tested this on a pair of i386 boxes with a large loop filesystem and
inode64.  Without the fix I got ESTALE on any inodes > 32 bits, and with
the patch it works great.

Signed-off-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
