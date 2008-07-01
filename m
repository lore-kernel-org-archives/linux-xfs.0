Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 07:12:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m61EBuEL002280
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 07:12:33 -0700
Message-ID: <486A3B5B.20402@sgi.com>
Date: Wed, 02 Jul 2008 00:12:43 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: rfc: kill ino64 mount option
References: <20080627153928.GA31384@lst.de> <20080628000914.GE29319@disturbed> <486589E7.9010705@sgi.com> <4869E5A4.4020900@uni-koblenz.de>
In-Reply-To: <4869E5A4.4020900@uni-koblenz.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Litauer <litauer@uni-koblenz.de>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com



Christoph Litauer wrote:
> Mark Goodwin schrieb:
> ..
>> We have a design proposal known as "inode32+" that essentially removes
>> the direct mapping between inode number and disk offset. This will
>> provide all the layout and performance benefits of ino64 without the
>> interop issues.  Until inode32+ is available, we need to keep ino64.
>
> Hi,
>
> as I have massive performance problems using xfs with millions of
> inodes, I am very interested in this "incode32+". 

can you please post some details of the problems you're seeing?

> My server is a 32 bit machine, so I am not able to use inode64.
> Is it available?

inode32+ is only a design at the moment. An implementation is several
months away. Until then, you'll have to update your server to 64bit.

Thanks
-- Mark
