Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o75IweBF098614 for <xfs@oss.sgi.com>; Thu, 5 Aug 2010 13:58:41 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 083EFC52773
	for <xfs@oss.sgi.com>; Thu,  5 Aug 2010 12:07:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8mHV8va0ETOLCHGa for
	<xfs@oss.sgi.com>; Thu, 05 Aug 2010 12:07:10 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: direct-io regression [Was: How to track down abysmal performance
	ata - raid1 - crypto - vg/lv - xfs]
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
Date: Thu, 05 Aug 2010 14:58:37 -0400
In-Reply-To: <20100805113240.GA29846@think> (Chris Mason's message of "Thu, 5
	Aug 2010 07:32:40 -0400")
Message-ID: <x49tyn8c2ea.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Chris Mason <chris.mason@oracle.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, linux-raid@vger.kernel.org, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Dominik Brodowski <linux@dominikbrodowski.net>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, josef@redhat.com

Chris Mason <chris.mason@oracle.com> writes:

> But, I'm surprised your drive is doing 8K dio reads at 16MB/s, that
> seems a little high.  

I'm not sure why you think that.  We're talking about a plain old SATA
disk, right?  I can get 40-50MB/s on my systems for 8KB O_DIRECT reads.
What am I missing?

Cheers,
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
