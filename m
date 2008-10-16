Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 15:35:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9GMYxSY030198
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 15:34:59 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1AAFD5091E8
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 15:36:40 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id EEfdegWFWnVpc56C for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 15:36:40 -0700 (PDT)
Date: Fri, 17 Oct 2008 09:36:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS fix remount rw with unrecognized options
Message-ID: <20081016223637.GB31761@disturbed>
References: <20081016002926.D912558FA22B@chook.melbourne.sgi.com> <20081016134112.GA8773@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016134112.GA8773@ubuntu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jianjun Kong <jianjun@zeuux.org>
Cc: Tim Shimmin <tes@sgi.com>, stable@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 16, 2008 at 09:41:12PM +0800, Jianjun Kong wrote:
> 
> And the code above "return 0" can not be executed, so delete them.
> __________________________________________
> #if 0
>                         printk(KERN_INFO
>         "XFS: mount option \"%s\" not supported for remount\n", p);
>                         return -EINVAL;
> #else                                                                                                            
>                         return 0;
> -----------------------------------------

That ifdef was added to stub out the behaviour we *actually want*
remount to have when it encounters an invalid remount option.
The reason for leaving it is in the next release we should have all
the other problems we discovered by doing this fixed, so that
code will be re-enabled. Hence the temporary #if 0 around it.

So at this point, don't remove it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
