Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9VJtRfC140348 for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 14:55:28 -0500
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 038DE1C083CE
	for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 12:56:48 -0700 (PDT)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id olcEYCDZz0wlxb9d for
	<xfs@oss.sgi.com>; Sun, 31 Oct 2010 12:56:48 -0700 (PDT)
Received: from [128.114.125.121] (HELO ucsc.edu)
	by email-prod-out-1.ucsc.edu (CommuniGate Pro SMTP 5.2.13)
	with ESMTPS id 25169022 for xfs@oss.sgi.com;
	Sun, 31 Oct 2010 12:56:47 -0700
Received: from [71.198.233.81] (account ermorris@ucsc.edu HELO [10.0.1.4])
	by email-prod-fe-2.ucsc.edu (CommuniGate Pro SMTP 5.2.13)
	with ESMTPSA id 399092181 for xfs@oss.sgi.com;
	Sun, 31 Oct 2010 12:56:34 -0700
From: Eli Morris <ermorris@ucsc.edu>
Subject: Re: xfs_repair of critical volume
Date: Sun, 31 Oct 2010 12:56:33 -0700
Message-Id: <C17C2CB6-A695-41B2-B12A-1CBF6DAD556F@ucsc.edu>
Mime-Version: 1.0 (Apple Message framework v1081)
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

> Hi,
> 
> I have a large XFS filesystem (60 TB) that is composed of 5 hardware RAID 6 volumes. One of those volumes had several drives fail in a very short time and we lost that volume. However, four of the volumes seem OK. We are in a worse state because our backup unit failed a week later when four drives simultaneously went offline. So we are in a bad very state. I am able to mount the filesystem that consists of the four remaining volumes. I was thinking about running xfs_repair on the filesystem in hopes it would recover all the files that were not on the bad volume, which are obviously gone. Since our backup is gone, I'm very concerned about doing anything to lose the data that will still have. I ran xfs_repair with the -n flag and I have a lengthly file of things that program would do to our filesystem. I don't have the expertise to decipher the output and figure out if xfs_repair would fix the filesystem in a way that would retain our remaining data or if it would, let's say!
  t!
> runcate the filesystem at the data loss boundary (our lost volume was the middle one of the five volumes), returning 2/5 of the filesystem or some other undesirable result. I would post the xfs_repair -n output here, but it is more than a megabyte. I'm hoping some one of you xfs gurus will take pity on me and let me send you the output to look at or give me an idea as to what they think xfs_repair is likely to do if I should run it or if anyone has any suggestions as to how to get back as much data as possible in this recovery.
> 
> thanks very much,
> 
> Eli

Hi guys,

Thanks for all the responses. On the XFS volume that I'm trying to recover here, I've already re-initialized the RAID, so I've kissed that data goodbye. I am using LVM2. Each of the 5 RAID volumes is a physical volume. Then a logical volume is created out of those, and then the filesystem lies on top of that. So now we have, in order, 2 intact PVs, 1 OK, but blank PV, 2 intact PVs. On the RAID where we lost the drives, replacements are in place and I created a now healthy volume. Through LVM, I was then able to create a new PV from the re-constituted RAID volume and put that into our logical volume in place of the destroyed PV. So now, I have a logical volume that I can activate and I can see the filesystem. It still reports as having all the old files as before, although it doesn't. So the hardware is now OK. It's just what to do with our damaged filesystem that has a huge chunk missing out of it. I put the xfs_repair trial output on an http server, as suggested (good sugge!
 stion) and it is here:

http://sczdisplay.ucsc.edu/vol_repair_test.txt

Now I also have the problem of our backup RAID unit that failed. That one failed after I re-initialized the primary RAID, but before I could restore the backups to the primary. I'm having some good luck, huh? On that RAID unit, everything was fine until the next time I looked at it, which was a couple of hours later, 4 drives went offline and it reported the volume as lost. On that unit, the only thing I have done so far is to power cycle it a couple of times. Other than that, it is untouched. In it we are using the Caviar Green 2 TB drives, which our vendor told us where fine to use. However, I have read in the last couple of days that they have as issue with timing out as they remap sectors, as noted here:

http://en.wikipedia.org/wiki/Time-Limited_Error_Recovery#Western_Digital_Time_Limit_Error_Recovery_Utility_-_WDTLER.EXE

Thus, I've learned that they are not recommended for use in RAID volumes. So I am looking hard into ways to trying to recover that data as well, although it is only a partial backup of our main volume. It contains about 10 TB of the most critical files from the main volume. Fortunately, this isn't the human genome, but it is climate modeling data that graduate students have been generating for years. So losing all this could set them back years on their PhDs. So I take the situation pretty seriously. In this case, we are thinking about going with a data recovery company, but this isn't industry. Our lab doesn't have very deep pockets. $10K would be a huge chunk of money to spend. So, I would welcome suggestions for this unit as well. I believe the drives themselves in this unit are OK, as four going out with one minute, as the log shows, is not something that makes a lot of sense.  My guess is that they were under heavy load for the first time in a few months and four of the!
  drives started remapping sectors at pretty much the same time. The RAID controller in this DAS 16 drive box tried to contact the drives and reached a timeout and marked them all as dead. We are also considering that we are having some sort of power problem as we seem to be usually unlucky in the last couple of weeks, although we do have everything behind a pretty nice $7K UPS that isn't reporting any problems. 

OK, that's a long tale of woe. Thanks for any advise. 

Eli
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
