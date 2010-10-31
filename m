Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9VL8mdJ142935 for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 16:08:49 -0500
Received: from omr7.networksolutionsemail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5EFCC4CA212
	for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 14:10:10 -0700 (PDT)
Received: from omr7.networksolutionsemail.com (omr7.networksolutionsemail.com
	[205.178.146.57]) by cuda.sgi.com with ESMTP id
	lirdMOTiGlVSBw85 for <xfs@oss.sgi.com>;
	Sun, 31 Oct 2010 14:10:10 -0700 (PDT)
Received: from cm-omr7 (mail.networksolutionsemail.com [205.178.146.50])
	by omr7.networksolutionsemail.com (8.13.6/8.13.6) with ESMTP id
	o9VLA915006288 for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 17:10:09 -0400
Message-ID: <4CCDDB2E.1080508@chaven.com>
Date: Sun, 31 Oct 2010 16:10:06 -0500
From: Steve Costaras <stevecs@chaven.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eli Morris <ermorris@ucsc.edu>
Cc: xfs@oss.sgi.com



On 2010-10-31 14:56, Eli Morris wrote:
>
> Hi guys,
>
> Thanks for all the responses. On the XFS volume that I'm trying to recover here, I've already re-initialized the RAID, so I've kissed that data goodbye. I am using LVM2. Each of the 5 RAID volumes is a physical volume. Then a logical volume is created out of those, and then the filesystem lies on top of that. So now we have, in order, 2 intact PVs, 1 OK, but blank PV, 2 intact PVs. On the RAID where we lost the drives, replacements are in place and I created a now healthy volume. Through LVM, I was then able to create a new PV from the re-constituted RAID volume and put that into our logical volume in place of the destroyed PV. So now, I have a logical volume that I can activate and I can see the filesystem. It still reports as having all the old files as before, although it doesn't. So the hardware is now OK. It's just what to do with our damaged filesystem that has a huge chunk missing out of it. I put the xfs_repair trial output on an http server, as suggested (good sug!
 ge!
>   stion) and it is here:

What was your raid stripe size (hardware)?  Did you have any 
partitioning scheme on the hdw raid volumes or did you just use the 
native device?    When you created the volume group & lv did you do any 
striping or just concatenation of the luns?  if striping what was your 
lvcreate parameters (stripe size et al).

You mentioned that you lost only 1 of the 5 arrays.    Assuming the 
others did not have any failures?    You wiped the array that failed so 
you  have 4/5 of the data and 1/5 is zeroed.     Which removes the 
possibility of vendor recovery/assistance.

Assuming that everything is equal there should be an equal distribution 
of files across the AG's and the AG's should have been distributed 
across the 5 volumes.    Do you have the xfs_info data?     I think you 
may be a bit out of luck here with xfs_repair.     I am not sure how XFS 
handles files/fragmentation between AG's and AG's relation to the 
underlying 'physical volume'.    I.e.  problem would be if a particular 
AG was on a different volume than the blocks of the actual file, 
likewise another complexity would be fragmented files where data was not 
contiguous.    What is the average size of the files that you had on the 
volume?

In similar circumstances if files were small enough to be on the 
remaining disks and contiguous/non fragmented I've had some luck w/ 
forensic tools Foremost & Scalpel.

Steve



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
