Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EAF517F4E
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 13:11:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B05C830407A
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 11:11:25 -0700 (PDT)
Received: from mail-qc0-f176.google.com (mail-qc0-f176.google.com
	[209.85.216.176]) by cuda.sgi.com with ESMTP id
	P5yMJFyWZXQQ0xvo (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Mar 2013 11:11:23 -0700 (PDT)
Received: by mail-qc0-f176.google.com with SMTP id n41so598143qco.21
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 11:11:22 -0700 (PDT)
Message-ID: <5140C147.7070205@binghamton.edu>
Date: Wed, 13 Mar 2013 14:11:19 -0400
From: Dave Hall <kdhall@binghamton.edu>
MIME-Version: 1.0
Subject: xfs_fsr, sunit, and swidth
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Does xfs_fsr react in any way to the sunit and swidth attributes of the 
file system?  In other words, with an XFS filesytem set up directly on a 
hardware RAID, it is recommended that the mount command be changed to 
specify sunit and swidth values that reflect the new geometry of the 
RAID.  In my case, these values were not specified on the mkfs.xfs of a 
rather large file system running on a RAID 6 array.  I am wondering 
adding sunit and swidth parameters to the fstab will cause xfs_fsr to do 
anything different than it is already doing.  Most importantly, will it 
improve performace in any way?

Thanks.

-Dave

-- 
Dave Hall
Binghamton University
kdhall@binghamton.edu
607-760-2328 (Cell)
607-777-4641 (Office)	

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
