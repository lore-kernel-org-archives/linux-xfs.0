Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Apr 2008 12:40:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3OJddJE022393
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 12:39:47 -0700
Received: from wilson.telenet-ops.be (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F2B27AC492E
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 12:40:18 -0700 (PDT)
Received: from wilson.telenet-ops.be (wilson.telenet-ops.be [195.130.132.42]) by cuda.sgi.com with ESMTP id dE7WSBnXIHAsv8Rh for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 12:40:18 -0700 (PDT)
Date: Thu, 24 Apr 2008 21:40:15 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next: Tree for April 24
In-Reply-To: <20080424173626.bcd088e7.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0804242136420.21224@anakin>
References: <20080424173626.bcd088e7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, 24 Apr 2008, Stephen Rothwell wrote:
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.

For the second day in a row, m68k builds failed because of

    fs/xfs/xfs_fsops.c:527: error: implicit declaration of function 'xfs_icsb_sync_counters_locked'
    make[3]: *** [fs/xfs/xfs_fsops.o] Error 1

According to
http://www.linux.sgi.com/archives/xfs/2008-03/msg00202.html, there's a
forward declaration for xfs_icsb_sync_counters_locked() only if HAVE_PERCPU_SB
is defined, i.e. for CONFIG_SMP. This break UP architectures.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
