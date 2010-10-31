Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9VEeJhB128173 for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 09:40:19 -0500
Received: from omr11.networksolutionsemail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54A0B14072F
	for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 07:41:39 -0700 (PDT)
Received: from omr11.networksolutionsemail.com
	(omr11.networksolutionsemail.com [205.178.146.61]) by
	cuda.sgi.com with ESMTP id oyvnANEf9XDopGD3 for
	<xfs@oss.sgi.com>; Sun, 31 Oct 2010 07:41:39 -0700 (PDT)
Received: from cm-omr14 (mail.networksolutionsemail.com [205.178.146.50])
	by omr11.networksolutionsemail.com (8.13.6/8.13.6) with ESMTP id
	o9VEfdoT028702 for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 10:41:39 -0400
Message-ID: <4CCD8021.2070403@chaven.com>
Date: Sun, 31 Oct 2010 09:41:37 -0500
From: Steve Costaras <stevecs@chaven.com>
MIME-Version: 1.0
Subject: Re: xfs_repair of critical volume
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
	<20101031151000.70dcd6b9@galadriel.home>
In-Reply-To: <20101031151000.70dcd6b9@galadriel.home>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com



On 2010-10-31 09:10, Emmanuel Florac wrote:
> Did you try to actually freeze the failed drives (it may revive them 
> for a while)?

Do NOT try this.   It's only good for some /very/ specific types of 
issues with older drives.   With an array of your size you are probably 
running relatively current drives (i.e. past 5-7 years) and this has a 
vary large probability of causing more damage.

The other questions are to the point to determine the circumstances 
around the failure and what the  state of the array was at the 
time.      Take your time, do not rush anything; you are already hanging 
over a cliff.

First thing if you are able is to do a bit copy of the physical drives 
to spares that way you can always get back to the same point where you 
are now.    This may not be practical with such a large array but if you 
have the means it's worth it.

You want to start from the lowest component and work your way up.    So 
you want to make sure that your raid array itself is sane before looking 
to fix any volume management functions and that before looking at your 
file systems.    When dealing with degraded or failed arrays be careful 
on what you do if you have write cache enabled on your controllers.   
Talk to the vendor!   Whatever operations you do on the card could cause 
this data to be lost and that can  be substantial with some controllers 
(MiB->GiB ranges).       Normally we  run w/ write cache disabled (both 
on the drive and on the raid controllers) for critical data to avoid 
having too much data in flight if a problem ever did occur.

The points that Emmanuel mentioned are valid;    Though would hold off 
on powering down until you are able to get all the geometry information 
from your raid's (unless you already have them).   Also would hold off 
until you determine if you have any dirty caches on the raid 
controllers.    Most controllers keep a rotating buffer of events 
including failure pointers that if you re-boot the re-scanning of drives 
upon start may push that pointer further down the stack until it gets 
lost and then you won't be able to recover outstanding data.   I've seen 
this set at 128 - 256 entries on various systems, another reason to keep 
drives per controller counts down.

Steve


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
