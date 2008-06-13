Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jun 2008 20:05:12 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5D3595H017479
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 20:05:09 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84FB517BB82D
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 20:06:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 2HqD5gTVXznzLWCx for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 20:06:05 -0700 (PDT)
Message-ID: <4851E41C.6050108@sandeen.net>
Date: Thu, 12 Jun 2008 22:06:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Filestreams (and 64bit inodes)
References: <484B15A3.4030505@sauce.co.nz> <484CA425.3080606@sandeen.net> <484DDDB3.70000@sgi.com> <484F0998.90306@sauce.co.nz> <484F2CD7.9070506@sgi.com> <484F452A.8090909@sandeen.net> <48512A34.1020604@sandeen.net> <4851CD32.7080106@melbourne.sgi.com>
In-Reply-To: <4851CD32.7080106@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Greg Banks <gnb@melbourne.sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>, Richard Scobie <richard@sauce.co.nz>, xfs@oss.sgi.com

Greg Banks wrote:
> Eric Sandeen wrote:

> Cool, thanks for the data Eric.
> 
>>  but it ain't pretty.
>>
>> I installed all fedora packages under a directory and ran greg's tool over:
>>
>> /sbin /usr/sbin /bin /usr/bin /usr/kerberos/bin/ /usr/kerberos/sbin/
>>
>> Aggregate results:
>>
>>    4070 29.1% are scripts (shell, perl, whatever)
>>    6598 47.2% don't use any stat() family calls at all
>>    1829 13.1% use 32-bit stat() family interfaces only
>>    1312  9.4% use 64-bit stat64() family interfaces only
>>     180  1.3% use both 32-bit and 64-bit stat() family interfaces
>>   
> Ouch.  That's over two thousand executables to patch, rebuild, and ship.
>> list of packages, sorted by the semi-lame "number of files in package
>> which call a 32-bit stat variant" metric:
>>
>> http://sandeen.fedorapeople.org/stat32-ers

And about 900 packages...

>> I'm going to see if I can't leverage Fedora to clean some of this up.
>>
>> -Eric
>>   
> Good luck with that.

Heh :)  At first I was just going to correlate with st_ino users to cut
it down, but then I learned that glibc will actually give you an
EOVERFLOW if, say st_ino overflows, even if you were only going to check
st_mode.  :(  So pretty much everything needs fixing.

(FWIW I gathered statfs/statvfs calls, too...)

-Eric
