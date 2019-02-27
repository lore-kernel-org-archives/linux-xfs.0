Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41050 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728905AbfB0HKp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Feb 2019 02:10:45 -0500
Subject: Re: [PATCH] xfs: allocate sector sized IO buffer via page_frag_alloc
References: <20190226045826.GJ23020@dastard>
 <20190226093302.GA24879@ming.t460p>
 <a641feb8-ceb2-2dac-27aa-7b1df10f5ae5@suse.cz>
 <CACVXFVMX=WpTRBbDTSibfXkTZxckk3ootetbE+rkJtHhsZkRAw@mail.gmail.com>
 <20190226121209.GC11592@bombadil.infradead.org>
 <20190226123545.GA6163@ming.t460p>
 <20190226130230.GD11592@bombadil.infradead.org>
 <20190226134247.GA30942@ming.t460p>
 <20190226140440.GF11592@bombadil.infradead.org>
 <20190226161433.GH21626@magnolia>
 <20190226161912.GG11592@bombadil.infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <095ae112-f98e-9516-910a-43b49ea5bf0d@suse.cz>
Date: Wed, 27 Feb 2019 08:07:31 +0100
MIME-Version: 1.0
In-Reply-To: <20190226161912.GG11592@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>, Ming Lei <tom.leiming@gmail.com>, Dave Chinner <david@fromorbit.com>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Christopher Lameter <cl@linux.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-block <linux-block@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>

On 2/26/19 5:19 PM, Matthew Wilcox wrote:
> On Tue, Feb 26, 2019 at 08:14:33AM -0800, Darrick J. Wong wrote:
>> On Tue, Feb 26, 2019 at 06:04:40AM -0800, Matthew Wilcox wrote:
>> Wait a minute, are you all saying that /directio/ is broken on XFS too??
>> XFS doesn't use blockdev_direct_IO anymore.
>>
>> I thought we were talking about alignment of XFS metadata buffers
>> (xfs_buf.c), which is a very different topic.
>>
>> As I understand the problem, in non-debug mode the slab caches give
>> xfs_buf chunks of memory that are aligned well enough to work, but in
>> debug mode the slabs allocate slightly more bytes to carry debug
>> information which pushes the returned address up slightly, thus breaking
>> the alignment requirements.
>>
>> So why can't we just move the debug info to the end of the object?  If
>> our 512 byte allocation turns into a (512 + a few more) bytes we'll end
>> up using 1024 bytes on the allocation regardless, so it shouldn't matter
>> to put the debug info at offset 512.  If the reason is fear that kernel
>> code will scribble off the end of the object, then return (*obj + 512).
>> Maybe you all have already covered this, though?
> 
> I don't know _what_ Ming Lei is saying.  I thought the problem was
> with slab redzones, which need to be before and after each object,
> but apparently the problem is with KASAN as well.

That's what I thought as well. But if we can solve it for caches created
by kmem_cache_create(..., align, ...) then IMHO we could guarantee
natural alignment for power-of-two kmalloc caches as well.
