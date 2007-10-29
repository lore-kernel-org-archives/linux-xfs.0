Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 07:01:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9TE1n5H021294
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 07:01:53 -0700
Message-ID: <4725E7D0.8090400@sandeen.net>
Date: Mon, 29 Oct 2007 09:01:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Default mount options (that suck less).
References: <20071029075657.GA84369978@melbourne.sgi.com> <20071029085502.GI995458@sgi.com>
In-Reply-To: <20071029085502.GI995458@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Niv Sardi <xaiki@sgi.com>, xfs@oss.sgi.com

David Chinner wrote:
> On Mon, Oct 29, 2007 at 06:56:57PM +1100, Niv Sardi wrote:
>> Hello,
>>
>> XFS's default mount options are in most cases sub-optimal, we should try
> 
> Mkfs options ;)
> 
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
> 
> Given that 25% on a 4GB filesystem will allow about 5million inodes,
> I think it's probably reasonable to bring it down to 5% by the time we
> pass 1TB and 1% by 50TB.....

But what does this affect?  It's a cap, but it doesn't affect allocation
policy or anything does it?  What's the downside to 25%?

-Eric
