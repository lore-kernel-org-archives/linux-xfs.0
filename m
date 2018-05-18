Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:46595 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752590AbeERQ44 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 May 2018 12:56:56 -0400
Received: by mail-pf0-f177.google.com with SMTP id p12-v6so4023554pff.13
        for <linux-xfs@vger.kernel.org>; Fri, 18 May 2018 09:56:56 -0700 (PDT)
Subject: Re: [PATCH 01/34] block: add a lower-level bio_add_page interface
References: <20180518164830.1552-1-hch@lst.de>
 <20180518164830.1552-2-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <febbcb2b-b3de-4e43-242e-0eb43f681bd0@kernel.dk>
Date: Fri, 18 May 2018 10:56:53 -0600
MIME-Version: 1.0
In-Reply-To: <20180518164830.1552-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On 5/18/18 10:47 AM, Christoph Hellwig wrote:
> For the upcoming removal of buffer heads in XFS we need to keep track of
> the number of outstanding writeback requests per page.  For this we need
> to know if bio_add_page merged a region with the previous bvec or not.
> Instead of adding additional arguments this refactors bio_add_page to
> be implemented using three lower level helpers which users like XFS can
> use directly if they care about the merge decisions.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

