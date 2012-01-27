Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RB2sPo163936 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 05:02:54 -0600
Date: Fri, 27 Jan 2012 06:02:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] xfs: change available ranges in quota check
Message-ID: <20120127110238.GB31093@infradead.org>
References: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
	<20120124174612.GC9853@infradead.org>
	<4F22424E.8070407@hitachi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F22424E.8070407@hitachi.com>
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
To: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>

On Fri, Jan 27, 2012 at 03:21:02PM +0900, HAYASAKA Mitsuo wrote:
> > Can you send a testcase that reproduces issues with the old behaviour?
> > 
> 
> Regarding (1) related to inode reservation, current xfs works well
> because inode is reserved one by one if required.
> 
> For example, when an new inode tries to be reserved in xfs_trans_dqresv(),
> it checks quota as follows.

I'm just curious what the intent behdind the patches was.  They look
good to me, but I wonder why we need to change it at all.

> To make it more general, this check should be the same way as the new
> block quota check introduced in the PATCH 2/3 where the disk block can
> be used up to the block quota limits.

So I guess that's the part we'd want a test case for if possible.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
