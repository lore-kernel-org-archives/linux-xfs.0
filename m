Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Sep 2007 21:55:05 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.179])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8A4sw4p027163
	for <xfs@oss.sgi.com>; Sun, 9 Sep 2007 21:54:59 -0700
Received: by wa-out-1112.google.com with SMTP id k22so1554037waf
        for <xfs@oss.sgi.com>; Sun, 09 Sep 2007 21:55:00 -0700 (PDT)
Message-ID: <cc7060690709092154p235e69e3p806e6047fa885bb1@mail.gmail.com>
Date: Mon, 10 Sep 2007 10:24:59 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: [PATCH] remove dead SYNC_BDFLUSH case in xfs_sync_inodes
In-Reply-To: <46E467A1.7030400@sandeen.net>
MIME-Version: 1.0
References: <20070909154220.GC19986@lst.de>
	 <cc7060690709091243y4caab0fat85f189d7ce4d6b31@mail.gmail.com>
	 <46E467A1.7030400@sandeen.net>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Ah, I see. It looks we don't use SYNC_BDFLUSH in xfs_sync_inodes. I believe
we don't
want to flush inodes from xfssync as inodes will be flushed by pdflush,
memory cleaner
threads.  It looks like this code may be valid to other operating systems,
not for linux?

-Saradhi.

On 9/10/07, Eric Sandeen <sandeen@sandeen.net> wrote:
>
> Bhagi rathi wrote:
> > vfs_sync_worker calls with SYNC_BDFLUSH. xfssyncd can call this. I might
> be
> > missing something
> > if this is not used.
> >
> > Thanks,
> > -Saradhi.
>
>
> My eyes glazed over it too, but in xfs_syncsub as hch pointed out to me:
>
>         if (flags & (SYNC_ATTR|SYNC_DELWRI)) {
>                 if (flags & SYNC_BDFLUSH)
>                         xfs_finish_reclaim_all(mp, 1);
>                 else
>                         error = xfs_sync_inodes(mp, flags, bypassed);
>         }
>
> so it won't be called with that flag.
>
> -Eric
>


[[HTML alternate version deleted]]
