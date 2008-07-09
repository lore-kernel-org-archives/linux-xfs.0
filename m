Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 06:53:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m69DrPbG014188
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 06:53:27 -0700
Received: from casper.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0E30123B8F7
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 06:54:28 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by cuda.sgi.com with ESMTP id SrwCghbCY2qy79ko for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 06:54:28 -0700 (PDT)
Date: Wed, 9 Jul 2008 06:53:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709065336.1e5e4d74@infradead.org>
In-Reply-To: <20080709071346.GS11558@disturbed>
References: <20080708231026.GP11558@disturbed>
	<20080708232031.GE18195@elf.ucw.cz>
	<20080709005254.GQ11558@disturbed>
	<20080709010922.GE9957@mit.edu>
	<E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu>
	<20080709061621.GA5260@infradead.org>
	<E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu>
	<20080708234120.5072111f@infradead.org>
	<E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu>
	<20080708235502.1c52a586@infradead.org>
	<20080709071346.GS11558@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org, tytso@mit.edu, pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Wed, 9 Jul 2008 17:13:46 +1000
Dave Chinner <david@fromorbit.com> wrote:

> > one can argue about the need of doing the first 3 steps via a
> > userland loop; it sure sounds like one needs to be really careful
> > to not do any writes to the fs from the app that does snapshots
> > (and that includes doing any syscalls in the kernel that allocate
> > memory.. just because that already could cause unrelated data to be
> > written from inside the app. Not fun.)
> 
> Bloody hell! Doesn't *anyone* understand that a frozen filesystem is
> *clean*? That the process of freezing it ensures all dirty data and
> metadata is written out before the freeze completes? And that once
> frozen, it can't be dirtied until unfrozen?
> 
> That's 3 (or is it 4 - maybe 5 now that I think about it) different
> ppl in 24 hours that have made this same broken argument about
> being unable to write back dirty data on a frozen filesystem......

unless you also freeze the system as a whole (in a 'refrigerator
suspend' way).. the "clean" part is just about a nanosecond long. After
that stuff gets dirty again (you're doing that sendfile to receive more
packets from the FTP upload etc etc).
Sure you can pause those. But there's a real risk that you end up
pausing the app that you want to unfreeze the fs (via the memory
allocation->direct reclaim path). And no, mlock doesn't help.
Especially with delayed allocation, where data writes will cause
metadata activity, this is not just theory.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
