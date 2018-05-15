Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50453 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752781AbeEONra (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 May 2018 09:47:30 -0400
Subject: Re: [PATCH 31/33] iomap: add support for sub-pagesize buffered I/O
 without buffer heads
References: <20180509074830.16196-1-hch@lst.de>
 <20180509074830.16196-32-hch@lst.de>
 <eebcc4bf-f646-edc6-264b-124b3880f3cb@suse.de>
 <20180515072625.GA23384@lst.de>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <8b36b6c2-03b0-ea66-9bea-df2695dd1dba@suse.de>
Date: Tue, 15 May 2018 08:47:25 -0500
MIME-Version: 1.0
In-Reply-To: <20180515072625.GA23384@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org



On 05/15/2018 02:26 AM, Christoph Hellwig wrote:
> On Mon, May 14, 2018 at 11:00:08AM -0500, Goldwyn Rodrigues wrote:
>>> +	if (iop || i_blocksize(inode) == PAGE_SIZE)
>>> +		return iop;
>>
>> Why is this an equal comparison operator? Shouldn't this be >= to
>> include filesystem blocksize greater than PAGE_SIZE?
> 
> Which filesystems would that be that have a tested and working PAGE_SIZE
> support using iomap?

Oh, I assumed iomap would work for filesystems with block size greater
than PAGE_SIZE.

-- 
Goldwyn
