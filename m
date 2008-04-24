Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Apr 2008 12:44:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3OJiHhC022795
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 12:44:25 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38E2615D37AD
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 12:44:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id w7z6tqgrzaZPrBP8 for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 12:44:58 -0700 (PDT)
Date: Thu, 24 Apr 2008 15:44:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: Tree for April 24
Message-ID: <20080424194457.GA22805@infradead.org>
References: <20080424173626.bcd088e7.sfr@canb.auug.org.au> <Pine.LNX.4.64.0804242136420.21224@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804242136420.21224@anakin>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Apr 24, 2008 at 09:40:15PM +0200, Geert Uytterhoeven wrote:
> On Thu, 24 Apr 2008, Stephen Rothwell wrote:
> > Status of my local build tests will be at
> > http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
> > advice about cross compilers/configs that work, we are always open to add
> > more builds.
> 
> For the second day in a row, m68k builds failed because of
> 
>     fs/xfs/xfs_fsops.c:527: error: implicit declaration of function 'xfs_icsb_sync_counters_locked'
>     make[3]: *** [fs/xfs/xfs_fsops.o] Error 1

Eric already submitted a patch on the xfs list, that should make it to
the tree ASAP.
