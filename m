Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f42.google.com ([209.85.210.42]:32791 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727232AbfFMKGZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 06:06:25 -0400
Received: by mail-ot1-f42.google.com with SMTP id p4so15173437oti.0
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 03:06:25 -0700 (PDT)
Subject: Re: alternative take on the same page merging leak fix v2
References: <20190613095529.25005-1-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <00c908ad-ca33-164d-3741-6c67813c1f0d@kernel.dk>
Date: Thu, 13 Jun 2019 04:04:03 -0600
MIME-Version: 1.0
In-Reply-To: <20190613095529.25005-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc: David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org

On 6/13/19 3:55 AM, Christoph Hellwig wrote:
> Hi Jens, hi Ming,
> 
> this is the tested and split version of what I think is the better
> fix for the get_user_pages page leak, as it leaves the intelligence
> in the callers instead of in bio_try_to_merge_page.
> 
> Changes since v1:
>   - drop patches not required for 5.2
>   - added Reviewed-by tags

Applied for 5.2, thanks.

-- 
Jens Axboe
