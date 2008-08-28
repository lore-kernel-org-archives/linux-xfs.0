Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Aug 2008 17:18:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7S0IlFi030182
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2008 17:18:48 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 856DDFD1021
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2008 17:20:10 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id qEwHBiyCHw0DwnpZ for <xfs@oss.sgi.com>; Wed, 27 Aug 2008 17:20:10 -0700 (PDT)
Date: Thu, 28 Aug 2008 10:20:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS issue under 2.6.25.13 kernel
Message-ID: <20080828002005.GA30189@disturbed>
References: <50ed5c760808220303p37e03e8dge5b868a572374e0b@mail.gmail.com> <20080823010524.GM5706@disturbed> <50ed5c760808250408o44aeaf07me262eab8da8340ba@mail.gmail.com> <20080826014133.GS5706@disturbed> <50ed5c760808260553i7def5e93qb0bcb4d2206a4a38@mail.gmail.com> <20080827005243.GB5706@disturbed> <50ed5c760808271109u4dee0311ha7cf2c1e7cae31dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50ed5c760808271109u4dee0311ha7cf2c1e7cae31dd@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?utf-8?B?U8WCYXdvbWly?= Nowakowski <nailman23@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 27, 2008 at 08:09:18PM +0200, Sławomir Nowakowski wrote:
> Dear Dave,
> 
> We really apreciate your help..
> 
> In the realtion to previous correspondations about differences between
> implementation of kernels 2.6.17.13 and 2.6.25.13 we'd like to ask
> some questions.
> 
> We was based on git repository:
> 
> git://git.kernel.org
> 
> We have reverted some changes for XFS in 2.6.25.13 kernel. We have
> usedf 3 commits:
> 
> - 94E1E99F11... (SGI-PV: 964468)
> - 4BE536DEBE... (SGI-PV: 955674)
> - 4CA488EB4...  (SGI-PV: 971186)
> 
> With these changes we have created patch for 2.6.25.13 kernel. This
> patch should eliminate additional reservation of disk space in XFS
> file system. Our intention was to get similarity space of disk between
> 2.6.17.13 and 2.6.25.13 kernels.

After removing the reservation with xfs_io (the big difference), I
don't see why you need to hack the kernel as well. Have you got
such little margin in your filesystem provisioning that you can't
spare 4 blocks per AG?

> Does patch that is attached to this mail do everything properly?

Don't know. You've taken away a bunch of reserved blocks other
code relies on existing for correct operation at ENOSPC. Given
that you are doing this because you are running so close to
ENOSPC there's a good chance that you've broken something.

I don't have the time (or the desire) to analyse the impact of the
changes being made, but I bet that the XFSQA tests that exercise
behaviour at ENOSPC will start to deadlock again...

> Is it
> 100% compatibe with XFS API?

You've changed statfs. You'll have to make sure it reports
the correct thing in all cases (there's an XFSQA test for this).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
