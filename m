Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34661 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdEEI1I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 May 2017 04:27:08 -0400
Received: by mail-io0-f195.google.com with SMTP id 12so2964845iol.1
        for <linux-xfs@vger.kernel.org>; Fri, 05 May 2017 01:27:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170505075725.19597-4-hch@lst.de>
References: <20170505075725.19597-1-hch@lst.de> <20170505075725.19597-4-hch@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 5 May 2017 11:27:07 +0300
Message-ID: <CAOQ4uxh+U+p=dUvrUE3QyXgehn5pffRRrmpVOGi5c6sbSOEG-A@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: remove uuid_getnodeuniq and xfs_uu_t
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, May 5, 2017 at 10:57 AM, Christoph Hellwig <hch@lst.de> wrote:
> And just opencode retreiving the UUID v1 information in the only caller
> using get_unaligned_be*.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
