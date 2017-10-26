Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from LGEAMRELO13.lge.com ([156.147.23.53]:48444 "EHLO
        lgeamrelo13.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750919AbdJZF66 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 01:58:58 -0400
Date: Thu, 26 Oct 2017 14:58:50 +0900
From: Byungchul Park <byungchul.park@lge.com>
Subject: Re: [PATCH v5 9/9] block: Assign a lock_class per gendisk used for
 wait_for_completion()
Message-ID: <20171026055850.GA5594@X58A-UD3R>
References: <1508921765-15396-1-git-send-email-byungchul.park@lge.com>
 <1508921765-15396-10-git-send-email-byungchul.park@lge.com>
 <20171025101328.b6fg32m2oazh3zro@gmail.com>
 <89864125-688d-d3df-a24c-7f335b9a144e@kernel.dk>
 <20171026055046.wjbbua4kx6lw5l2r@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171026055046.wjbbua4kx6lw5l2r@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ingo Molnar <mingo@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, peterz@infradead.org, johan@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, johannes.berg@intel.com, oleg@redhat.com, amir73il@gmail.com, david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, idryomov@gmail.com, kernel-team@lge.com

On Thu, Oct 26, 2017 at 07:50:46AM +0200, Ingo Molnar wrote:
> 
> * Jens Axboe <axboe@kernel.dk> wrote:
> 
> > On 10/25/2017 03:13 AM, Ingo Molnar wrote:
> > > 
> > > * Byungchul Park <byungchul.park@lge.com> wrote:
> > > 
> > >> Darrick posted the following warning and Dave Chinner analyzed it:
> > >>
> > >>> ======================================================
> > >>> WARNING: possible circular locking dependency detected
> > >>> 4.14.0-rc1-fixes #1 Tainted: G        W
> > > 
> > >> Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
> > >> Analyzed-by: Dave Chinner <david@fromorbit.com>
> > >> Signed-off-by: Byungchul Park <byungchul.park@lge.com>
> > >> ---
> > >>  block/bio.c           |  2 +-
> > >>  block/genhd.c         | 10 ++--------
> > >>  include/linux/genhd.h | 22 ++++++++++++++++++++--
> > >>  3 files changed, 23 insertions(+), 11 deletions(-)
> > > 
> > > Ok, this patch looks good to me now, I'll wait to get an Ack or Nak from Jens for 
> > > these changes.
> > > 
> > > Jens: this patch has some dependencies in prior lockdep changes, so I'd like to 
> > > carry it in the locking tree for a v4.15 merge.
> > 
> > Looks fine to me, you can add my reviewed-by and carry it in your tree.
> 
> Thanks Jens!

Thanks all of you.

