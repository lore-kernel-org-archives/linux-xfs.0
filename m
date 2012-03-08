Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28NYrpB095032 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 17:34:53 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KJTnzJqSzUtG9QQ5 for <xfs@oss.sgi.com>;
	Thu, 08 Mar 2012 15:34:52 -0800 (PST)
Date: Fri, 9 Mar 2012 10:34:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: several 274 fixups
Message-ID: <20120308233450.GO5091@dastard>
References: <4F271967.10308@sandeen.net> <20120131224152.GP9090@dastard>
	<4F592AE1.4070302@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F592AE1.4070302@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: WuBo <wu.bo@cn.fujitsu.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 08, 2012 at 03:55:45PM -0600, Eric Sandeen wrote:
> On 1/31/12 4:41 PM, Dave Chinner wrote:
> > On Mon, Jan 30, 2012 at 04:27:51PM -0600, Eric Sandeen wrote:
> > 
> > That whole create and falloc step can be done with one command:
> > 
> > xfs_io -F -c "write 0 4k" -c "falloc -k 4k 4m" $SCRATCH_MNT/test
> > 
> > The output of xfs_io will tell us what failed if it does.
> 
> too bad that doesn't quite fail properly ;)

Just a small typo - the command is pwrite ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
