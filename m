Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KHP1S0072756 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 12:25:02 -0500
Date: Tue, 20 Sep 2011 13:24:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs deadlock in stable kernel 3.0.4
Message-ID: <20110920172455.GA30757@infradead.org>
References: <4E6EF274.7050007@profihost.ag>
	<20110913205018.GA8543@infradead.org> <4E70571A.80108@profihost.ag>
	<4E705C42.6020909@profihost.ag>
	<20110914143005.GA28496@infradead.org>
	<4E75B660.1030502@profihost.ag> <20110918230245.GF15688@dastard>
	<4E78665E.8030409@profihost.ag>
	<20110920160226.GA25542@infradead.org>
	<4E78CBF4.1030505@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E78CBF4.1030505@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, aelder@sgi.com

On Tue, Sep 20, 2011 at 07:23:00PM +0200, Stefan Priebe - Profihost AG wrote:
> >  - what is the fs geometry?
> What do you exactly mean? I've seen this on 1TB and 160GB SSD
> devices with totally different disk layout.

The output of mkfs.xfs (of xfs_info after it's been created)

> >Note that 2.6.38 moved the whole log grant code to a lockless algorithm,
> >so this might be a likely culprit if you're managing to hit race windows
> >no one else does, i.e. this really is a timing issue.
> I'm nearly willing todo anything to solve this. What can i do to
> help. My last hope from today was to get some code lines with kgdb -
> sadly it does not happen at all when kgdb is attached ;-(

I'll run tests on a system with a pci-e flash device today.  Just to
make sure we are on the same page, can you give me your kernel .config
in addition to the mkfs output above?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
