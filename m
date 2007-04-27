Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Apr 2007 19:24:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3R2O7fB021749
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 19:24:09 -0700
Message-ID: <46315EC0.9080401@sandeen.net>
Date: Thu, 26 Apr 2007 21:24:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] make growfs check device size limits too
References: <1177569014.6273.367.camel@edge>	 <20070426071055.GA24411@infradead.org> <1177631120.6273.380.camel@edge>
In-Reply-To: <1177631120.6273.380.camel@edge>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Nathan Scott wrote:
> On Thu, 2007-04-26 at 08:10 +0100, Christoph Hellwig wrote:
>> On Thu, Apr 26, 2007 at 04:30:14PM +1000, Nathan Scott wrote:
>>> On the mount path we check for a superblock that describes a filesystem
>>> to large for the running kernel to handle.  This catches the case of an
>>> attempt to mount a >16TB filesystem on i386 (where we are limited by the
>>> page->index size, for XFS metadata buffers in xfs_buf.c).
>>>
>>> This patch makes similar checks on the growfs code paths for regular and
>>> realtime growth, else we can end up with filesystem corruption, it would
>>> seem (from #xfs chatter).  Untested patch follows; probably better to do
>>> this as a macro, in a header, and call that in each place...?
>> Yeah, the check should probably we in one place only.  Given that's it's
>> only used in slow pathes a function would probably do it.
> 
> Here's a revised version...
> 
> cheers.
> 

Looks good to me

-Eric
