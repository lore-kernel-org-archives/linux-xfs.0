Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 194907F37
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 02:02:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B3A5CAC002
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 00:01:58 -0700 (PDT)
Received: from mail.kernel.org ([198.145.29.136]) by cuda.sgi.com with ESMTP
	id yx9NXDAlmTO0zoDT for <xfs@oss.sgi.com>;
	Wed, 08 Jul 2015 00:01:56 -0700 (PDT)
Message-ID: <1436338913.13729.11.camel@hasee>
Subject: xfs_io bmap confused
From: Ming Lin <mlin@kernel.org>
Date: Wed, 08 Jul 2015 00:01:53 -0700
Mime-Version: 1.0
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
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@lst.de>

Hi list,

I am testing some direct-io patches.
xfs_tests/xfs/080 failed.

It's strange.
There is no hole in "rwtest.file",
but when read it at some offset it returns zero because of hole.

root@block:~# xfs_io -c bmap /mnt/test/rwtest.file
/mnt/test/rwtest.file:
             0: [0..125671]: 160..125831

Then I read at file offset 659456,
root@block:~# dd if=/mnt/test/rwtest.file of=tmp.file bs=512 skip=1288 count=1

The code actually goes to below if statements.

Any idea what's wrong?

139 static struct bio *
140 do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
141                 sector_t *last_block_in_bio, struct buffer_head *map_bh,
142                 unsigned long *first_logical_block, get_block_t get_block)
143 {
....
....
209                 if (!buffer_mapped(map_bh)) {
210                         fully_mapped = 0;
211                         if (first_hole == blocks_per_page)
212                                 first_hole = page_block;
213                         page_block++;
214                         block_in_file++;
215                         continue;
216                 }
....
....
249         if (first_hole != blocks_per_page) {
250                 zero_user_segment(page, first_hole << blkbits, PAGE_CACHE_SIZE);
251                 if (first_hole == 0) {
252                         SetPageUptodate(page);
253                         unlock_page(page);
254                         goto out;
255                 }

Thanks,
Ming


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
