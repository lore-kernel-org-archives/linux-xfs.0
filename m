Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 22:12:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m745CmYr022852
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 22:12:50 -0700
Message-ID: <48969015.6020205@sgi.com>
Date: Mon, 04 Aug 2008 15:13:57 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Question about extended attributes...
References: <48925495.7040804@tlinx.org> <4892B361.9030900@sgi.com> <20080801123253.GG6201@disturbed>
In-Reply-To: <20080801123253.GG6201@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Fri, Aug 01, 2008 at 04:55:29PM +1000, Timothy Shimmin wrote:
>> Hi Linda,
>>
>> Linda A. Walsh wrote:
>>> my man page says extended xfs attributes can have 256-byte names
>>> with up to 64K of data.
>>>
>>> Is there a limit on the number of extended attributes max data size or
>>> name size?
>>>
>>> I.e. could I have 1000 attributes with 64K of data each?
>>>
>> Yep.
>>
>>> Is there a strong reason why the file and data sizes were limited to
>>> 256/64K?
> 
> ....
> 
>> I'm not sure why 64K was chosen for a value size limit.
> 
> Because changes to EAs are journalled. Hence there must be a bound
> size limit because log space is limited.
> 
Yeah, good point.
Which I guess also reflects how we consider extended attributes
to be more for metadata.

--Tim
