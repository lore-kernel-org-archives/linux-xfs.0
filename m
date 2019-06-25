Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48750 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726414AbfFYMmY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 08:42:24 -0400
Subject: Re: [PATCH 09/12] xfs: refactor the ioend merging code
References: <20190624055253.31183-1-hch@lst.de>
 <20190624055253.31183-10-hch@lst.de>
 <e42c54c4-4c64-8185-8ac3-cca38ad8e8a4@suse.com>
 <20190625101445.GK1462@lst.de>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <387a9e4b-6a15-5b08-6878-53ed5cfb9bb0@suse.com>
Date: Tue, 25 Jun 2019 15:42:20 +0300
MIME-Version: 1.0
In-Reply-To: <20190625101445.GK1462@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org



On 25.06.19 г. 13:14 ч., Christoph Hellwig wrote:
> On Mon, Jun 24, 2019 at 07:06:22PM +0300, Nikolay Borisov wrote:
>>> +{
>>> +	struct list_head	tmp;
>>> +
>>> +	list_replace_init(&ioend->io_list, &tmp);
>>> +	xfs_destroy_ioend(ioend, error);
>>> +	while ((ioend = list_pop(&tmp, struct xfs_ioend, io_list)))
>>> +		xfs_destroy_ioend(ioend, error);
>>
>> nit: I'd prefer if the list_pop patch is right before this one since
>> this is the first user of it.
> 
> I try to keep generic infrastructure first instead of interveawing
> it with subystem-specific patches.
> 
>> Additionally, I don't think list_pop is
>> really a net-negative win 
> 
> What is a "net-negative win" ?

What I meant was 'net-positive win', in terms of making the code more
readable or optimised.

> 
>> in comparison to list_for_each_entry_safe
>> here. In fact this "delete the list" would seems more idiomatic if
>> implemented via list_for_each_entry_safe
> 
> I disagree.  The for_each loops require an additional next iterator,
> and also don't clearly express what is going on, but require additional
> spotting of the list_del.

That is of course your opinion. At the very least we can agree to disagree.

What I'm worried about, though, is now you've essentially introduced a
new idiom to dispose of lists, which is used only in your code. If it
doesn't become more widespread and gradually start replacing current
list_for_each_entry_safe usage then you would have increased the public
list interface to cater for one specific use case, just because it seems
more natural to you. I guess only time will show whether it makes sense
to have list_pop_entry
