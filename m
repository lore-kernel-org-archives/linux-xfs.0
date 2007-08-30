Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 11:57:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7UIvF4p012074
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 11:57:17 -0700
Message-ID: <46D71318.2050604@sandeen.net>
Date: Thu, 30 Aug 2007 13:57:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: ZFS, XFS, and EXT4 compared
References: <1188454611.23311.13.camel@toonses.gghcwest.com> <1188457666.24970.94.camel@edge.yarra.acx> <20070830132002.GA4086@infradead.org>
In-Reply-To: <20070830132002.GA4086@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Nathan Scott <nscott@aconex.com>, "Jeffrey W. Baker" <jwbaker@acm.org>, zfs-discuss@opensolaris.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Aug 30, 2007 at 05:07:46PM +1000, Nathan Scott wrote:
>> To improve metadata performance, you have many options with XFS (which
>> ones are useful depends on the type of metadata workload) - you can try
>> a v2 format log, and mount with "-o logbsize=256k", try increasing the
>> directory block size (e.g. mkfs.xfs -nsize=16k, etc), and also the log
>> size (mkfs.xfs -lsize=XXXXXXb).
> 
> Okay, these suggestions are one too often now.  v2 log and large logs/log
> buffers are the almost universal suggestions, and we really need to make
> these defaults.  XFS is already the laughing stock of the Linux community
> due to it's absurdely bad default settings.

Agreed on reevaluating the defaults, Christoph!

barrier seems to hurt badly on xfs, too.  Note: barrier is off by
default on ext[34], so if you want apples to apples there, you need to
change one or the other filesystem's mount options.  If your write cache
is safe (battery backed?) you may as well turn barriers off.  I'm not
sure offhand who will react more poorly to an evaporating write cache
(with no barriers), ext4 or xfs...

-Eric
