Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 17:45:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5S0jc0F009050
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 17:45:40 -0700
Message-ID: <486589E7.9010705@sgi.com>
Date: Sat, 28 Jun 2008 10:46:31 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: rfc: kill ino64 mount option
References: <20080627153928.GA31384@lst.de> <20080628000914.GE29319@disturbed>
In-Reply-To: <20080628000914.GE29319@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com



Dave Chinner wrote:
> On Fri, Jun 27, 2008 at 05:39:28PM +0200, Christoph Hellwig wrote:
>> Does anyone have objections to kill the ino64 mount option?  It's purely
>> a debug tool to force inode numbers outside of the range representable
>> in 32bits and is quite invasive for something that could easily be
>> debugged by just having a large enough filesystem..
>
> It's the "large enough fs" that is the problem. XFSQA uses
> small partitions for the most part, and this allows testing
> of 64 bit inode numbers with a standard qa config.
>
> That being said, I don't really if it goes or stays...

Although ino64 has interoperability issues with 32bit apps, it does
have significant performance advantages over inode32 for some
storage topologies and workloads, i.e. it's generally desirable to
keep inodes near their data, but with large configs inode32 can't
always oblige. ino64 is not just a debug tool.

We have a design proposal known as "inode32+" that essentially removes
the direct mapping between inode number and disk offset. This will
provide all the layout and performance benefits of ino64 without the
interop issues.  Until inode32+ is available, we need to keep ino64.

Cheers

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
