Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 15:46:39 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9GMkaa9031543
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 15:46:36 -0700
Message-ID: <48F7C4A7.5090708@sgi.com>
Date: Fri, 17 Oct 2008 09:48:07 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS fix remount rw with unrecognized options
References: <20081016002926.D912558FA22B@chook.melbourne.sgi.com> <20081016134112.GA8773@ubuntu> <20081016223637.GB31761@disturbed>
In-Reply-To: <20081016223637.GB31761@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jianjun Kong <jianjun@zeuux.org>, Dave Chinner <david@fromorbit.com>, stable@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Dave Chinner wrote:
> On Thu, Oct 16, 2008 at 09:41:12PM +0800, Jianjun Kong wrote:
>> And the code above "return 0" can not be executed, so delete them.
>> __________________________________________
>> #if 0
>>                         printk(KERN_INFO
>>         "XFS: mount option \"%s\" not supported for remount\n", p);
>>                         return -EINVAL;
>> #else                                                                                                            
>>                         return 0;
>> -----------------------------------------
> 
> That ifdef was added to stub out the behaviour we *actually want*
> remount to have when it encounters an invalid remount option.
> The reason for leaving it is in the next release we should have all
> the other problems we discovered by doing this fixed, so that
> code will be re-enabled. Hence the temporary #if 0 around it.
> 
> So at this point, don't remove it.
> 
> Cheers,
> 
> Dave.

Exactly.
I don't want it removed.
Extra code for comparing existing mount state with new mount state
needs to be done and this code can be reactivated when we sort
this stuff out later.
This patch should be just the fix for the current regression.

Thanks,
--Tim
