Return-Path: <xfs-bounces@oss.sgi.com>
Subject: Re: [PATCH] Return -EIO when xfs_vn_getattr() failed
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110917133838.27791.63070.stgit@ltc219.sdl.hitachi.co.jp>
References: <20110917133838.27791.63070.stgit@ltc219.sdl.hitachi.co.jp>
Date: Mon, 19 Sep 2011 11:54:37 -0500
Message-ID: <1316451277.2941.30.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sat, 2011-09-17 at 22:38 +0900, Mitsuo Hayasaka wrote:
> An attribute of inode can be fetched via xfs_vn_getattr() in XFS.
> Currently it returns EIO, not negative value, when it failed.
> As a result, the system call returns not negative value even though
> an error occured. The stat(2), ls and mv commands cannot handle this
> error and do not work correctly.
> 
> This patch fixes this bug, and returns -EIO, not EIO when an error
> is detected in xfs_vn_getattr().
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Cc: Alex Elder <aelder@sgi.com>
> Cc: Christoph Hellwig <hch@infradead.org>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
