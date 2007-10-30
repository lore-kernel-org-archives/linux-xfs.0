Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 17:46:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9U0k41w008782
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 17:46:06 -0700
Message-ID: <47267EC7.8000906@sgi.com>
Date: Tue, 30 Oct 2007 11:45:59 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Default mount options (that suck less).
References: <20071029075657.GA84369978@melbourne.sgi.com> <4725FBB4.1010400@sandeen.net>
In-Reply-To: <4725FBB4.1010400@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Niv Sardi <xaiki@sgi.com>, xfs@oss.sgi.com

Eric Sandeen wrote:
> Niv Sardi wrote:
>> Hello,
>>
>> XFS's default mount options are in most cases sub-optimal, we should try
>> to have more sensible defaults, so far I'm following some quick dave-powered
>> recomendations:
>>
>> - version 2 logs
>> - attr2
>> - lazy superblock counters
>> - less allocation groups for single disk configs
>>
>> - imaxpct default can be reduced
>>
>> it is currently 25, what would be reasonable ?
>>
>> - dropping the ability to turn unwritten extents off completely
>>
>> please submit your pet-idea for better defaults here.
> 
> Sorry for all the replies ;-)
> 
> What would you think of a mkfs conf file like e2fsprogs has, which
> defines filesystem classes, and defaults for each?  (small, news,
> largefile, etc...)
> 
> -Eric
> 

It might be interesting if people let us know what non-default
mkfs and mount options that they are using for their various
configurations/classes.
Didn't Russell C. have some survey years ago - can't remember if
that was for h/ware or what now.

Maybe Dave C. or others have some suggestions from performance runs
for various types of workloads. Do we have this compiled somewhere?

--Tim
