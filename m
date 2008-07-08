Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Jul 2008 16:18:38 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m68NIZEu011773
	for <xfs@oss.sgi.com>; Tue, 8 Jul 2008 16:18:36 -0700
Received: from gprs189-60.eurotel.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F8A518939C0
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2008 16:19:37 -0700 (PDT)
Received: from gprs189-60.eurotel.cz (gprs189-60.eurotel.cz [160.218.189.60]) by cuda.sgi.com with ESMTP id vrB7FnmjaDKjPjwK for <xfs@oss.sgi.com>; Tue, 08 Jul 2008 16:19:37 -0700 (PDT)
Date: Wed, 9 Jul 2008 01:20:31 +0200
From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080708232031.GE18195@elf.ucw.cz>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz> <20080708231026.GP11558@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708231026.GP11558@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Takashi Sato <t-sato@yk.jp.nec.com>, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, axboe@kernel.dk, mtk.manpages@googlemail.com

On Wed 2008-07-09 09:10:27, Dave Chinner wrote:
> On Mon, Jul 07, 2008 at 01:07:31PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > I still disagree with this whole patch.  There is not reason to let
> > > the freeze request timeout - an auto-unfreezing will only confuse the
> > > hell out of the caller.  The only reason where the current XFS freeze
> > > call can hang and this would be theoretically useful is when the
> > 
> > What happens when someone dirties so much data that vm swaps out
> > whatever process that frozen the filesystem?
> 
> a) you can't dirty a frozen filesystem - by definition a frozen
>    filesystem is a *clean filesystem* and *cannot be dirtied*.

Can you stop me?

mmap("/some/huge_file", MAP_SHARED);

then write to memory mapping?

> b) Swap doesn't write through the filesystem
> c) you can still read from a frozen filesystem to page your
>    executable?? in.

atime modification should mean dirty data, right? And dirty data mean
memory pressure, right? 

> d) if dirtying another unfrozen filesystem swaps out your
                 ~~~~~~~
>    application so it can't run, then there's a major VM bug.
>    Regardless, until the app completes it is relying on the
>    filesystem being frozen, so it better remain frozen....

Agreed. With emphasis on "another".

> > I though that was why the timeout was there...
> 
> Not that I know of. 

Ok, lets see how you deal with mmap.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
