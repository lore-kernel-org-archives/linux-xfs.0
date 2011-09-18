Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IK05W1198281 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:00:05 -0500
Date: Sun, 18 Sep 2011 15:59:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Return -EIO when xfs_vn_getattr() failed
Message-ID: <20110918195957.GA14899@infradead.org>
References: <20110917133838.27791.63070.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110917133838.27791.63070.stgit@ltc219.sdl.hitachi.co.jp>
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
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alex Elder <aelder@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, yrl.pp-manager.tt@hitachi.com

On Sat, Sep 17, 2011 at 10:38:38PM +0900, Mitsuo Hayasaka wrote:
> An attribute of inode can be fetched via xfs_vn_getattr() in XFS.
> Currently it returns EIO, not negative value, when it failed.
> As a result, the system call returns not negative value even though
> an error occured. The stat(2), ls and mv commands cannot handle this
> error and do not work correctly.
> 
> This patch fixes this bug, and returns -EIO, not EIO when an error
> is detected in xfs_vn_getattr().

Indeed.  Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
