Return-Path: linux-xfs-owner@vger.kernel.org
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53032 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932076AbeE3T1u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 May 2018 15:27:50 -0400
Date: Wed, 30 May 2018 15:27:48 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 07/12] dm: convert to bioset_init()/mempool_init()
Message-ID: <20180530192747.GA6568@redhat.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
 <20180520222558.7053-8-kent.overstreet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180520222558.7053-8-kent.overstreet@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, colyli@suse.de, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com

On Sun, May 20 2018 at  6:25pm -0400,
Kent Overstreet <kent.overstreet@gmail.com> wrote:

> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> ---
>  drivers/md/dm-bio-prison-v1.c      | 13 ++++---
>  drivers/md/dm-bio-prison-v2.c      | 13 ++++---
>  drivers/md/dm-cache-target.c       | 25 ++++++-------
>  drivers/md/dm-core.h               |  4 +-
>  drivers/md/dm-crypt.c              | 60 ++++++++++++++----------------
>  drivers/md/dm-integrity.c          | 15 ++++----
>  drivers/md/dm-io.c                 | 29 ++++++++-------
>  drivers/md/dm-kcopyd.c             | 22 ++++++-----
>  drivers/md/dm-log-userspace-base.c | 19 +++++-----
>  drivers/md/dm-region-hash.c        | 23 ++++++------
>  drivers/md/dm-rq.c                 |  2 +-
>  drivers/md/dm-snap.c               | 17 ++++-----
>  drivers/md/dm-thin.c               | 32 ++++++++--------
>  drivers/md/dm-verity-fec.c         | 55 +++++++++++++--------------
>  drivers/md/dm-verity-fec.h         |  8 ++--
>  drivers/md/dm-zoned-target.c       | 13 +++----
>  drivers/md/dm.c                    | 53 ++++++++++++--------------
>  17 files changed, 197 insertions(+), 206 deletions(-)

In general I think each of these driver patches in the series needs a
one-line summary in the description, e.g.:
Embed bioset and mempool_t to avoid pointer indirection in the fast IO path.

But that aside, on a code level, I had to double check bioset_exit() is
safe to call even if bioset_init() failed.  AFter confirming it is (and
double checking by chatting with Kent) I like how the code is simpler
(not having to check if the bioset is set before calling it).

Nice job Kent, like you said: mostly mechnical.  But even the changes
that weren't purely mechnical (e.g. passing r to ERR_PTR, rather than
using old hardcode) were fixed up nicely.

Acked-by: Mike Snitzer <snitzer@redhat.com>
