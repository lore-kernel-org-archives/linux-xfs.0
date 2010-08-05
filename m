Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o75J6OOq098876 for <xfs@oss.sgi.com>; Thu, 5 Aug 2010 14:06:24 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DDFD1E40383
	for <xfs@oss.sgi.com>; Thu,  5 Aug 2010 12:06:43 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id VFGD2Xl3XjCNxWSH for
	<xfs@oss.sgi.com>; Thu, 05 Aug 2010 12:06:43 -0700 (PDT)
Date: Thu, 5 Aug 2010 15:01:38 -0400
From: Chris Mason <chris.mason@oracle.com>
Subject: Re: direct-io regression [Was: How to track down abysmal
	performance ata - raid1 - crypto - vg/lv - xfs]
Message-ID: <20100805190138.GV29846@think>
References: <20100804085039.GA11671@infradead.org>
	<20100804091317.GA27779@isilmar-3.linta.de>
	<20100804092122.GA2998@infradead.org>
	<20100804073546.GA7494@comet.dominikbrodowski.net>
	<201008041116.09822@zmi.at>
	<20100804102526.GB13766@isilmar-3.linta.de>
	<15446.1280953986@localhost>
	<20100805093100.GA3001@comet.dominikbrodowski.net>
	<20100805113240.GA29846@think>
	<x49tyn8c2ea.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49tyn8c2ea.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, linux-raid@vger.kernel.org, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Dominik Brodowski <linux@dominikbrodowski.net>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, josef@redhat.com

On Thu, Aug 05, 2010 at 02:58:37PM -0400, Jeff Moyer wrote:
> Chris Mason <chris.mason@oracle.com> writes:
> 
> > But, I'm surprised your drive is doing 8K dio reads at 16MB/s, that
> > seems a little high.  
> 
> I'm not sure why you think that.  We're talking about a plain old SATA
> disk, right?  I can get 40-50MB/s on my systems for 8KB O_DIRECT reads.
> What am I missing?

Clearly I'm wrong, his drive is going much faster ;)  I expect the
smaller reads to be slower but the drive's internal cache is doing well.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
