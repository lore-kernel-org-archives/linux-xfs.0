Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0KKXNnB013693 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 14:33:24 -0600
Date: Tue, 20 Jan 2009 15:33:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [xfs-masters] 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
Message-ID: <20090120203319.GA7103@infradead.org>
References: <20090110143924.GA25900@infradead.org>
	<a4423d670901100709v1e7ce0bfs167547c5001787ac@mail.gmail.com>
	<20090110152803.GA7469@infradead.org>
	<20090110221459.GA8873@orion> <20090111104659.GB8071@disturbed>
	<a4423d670901111648w26e86baajcf7b6d98ff37d043@mail.gmail.com>
	<20090112034550.GI8071@disturbed>
	<a4423d670901120008j728af9cdrbed8bbb938117ea3@mail.gmail.com>
	<20090112211848.GL8071@disturbed>
	<a4423d670901201054t3e48ece2ned4a7e3254250fce@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a4423d670901201054t3e48ece2ned4a7e3254250fce@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Tue, Jan 20, 2009 at 09:54:44PM +0300, Alexander Beregalov wrote:
> Hi
> 
> Is it a new bug?
> It is pre-2.6.29-rc1 kernel, which was supossed to be free of the bug
> "fs_is_ok, file: fs/xfs/xfs_btree.c, line: 3327"

>From the trace it's a post-btree consolidation kernel, so all the bugs
in -rc1 are there, too.  It looks like this is the readahead type
cockup that Geert noticed, so this particular one should be fixed in
-rc2.

I would strongly recommend to just turn on CNFIG_LBD for post-2.6.28
kernels for now as all the problems showing up are without CONFIG_LBD.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
