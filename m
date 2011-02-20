Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1KLTP7T105694 for <xfs@oss.sgi.com>; Sun, 20 Feb 2011 15:29:25 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 730982EC265
	for <xfs@oss.sgi.com>; Sun, 20 Feb 2011 13:32:07 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	n3EGpk5rdeQPNrNG for <xfs@oss.sgi.com>;
	Sun, 20 Feb 2011 13:32:07 -0800 (PST)
Date: Mon, 21 Feb 2011 08:32:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: First 128KB of XFS partition is NULL.
Message-ID: <20110220213205.GD3166@dastard>
References: <AANLkTindiB_D7shZKkrdkePM=xaAXCe1HAX5tPy87SCy@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTindiB_D7shZKkrdkePM=xaAXCe1HAX5tPy87SCy@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Feb 20, 2011 at 11:22:34AM +0900, Ajeet Yadav wrote:
> Dear All,
> I have received a corrupted disk from team testing XFS, when I look
> hexdump of partiton. Its 0000 in first 128KB.
> Our kernel is 2.6.30.9 however we have backported XFS from 2.6.34,
> Arch MIP with VIPT cache.
> This arch previously had many issues but after properly implementing
> "xfs: fix xfs to work with Virtually Indexed architectures " most
> problem resolved.
> 
> Can anyone make guess in what case first 128KB may become NULL, I seem
> to be impossible because file system does not modify all 128KB at the
> begining of partition at once.

Something else wrote to the block device. Maybe a partitioning
program, a boot loader or possibly something else entirely...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
