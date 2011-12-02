Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2G6pM3086559 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 10:06:51 -0600
Date: Fri, 2 Dec 2011 10:07:12 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 5/4] xfs: fix nfs export of 64-bit inodes numbers on
	32-bit kernels
Message-ID: <20111202160712.GO29840@sgi.com>
References: <20111128081732.350228200@bombadil.infradead.org>
	<20111130085817.GA22471@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111130085817.GA22471@infradead.org>
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

Hey Christoph,

On Wed, Nov 30, 2011 at 03:58:18AM -0500, Christoph Hellwig wrote:
> The i_ino field in the VFS inode is of type unsigned long and thus can't
> hold the full 64-bit inode number on 32-bit kernels.  We have the full
> inode number in the XFS inode, so use that one for nfs exports.  Note
> that I've also switched the 32-bit file handles types to it, just to make
> the code more consistent and copy & paste errors less likely to happen.
> 
> Reported-by: Guoquan Yang <ygq51@hotmail.com>
> Reported-by: Hank Peng <pengxihan@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

To what extent did you test this one?  Anything in particular I should
look for when I test it?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
