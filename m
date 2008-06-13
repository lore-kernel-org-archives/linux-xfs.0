Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jun 2008 20:19:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5D3JUUa023007
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 20:19:31 -0700
Message-ID: <4851E774.2070401@sgi.com>
Date: Fri, 13 Jun 2008 13:20:20 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: Filestreams (and 64bit inodes)
References: <484B15A3.4030505@sauce.co.nz> <484CA425.3080606@sandeen.net> <484DDDB3.70000@sgi.com> <484F0998.90306@sauce.co.nz> <484F2CD7.9070506@sgi.com> <484F452A.8090909@sandeen.net> <48512A34.1020604@sandeen.net> <4851CD32.7080106@melbourne.sgi.com>
In-Reply-To: <4851CD32.7080106@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Greg Banks <gnb@melbourne.sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Timothy Shimmin <tes@sgi.com>, Richard Scobie <richard@sauce.co.nz>, xfs@oss.sgi.com



Greg Banks wrote:
> Eric Sandeen wrote:
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

struct dirent has an embedded ino_t too, so for completeness we should also
be looking for readdir(), readdir64(), getdirentries(), 
getdirentries64(), etc.

>> I'm going to see if I can't leverage Fedora to clean some of this up.
>>
>> -Eric
>>
> Good luck with that.

Yes good luck :)
(and the plan for statically linked apps? ...)

Cheers

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
