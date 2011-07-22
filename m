Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MNFpMS113477 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 18:15:51 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D94028134F
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:10:49 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	jZlWm7ot5Fc0Rvnv for <xfs@oss.sgi.com>;
	Fri, 22 Jul 2011 16:10:49 -0700 (PDT)
Date: Sat, 23 Jul 2011 09:10:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 30 TB RAID6 + XFS slow write performance
Message-ID: <20110722231040.GD13963@dastard>
References: <4E24907F.6020903@johnbokma.com> <201107210820.01019@zmi.at>
	<20110721064838.GA13963@dastard> <201107220810.01889@zmi.at>
	<4E29BBDA.3000603@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E29BBDA.3000603@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, John Bokma <contact@johnbokma.com>, xfs@oss.sgi.com

On Fri, Jul 22, 2011 at 01:05:14PM -0500, Stan Hoeppner wrote:
> On 7/22/2011 1:10 AM, Michael Monnerie wrote:
> 
> > Yes, I just wanted to know about the corner cases, and how XFS behaves. 
> > Actually, we're changing over to using NetApps, and with their WAFL 
> > anyway I should drop all su/sw usage and just use 4KB blocks.
> 
> I've never used a NetApp filer myself.  However, that said, I would
> assume that WAFL is only in play for NFS/CIFS transactions since WAFL is
> itself a filesystem.

Netapp's website is busted, so here's a cached link:

http://webcache.googleusercontent.com/search?q=cache:9DdO2a16hdIJ:blogs.netapp.com/extensible_netapp/2008/10/what-is-wafl--3.html+netapp+san+wafl&cd=1&hl=en&ct=clnk&source=www.google.com

"The point is that WAFL is the part of the code that provides the
'read or write from-disk' mechanisms to both NFS and CIFS and SAN.
The semantics of a how the blocks are accessed are provided by
higher level code not by WAFL, which means WAFL is not a file
system."

If you can be bothered trolling for that entire series of blog posts
in the google cache, it's probably a good idea so you can get a
basic understanding of what WAFL actually is.

> When exposing LUNs from the same filer to FC and iSCSI hosts I would
> assume the filer acts just as any other SAN controller would.

It has it's own quirks, just like any other FC attached RAID array...

> In this case I would think you'd probably still want to align your
> XFS filesystem to the underlying RAID stripe from which the LUN
> was carved.

Which actually matters very little when WAFL between the FS and the
disk because WAFL uses copy-on-write and stages all it's writes
through NVRAM and so you've got no idea what the alignment of any
given address in the filesystem maps to, anyway.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
