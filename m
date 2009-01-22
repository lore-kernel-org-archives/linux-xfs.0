Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0MHewAo093607 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 11:40:58 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D82A184A0F5
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 09:40:13 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id luQbXD7P2aArBX3O for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2009 09:40:13 -0800 (PST)
Message-ID: <4978AF61.20801@sandeen.net>
Date: Thu, 22 Jan 2009 11:39:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: No space left on device on xfs filesystem with 1.6TB free
References: <alpine.LSU.2.00.0901211007200.19898@hermes-2.csi.cam.ac.uk>	<20090121225453.GN10158@disturbed>	<20090122030955.GT10158@disturbed>
	<49784989.1000306@news-service.com>
In-Reply-To: <49784989.1000306@news-service.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Patrick Schreurs <patrick@news-service.com>
Cc: Owen Dunn <osd1000@cam.ac.uk>, xfs@oss.sgi.com

Patrick Schreurs wrote:
> Dave Chinner wrote:
>> You've run out of inode space below 1TB or free space is
>> sufficiently fragmented below 1TB that new inode chunks cannot
>> be allocated.
> 
> Is this related to fs growth or can this happen with any xfs partition?

a grown fs may be more susceptible to it...

xfs dynamically allocates inodes, and inode numbers reflect their
location on disk.

For large-offset disk locations, the inode numbers grow large, and can
be > 32 bits, which causes problems for some applications.

By default xfs keeps inode numbers below 32 bits, and hence restricts
them to the lower part of the filesystem, with data going out towards
the end.

If your fs started out small, more of that low-offset space will be
occupied by data, and be unavailable for inodes even as the filesystem
grows; in short when the fs was small, you used up the space that the
larger fs would have liked to use for inodes.

-Eric

> Thanks,
> 
> Patrick Schreurs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
