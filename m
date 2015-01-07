Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 13E737F50
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 18:27:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 97757AC001
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 16:27:33 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	pacGow4wKlR4pB5M for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 16:27:31 -0800 (PST)
Date: Wed, 7 Jan 2015 11:27:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS corrupt after RAID failure and resync
Message-ID: <20150107002729.GB25000@dastard>
References: <CAOFq7B5PaPCJdAxyYa6feCXgGbkz+1Qs+Gfb2WG=5af=A+WOQg@mail.gmail.com>
	<44b127de199c445fa12c3b832a05f108@000s-ex-hub-qs1.unimelb.edu.au>
	<CAOFq7B5HnEZFtVvoRORRwOxPhx5Txf9xJW=BG6GFbLMNk+_CEw@mail.gmail.com>
	<8cc9a649ec2240faa4e38fd742437546@000S-EX-HUB-NP2.unimelb.edu.au>
	<CAOFq7B6t8jrBBu81CuT2tqTyPEYROqkCJ4ChnxCtCvMGiGb7wg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOFq7B6t8jrBBu81CuT2tqTyPEYROqkCJ4ChnxCtCvMGiGb7wg@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: David Raffelt <david.raffelt@florey.edu.au>
Cc: "stefanrin@gmail.com" <stefanrin@gmail.com>, Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jan 07, 2015 at 10:47:00AM +1100, David Raffelt wrote:
> Hi Brain,
> Below is the root inode data. I'm currently running xfs_metadump and will
> send you a link to the file.
> Cheers!
> David
> 
> 
> 
> 
> xfs_db> sb
> xfs_db> p rootino
> rootino = 1024
> xfs_db> inode 1024
> xfs_db> p
> core.magic = 0
> core.mode = 0
> core.version = 0
> core.format = 0 (dev)

It's a zero'd block. Even an unallocated inode should have the
magic number, inode version and data fork format stamped in it.
This is something we typically see when RAID rebuilds have not
worked correctly, even though they say they were "successful"....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
