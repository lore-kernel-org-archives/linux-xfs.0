Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Jul 2008 17:52:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m690prDL022137
	for <xfs@oss.sgi.com>; Tue, 8 Jul 2008 17:51:54 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED6D92CBF71
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2008 17:52:58 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id RS5k1zKf9f0E2Mmu for <xfs@oss.sgi.com>; Tue, 08 Jul 2008 17:52:58 -0700 (PDT)
Date: Wed, 9 Jul 2008 10:52:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709005254.GQ11558@disturbed>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz> <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708232031.GE18195@elf.ucw.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pavel Machek <pavel@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Takashi Sato <t-sato@yk.jp.nec.com>, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, axboe@kernel.dk, mtk.manpages@googlemail.com

On Wed, Jul 09, 2008 at 01:20:31AM +0200, Pavel Machek wrote:
> On Wed 2008-07-09 09:10:27, Dave Chinner wrote:
> > On Mon, Jul 07, 2008 at 01:07:31PM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > I still disagree with this whole patch.  There is not reason to let
> > > > the freeze request timeout - an auto-unfreezing will only confuse the
> > > > hell out of the caller.  The only reason where the current XFS freeze
> > > > call can hang and this would be theoretically useful is when the
> > > 
> > > What happens when someone dirties so much data that vm swaps out
> > > whatever process that frozen the filesystem?
> > 
> > a) you can't dirty a frozen filesystem - by definition a frozen
> >    filesystem is a *clean filesystem* and *cannot be dirtied*.
> 
> Can you stop me?
> 
> mmap("/some/huge_file", MAP_SHARED);
> 
> then write to memory mapping?

Sure - we can put a hook in ->page_mkwrite() to prevent it.  We
don't right now because nobody in the real world really cares if one
half of a concurrent user data change is in the old snapshot or the
new one......

> > b) Swap doesn't write through the filesystem
> > c) you can still read from a frozen filesystem to page your
> >    executable?? in.
> 
> atime modification should mean dirty data, right?

Metadata, not data. If that's really a problem (and it never has
been for XFS because we always allow in memory changes to atime)
then touch_atime could be easily changed to avoid this...

> And dirty data mean
> memory pressure, right? 

If you walk enough inodes while the filesystem is frozen, it
theoretically could happen.  Typically a filesystem is only for a
few seconds at a time so in the real world this has never, ever been
a problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
