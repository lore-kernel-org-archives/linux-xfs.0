Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 14:53:25 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1IMrID5000475
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 14:53:21 -0800
Date: Tue, 19 Feb 2008 09:53:35 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: tuning, many small files, small blocksize
Message-ID: <20080218225335.GR155407@sgi.com>
References: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Breidenbach <jeff@jab.org>
Cc: xfs@oss.sgi.com

On Fri, Feb 15, 2008 at 09:01:10PM -0800, Jeff Breidenbach wrote:
> I'm testing xfs for use in storing 100 million+ small files
> (roughly 4 to 10KB each) and some directories will contain
> tens of thousands of files. There will be a lot of random
> reading, and also some random writing, and very little
> deletion.
.....
> a) Should I just go with the 512 byte blocksize or is that going to be
> bad for some performance reason? Going to 1024 is no problem,
> but I'd prefer not to waste 20% of the partition capacity by using 4096.

I'd suggest wasting 20% of disk space and staying with 4k block size.

> b) Are there any other mkfs.xfs paramters that I should play with.

Large directory block size (-n size=XXX), esp. if you are putting
thousands of files per directory....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
