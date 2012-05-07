Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47GiCGp095100 for <xfs@oss.sgi.com>; Mon, 7 May 2012 11:44:12 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id NQYt2xQLB7TOHTkJ
	for <xfs@oss.sgi.com>; Mon, 07 May 2012 09:44:11 -0700 (PDT)
Message-ID: <4FA7FBDC.9070308@hardwarefreak.com>
Date: Mon, 07 May 2012 11:44:12 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: suddenly slow writes on XFS Filesystem
References: <4FA63DDA.9070707@profihost.ag> <20120507013456.GW5091@dastard>
	<4FA76E11.1070708@profihost.ag>
	(sfid-20120507_095413_656560_122EB192)
	<201205071021.14478.Martin@lichtvoll.de>
In-Reply-To: <201205071021.14478.Martin@lichtvoll.de>
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
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, xfs@oss.sgi.com

On 5/7/2012 3:21 AM, Martin Steigerwald wrote:
> Am Montag, 7. Mai 2012 schrieb Stefan Priebe - Profihost AG:

>> after deleting 400GB it was faster. Now there are still 300GB free but
>> it is slow as hell again ;-(
> 
> Well, before you had 200 GB free, now you have 300 GB free. Thats not that 
> much more. You have 5 AGs, so if distributed evenly it would be 40 to 60 
> GB free space per AG.
> 
> The 10% Dave recommended of 4,6 TB would be 460 GB.

As I mentioned, increasing the size of the free space pool will only
help for a short duration.  Most of the files Stefan is deleting are
small files.  Thus he's simply punching out small holes of free space,
which is the problem he already has.  Now if he could delete a handful
of large files (10GB+) that are mostly contiguous now, that would help
quite a bit, as the resulting free space wouldn't be horribly fragmented.

So the takeaway is that simply deleting files to get more space isn't
the right way to go.  Deleting larger files that are currently
contiguous is the way to go.  At least for some temporary breathing
room.  The "permanent" solution I described in another reply.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
