Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OI2rvg060986 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 12:02:53 -0600
Date: Tue, 24 Jan 2012 13:02:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: show uuid when mount fails due to duplicate uuid
Message-ID: <20120124180242.GD23671@infradead.org>
References: <20120113055839.12919.98763.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120113055839.12919.98763.stgit@ltc219.sdl.hitachi.co.jp>
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
Cc: Alex Elder <elder@kernel.org>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>

On Fri, Jan 13, 2012 at 02:58:39PM +0900, Mitsuo Hayasaka wrote:
> When a system tries to mount a filesystem (FS) using UUID, the xfs
> returns -EINVAL and shows a message if a FS with the same UUID has
> been already mounted. It is useful to output the duplicate UUID
> with it.

The new version looks fine to me, thanks a lot!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
