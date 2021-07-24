Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E39C4338F
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Jul 2021 07:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C881F60E97
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Jul 2021 07:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbhGXHLz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Jul 2021 03:11:55 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:57442 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234266AbhGXHLv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Jul 2021 03:11:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UgmyvHs_1627113140;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UgmyvHs_1627113140)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 24 Jul 2021 15:52:21 +0800
Date:   Sat, 24 Jul 2021 15:52:20 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: Support inline data with block size < page
 size
Message-ID: <YPvGtP89rmiy9sU0@B-P7TQMD6M-0146.local>
Mail-Followup-To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-xfs@vger.kernel.org
References: <20210724034435.2854295-1-willy@infradead.org>
 <20210724034435.2854295-3-willy@infradead.org>
 <YPubNbDS0KgUALtt@B-P7TQMD6M-0146.local>
 <YPug7VUMZboQu4QW@B-P7TQMD6M-0146.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YPug7VUMZboQu4QW@B-P7TQMD6M-0146.local>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 24, 2021 at 01:11:09PM +0800, Gao Xiang wrote:
> On Sat, Jul 24, 2021 at 12:46:45PM +0800, Gao Xiang wrote:

...

> > 
> > Thanks for the patch!
> > 
> > Previously I'd like to skip the leading uptodate blocks and update the
> > extent it covers that is due to already exist iop. If we get rid of the
> > offset_in_page(pos) restriction like this, I'm not sure if we (or some
> > other fs users) could face something like below (due to somewhat buggy
> > fs users likewise):
> > 
> >  [0 - 4096)    plain block
> > 
> >  [4096 - 4608)  tail INLINE 1 (e.g. by mistake or just splitted
> >                                     .iomap_begin() report.)
> >  [4608 - 5120]  tail INLINE 2
> > 
> 
> (cont.)
> 
> So I think without the !offset_in_page(pos) restriction, at least we
> may need to add something like:
> 
> if (WARN_ON_ONCE(size != i_size_read(inode) - iomap->offset))
> 	return -EIO;
> 
> to the approach to detect such cases at least but that is no need with
> page-sized and !offset_in_page(pos) restriction.
> 

Never mind, after rethinking with clear head, I think I was overthinking
this part and it shouldn't behave like this. Sorry about the noise above.

> > 
> > >  
> > > -	addr = kmap_atomic(page);
> > > +	addr = kmap_atomic(page) + poff;
> > >  	memcpy(addr, iomap_inline_buf(iomap, pos), size);
> > > -	memset(addr + size, 0, PAGE_SIZE - size);
> > > +	memset(addr + size, 0, PAGE_SIZE - poff - size);
> > >  	kunmap_atomic(addr);
> > 
> > As my limited understanding, this may need to be fixed, since it
> > doesn't match kmap_atomic(page)...
> > 
> > Thanks,
> > Gao Xiang
> > 
> > > -	SetPageUptodate(page);
> > > -	return PAGE_SIZE;
> > > +	iomap_set_range_uptodate(page, poff, PAGE_SIZE - poff);
> > > +	return PAGE_SIZE - poff;
> > >  }
> > >  
> > >  static inline bool iomap_block_needs_zeroing(struct inode *inode,
> > > -- 
> > > 2.30.2
> > > 
