Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6A817FD8
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 06:45:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 382E0AC001
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 04:45:43 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	480Afv7oLgp7Qzgk for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 04:45:42 -0700 (PDT)
Date: Fri, 15 Mar 2013 22:45:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_fsr, sunit, and swidth
Message-ID: <20130315114538.GF6369@dastard>
References: <5140C147.7070205@binghamton.edu>
	<514113C6.9090602@hardwarefreak.com>
	<514153ED.3000405@binghamton.edu>
	<5141C1FC.4060209@hardwarefreak.com>
	<5141C8C1.2080903@hardwarefreak.com>
	<5141E5CF.10101@binghamton.edu>
	<5142AE40.6040408@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5142AE40.6040408@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Dave Hall <kdhall@binghamton.edu>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Mar 15, 2013 at 12:14:40AM -0500, Stan Hoeppner wrote:
> On 3/14/2013 9:59 AM, Dave Hall wrote:
> Looks good.  75% is close to tickling the free space fragmentation
> dragon but you're not there yet.

Don't be so sure ;)

> 
> > Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> > /dev/sdb1            5469091840 1367746380 4101345460   26% /infortrend
> 
> Plenty of free inodes.
> 
> > # xfs_db -r -c freesp /dev/sdb1
> >    from      to extents  blocks    pct
> >       1       1  832735  832735   0.05
> >       2       3  432183 1037663   0.06
> >       4       7  365573 1903965   0.11
> >       8      15  352402 3891608   0.23
> >      16      31  332762 7460486   0.43
> >      32      63  300571 13597941   0.79
> >      64     127  233778 20900655   1.21
> >     128     255  152003 27448751   1.59
> >     256     511  112673 40941665   2.37
> >     512    1023   82262 59331126   3.43
> >    1024    2047   53238 76543454   4.43
> >    2048    4095   34092 97842752   5.66
> >    4096    8191   22743 129915842   7.52
> >    8192   16383   14453 162422155   9.40
> >   16384   32767    8501 190601554  11.03
> >   32768   65535    4695 210822119  12.20
> >   65536  131071    2615 234787546  13.59
> >  131072  262143    1354 237684818  13.76
> >  262144  524287     470 160228724   9.27
> >  524288 1048575      74 47384798   2.74
> > 1048576 2097151       1 2097122   0.12
> 
> Your free space map isn't completely horrible given you're at 75%
> capacity.  Looks like most of it is in chunks 32MB and larger.  Those
> 14.8m files have a mean size of ~1.22MB which suggests most of the files
> are small, so you shouldn't be having high seek load (thus latency)
> during allocation.

FWIW, you can't really tell how bad the freespace fragmentation is
from the global output like this. All of the large contiguous free
space might be in one or two AGs, and the others might be badly
fragmented. Hence you need to at least sample a few AGs to determine
if this is representative of the freespace in each AG....

As it is, the above output raises alarms for me. What I see is that
the number of small extents massively outnumbers the large extents.
The fact that there are roughly 2.5 million extents smaller than 63
blocks and that there is only one freespace extent larger than 4GB
indicates to me that free space is substantially fragmented. At 25%
free space, that's 250GB per AG, and if the largest freespace in
most AGs is less than 4GB in length, then free space is not
contiguous. i.e.  Free space appears to be heavily weighted towards
small extents...`

So, the above output would lead me to investigate the freespace
layout more deeply to determine if this is going to affect the
workload that is being run...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
