Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 00:21:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S7LEPU002231
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 00:21:14 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A47F1B6678D
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 00:21:13 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id x4Q7UCsm2juxljgK for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 00:21:13 -0700 (PDT)
Date: Tue, 28 Oct 2008 18:21:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Map a disk LBA to filename?
Message-ID: <20081028072105.GW4985@disturbed>
References: <4905A3FB.6080709@aei.mpg.de> <20081027114945.GE4985@disturbed> <4905B48A.8010108@aei.mpg.de> <4905BC13.3030402@drutsystem.com> <20081027233516.GG4985@disturbed> <4906BB32.8080403@aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4906BB32.8080403@aei.mpg.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: Michal Soltys <nozo@drutsystem.com>, xfs@oss.sgi.com

On Tue, Oct 28, 2008 at 08:11:46AM +0100, Carsten Aulbert wrote:
> Hi Dave et al
> 
> Dave Chinner wrote:
> 
> > Blockget - yes it will. It just does the traversal internally to
> > build the mapping. With large filesystems xfs_db can run out of
> > memory building the mapping, which is why I've used the
> > explicit traverse+xfs_bmap method in the past....
> 
> How expensive is this operation (rule of thumb)? We will mostly use this
> on compute nodes where the partition is 500-750 GB large and the node
> has 8 GB of memory. For the simple test where I apparently hit thin air
> I have not seen anything bad in terms of memory consumption.

Shouldn't be a problem with a filesystem that size. It's when you're
dealing with tens of terabytes in a single filesystem that it can
be a problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
