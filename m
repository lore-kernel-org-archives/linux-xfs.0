Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 15:41:24 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7UMfI4p021888
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 15:41:21 -0700
Subject: Re: ZFS, XFS, and EXT4 compared
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20070830132002.GA4086@infradead.org>
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
	 <1188457666.24970.94.camel@edge.yarra.acx>
	 <20070830132002.GA4086@infradead.org>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 08:42:31 +1000
Message-Id: <1188513751.24970.109.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Jeffrey W. Baker" <jwbaker@acm.org>, xfs@oss.sgi.com, linux-ext4@vger.kernel.org

[culled zfs-discuss from CC, since its subscriber-only]

On Thu, 2007-08-30 at 14:20 +0100, Christoph Hellwig wrote:
> 
> On Thu, Aug 30, 2007 at 05:07:46PM +1000, Nathan Scott wrote:
> > To improve metadata performance, you have many options with XFS
> (which
> > ones are useful depends on the type of metadata workload) - you can
> try
> > a v2 format log, and mount with "-o logbsize=256k", try increasing
> the
> > directory block size (e.g. mkfs.xfs -nsize=16k, etc), and also the
> log
> > size (mkfs.xfs -lsize=XXXXXXb).
> 
> Okay, these suggestions are one too often now.  v2 log and large
> logs/log
> buffers are the almost universal suggestions, and we really need to
> make
> these defaults.

Possibly.  Far more importantly for XFS, there really needs to be some
way for RAID drivers to say "even though I support write barriers, its
not a good idea for filesystems to enable write barriers by default on
me".  Enabling write barriers everywhere, by default, seems to have a
far worse impact than any mkfs/mount option tweaking.

>   XFS is already the laughing stock of the Linux community
> due to it's absurdely bad default settings.

Oh, _thats_ what everyone's laughing at?

cheers.

--
Nathan
