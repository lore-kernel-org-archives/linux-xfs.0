Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n029wJCI016566 for <xfs@oss.sgi.com>; Fri, 2 Jan 2009 03:58:20 -0600
Received: from wilson.telenet-ops.be (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7AFB1BF92DB
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2009 01:58:17 -0800 (PST)
Received: from wilson.telenet-ops.be (wilson.telenet-ops.be [195.130.132.42])
	by cuda.sgi.com with ESMTP id JyIGrBEzYCbQViKw for
	<xfs@oss.sgi.com>; Fri, 02 Jan 2009 01:58:17 -0800 (PST)
Date: Fri, 2 Jan 2009 10:57:43 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [GIT PULL] XFS update for 2.6.29
In-Reply-To: <20090101170329.GA17892@infradead.org>
Message-ID: <Pine.LNX.4.64.0901021056360.14380@anakin>
References: <20081230030845.A4F0558AE206@chook.melbourne.sgi.com>
	<Pine.LNX.4.64.0901011048090.14380@anakin>
	<20090101170329.GA17892@infradead.org>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, 1 Jan 2009, Christoph Hellwig wrote:
> On Thu, Jan 01, 2009 at 10:50:52AM +0100, Geert Uytterhoeven wrote:
> > | fs/xfs/xfs_btree.c: In function 'xfs_btree_readahead_lblock':
> > | fs/xfs/xfs_btree.c:736: warning: comparison is always true due to limited range of data type
> > | fs/xfs/xfs_btree.c:741: warning: comparison is always true due to limited range of data type
> > 
> > left/right = xfs_fsblock_t (32 or 64 bit), NULLDFSBNO = xfs_dfsbno_t (64 bit)
> 
> Hmm, can't reproduce it here with CONFIG_LBD=n on x86, but the following

x86-32 or -64?

It may also depend on the compiler version. I have gcc version 4.1.2 20061115
(prerelease) (Debian 4.1.1-21).

> patch should fix it:

Yep, the warning is good.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
