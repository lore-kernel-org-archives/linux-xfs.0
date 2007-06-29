Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 23:29:19 -0700 (PDT)
Received: from zebday.corky.net (corky.net [212.150.53.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5T6TEtL027521
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 23:29:16 -0700
Message-ID: <4684A506.4030705@corky.net>
Date: Fri, 29 Jun 2007 07:21:58 +0100
From: Just Marc <marc@corky.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr, performance related tweaks
References: <4683ADEB.3010106@corky.net> <46841C60.5030207@sandeen.net>
In-Reply-To: <46841C60.5030207@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Hi Eric,

In my particular case, and I'm sure for many other people, files that 
are stored never change again until they deleted.  I hinted that there 
could be a command line switch to turn this functionality on, as it may 
not be perfect for everyone's use cases.

If nobody likes this still, I would appreciate some hints on how to mark 
files as no-defrag from within fsr itself given that I only have the 
file descriptor ... A hack like looking up the descriptor in 
/proc/self/fd should work, but is linux specific and is too hackish in 
my opinion.   I'd like to at least have a nice simple patch for my own uses.

Marc


Eric Sandeen wrote:
> Just Marc wrote:
>
>   
>> 2. Files for which 'No improvement will be made' should also be marked 
>> as no-defrag, this will avoid a ton of extra work in the future.   
>>     
>
> But... that file could drastically change in the future, no?  Just
> because it can't be improved now doesn't necessarily mean that it should
> never be revisited on subsequent runs, does it?
>
> -Eric
>
>
>   
