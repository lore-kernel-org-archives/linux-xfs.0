Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AD5E57FBA
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 04:55:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4867BAC001
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 02:55:48 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id VSyuo0wz1jXejvgj
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 02:55:47 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id BD6FA6C162
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 04:55:46 -0500 (CDT)
Message-ID: <516688A9.8050506@hardwarefreak.com>
Date: Thu, 11 Apr 2013 04:55:53 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_repair breaks with assertion
References: <CAPaMSRCGSyhmnjrXpFFkEpmKrjsHqLn0kJ1xLGyf-WZosV7mmQ@mail.gmail.com>
	<20130411062515.GH10481@dastard>
	<CAPaMSRCq0f+GqTbRRCXBFUDdtmpBx=VjBaOLpdDytXunL9dfmQ@mail.gmail.com>
In-Reply-To: <CAPaMSRCq0f+GqTbRRCXBFUDdtmpBx=VjBaOLpdDytXunL9dfmQ@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 4/11/2013 1:34 AM, Victor K wrote:

> The raid array did not suffer, at least, not according to mdadm; it is now
> happily recovering the one disk that officially failed, but the whole thing
> assembled without a problem
> There was a similar crash several weeks ago on this same array, but had
> ext4 system back then.
> I was able to save some of the latest stuff, and decided to move to xfs as
> something more reliable.
> I suspect now I should also had replaced the disk controller then.

Rebuilds are *supposed* to be transparent to the filesystem but this is
not always the case.  Sometimes due to bugs.  In fact we just recently
saw an LVM bug wherein a pvmove operation was not transparent, and hosed
up an XFS.  This is but one of many reasons I prefer hardware based RAID
and volume management.  It isolates these functions and RAID memory
structures from the kernel, and thus prevents such bugs from causing
problems.  This may/not be the source of your apparent XFS corruption.
We don't have enough (log) data to ascertain the cause at this point.

Running repair on an 8/10TB filesystem while md is rebuilding the
underlying RAID6 array isn't something I'd put a lot of trust in.  Wait
until the rebuild is finished and then run a non-destructive repair.
Compare the results to the previous repair.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
