Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o75FZOQD092483 for <xfs@oss.sgi.com>; Thu, 5 Aug 2010 10:35:24 -0500
Received: from linta.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 464A6C4F674
	for <xfs@oss.sgi.com>; Thu,  5 Aug 2010 08:43:52 -0700 (PDT)
Received: from linta.de (isilmar-3.linta.de [188.40.101.200]) by cuda.sgi.com
	with ESMTP id Apxr6YE0IA1tADl2 for <xfs@oss.sgi.com>;
	Thu, 05 Aug 2010 08:43:52 -0700 (PDT)
Date: Thu, 5 Aug 2010 17:35:19 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: direct-io regression [Was: How to track down abysmal
	performance ata - raid1 - crypto - vg/lv - xfs]
Message-ID: <20100805153519.GA7242@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100805123649.GA18672@dhcp231-156.rdu.redhat.com>
	<20100805113240.GA29846@think>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chris Mason <chris.mason@oracle.com>, josef@redhat.com
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, linux-raid@vger.kernel.org, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com

Hey,

On Thu, Aug 05, 2010 at 07:32:40AM -0400, Chris Mason wrote:
> But, I'm surprised your drive is doing 8K dio reads at 16MB/s, that
> seems a little high.  

Well, that's what it does:

# $ dd if=/dev/mapper/vg0-home_crypt of=/dev/zero iflag=direct bs=8k count=131072 seek=131072
# 131072+0 records in
# 131072+0 records out
# 1073741824 bytes (1.1 GB) copied, 62.0177 s, 17.3 MB/s

On Thu, Aug 05, 2010 at 08:36:49AM -0400, Josef Bacik wrote:
> Hrm, I made sure there were no perf regressions when I wast testing this stuff,
> though I think I only tested xfs and ext4.

For this test, I'm not doing dio on filesystem level, but on block level
(/dev/mapper/vg0-*_crypt). It seems that dm-crypt creates such offending
holes, which cause this huge performance drop.

>  Originally I had a test where if we
> provided our own submit_io, so maybe as a workaround just make
> 
> if (dio->final_block_in_bio != dio->cur_page_block ||
>                     cur_offset != bio_next_offset) 
> 
> look like this
> 
> if (dio->final_block_in_bio != dio->cur_page_block ||
>     (dio->submit_io && cur_offset != bio_next_offset))

Tested-by: Dominik Brodowski <linux@dominikbrodowski.net>

With this fix, I get proper speeds when doing dio reads from
/dev/mapper/vg0-*_crypt; see the 17.3 MB/s above. Most strangely,
also accesing /dev/mapper/vg0-* (un-encrypted) and the raw
device at /dev/sda* speeds up (to up to 28 MB/s). Was only seeing around
16 to 18 MB/s without this patch for unencrypted access.

> I know why it could cause a problem, but this change shouldn't be
> causing a 400% regression.

Well, it seems to cause -- at least on my notebook -- a 150% regression on
unencrypted LVM2 access; and this > 400% on encrypted LVM2 access...

> I suspect something else is afoot here.

There is, probably. But the fix you propose helps a lot, already.

Thanks & best,

	Dominik

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
