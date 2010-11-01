Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA1F1v6k218740 for <xfs@oss.sgi.com>; Mon, 1 Nov 2010 10:01:58 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C1101E8ACA2
	for <xfs@oss.sgi.com>; Mon,  1 Nov 2010 08:03:18 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 6TJAzBBaCGBrlKFq
	for <xfs@oss.sgi.com>; Mon, 01 Nov 2010 08:03:18 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 8434E6C140
	for <xfs@oss.sgi.com>; Mon,  1 Nov 2010 10:03:18 -0500 (CDT)
Message-ID: <4CCED6B6.9090002@hardwarefreak.com>
Date: Mon, 01 Nov 2010 10:03:18 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_repair of critical volume
References: <C17C2CB6-A695-41B2-B12A-1CBF6DAD556F@ucsc.edu>
In-Reply-To: <C17C2CB6-A695-41B2-B12A-1CBF6DAD556F@ucsc.edu>
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

Eli Morris put forth on 10/31/2010 2:56 PM:

> OK, that's a long tale of woe. Thanks for any advise. 

In additional to the suggestions you've already received, I'd suggest
you reach out to your colleagues at SDSC.  They'd most certainly have
quite a bit of storage experience on staff, and they are part of the
University of California system, and thus "family" of sorts.

The Janus 6640 has 4 rows of 4 hot swap drives connected to a backplane.
 Of the 4 drives that were marked offline, are they all in the same
horizontal row or vertical column?  If so, I'd say you most certainly
have a defective SATA backplane.  Even if the offline drives are not in
a physical row, the problem could still likely be the backplane.  This
is _very_ common with "low end" or low cost SATA arrays.  Backplanes
issues are the most common cause of drives being kicked offline
unexpectedly.

The very first thing I would do, given the _value_ of the data itself,
is get an emergency onsite qualified service tech from your vendor or
the manufacturer and have the backplane or the entire unit itself
replaced.  If replacing the entire unit, swap all of the 16 drives into
the new unit _inserting each drive in the same slot number as the old
unit_

Have the firmware/nvram configuration dumped from the old unit to the
new one so the RAID configuration is carried over as well as the same
firmware rev you were using.

After this is complete, power up the array and manually put all of the
drives online and get a healthy status in the LCD display.  Mount the
filesystem read only and do some serious read stress tests to make sure
drives aren't kicked offline again.  If they are kicked offline, note
the drive slot numbers to see if the same set of 4 drives are kicked
offline.  At this point, either the backplane design is faulty, or the 4
drives being kicked offline have a firmware rev different enough from
the other drives, or simply faulty for your RAID application, that the
RAID controller simply doesn't like them.  If this is the case, you need
to take an inventory of the firmware revision on each and every one of
the 2TB drives.  Of those not being kicked offline, note the highest
quantity of identical firmware.

Contact Western Digital support via phone.  Briefly but thoroughly
explain who you are, what your situation is, and the gravity of the
situation.  Ask them what their opinion is on the firmware issue, and
what rev you should download for use in flashing the entire set of drives.

Mismatched drive firmware across a set of drives assigned to a RAID
array, especially a hardware RAID array, is the second most common cause
of drives being kicked offline unexpectedly.  Linux mdraid is slightly
more tolerant of mismatched firmware, but it's always best practice to
use only drives of matched firmware rev within a given RAID group.  This
has been true for a couple of decades now (or more).

Hope this helps.  Good luck.  We're pulling for you.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
