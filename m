Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 04:09:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m69B91eo021861
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 04:09:01 -0700
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BD602CDD30
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 04:10:04 -0700 (PDT)
Received: from thunker.thunk.org (www.church-of-our-saviour.org [69.25.196.31]) by cuda.sgi.com with ESMTP id CpSTwGGgqfjsrihu for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 04:10:04 -0700 (PDT)
Date: Wed, 9 Jul 2008 07:09:00 -0400
From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709110900.GI9957@mit.edu>
References: <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709071346.GS11558@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Arjan van de Ven <arjan@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org, pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

> 
> Bloody hell! Doesn't *anyone* understand that a frozen filesystem is
> *clean*? That the process of freezing it ensures all dirty data and
> metadata is written out before the freeze completes? And that once
> frozen, it can't be dirtied until unfrozen?

What do you mean by "it can't be diritied until unfrozen".  What
happens if I have a kernel compilation happening on a filesystem which
I am trying to freeze?   Does

(a) the freeze fail (because the checks equivalent to what happens
when you remount a filesystem read-only happen)?

(b) The process gets a kill -9 when it tries to write a file on the
frozen filesystem?

(c) The process gets a kill -STOP when it tries to write
to a file on the frozen filesystem?  

(d) The process won't fail, but just continue to run, filling the page
cache with dirty pages that can't be written out because the
filesystem is frozen?

If the answer is (b) or (c), and if you don't have a timeout, and the
backup process which has frozen the filesystem tries to write to the
filesystem, hilarity will ensue....

> That's 3 (or is it 4 - maybe 5 now that I think about it) different
> ppl in 24 hours that have made this same broken argument about
> being unable to write back dirty data on a frozen filesystem......

It's not a question of writing back dirty data, it's the fact that you
*can't*, leading to the page cache filling up wirth dirty data,
leading eventually to the OOM killer running --- and since the last
time I tried suggesting that if the process holding the file
descriptor freezing the filesystem, that idea got shot down (I see
it's been suggested again), if that happens, there is going to be no
other recovery path other than the Big Red Button.

      	       	    	       	       	   - Ted
