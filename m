Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMExtB4028305 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:59:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBA273ED61
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 06:59:46 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7ky0azpnlH1oJt6D for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 06:59:46 -0800 (PST)
Date: Mon, 22 Dec 2008 09:59:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: random cleanups of xfs_swap_extents
Message-ID: <20081222145946.GB18859@infradead.org>
References: <20081107230054.GH26208@josefsipek.net>
	<20081112100958.GB32567@infradead.org>
	<20081112153903.GE27125@josefsipek.net>
	<20081222130202.GB12367@infradead.org>
	<20081222145825.GY15407@josefsipek.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081222145825.GY15407@josefsipek.net>
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
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: Christoph Hellwig <hch@infradead.org>, XFS Mailing List <xfs@oss.sgi.com>

On Mon, Dec 22, 2008 at 09:58:25AM -0500, Josef 'Jeff' Sipek wrote:
> On Mon, Dec 22, 2008 at 08:02:02AM -0500, Christoph Hellwig wrote:
> > On Wed, Nov 12, 2008 at 10:39:03AM -0500, Josef 'Jeff' Sipek wrote:
> > > > With the one case that does a trans_cancel with partially unlocked
> > > > inodes handcoding most of it.
> > > 
> > > Ok, I'll do that.
> > 
> > Did you manage to actually do it? :)
> 
> I did, I just didn't have time to run it through xfsqa (well, set up a test
> box for xfsqa). Use at your own risk :)

Thanks, I'll throw it into my QA queue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
