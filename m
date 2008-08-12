Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Aug 2008 19:47:20 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7C2lGGD007345
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 19:47:17 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E8FC19B3C80
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 19:48:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id AsRf5vNaIsDDXFnB for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 19:48:30 -0700 (PDT)
Message-ID: <48A0F9FC.1070805@sandeen.net>
Date: Mon, 11 Aug 2008 21:48:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Lock debugging noise or real problem?
References: <48A093A7.40606@tlinx.org> <48A09CA9.9080705@sandeen.net> <48A0F686.2090700@tlinx.org>
In-Reply-To: <48A0F686.2090700@tlinx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Linda Walsh wrote:
> Eric Sandeen wrote:
>> the explanation for xfs_fsr, at least, is the same as the last time you
>> brought it up ;)
>> http://lkml.org/lkml/2008/2/12/86
>> -Eric
>>   
> ---
> Ah...Looks like the 1st xfs_fsr prob is the same as the one 6 months 
> ago...(sorry)
>     xfs_ilock & xfs_ilock
> 
> But... the 3 imapds and the sort process were all 4 holding
>      xfs_ilock     &    shrink_icache_memory
> 
> And the other two xfs_fsr's were holding different locks than the 
> 6-month-ago bug:
>     dio_get_page   &   xfs_ilock

> Are these the same as well?
> 
> I.e. looks like 3 possibly different probs:
>     #1 (same as 6 months ago)...
>     #2 (3)imapds & sort:      holding   xfs_ilock   &  shrink_icache
>     #3 xfs_fsr with two different locks:      dio_get_page   &   xfs_ilock> 

http://www.google.com/search?q=xfs_fsr+dio_get_page+lockdep

-> http://oss.sgi.com/archives/xfs/2008-01/msg00042.html

I haven't looked closely at #2 but there have been so many lockdep
reports for xfs, and so many explanations of why they don't always get
along, you'll probably be able to find something with some searching.

-Eric
