Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o75CWK8G086789 for <xfs@oss.sgi.com>; Thu, 5 Aug 2010 07:32:21 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F36D1BEFCF8
	for <xfs@oss.sgi.com>; Thu,  5 Aug 2010 05:32:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mEHHrUbBZhAmUobA for
	<xfs@oss.sgi.com>; Thu, 05 Aug 2010 05:32:41 -0700 (PDT)
Date: Thu, 5 Aug 2010 08:36:49 -0400
From: Josef Bacik <josef@redhat.com>
Subject: Re: direct-io regression [Was: How to track down abysmal
	performance ata - raid1 - crypto - vg/lv - xfs]
Message-ID: <20100805123649.GA18672@dhcp231-156.rdu.redhat.com>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
	<20100804085039.GA11671@infradead.org>
	<20100804091317.GA27779@isilmar-3.linta.de>
	<20100804092122.GA2998@infradead.org>
	<20100804073546.GA7494@comet.dominikbrodowski.net>
	<201008041116.09822@zmi.at>
	<20100804102526.GB13766@isilmar-3.linta.de>
	<15446.1280953986@localhost>
	<20100805093100.GA3001@comet.dominikbrodowski.net>
	<20100805113240.GA29846@think>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100805113240.GA29846@think>
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
To: Chris Mason <chris.mason@oracle.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Valdis.Kletnieks@vt.edu, josef@redhat.com, Michael Monnerie <michael.monnerie@is.it-management.at>, Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com

On Thu, Aug 05, 2010 at 07:32:40AM -0400, Chris Mason wrote:
> On Thu, Aug 05, 2010 at 11:31:00AM +0200, Dominik Brodowski wrote:
> > Hey,
> > 
> > when attempting to track down insufficient I/O performance, I found the
> > following reression relating to direct-io on my notebook, where an
> > ata device, which consists of several partitions, is combined to a lvm
> > volume, and one logical volume is then encrypted using dm-crypt. Test case
> > was the following command:
> > 
> > $ dd if=/dev/mapper/vg0-root_crypt of=/dev/zero iflag=direct bs=8k count=131072
> > 
> > 2.6.34 results in ~16 MB/s,
> > 2.6.35 results in ~ 3.1 MB/s
> > 
> > The regression was bisected down to the follwoing commit:
> > 
> > commit c2c6ca417e2db7a519e6e92c82f4a933d940d076
> > Author: Josef Bacik <josef@redhat.com>
> > Date:   Sun May 23 11:00:55 2010 -0400
> > 
> >     direct-io: do not merge logically non-contiguous requests
> >     
> > ...
> > 
> > How to fix this? I do not use btrfs, but ext3 (and the access was down on
> > the block level, not on the fs level, so this btrs-related commit should not
> > cause such a regression).
> 
> Well, you've already bisected down to an offending if statement, that's
> a huge help.  I'll try to reproduce this and fix it up today.
> 
> But, I'm surprised your drive is doing 8K dio reads at 16MB/s, that
> seems a little high.  
>

Hrm, I made sure there were no perf regressions when I wast testing this stuff,
though I think I only tested xfs and ext4.  Originally I had a test where if we
provided our own submit_io, so maybe as a workaround just make

if (dio->final_block_in_bio != dio->cur_page_block ||
                    cur_offset != bio_next_offset) 

look like this

if (dio->final_block_in_bio != dio->cur_page_block ||
    (dio->submit_io && cur_offset != bio_next_offset))

and that should limit my change to only btrfs.  I know why it could cause a
problem, but this change shouldn't be causing a 400% regression.  I suspect
something else is afoot here.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
