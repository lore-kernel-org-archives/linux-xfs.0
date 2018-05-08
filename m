Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38497 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755722AbeEHUqi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 16:46:38 -0400
Received: by mail-pf0-f196.google.com with SMTP id o76so24516475pfi.5
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 13:46:38 -0700 (PDT)
Date: Tue, 8 May 2018 13:46:36 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH 3/4] blk-wbt: pass in enum wbt_flags to get_rq_wait()
Message-ID: <20180508204636.GD27324@vader>
References: <1525709615-14395-1-git-send-email-axboe@kernel.dk>
 <1525709615-14395-4-git-send-email-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525709615-14395-4-git-send-email-axboe@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, dchinner@redhat.com, hch@lst.de

On Mon, May 07, 2018 at 10:13:34AM -0600, Jens Axboe wrote:
> This is in preparation for having more write queues, in which
> case we would have needed to pass in more information than just
> a simple 'is_kswapd' boolean.


Reviewed-by: Omar Sandoval <osandov@fb.com>

> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-wbt.c | 25 +++++++++++++++----------
>  block/blk-wbt.h |  4 +++-
>  2 files changed, 18 insertions(+), 11 deletions(-)
