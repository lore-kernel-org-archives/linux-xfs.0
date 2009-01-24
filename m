Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0O3QgnN244586 for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 21:26:42 -0600
Date: Sat, 24 Jan 2009 04:22:10 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [xfs-masters] 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
Message-ID: <20090124032210.GA30366@lst.de>
References: <20090110152803.GA7469@infradead.org>
	<20090110221459.GA8873@orion> <20090111104659.GB8071@disturbed>
	<a4423d670901111648w26e86baajcf7b6d98ff37d043@mail.gmail.com>
	<20090112034550.GI8071@disturbed>
	<a4423d670901120008j728af9cdrbed8bbb938117ea3@mail.gmail.com>
	<20090112211848.GL8071@disturbed>
	<a4423d670901201054t3e48ece2ned4a7e3254250fce@mail.gmail.com>
	<20090120203319.GA7103@infradead.org>
	<a4423d670901231034k6971ed91tbed3d6eab05d7285@mail.gmail.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a4423d670901231034k6971ed91tbed3d6eab05d7285@mail.gmail.com>
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
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, kernel-testers@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jan 23, 2009 at 09:34:36PM +0300, Alexander Beregalov wrote:
> But I do not need LBD. Does XFS strongly require LBD?
> Should I always turn it on even if I do not have files or devices of size 2Tb+ ?

The bug is now fixed in the development tree, but until you upgrade
to a kernel with the fix enabling CONFIG_LBD will keep you from hitting
the bug.

As you unfortunately noticed the !CONFIG_LBD case doesn't really get
much test coverage, so I would personally recommend turning it on even
if you don't need it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
