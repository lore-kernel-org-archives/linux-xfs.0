Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 21:30:46 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5S4UedA011704
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 21:30:40 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8EA62183FF1D
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 21:31:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id wYo5rduX7A8p5Gwg for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 21:31:40 -0700 (PDT)
Message-ID: <4865BEAB.4030108@sandeen.net>
Date: Fri, 27 Jun 2008 23:31:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: rfc: kill ino64 mount option
References: <20080627153928.GA31384@lst.de> <20080628000914.GE29319@disturbed> <486589E7.9010705@sgi.com>
In-Reply-To: <486589E7.9010705@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Mark Goodwin wrote:
> 
> Dave Chinner wrote:
>> On Fri, Jun 27, 2008 at 05:39:28PM +0200, Christoph Hellwig wrote:
>>> Does anyone have objections to kill the ino64 mount option?  It's purely
>>> a debug tool to force inode numbers outside of the range representable
>>> in 32bits and is quite invasive for something that could easily be
>>> debugged by just having a large enough filesystem..
>> It's the "large enough fs" that is the problem. XFSQA uses
>> small partitions for the most part, and this allows testing
>> of 64 bit inode numbers with a standard qa config.
>>
>> That being said, I don't really if it goes or stays...
> 
> Although ino64 has interoperability issues with 32bit apps, it does
> have significant performance advantages over inode32 for some
> storage topologies and workloads, i.e. it's generally desirable to
> keep inodes near their data, but with large configs inode32 can't
> always oblige. ino64 is not just a debug tool.

You're confusing inode64, which allows inodes > 32 bits, with ino64,
which forces all inodes > 32 bits.  The latter debugging option is what
Christoph wants to remove...

Christoph, the "large enough fs" could be sparse I guess but you still
need to play tricks to get enough inodes up high I think.... I was
actually considering using ino64 just to see what breaks in fedora. :)

I guess I'm ambivalent too, is it really that invasive?  Maybe 10, 15
lines of code looks like?

-Eric
