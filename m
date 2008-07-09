Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 13:55:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m69Kt27Y027947
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 13:55:03 -0700
Received: from spitz.ucw.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02F69123BE7A
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 13:55:38 -0700 (PDT)
Received: from spitz.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60]) by cuda.sgi.com with ESMTP id oTWqmD2IiPI2x14m for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 13:55:38 -0700 (PDT)
Date: Wed, 9 Jul 2008 22:44:13 +0200
From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709204412.GG11006@ucw.cz>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz> <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709005254.GQ11558@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Takashi Sato <t-sato@yk.jp.nec.com>, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, axboe@kernel.dk, mtk.manpages@googlemail.com

Hi!

> > > > > I still disagree with this whole patch.  There is not reason to let
> > > > > the freeze request timeout - an auto-unfreezing will only confuse the
> > > > > hell out of the caller.  The only reason where the current XFS freeze
> > > > > call can hang and this would be theoretically useful is when the
> > > > 
> > > > What happens when someone dirties so much data that vm swaps out
> > > > whatever process that frozen the filesystem?
> > > 
> > > a) you can't dirty a frozen filesystem - by definition a frozen
> > >    filesystem is a *clean filesystem* and *cannot be dirtied*.
> > 
> > Can you stop me?
> > 
> > mmap("/some/huge_file", MAP_SHARED);
> > 
> > then write to memory mapping?
> 
> Sure - we can put a hook in ->page_mkwrite() to prevent it.  We
> don't right now because nobody in the real world really cares if one
> half of a concurrent user data change is in the old snapshot or the
> new one......
> 
> > > b) Swap doesn't write through the filesystem
> > > c) you can still read from a frozen filesystem to page your
> > >    executable?? in.
> > 
> > atime modification should mean dirty data, right?
> 
> Metadata, not data. If that's really a problem (and it never has
> been for XFS because we always allow in memory changes to atime)
> then touch_atime could be easily changed to avoid this...
> 
> > And dirty data mean
> > memory pressure, right? 
> 
> If you walk enough inodes while the filesystem is frozen, it
> theoretically could happen.  Typically a filesystem is only for a
> few seconds at a time so in the real world this has never, ever been
> a problem.

So we have freezing interface that does not really freeze, and
that can break the system when filesystem is frozen for too long...
:-(.

Maybe you could use process freezer -- cgroup people are adding
userspace interface to that -- to solve those... but that would mean
stopping everyone but thread doing freezing...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
