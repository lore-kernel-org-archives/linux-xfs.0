Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 05:32:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71CVik8013327
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 05:31:44 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF7C434EA5E
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 05:32:56 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id ZGkFRW4HSHMJf3oq for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 05:32:56 -0700 (PDT)
Date: Fri, 1 Aug 2008 22:32:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question about extended attributes...
Message-ID: <20080801123253.GG6201@disturbed>
References: <48925495.7040804@tlinx.org> <4892B361.9030900@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4892B361.9030900@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: "Linda A. Walsh" <xfs@tlinx.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, Aug 01, 2008 at 04:55:29PM +1000, Timothy Shimmin wrote:
> Hi Linda,
> 
> Linda A. Walsh wrote:
> > my man page says extended xfs attributes can have 256-byte names
> > with up to 64K of data.
> > 
> > Is there a limit on the number of extended attributes max data size or
> > name size?
> > 
> > I.e. could I have 1000 attributes with 64K of data each?
> > 
> Yep.
> 
> > Is there a strong reason why the file and data sizes were limited to
> > 256/64K?

....

> I'm not sure why 64K was chosen for a value size limit.

Because changes to EAs are journalled. Hence there must be a bound
size limit because log space is limited.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
