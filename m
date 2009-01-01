Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n019owGf006663 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 03:50:59 -0600
Received: from winston.telenet-ops.be (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F2674577A9
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 01:50:56 -0800 (PST)
Received: from winston.telenet-ops.be (winston.telenet-ops.be
	[195.130.137.75]) by cuda.sgi.com with ESMTP id
	HLOEPBCk5oMGFtQj for <xfs@oss.sgi.com>;
	Thu, 01 Jan 2009 01:50:56 -0800 (PST)
Date: Thu, 1 Jan 2009 10:50:52 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [GIT PULL] XFS update for 2.6.29
In-Reply-To: <20081230030845.A4F0558AE206@chook.melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0901011048090.14380@anakin>
References: <20081230030845.A4F0558AE206@chook.melbourne.sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>, Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, 30 Dec 2008, Lachlan McIlroy wrote:
> The following changes since commit 3c92ec8ae91ecf59d88c798301833d7cf83f2179:
>   Linus Torvalds (1):
>         Merge branch 'next' of git://git.kernel.org/.../paulus/powerpc
> 
> are available in the git repository at:
> 
>   git://oss.sgi.com/oss/git/xfs/xfs.git for-linus

> Christoph Hellwig (91):
>       [XFS] refactor xfs_btree_readahead

On m68k, with CONFIG_LBD=n:

| fs/xfs/xfs_btree.c: In function 'xfs_btree_readahead_lblock':
| fs/xfs/xfs_btree.c:736: warning: comparison is always true due to limited range of data type
| fs/xfs/xfs_btree.c:741: warning: comparison is always true due to limited range of data type

left/right = xfs_fsblock_t (32 or 64 bit), NULLDFSBNO = xfs_dfsbno_t (64 bit)

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
