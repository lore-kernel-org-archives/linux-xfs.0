Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jun 2008 18:31:41 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5D1VaTF012934
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 18:31:36 -0700
Message-ID: <4851CD32.7080106@melbourne.sgi.com>
Date: Fri, 13 Jun 2008 11:28:18 +1000
From: Greg Banks <gnb@melbourne.sgi.com>
MIME-Version: 1.0
Subject: Re: Filestreams (and 64bit inodes)
References: <484B15A3.4030505@sauce.co.nz> <484CA425.3080606@sandeen.net> <484DDDB3.70000@sgi.com> <484F0998.90306@sauce.co.nz> <484F2CD7.9070506@sgi.com> <484F452A.8090909@sandeen.net> <48512A34.1020604@sandeen.net>
In-Reply-To: <48512A34.1020604@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, Richard Scobie <richard@sauce.co.nz>, xfs@oss.sgi.com

Eric Sandeen wrote:
> Eric Sandeen wrote:
>   
>> Timothy Shimmin wrote:
>>
>>     
>>> (1) It would be nice to know what the state of the apps really are.
>>> There is also the question of interaction with CXFS and NFS.
>>> Greg Banks has a compat matrix for NFS. It looks like the main
>>> things is to get something half recent - linux 2.6, nfs v3,
>>> apps which use 64 bit sys calls (eg. stat64) etc...
>>> Would need to do investigating.
>>>       
>> Greg has a tool to scan binaries... some day I'm going to run it over
>> the fedora universe, I'll get back to you...  someday.
>>     
>
> someday didn't take too long :) 
Cool, thanks for the data Eric.

>  but it ain't pretty.
>
> I installed all fedora packages under a directory and ran greg's tool over:
>
> /sbin /usr/sbin /bin /usr/bin /usr/kerberos/bin/ /usr/kerberos/sbin/
>
> Aggregate results:
>
>    4070 29.1% are scripts (shell, perl, whatever)
>    6598 47.2% don't use any stat() family calls at all
>    1829 13.1% use 32-bit stat() family interfaces only
>    1312  9.4% use 64-bit stat64() family interfaces only
>     180  1.3% use both 32-bit and 64-bit stat() family interfaces
>   
Ouch.  That's over two thousand executables to patch, rebuild, and ship.
> list of packages, sorted by the semi-lame "number of files in package
> which call a 32-bit stat variant" metric:
>
> http://sandeen.fedorapeople.org/stat32-ers
>
> I'm going to see if I can't leverage Fedora to clean some of this up.
>
> -Eric
>   
Good luck with that.

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
The cake is *not* a lie.
I don't speak for SGI.
