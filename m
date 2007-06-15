Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Jun 2007 17:56:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5F0ttWt006391
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 17:55:56 -0700
Subject: Re: Review: dmapi-devel RPM should required xfsprogs-devel RPM
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <op.ttwa4bv73jf8g2@pc-bnaujok.melbourne.sgi.com> <467150D3.7090109@sandeen.net>
Date: Fri, 15 Jun 2007 10:59:38 +1000
Message-ID: <op.ttxudohb3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <467150D3.7090109@sandeen.net>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Fri, 15 Jun 2007 00:29:39 +1000, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> Barry Naujok wrote:
>> As per the subject (and also mentioned in the description):
>>
>> --- a/dmapi/build/rpm/dmapi.spec.in     2007-06-14 15:02:13.000000000  
>> +1000
>> +++ b/dmapi/build/rpm/dmapi.spec.in     2007-06-14 14:47:31.290063558  
>> +1000
>> @@ -23,7 +23,7 @@
>>   %package devel
>>   Summary: Data Management API static libraries and headers.
>>   Group: Development/Libraries
>> -Requires: @pkg_name@ >= 2.0.4
>> +Requires: @pkg_name@ >= 2.0.4 xfsprogs-devel
>>
>>   %description devel
>>   dmapi-devel contains the libraries and header files needed to
>>
>>
>
> seems sane to me.  Just a header issue I guess?

Yep, dmapi.h requires xfs headers.
