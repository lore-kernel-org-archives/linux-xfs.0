Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:44111 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752989AbdHKPOR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Aug 2017 11:14:17 -0400
Subject: Re: Locking problems with Linux 4.9 and 4.11 with NFSD and
 `fs/iomap.c`
References: <20170508131843.GB29840@bfoster.bfoster>
 <20170509090534.GB2378@lst.de>
 <7ae18b0d-38e3-9b12-0989-ede68956ad43@molgen.mpg.de>
 <358037e8-6784-ebca-9fbb-ec7eef3977d6@molgen.mpg.de>
 <20170510171757.GA10534@localhost.localdomain>
 <f6115b81-918d-ecfe-e3d9-812bccf7c80f@molgen.mpg.de>
 <979473d1-9e8a-51ba-28d9-9ace63f8105b@molgen.mpg.de>
 <20170801225144.GP17762@dastard>
 <92d0933c-f031-f4e7-191e-eb3c9b1260aa@molgen.mpg.de>
 <12EF8D94C6F8734FB2FF37B9FBEDD173010E032482@EXCHANGE.collogia.de>
 <20170811101513.GA11531@lst.de>
From: Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <1853b5d0-891c-6cdd-7270-a2eaedc4072e@molgen.mpg.de>
Date: Fri, 11 Aug 2017 17:14:15 +0200
MIME-Version: 1.0
In-Reply-To: <20170811101513.GA11531@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Markus Stockhausen <stockhausen@collogia.de>
Cc: Dave Chinner <david@fromorbit.com>, "it+linux-nfs@molgen.mpg.de" <it+linux-nfs@molgen.mpg.de>, Brian Foster <bfoster@redhat.com>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>

Dear Christoph, dear Markus,


On 08/11/17 12:15, Christoph Hellwig wrote:
> On Thu, Aug 10, 2017 at 07:54:51PM +0000, Markus Stockhausen wrote:
>> Lets say you are trying to zero multiple of 4GB chunks. With bytes
>> evaluated towards 0 this will hit an endless loop within that iomap
>> function. That might explain your observation. If that is right a bugfix
>> would qualify for stable 4.8+
> 
> Yes, it seems like min_t casts arguments 2 and 3 to the type in argument
> 1, which could lead to incorrect truncation.
> 
> Paul, please try the patch below:
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 039266128b7f..59cc98ad7577 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -278,7 +278,7 @@ iomap_dirty_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>   		unsigned long bytes;	/* Bytes to write to page */
>   
>   		offset = (pos & (PAGE_SIZE - 1));
> -		bytes = min_t(unsigned long, PAGE_SIZE - offset, length);
> +		bytes = min_t(loff_t, PAGE_SIZE - offset, length);
>   
>   		rpage = __iomap_read_page(inode, pos);
>   		if (IS_ERR(rpage))
> @@ -373,7 +373,7 @@ iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
>   		unsigned offset, bytes;
>   
>   		offset = pos & (PAGE_SIZE - 1); /* Within page */
> -		bytes = min_t(unsigned, PAGE_SIZE - offset, count);
> +		bytes = min_t(loff_t, PAGE_SIZE - offset, count);
>   
>   		if (IS_DAX(inode))
>   			status = iomap_dax_zero(pos, offset, bytes, iomap);

I applied this on top of Linux 4.9.41. Even when writing 40 100 GB in 
parallel on an NFS exported directory from different systems, and 
keeping the load high on the system, the NFS exported directory was 
always accessible from all hosts.

Markus, thank you very much for looking into this and spotting the bug. 
A bug thank you to all people helping to analyze this issue.

I’ll keep you posted, but until know.

Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
