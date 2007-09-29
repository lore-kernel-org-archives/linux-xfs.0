Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Sep 2007 17:35:37 -0700 (PDT)
Received: from terminus.zytor.com ([198.137.202.10])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8T0ZV0C024209
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 17:35:32 -0700
Message-ID: <46FD959E.5030009@zytor.com>
Date: Fri, 28 Sep 2007 17:00:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Subject: Re: Truncated Filesystem
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org> <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan> <46FD9006.6050807@sandeen.net>
In-Reply-To: <46FD9006.6050807@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Benjamin Carr <bcarr@whoi.edu>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Justin Piszcz wrote:
>> Including LKML on this one as it may be a partition size limit?  Sdc1 is 
>> not 11TB.
>>
>> Justin.
> 
> Yup saw the same thing:
> 
> (1957867653*1024)/1024/1024/1024/1024 = 1.82T
> 
> I'm afraid you don't have a truncated filesystem, you have a truncated
> block device.  I'm afraid this is not an xfs problem... you need to
> figure out what happened to sdc1 (for example, why doesn't it extend to
> the end of sdc?)
> 

What kind of partition table is it?  MS-DOS partition tables have a 2 TB
limit.

	-hpa
