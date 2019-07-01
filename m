Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47506 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbfGAGI6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 02:08:58 -0400
Date: Sun, 30 Jun 2019 23:08:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC] iomap: introduce IOMAP_TAIL
Message-ID: <20190701060847.GA24797@infradead.org>
References: <20190629073020.22759-1-yuchao0@huawei.com>
 <20190630231932.GI1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190630231932.GI1404256@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Chao Yu <yuchao0@huawei.com>, hch@infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, gaoxiang25@huawei.com, chao@kernel.org, Andreas Gruenbacher <agruenba@redhat.com>

On Sun, Jun 30, 2019 at 04:19:32PM -0700, Darrick J. Wong wrote:
> On Sat, Jun 29, 2019 at 03:30:20PM +0800, Chao Yu wrote:
> > Some filesystems like erofs/reiserfs have the ability to pack tail
> > data into metadata, however iomap framework can only support mapping
> > inline data with IOMAP_INLINE type, it restricts that:
> > - inline data should be locating at page #0.
> > - inline size should equal to .i_size
> 
> Wouldn't it be easier simply to fix the meaning of IOMAP_INLINE so that
> it can be used at something other than offset 0 and length == isize?
> IOWs, make it mean "use the *inline_data pointer to read/write data
> as a direct memory access"?

Yes.  I vaguely remember Andreas pointed out some issues with a
general scheme, which is why we put the limits in.  If that is not just
me making things up we'll need to address them.  Either way just copy
and pasting code isn't very helpful.
