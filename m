Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 05:23:40 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m69CNb9T003374
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 05:23:38 -0700
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35E75189D13C
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 05:24:42 -0700 (PDT)
Received: from thunker.thunk.org (www.church-of-our-saviour.org [69.25.196.31]) by cuda.sgi.com with ESMTP id sVn7BuULP3bwOIVC for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 05:24:42 -0700 (PDT)
Date: Wed, 9 Jul 2008 08:24:01 -0400
From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709122401.GK9957@mit.edu>
References: <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed> <20080709110900.GI9957@mit.edu> <20080709114958.GV11558@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709114958.GV11558@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Arjan van de Ven <arjan@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org, pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Wed, Jul 09, 2008 at 09:49:58PM +1000, Dave Chinner wrote:
> (e) none of the above.  The kernel compilation will appear to pause
> until the filesystem is unfrozen. No other visible effect should
> occur. It will get blocked in a write or filesystem transaction
> because the fs is frozen.

So if the process which froze the filesystem accidentally tries
writing to a log file (or database file containing the backup
information, or whatever) that happens to be on the filesystem that is
frozen, that process will get blocked and you end up in a deadlock;
did I get that right?

						- Ted
