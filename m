Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48948 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750759AbeEPSAf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 May 2018 14:00:35 -0400
Date: Wed, 16 May 2018 20:05:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/33] block: add a lower-level bio_add_page interface
Message-ID: <20180516180503.GA6627@lst.de>
References: <20180509074830.16196-1-hch@lst.de> <20180509074830.16196-2-hch@lst.de> <37c16316-aa3a-e3df-79d0-9fca37a5996f@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37c16316-aa3a-e3df-79d0-9fca37a5996f@codeaurora.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ritesh Harjani <riteshh@codeaurora.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Wed, May 16, 2018 at 10:36:14AM +0530, Ritesh Harjani wrote:
> 1. if bio_full is true that means no space in bio->bio_io_vec[] no?
> Than how come we are still proceeding ahead with only warning?
> While originally in bio_add_page we used to return after checking
> bio_full. Callers can still call __bio_add_page directly right.

I you don't know if the bio is full or not don't use __bio_add_page,
keep using bio_add_page.  The WARN_ON is just a debug tool to catch
cases where the developer did use it incorrectly.

> 2. IF above is correct why don't we set the bio->bi_max_vecs to the size
> of the slab instead of keeeping it to nr_iovecs which user requested?
> (in bio_alloc_bioset)

Because we limit the user to the number that the user requested.  Not
that this patch changes anything about that.

> 3. Could you please help understand why for cloned bio we still allow
> __bio_add_page to work? why not WARN and return like in original code?

It doesn't work, and I have now added the WARN_ON to deal with any
incorrect usage.

>> -	if (bio->bi_vcnt >= bio->bi_max_vecs)
>> -		return 0;
> Originally here we were supposed to return and not proceed further.
> Should __bio_add_page not have similar checks to safeguard crossing
> the bio_io_vec[] boundary?

No, __bio_add_page is the "I know what I am doing" interface.
