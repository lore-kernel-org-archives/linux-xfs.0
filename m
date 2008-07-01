Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 07:44:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m61Ei9gM004650
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 07:44:10 -0700
Received: from deliver.uni-koblenz.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1032D2A4684
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 07:45:10 -0700 (PDT)
Received: from deliver.uni-koblenz.de (deliver.uni-koblenz.de [141.26.64.15]) by cuda.sgi.com with ESMTP id Vr1ESNTtDBUP33I0 for <xfs@oss.sgi.com>; Tue, 01 Jul 2008 07:45:10 -0700 (PDT)
Message-ID: <486A42F3.3090207@uni-koblenz.de>
Date: Tue, 01 Jul 2008 16:45:07 +0200
From: Christoph Litauer <litauer@uni-koblenz.de>
MIME-Version: 1.0
Subject: Re: rfc: kill ino64 mount option
References: <20080627153928.GA31384@lst.de> <20080628000914.GE29319@disturbed> <486589E7.9010705@sgi.com> <4869E5A4.4020900@uni-koblenz.de> <486A3B5B.20402@sgi.com>
In-Reply-To: <486A3B5B.20402@sgi.com>
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
> Christoph Litauer wrote:
>> Mark Goodwin schrieb:
>> ..
>>> We have a design proposal known as "inode32+" that essentially removes
>>> the direct mapping between inode number and disk offset. This will
>>> provide all the layout and performance benefits of ino64 without the
>>> interop issues.  Until inode32+ is available, we need to keep ino64.
>>
>> Hi,
>>
>> as I have massive performance problems using xfs with millions of
>> inodes, I am very interested in this "incode32+". 
> 
> can you please post some details of the problems you're seeing?

Please see thread "Performance problems with millions of inodes". If you 
don't have it anymore, I can send it to you.

> 
>> My server is a 32 bit machine, so I am not able to use inode64.
>> Is it available?
> 
> inode32+ is only a design at the moment. An implementation is several
> months away. Until then, you'll have to update your server to 64bit.

This is, sadly, not an option at the moment ...

-- 
Regards
Christoph
________________________________________________________________________
Christoph Litauer                  litauer@uni-koblenz.de
Uni Koblenz, Computing Center,     http://www.uni-koblenz.de/~litauer
Postfach 201602, 56016 Koblenz     Fon: +49 261 287-1311, Fax: -100 1311
PGP-Fingerprint: F39C E314 2650 650D 8092 9514 3A56 FBD8 79E3 27B2
