Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Jul 2008 23:35:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6E6YW4X025542
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2008 23:34:33 -0700
Received: from gprs189-60.eurotel.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7A042EA21C
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2008 23:35:37 -0700 (PDT)
Received: from gprs189-60.eurotel.cz (gprs189-60.eurotel.cz [160.218.189.60]) by cuda.sgi.com with ESMTP id J1HuIoqnsvadFeW1 for <xfs@oss.sgi.com>; Sun, 13 Jul 2008 23:35:37 -0700 (PDT)
Date: Mon, 14 Jul 2008 08:36:17 +0200
From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080714063617.GF31949@elf.ucw.cz>
References: <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed> <20080709110900.GI9957@mit.edu> <20080709114958.GV11558@disturbed> <4874C3E8.20804@hp.com> <20080713120602.GC7517@elf.ucw.cz> <487A383F.50600@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487A383F.50600@hp.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: jim owens <jowens@hp.com>
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Sun 2008-07-13 13:15:43, jim owens wrote:
> Pavel Machek wrote:
>
>>> This means ONLY SOME metadata (or no metadata) is flushed and
>>> then all metadata updates are stopped.  User/kernel writes
>>> to already allocated file pages WILL go to a frozen disk.
>>
>> That's the difference here. They do write file data, and thus avoid
>> mmap()-writes problem.
>>
>> ...and they _still_ provide auto-thaw.
>> 								Pavel
>
> One of the hardest things to make people understand is that
> stopping file data writes in the filesystem during a freeze
> is not just dangerous, it is also __worthless__ unless you
> have a complete "user environment freeze" mechanism.

Eh?

> And unless each independent component has a freeze and they
> can all be coordinated, the data in the pipeline is never
> stable enough to say "if you stop all writes to disk and
> take a snapshot, this is the same as an orderly shutdown,
> backup, restore, and startup".

If you also freeze data writes, at least snapshot is not worse than
_unexpected_ shutdown.

And apps should already be ready for unexpected shutdowns (using fsync
etc).

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
