Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57148 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726875AbfDLH52 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Apr 2019 03:57:28 -0400
Subject: Re: [LSF/MM TOPIC] guarantee natural alignment for kmalloc()?
References: <790b68b7-3689-0ff6-08ae-936728bc6458@suse.cz>
 <1555053293.3046.4.camel@HansenPartnership.com>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <68385367-8744-50c3-8a81-be3a4637ea80@suse.cz>
Date: Fri, 12 Apr 2019 09:54:07 +0200
MIME-Version: 1.0
In-Reply-To: <1555053293.3046.4.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: James Bottomley <James.Bottomley@HansenPartnership.com>, lsf-pc@lists.linux-foundation.org
Cc: Linux-FSDevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-block@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

On 4/12/19 9:14 AM, James Bottomley wrote:
>> In the session I hope to resolve the question whether this is indeed
>> the right thing to do for all kmalloc() users, without an explicit
>> alignment requests, and if it's worth the potentially worse
>> performance/fragmentation it would impose on a hypothetical new slab
>> implementation for which it wouldn't be optimal to split power-of-two
>> sized pages into power-of-two-sized objects (or whether there are any
>> other downsides).
> 
> I think so.  The question is how aligned?  explicit flushing arch's
> definitely need at least cache line alignment when using kmalloc for
> I/O and if allocations cross cache lines they have serious coherency
> problems.   The question of how much more aligned than this is
> interesting ... I've got to say that the power of two allocator implies
> same alignment as size and we seem to keep growing use cases that
> assume this.

Right, by "natural alignment" I meant exactly that - align to size for
power-of-two sizes.

> I'm not so keen on growing a separate API unless there's
> a really useful mm efficiency in breaking the kmalloc alignment
> assumptions.

I'd argue there's not.

> James
> 
