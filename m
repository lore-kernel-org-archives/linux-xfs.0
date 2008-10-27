Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 16:35:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RNZPts021386
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:35:26 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A69754F2D0
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:35:24 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id pJoSYVFWH2ln8OOf for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:35:24 -0700 (PDT)
Date: Tue, 28 Oct 2008 10:35:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Map a disk LBA to filename?
Message-ID: <20081027233516.GG4985@disturbed>
References: <4905A3FB.6080709@aei.mpg.de> <20081027114945.GE4985@disturbed> <4905B48A.8010108@aei.mpg.de> <4905BC13.3030402@drutsystem.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4905BC13.3030402@drutsystem.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michal Soltys <nozo@drutsystem.com>
Cc: Carsten Aulbert <carsten.aulbert@aei.mpg.de>, xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 02:03:15PM +0100, Michal Soltys wrote:
> Carsten Aulbert wrote:
>>
>> Dave Chinner wrote:
>>> Use xfs_bmap to find the location on disk of the extents in each
>>> file. Recurse over the filesystem until you find the file that owns
>>> the block that went bad.
>>
>> Sounds like a tedious but doable route to take.
>>
>
> Wouldn't something like (under xfs_db) :
>
> getblock -b #block -n
> ncheck -i #inode
>
> where required #inode is reported by getblock
>
> do the thing ?

Blockget - yes it will. It just does the traversal internally to
build the mapping. With large filesystems xfs_db can run out of
memory building the mapping, which is why I've used the
explicit traverse+xfs_bmap method in the past....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
