Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45256 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfGKNHC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jul 2019 09:07:02 -0400
Date: Thu, 11 Jul 2019 06:06:49 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH] iomap: generalize IOMAP_INLINE to cover tail-packing
 case
Message-ID: <20190711130649.GQ32320@bombadil.infradead.org>
References: <20190703075502.79782-1-yuchao0@huawei.com>
 <CAHpGcM+s77hKMXo=66nWNF7YKa3qhLY9bZrdb4-Lkspyg2CCDw@mail.gmail.com>
 <39944e50-5888-f900-1954-91be2b12ea5b@huawei.com>
 <CAHpGcMJ_wPJf8KtF3xMP_28pe4Vq4XozFtmd2EuZ+RTqZKQxLA@mail.gmail.com>
 <1506e523-109d-7253-ee4b-961c4264781d@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1506e523-109d-7253-ee4b-961c4264781d@aol.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gao Xiang <hsiangkao@aol.com>
Cc: Andreas =?iso-8859-1?Q?Gr=FCnbacher?= <andreas.gruenbacher@gmail.com>, Chao Yu <yuchao0@huawei.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Gao Xiang <gaoxiang25@huawei.com>, chao@kernel.org

On Thu, Jul 11, 2019 at 07:42:20AM +0800, Gao Xiang wrote:
> 
> At 2019/7/11 ??????5:50, Andreas Gr??nbacher Wrote:
> > At this point, can I ask how important this packing mechanism is to
> > you? I can see a point in implementing inline files, which help
> > because there tends to be a large number of very small files. But for
> > not-so-small files, is saving an extra block really worth the trouble,
> > especially given how cheap storage has become?
> 
> I would try to answer the above. I think there are several advantages by
> using tail-end packing inline:
> 1) It is more cache-friendly. Considering a file "A" accessed by user
> now or recently, we
> ?????? tend to (1) get more data about "A" (2) leave more data about "A"
> according to LRU-like assumption
> ?????? because it is more likely to be used than the metadata of some other
> files "X", especially for files whose
> ?????? tail-end block is relatively small enough (less than a threshold,
> e.g. < 100B just for example);
> 
> 2) for directories files, tail-end packing will boost up those traversal
> performance;
> 
> 3) I think tail-end packing is a more generic inline, it saves I/Os for
> generic cases not just to
> ?????? save the storage space;
> 
> "is saving an extra block really worth the trouble" I dont understand
> what exact the trouble is...

"the trouble" is adding code complexity and additional things to test.

I'm not sure you really understood Andreas' question.  He's saying that he
understands the performance and space gain from packing short files
(eg files less than 100 bytes).  But how many files are there between
4096 and 4196 bytes in size, let alone between 8192 and 8292, 12384 and
12484 ...

Is optimising for _those_ files worth it?
