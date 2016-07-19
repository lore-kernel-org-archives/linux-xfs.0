Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 825F57CA0
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 06:24:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 474F88F8033
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 04:24:55 -0700 (PDT)
Received: from mail02.iobjects.de (mail02.iobjects.de [188.40.134.68]) by
	cuda.sgi.com with ESMTP id OYUUMTfk5HlDj3RF (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Jul 2016 04:24:52 -0700 (PDT)
Subject: Re: xfs_vm_releasepage() causing BUG at free_buffer_head()
References: <143E2E5E912B4C348E8C62AA987F0506@alyakaslap>
	<578D399C.1010006@applied-asynchrony.com>
	<EBFD548A4E314321937A5966D9B00808@alyakaslap>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <578E0E02.9010509@applied-asynchrony.com>
Date: Tue, 19 Jul 2016 13:24:50 +0200
MIME-Version: 1.0
In-Reply-To: <EBFD548A4E314321937A5966D9B00808@alyakaslap>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

Hi,

first off I didn't mean to imply that this is exactly the same problem,
merely a related symptom due to buffer shrinking crashing your party.

On 07/19/16 10:43, Alex Lyakas wrote:
> Thank you for your response. I see that xfs_finish_page_writeback()
> has been added very recently and is called from xfs_destroy_ioend().
> In my kernel (3.18.19), the xfs_destroy_ioend() is [1]. I think it
> doesn't suffer from the problem of xfs_finish_page_writeback().
> Looking at other usage of "b_this_page" in my kernel, they all seem
> valid, and similar to what Linus's tree has.

Unwinding this a bit, all I superficially understand is that

  e10de3723c "don't chain ioends during writepage submission"

made the window for bh corruption smaller, and then both

  bb18782aa4 "build bios directly in xfs_add_to_ioend" and
  37992c18bb "don't release bios on completion immediately"

changed that to track page state instead, presumably because
the bh traversing was indeed racy. That was still incomplete, as
Calvin found.

So I don't see why your current version of xfs_submit_ioend() wouldn't
suffer from the same problem(s). You just walked into the bh BUG later,
instead of a use-after-free as it can happen now.

> Looking at b_private usage to link buffer heads, the only suspicious
> code is in xfs_submit_ioend():
> 
>        for (bh = ioend->io_buffer_head; bh; bh = bh->b_private) {
> 
>            if (!bio) {
> retry:
>                bio = xfs_alloc_ioend_bio(bh);
>            } else if (bh->b_blocknr != lastblock + 1) {
>                xfs_submit_ioend_bio(wbc, ioend, bio);
>                goto retry;
>            }
> 
>            if (xfs_bio_add_buffer(bio, bh) != bh->b_size) {
>                xfs_submit_ioend_bio(wbc, ioend, bio);
>                goto retry;
>            }
> 
>            lastblock = bh->b_blocknr;
>        }
>
> Can it happen that when the for loop does "bh = bh->b_private", the
> bh has already been completed and freed? With this in mind, the "goto
> retry" also seem suspicious for the same reason.
> 
> What do you think?

I think all this is dark and full of terrors. As for what you could
do - other than backport half of mainline XFS - I guess only Dave can
make a realistic suggestion.

-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
