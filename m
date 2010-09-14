Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ENMXuk153182 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 18:22:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53B1817F3E81
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 16:23:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QddRvZGeSDqH1Qnk for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 16:23:22 -0700 (PDT)
Date: Tue, 14 Sep 2010 19:23:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Delaylog
Message-ID: <20100914232321.GA11123@infradead.org>
References: <AANLkTin6FSBK3tMXhSxDuLdjyb+R0LhNnaa2CKt37FcV@mail.gmail.com>
	<201009142106.24448.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009142106.24448.arekm@maven.pl>
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
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Tue, Sep 14, 2010 at 09:06:24PM +0200, Arkadiusz Miskiewicz wrote:
> On Tuesday 14 of September 2010, Fabricio Archanjo wrote:
> > Hey all,
> > 
> >    I just trying delaylog in my server that has a mysql database. When
> > i monted my /var/lib/mysql with delaylog option, it showed me:
> > "Enabling EXPERIMENTAL delayed logging feature - use at your own
> > risk". Ok, i know it's experimental, but what kind of problem could i
> > have using delaylog?

Basically you could hit a race or lockup in the code under high stress
or unusual workloads.  So far we just had one possible lockup under very
high dbench load.

> ... and what problems in case of system hang or power loss when compared to 
> nodelaylog mode?

The same as with the old log code - if you crash recently written data
might be lost.  Unless a really severe bugs shows up (in either the old
or new code) that only includes data since the last fsync/sync.  The
quantitative difference is that a lot more metadata is now cached in
core, so on a crash you can lose more recently written but not synced
metadata.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
