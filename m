Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 May 2007 21:39:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l514dVWt004088
	for <xfs@oss.sgi.com>; Thu, 31 May 2007 21:39:33 -0700
Date: Fri, 01 Jun 2007 14:39:48 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [patch 1/3] Fix XFS_IOC_FSGEOMETRY_V1 in compat mode
Message-ID: <0C1BF59AD81186689933280E@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070531132615.GO85884050@sgi.com>
References: <20070530125954.706423971@suse.cz> <20070530143043.216024061@suse.cz>
 <20070531023031.GH85884050@sgi.com> <649C7FF68B1450E03D544BD9@timothy-shimmins-power-mac-g5.local>
 <20070531132615.GO85884050@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Michal Marek <mmarek@suse.cz>, xfs@oss.sgi.com



--On 31 May 2007 11:26:15 PM +1000 David Chinner <dgc@sgi.com> wrote:
>> Who would want to use XFS_IOC_FSGEOMETRY_V1?
>>
>> Okay it turns out a whole bunch of our xfs-cmds :-)
>> (Such as xfsdump as Michal mentioned)
>> On Sep/2002, Nathan changed a bunch of them to use v1.
>>  xfsprogs-2.3.0 (03 September 2002)
>>        - Several changes to geometry ioctl callers which will make
>>          the tools useable on older kernel versions too.
>> So he did this so that new tools would work on the older kernels which
>> didn't support the new geom version.
>> So I guess we are stuck with v1 now.
>
> Not necessarily - we could change the tools to use v4, and if that
> didn't exist, then try v1. That way we don't need to support v1 in
> linux, and the tools still run on old kernels.....
>
The problem with that is the old tools won't run on new kernels.
If you get a new kernel and use an old xfsdump then you are out of luck.
Not sure if we want to require people to bump up to new userspace for this.

--Tim
