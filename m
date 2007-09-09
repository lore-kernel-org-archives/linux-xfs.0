Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Sep 2007 14:37:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l89LbY4p032297
	for <xfs@oss.sgi.com>; Sun, 9 Sep 2007 14:37:37 -0700
Message-ID: <46E467A1.7030400@sandeen.net>
Date: Sun, 09 Sep 2007 16:37:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] remove dead SYNC_BDFLUSH case in xfs_sync_inodes
References: <20070909154220.GC19986@lst.de> <cc7060690709091243y4caab0fat85f189d7ce4d6b31@mail.gmail.com>
In-Reply-To: <cc7060690709091243y4caab0fat85f189d7ce4d6b31@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Bhagi rathi wrote:
> vfs_sync_worker calls with SYNC_BDFLUSH. xfssyncd can call this. I might be
> missing something
> if this is not used.
> 
> Thanks,
> -Saradhi.


My eyes glazed over it too, but in xfs_syncsub as hch pointed out to me:

        if (flags & (SYNC_ATTR|SYNC_DELWRI)) {
                if (flags & SYNC_BDFLUSH)
                        xfs_finish_reclaim_all(mp, 1);
                else
                        error = xfs_sync_inodes(mp, flags, bypassed);
        }

so it won't be called with that flag.

-Eric
