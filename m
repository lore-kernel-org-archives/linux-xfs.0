Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Jul 2008 16:09:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m68N9Sv7010767
	for <xfs@oss.sgi.com>; Tue, 8 Jul 2008 16:09:29 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 376772CBA3B
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2008 16:10:31 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id RlLskAlZCcxGzkOz for <xfs@oss.sgi.com>; Tue, 08 Jul 2008 16:10:31 -0700 (PDT)
Date: Wed, 9 Jul 2008 09:10:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080708231026.GP11558@disturbed>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080707110730.GG5643@ucw.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pavel Machek <pavel@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Takashi Sato <t-sato@yk.jp.nec.com>, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, axboe@kernel.dk, mtk.manpages@googlemail.com

On Mon, Jul 07, 2008 at 01:07:31PM +0200, Pavel Machek wrote:
> Hi!
> 
> > I still disagree with this whole patch.  There is not reason to let
> > the freeze request timeout - an auto-unfreezing will only confuse the
> > hell out of the caller.  The only reason where the current XFS freeze
> > call can hang and this would be theoretically useful is when the
> 
> What happens when someone dirties so much data that vm swaps out
> whatever process that frozen the filesystem?

a) you can't dirty a frozen filesystem - by definition a frozen
   filesystem is a *clean filesystem* and *cannot be dirtied*.
b) Swap doesn't write through the filesystem
c) you can still read from a frozen filesystem to page your
   executableѕ in.
d) if dirtying another unfrozen filesystem swaps out your
   application so it can't run, then there's a major VM bug.
   Regardless, until the app completes it is relying on the
   filesystem being frozen, so it better remain frozen....

> I though that was why the timeout was there...

Not that I know of. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
