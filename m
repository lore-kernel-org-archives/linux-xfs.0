Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34520 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755544AbeEHUsP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 16:48:15 -0400
Received: by mail-pg0-f67.google.com with SMTP id g20-v6so14990266pgv.1
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 13:48:15 -0700 (PDT)
Date: Tue, 8 May 2018 13:48:12 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH 4/4] blk-wbt: throttle discards like background writes
Message-ID: <20180508204812.GE27324@vader>
References: <1525709615-14395-1-git-send-email-axboe@kernel.dk>
 <1525709615-14395-5-git-send-email-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525709615-14395-5-git-send-email-axboe@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, dchinner@redhat.com, hch@lst.de

On Mon, May 07, 2018 at 10:13:35AM -0600, Jens Axboe wrote:
> Throttle discards like we would any background write. Discards should
> be background activity, so if they are impacting foreground IO, then
> we will throttle them down.

Seems reasonable.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-stat.h |  6 +++---
>  block/blk-wbt.c  | 43 ++++++++++++++++++++++++++-----------------
>  block/blk-wbt.h  |  4 +++-
>  3 files changed, 32 insertions(+), 21 deletions(-)
