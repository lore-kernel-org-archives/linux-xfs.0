Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97NKGQ7004460 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 18:20:16 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77E3D1B6981
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 16:20:14 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AQQXZzDgzM2BmNMU for <xfs@oss.sgi.com>;
	Fri, 07 Oct 2011 16:20:14 -0700 (PDT)
Date: Sat, 8 Oct 2011 10:20:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Premature "No Space left on device" on XFS
Message-ID: <20111007232012.GI3159@dastard>
References: <20111007013711.GW3159@dastard>
	<1317976813.82044.YahooMailClassic@web77716.mail.sg1.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1317976813.82044.YahooMailClassic@web77716.mail.sg1.yahoo.com>
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
To: Gim Leong Chin <chingimleong@yahoo.com.sg>
Cc: Bernhard Schmidt <berni@birkenwald.de>, xfs@oss.sgi.com

On Fri, Oct 07, 2011 at 04:40:13PM +0800, Gim Leong Chin wrote:
> Hi Dave,
> 
> 
> > 
> > As it is, your problem is most likely fragmented free space
> > (an
> > aging problem). Inodes are allocated in chunks of 64, so
> > require an
> > -aligned- contiguous 16k extent for the default 256 byte
> > inode size.
> > If you have no aligned contiguous 16k extents free then
> > inode
> > allocation will fail.
> > 
> 
> I understand from the mkfs.xfs man page "The  XFS  inode  contains a fixed-size part and a variable-size part."
> 
> 1) Do you mean inodes are allocated in units of 64 at one go?

http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/AG_Inode_Management.html
http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/Inode_Btrees.html

> 2) What is the size of the fixed-size part?
> 3) Are the fixed-size parts of inodes also allocated in units of 64 at one go?
> 4) Where are the fixed-size parts located?  On special extents just like the variable-size part?
> 5) What about the locality of the variable and fixed size parts of the inodes?  Can they be any distance apart?

http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/On-disk_Inode.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
