Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36270 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730242AbfFRT7G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 15:59:06 -0400
Received: by mail-ed1-f67.google.com with SMTP id k21so23470199edq.3
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 12:59:05 -0700 (PDT)
Subject: Re: same page merging leak fix v4
References: <20190617091412.15923-1-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <35950338-41e9-447c-d534-de735d5ffca5@kernel.dk>
Date: Tue, 18 Jun 2019 13:59:03 -0600
MIME-Version: 1.0
In-Reply-To: <20190617091412.15923-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc: David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org

On 6/17/19 3:14 AM, Christoph Hellwig wrote:
> Hi Jens, hi Ming,
> 
> this is the tested and split version of what I think is the better
> fix for the get_user_pages page leak, as it leaves the intelligence
> in the callers instead of in bio_try_to_merge_page.

Applied, thanks.

-- 
Jens Axboe
