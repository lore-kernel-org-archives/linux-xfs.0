Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:50450 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752274AbeEOQrT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 12:47:19 -0400
Received: by mail-it0-f65.google.com with SMTP id p3-v6so3199667itc.0
        for <linux-xfs@vger.kernel.org>; Tue, 15 May 2018 09:47:19 -0700 (PDT)
Subject: Re: [PATCH 01/33] block: add a lower-level bio_add_page interface
References: <20180509074830.16196-1-hch@lst.de>
 <20180509074830.16196-2-hch@lst.de>
 <20180509151243.GA1313@bombadil.infradead.org>
 <20180510064013.GA11422@lst.de>
 <AE0124C4-46F7-4051-BA24-AC2E3887E8A3@dilger.ca>
 <20180511062903.GA8210@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c9d1df5d-e9af-04f3-035c-29153a79b184@kernel.dk>
Date: Tue, 15 May 2018 10:47:16 -0600
MIME-Version: 1.0
In-Reply-To: <20180511062903.GA8210@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Andreas Dilger <adilger@dilger.ca>
Cc: Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On 5/11/18 12:29 AM, Christoph Hellwig wrote:
> On Thu, May 10, 2018 at 03:49:53PM -0600, Andreas Dilger wrote:
>> Would it make sense to change the bio_add_page() and bio_add_pc_page()
>> to use the more common convention instead of continuing the spread of
>> this non-standard calling convention?  This is doubly problematic since
>> "off" and "len" are both unsigned int values so it is easy to get them
>> mixed up, and just reordering the bio_add_page() arguments would not
>> generate any errors.
> 
> We have more than hundred callers.  I don't think we want to create
> so much churn just to clean things up a bit without any meaѕurable
> benefit.  And even if you want to clean it up I'd rather keep it
> away from my iomap/xfs buffered I/O series :)

Yeah let's not do that, I know someone that always gets really grumpy
when changes like that are made. So given that, I think we should retain
the argument order for that we already have for __bio_try_merge_page()
as well.

-- 
Jens Axboe

