Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1O7BafJ009688 for <xfs@oss.sgi.com>; Wed, 24 Feb 2010 01:11:36 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B62081CF4217
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2010 23:12:56 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.186]) by cuda.sgi.com with ESMTP id
	E3SEMh6wrgPOswKq for <xfs@oss.sgi.com>;
	Tue, 23 Feb 2010 23:12:56 -0800 (PST)
Date: Tue, 23 Feb 2010 23:12:40 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [patch 0/7] per-bdi flushing model improvements. reiser4
In-Reply-To: <20100222084753.0a5d613c.buchner.johannes@gmx.at>
Message-ID: <alpine.DEB.2.01.1002232307380.28195@bogon.housecafe.de>
References: <201002020255.46920.edward.shishkin@gmail.com>
	<20100202081728.GA2384@infradead.org>
	<4B6843E9.9070600@gmail.com> <20100202194208.GD5733@kernel.dk>
	<5e2ec5ac1002021345g569c743dtc5ccf77cde6738ae@mail.gmail.com>
	<4B68A68C.6030001@gmail.com>
	<20100222084753.0a5d613c.buchner.johannes@gmx.at>
MIME-Version: 1.0
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
To: Johannes Buchner <buchner.johannes@gmx.at>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>, ReiserFS Development List <reiserfs-devel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Ronni Holm-Nielsen <theronni@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, Edward Shishkin <edward.shishkin@gmail.com>

On Mon, 22 Feb 2010 at 08:47, Johannes Buchner wrote:
> It'd be great if someone could solve this, as the reiser4 patch is
> not usable in its current state, with or without my illfated attempts
> to fix it.

FWIW, I'm running Linus' latest -git with refs/heads/reiser4 on top[0], no 
issues during 2.6.33-git so far. Try it, if you don't like 
manually applying patches either :-)

Christian.

[0] http://git.zen-kernel.org/?p=kernel/zen.git;a=shortlog;h=refs/heads/reiser4
-- 
BOFH excuse #275:

Bit rot

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
