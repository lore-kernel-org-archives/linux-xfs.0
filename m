Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:45707 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932228AbdJYKNc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 06:13:32 -0400
Date: Wed, 25 Oct 2017 12:13:28 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v5 9/9] block: Assign a lock_class per gendisk used for
 wait_for_completion()
Message-ID: <20171025101328.b6fg32m2oazh3zro@gmail.com>
References: <1508921765-15396-1-git-send-email-byungchul.park@lge.com>
 <1508921765-15396-10-git-send-email-byungchul.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508921765-15396-10-git-send-email-byungchul.park@lge.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Byungchul Park <byungchul.park@lge.com>, Jens Axboe <axboe@kernel.dk>
Cc: peterz@infradead.org, johan@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, johannes.berg@intel.com, oleg@redhat.com, amir73il@gmail.com, david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, idryomov@gmail.com, kernel-team@lge.com


* Byungchul Park <byungchul.park@lge.com> wrote:

> Darrick posted the following warning and Dave Chinner analyzed it:
> 
> > ======================================================
> > WARNING: possible circular locking dependency detected
> > 4.14.0-rc1-fixes #1 Tainted: G        W

> Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
> Analyzed-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Byungchul Park <byungchul.park@lge.com>
> ---
>  block/bio.c           |  2 +-
>  block/genhd.c         | 10 ++--------
>  include/linux/genhd.h | 22 ++++++++++++++++++++--
>  3 files changed, 23 insertions(+), 11 deletions(-)

Ok, this patch looks good to me now, I'll wait to get an Ack or Nak from Jens for 
these changes.

Jens: this patch has some dependencies in prior lockdep changes, so I'd like to 
carry it in the locking tree for a v4.15 merge.

Thanks,

	Ingo
