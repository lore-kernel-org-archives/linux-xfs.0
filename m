Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0190B7F3F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 14:34:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E0A2C304062
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:34:08 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zlC5ynDtPJRFTwK7 for <xfs@oss.sgi.com>;
	Tue, 13 Jan 2015 12:34:04 -0800 (PST)
Date: Wed, 14 Jan 2015 07:33:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: extremely slow file creation/deletion after xfs ran full
Message-ID: <20150113203332.GD29484@destitution>
References: <54B387A1.6000807@aei.mpg.de> <54B3CC6A.4080405@aei.mpg.de>
	<20150112155206.GD25944@bfoster.bfoster>
	<54B3F19D.6030307@aei.mpg.de>
	<20150112163749.GE25944@bfoster.bfoster>
	<54B40552.50106@aei.mpg.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54B40552.50106@aei.mpg.de>
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
To: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Jan 12, 2015 at 06:33:06PM +0100, Carsten Aulbert wrote:
> Hi
> 
> On 01/12/2015 05:37 PM, Brian Foster wrote:
> > No, but it does show that there are a bunch of free inodes scattered
> > throughout the existing records in most of the AGs. The finobt should
> > definitely help avoid the allocation latency when this occurs.
> > 
> 
> That is good to know/hope :)
> 
> > It is interesting that you have so many more free inodes in ag 0 (~53m
> > as opposed to several hundreds/thousands in others). What does 'p count'
> > show for each ag? Was this fs grown to the current size over time?
> > 
> "p count" seems to "thin out" over ag:
> 
> count = 513057792

AG 0 has > 500 allocated million inodes, and > 50 million free
inodes.  Traversal of the inode btree to find free inodes is going
to be costly in both CPU time and memory footprint. The other AGs
have much fewer inodes, so searches are much less costly.

That's why allocation will be sometimes slow and sometimes fast - it
depends on what AG the inode is being allocated from.

> count = 16596224
> count = 15387584
> count = 14958528
> count = 4096960
> count = 4340416
> count = 4987968
> count = 3321792
> count = 5041856
> count = 5485376
> count = 5233088
> count = 5810432
> count = 5271552
> count = 5464000
> count = 365440

This pattern seems to match a filesystem that was running under
inode32 for most of it's life, and is now using inode64 and hence
spreading the subdirectories and hence new inodes over all AGs
instead of just limiting them to AG 0....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
