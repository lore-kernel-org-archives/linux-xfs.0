Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1Q2v47h201002 for <xfs@oss.sgi.com>; Sat, 25 Feb 2012 20:57:04 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id AxacyRk3Zq8FaUdG
	for <xfs@oss.sgi.com>; Sat, 25 Feb 2012 18:57:03 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 8BD386C15C
	for <xfs@oss.sgi.com>; Sat, 25 Feb 2012 20:57:02 -0600 (CST)
Message-ID: <4F499F81.7080305@hardwarefreak.com>
Date: Sat, 25 Feb 2012 20:57:05 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: creating a new 80 TB XFS
References: <4F478818.4050803@cape-horn-eng.com>
	<20120224150805.243e4906@harpe.intellique.com>
	<4F47B020.4000202@cape-horn-eng.com>
	<20297.22833.759182.360340@tree.ty.sabi.co.UK>
In-Reply-To: <20297.22833.759182.360340@tree.ty.sabi.co.UK>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 2/25/2012 3:57 PM, Peter Grandi wrote:

>> There are always failures. But again, this is a backup system.
> 
> Sure, but the last thing you want is for your backup system to
> fail.

Putting an exclamation point on Peter's wisdom requires nothing more
than browsing the list archive:

Subject: xfs_repair of critical volume
Date: Sun, 31 Oct 2010 00:54:13 -0700
To: xfs@oss.sgi.com

I have a large XFS filesystem (60 TB) that is composed of 5 hardware
RAID 6 volumes. One of those volumes had several drives fail in a very
short time and we lost that volume. However, four of the volumes seem
OK. We are in a worse state because our backup unit failed a week later
when four drives simultaneously went offline. So we are in a bad very state.
[...]


This saga is available in these two XFS list threads:
http://oss.sgi.com/archives/xfs/2010-07/msg00077.html
http://oss.sgi.com/archives/xfs/2010-10/msg00373.html

Lessons:
1.  Don't use cheap hardware for a backup server
2.  Make sure your backup system is reliable
    Do test restores operations regularly


I suggest you get the dual active/active controller configuration and
use two PCIe SAS HBAs, one connected to each controller, and use SCSI
multipath.  This prevents a dead HBA leaving you dead in the water until
replacement.  How long does it take, and at what cost to operations, if
your single HBA fails during a critical restore?

Get the battery backed cache option.  Verify the controllers disable the
drive write caches.

Others have recommended stitching 2 small arrays together with mdadm and
using a single XFS on the volume instead of one big array and one XFS.
I suggest using two XFS, one on each small array.  This ensures you can
still access some of your backups in the event of a problem with one
array or one filesystem.

As others mentioned, an xfs_[check|repair] can take many hours or even
days on a multi-terabyte huge metadata filesystem.  If you need to do a
restore during that period you're out of luck.  With two filesystems,
and if duplicating critical images/files on each, you're still in business.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
