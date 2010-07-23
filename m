Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6N9tUfm193802 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 04:55:31 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E59346B88B
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 02:58:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zdvsSNUVMFVQ1EaG for
	<xfs@oss.sgi.com>; Fri, 23 Jul 2010 02:58:33 -0700 (PDT)
Date: Fri, 23 Jul 2010 05:58:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 4k sector drives
Message-ID: <20100723095832.GA23174@infradead.org>
References: <201007211333.48363.eye.of.the.8eholder@gmail.com>
	<201007230809.28111@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201007230809.28111@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Fri, Jul 23, 2010 at 08:09:27AM +0200, Michael Monnerie wrote:
> On Mittwoch, 21. Juli 2010 Khelben Blackstaff wrote:
> > Nevertheless, you don't have to get them to report 4k to linux. As
> >  long as you align the partitions its fine. As i said in the other
> >  post, newer fdisk doesn't use "DOS compatibility mode" and uses
> >  sectors by default (instead of stupid CHS) with a 1MB alignment, so
> >  every partition will be properly aligned. If you don't dual boot
> >  Windows, you can also use GPT partitioning scheme. Also, from what i
> >  have seen, xfsprogs are quite clever and find most stuff on their
> >  own. I usually mkfs with "-s size=4096" just to be sure.
> 
> I always do -b size=4096 anyway, so I'm fine here. And I created the 
> partitions starting sector 512, so that should be good also.

-b size=4096 is the default anyway, for 4k sector drivers you also want
-s size=4096, which you do not want for 512 byte sector disks.

What values do the files

	/sys/block/<device>/queue/logical_block_size
	/sys/block/<device>/queue/physical_block_size
	/sys/block/<device>/alignment_offset

say about your disk?


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
