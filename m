Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD9467F47
	for <xfs@oss.sgi.com>; Sun, 22 Feb 2015 17:35:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9C55C304043
	for <xfs@oss.sgi.com>; Sun, 22 Feb 2015 15:35:24 -0800 (PST)
Received: from mail-qg0-f46.google.com (mail-qg0-f46.google.com
	[209.85.192.46]) by cuda.sgi.com with ESMTP id 8xh9jaU38TiBLy0q
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 22 Feb 2015 15:35:22 -0800 (PST)
Received: by mail-qg0-f46.google.com with SMTP id z107so22000727qgd.5
	for <xfs@oss.sgi.com>; Sun, 22 Feb 2015 15:35:22 -0800 (PST)
Message-ID: <54EA67B7.30805@binghamton.edu>
Date: Sun, 22 Feb 2015 18:35:19 -0500
From: Dave Hall <kdhall@binghamton.edu>
MIME-Version: 1.0
Subject: XFS/LVM/Multipath on a single RAID volume
References: <5143F94C.1020708@hardwarefreak.com>
	<20130316072126.GG6369@dastard> <515082C3.2000006@binghamton.edu>
	<515361B5.8050603@hardwarefreak.com>
	<5155F2B2.1010308@binghamton.edu>
	<20130331012231.GJ6369@dastard> <515C3BF3.60601@binghamton.edu>
	<51684382.50008@binghamton.edu>
	<5168AC0B.5010100@hardwarefreak.com>
	<516C649A.8010003@binghamton.edu>
	<20130416161841.GB13938@destitution>
In-Reply-To: <20130416161841.GB13938@destitution>
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
To: Dave Chinner <david@fromorbit.com>
Cc: stan@hardwarefreak.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Dave, Stan,

Not sure if you remember, but we corresponded for a while a couple years 
ago about some performance problems I was having with XFS on a 26TB 
SAS-attached RAID box.  If either of you is still working on XFS, I've 
got some new questions.  Actually, what I've got is a new array to set 
up.  Same size, but faster disks and a faster controller.  It will 
replace the existing array as the primary backup volume.

So since I have a fresh array that's not in production yet I was hoping 
to get some pointers on how to configure it to maximize XFS 
performance.  In particular, I've seen a suggestion that a multipathed 
array should be sliced up into logical drives and pasted back together 
with LVM.  Wondering also about putting the journal in a separate 
logical drive on the same array.

I am able to set up a 2-way multipath right now, and I might be able to 
justify adding a second controller to the array to get a 4-way multipath 
going.

Even if the LVM approach is the wrong one, I clearly have a rare chance 
to set this array up the right way.  Please let me know if you have any 
suggestions.

Thanks.

-Dave

Dave Hall
Binghamton University
kdhall@binghamton.edu
607-760-2328 (Cell)
607-777-4641 (Office)



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
