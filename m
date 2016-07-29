Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE15E7CA0
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2016 21:26:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 705708F8049
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2016 19:26:29 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fhvHMm8riEDsXeG5 for <xfs@oss.sgi.com>;
	Thu, 28 Jul 2016 19:26:27 -0700 (PDT)
Date: Fri, 29 Jul 2016 12:25:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Any better way to interact with xfs?
Message-ID: <20160729022552.GA16044@dastard>
References: <SYXPR01MB044863A851C967C37649BE3FF8000@SYXPR01MB0448.ausprd01.prod.outlook.com>
	<CAOQ4uxiOavjc+wrRQHW8U16EDocNRRGnM24a7d6dhO8tzV0a1w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiOavjc+wrRQHW8U16EDocNRRGnM24a7d6dhO8tzV0a1w@mail.gmail.com>
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
To: Amir Goldstein <amir73il@gmail.com>
Cc: Ryan Lindsay <rlindsay@unimelb.edu.au>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Jul 28, 2016 at 09:48:07AM +0300, Amir Goldstein wrote:
> Hi Ryan,
> 
> You could use the XFS_IOC_FSINUMBERS/XFS_IOC_FSBULKSTAT API to iterate
> over all inodes in the fs.

That's a read-only API - you can't use it to change the inodes
on disk.

> not having to readdir and recourse the directory tree should safe you
> some time (much less i/o).
> Also, the interface can be used to make your conversion work parallel
> by working on different inode ranges.

It cannot be used to make coherent, atomic changes to the inode
state.

> You can use xfsdump/xfsrestore code as reference.

xfsdump uses bulkstat scan and read inodes, not change anything on
disk.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
