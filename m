Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 15:54:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9GMsVi1032390
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 15:54:34 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55AB15090AC
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 15:56:14 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 9qcctk6emprpH8N7 for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 15:56:14 -0700 (PDT)
Date: Fri, 17 Oct 2008 09:56:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: XFS internal error xfs_trans_cancel in 2.6.27
Message-ID: <20081016225611.GC31761@disturbed>
References: <20081009113610.F13062@moloch.hellmouth.net> <20081009230227.GL9597@disturbed> <20081016151752.F30919@moloch.hellmouth.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081016151752.F30919@moloch.hellmouth.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sean Purdy <sean-kernel@purdy.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Oct 16, 2008 at 03:17:52PM +0100, Sean Purdy wrote:
> On Fri, 10 Oct 2008, Dave Chinner said:
> > On Thu, Oct 09, 2008 at 11:36:10AM +0100, Sean Purdy wrote:
> > > Hi,
> > > 
> > > Further to the discussion (and patching) of an xfs_trans_cancel
> > > issue in June, in kernel < 2.6.26
> > > 
> > > A similar issue came up on one disk of a 4 x 750GiB machine
> > > with a 2.6.24 kernel.  So I installed 2.6.27-6 and gave it another try.
> > > But I'm still seeing the same problem.  Remounting the drive each time
> > > is fine, and xfs_check shows no errors.
> > 
> > 2.6.27-6? You mean 2.6.27-rc6?
> 
> I meant rc9 as it happens, but never mind.
>  
> > Anyway, you need to try this patch:
> > 
> > http://oss.sgi.com/archives/xfs/2008-10/msg00105.html
> > 
> > which I posted a few days ago that fixes the latest reproducable
> > case of this shutdown that I know of.
> 
> This patch worked fine, thanks very much!

Great. It's good to know that mutliple people إve been hitting
this specific problem.

> Can we get it into
> some stable version of 2.6.27?  Maybe I can put in a bug request
> for the next Ubuntu kernel.

We haven't pushed it upstream for .28-rc1 yet as it is still being
QA'd. Once it is pushed we can consider it for .27-stable.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
