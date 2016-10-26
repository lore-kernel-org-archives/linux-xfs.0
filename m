Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51661 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750832AbcJZDeR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 23:34:17 -0400
Date: Tue, 25 Oct 2016 20:34:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/39] xfs_db: print one array element per line
Message-ID: <20161026033412.GF23568@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743669846.11035.8419161903309169766.stgit@birch.djwong.org>
 <20161026005138.GE23194@dastard>
 <20161026011343.GD23568@birch.djwong.org>
 <20161026032308.GH23194@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026032308.GH23194@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 26, 2016 at 02:23:08PM +1100, Dave Chinner wrote:
> On Tue, Oct 25, 2016 at 06:13:43PM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 26, 2016 at 11:51:38AM +1100, Dave Chinner wrote:
> > > On Tue, Oct 25, 2016 at 04:04:58PM -0700, Darrick J. Wong wrote:
> > > > Print one array element per line so that the debugger output isn't
> > > > a gigantic pile of screen snow.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > What commands does this affect?
> > 
> > The 'print' command.
> 
> Ok, let me be more specific - what is an example of the change of
> behaviour? printing bmbt records in a block, or something else?
> Can you post a before/after example?

Oh, sorry.  The patch changes the print command such that arrays of
records are printed with one record per line instead of one enormously
long line.

Before (inobt):

xfs_db> p recs
recs[1-55] = [startino,holemask,count,freecount,free] 
1:[128,0,64,0,0] 2:[4288,0xff,32,0,0xffffffff] 3:[4352,0,64,0,0] 4:[4416,0,64,10,0x1f0003e000000000] 5:[4480,0,64,17,0xc00e1803c2007840] 6:[4544,0,64,18,0x21e00c3801870070] 7:[4608,0,64,16,0x403e0007c010f00] 8:[4672,0,64,28,0xe1f07c3e8078200f] 9:[4736,0,64,18,0x838030700e0c01c1] 10:[4800,0,64,33,0xe1f07c3e0f87c10f] 11:[4864,0,64,33,0xc3e0f87c1f0f83e1] 12:[4928,0,64,33,0xf87c1f0f83e1f07] 13:[4992,0,64,32,0x7c3e0f87c1f0f83] 14:[5056,0,64,38,0xf87c1f0ff0f83e1f] 15:[5120,0,64,32,0x83e1f07c3e0f87c1] 16:[5184,0,64,32,0xc1f0f83e1f07c3e0] 17:[5248,0,64,35,0x7c1f0f837c3e0f87] 18:[5312,0,64,33,0xe0f87c1f0f83e1f0] 19:[5376,0,64,33,0x87c1f0f83e1f07c3] 20:[5440,0,64,34,0x1f0f83e1f07c3e0f] 

After:

xfs_db> p recs
recs[1-55] = [startino,holemask,count,freecount,free] 
1:[128,0,64,0,0] 
2:[4288,0xff,32,0,0xffffffff] 
3:[4352,0,64,0,0] 
4:[4416,0,64,10,0x1f0003e000000000] 
5:[4480,0,64,17,0xc00e1803c2007840] 
6:[4544,0,64,18,0x21e00c3801870070] 
7:[4608,0,64,16,0x403e0007c010f00] 
8:[4672,0,64,28,0xe1f07c3e8078200f] 
9:[4736,0,64,18,0x838030700e0c01c1] 
10:[4800,0,64,33,0xe1f07c3e0f87c10f] 
11:[4864,0,64,33,0xc3e0f87c1f0f83e1] 
12:[4928,0,64,33,0xf87c1f0f83e1f07] 
13:[4992,0,64,32,0x7c3e0f87c1f0f83] 
14:[5056,0,64,38,0xf87c1f0ff0f83e1f] 
15:[5120,0,64,32,0x83e1f07c3e0f87c1] 
16:[5184,0,64,32,0xc1f0f83e1f07c3e0] 
17:[5248,0,64,35,0x7c1f0f837c3e0f87] 
18:[5312,0,64,33,0xe0f87c1f0f83e1f0] 
19:[5376,0,64,33,0x87c1f0f83e1f07c3] 
20:[5440,0,64,34,0x1f0f83e1f07c3e0f] 

Somewhat less eyeball-bleeding, hopefully. :)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
