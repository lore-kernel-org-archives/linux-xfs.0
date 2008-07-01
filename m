Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 01:06:05 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m61861ON004902
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 01:06:01 -0700
Received: from deliver.uni-koblenz.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09055185AC70
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 01:07:02 -0700 (PDT)
Received: from deliver.uni-koblenz.de (deliver.uni-koblenz.de [141.26.64.15]) by cuda.sgi.com with ESMTP id fUOn0Sp57SoaqrBx for <xfs@oss.sgi.com>; Tue, 01 Jul 2008 01:07:02 -0700 (PDT)
Message-ID: <4869E5A4.4020900@uni-koblenz.de>
Date: Tue, 01 Jul 2008 10:07:00 +0200
From: Christoph Litauer <litauer@uni-koblenz.de>
MIME-Version: 1.0
Subject: Re: rfc: kill ino64 mount option
References: <20080627153928.GA31384@lst.de> <20080628000914.GE29319@disturbed> <486589E7.9010705@sgi.com>
In-Reply-To: <486589E7.9010705@sgi.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Mark Goodwin schrieb:
> 
> 
> Dave Chinner wrote:
>> On Fri, Jun 27, 2008 at 05:39:28PM +0200, Christoph Hellwig wrote:
>>> Does anyone have objections to kill the ino64 mount option?  It's purely
>>> a debug tool to force inode numbers outside of the range representable
>>> in 32bits and is quite invasive for something that could easily be
>>> debugged by just having a large enough filesystem..
>>
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
> 
> We have a design proposal known as "inode32+" that essentially removes
> the direct mapping between inode number and disk offset. This will
> provide all the layout and performance benefits of ino64 without the
> interop issues.  Until inode32+ is available, we need to keep ino64.

Hi,

as I have massive performance problems using xfs with millions of 
inodes, I am very interested in this "incode32+". My server is a 32 bit 
machine, so I am not able to use inode64.
Is it available?

-- 
Regards
Christoph
________________________________________________________________________
Christoph Litauer                  litauer@uni-koblenz.de
Uni Koblenz, Computing Center,     http://www.uni-koblenz.de/~litauer
Postfach 201602, 56016 Koblenz     Fon: +49 261 287-1311, Fax: -100 1311
PGP-Fingerprint: F39C E314 2650 650D 8092 9514 3A56 FBD8 79E3 27B2
