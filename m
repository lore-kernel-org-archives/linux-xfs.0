Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6O6Eudj194785 for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 01:14:56 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36C82EFFF28
	for <xfs@oss.sgi.com>; Sat, 23 Jul 2011 23:14:53 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ht6tUyI5sGTCsZFL
	for <xfs@oss.sgi.com>; Sat, 23 Jul 2011 23:14:53 -0700 (PDT)
Message-ID: <4E2BB859.1050200@hardwarefreak.com>
Date: Sun, 24 Jul 2011 01:14:49 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: 30 TB RAID6 + XFS slow write performance
References: <4E24907F.6020903@johnbokma.com>
	<201107210820.01019@zmi.at>	<20110721064838.GA13963@dastard>
	<201107220810.01889@zmi.at>	<4E29BBDA.3000603@hardwarefreak.com>
	<20110722231040.GD13963@dastard>
In-Reply-To: <20110722231040.GD13963@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com, John Bokma <contact@johnbokma.com>

On 7/22/2011 6:10 PM, Dave Chinner wrote:
> On Fri, Jul 22, 2011 at 01:05:14PM -0500, Stan Hoeppner wrote:

>> I've never used a NetApp filer myself.  However, that said, I would
>> assume that WAFL is only in play for NFS/CIFS transactions since WAFL is
>> itself a filesystem.
> 
> Netapp's website is busted, so here's a cached link:
> 
> http://webcache.googleusercontent.com/search?q=cache:9DdO2a16hdIJ:blogs.netapp.com/extensible_netapp/2008/10/what-is-wafl--3.html+netapp+san+wafl&cd=1&hl=en&ct=clnk&source=www.google.com

This is interesting:
http://communities.netapp.com/community/netapp-blogs/dave/blog/2008/12/08/is-wafl-a-filesystem

The author implemented WAFL in two layers.  The bottom layer handles
block stuff including volume management, dedup, snapshots, etc, and the
top layer functions as multiple file systems, amongst other duties.

> If you can be bothered trolling for that entire series of blog posts
> in the google cache, it's probably a good idea so you can get a
> basic understanding of what WAFL actually is.

It's never a bother to learn something new. :)

>> When exposing LUNs from the same filer to FC and iSCSI hosts I would
>> assume the filer acts just as any other SAN controller would.
> 
> It has it's own quirks, just like any other FC attached RAID array...
> 
>> In this case I would think you'd probably still want to align your
>> XFS filesystem to the underlying RAID stripe from which the LUN
>> was carved.
> 
> Which actually matters very little when WAFL between the FS and the
> disk because WAFL uses copy-on-write and stages all it's writes
> through NVRAM and so you've got no idea what the alignment of any
> given address in the filesystem maps to, anyway.

Is the NetApp FC/iSCSI attachment performance still competitive for
large file/streaming IO, given that one can't optimize XFS stripe
alignment, and with no indication of where the file fragments are
actually written on the media?  Or does it lag behind something like a
roughly equivalent class Infinite Storage array, or IBM DS?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
