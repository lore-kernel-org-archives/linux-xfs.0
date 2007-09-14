Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 13:58:51 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8EKwk4p022671
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 13:58:46 -0700
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1IWIFT-0007C4-Sd
	for linux-xfs@oss.sgi.com; Fri, 14 Sep 2007 13:58:47 -0700
Message-ID: <12683711.post@talk.nabble.com>
Date: Fri, 14 Sep 2007 13:58:47 -0700 (PDT)
From: Hxsrmeng <hxsrmeng@gmail.com>
Subject: Re: Newbie question about xfs_db with the response message
 "unexpected XFS SB magic number 0x2e524d46"
In-Reply-To: <46EAF230.4030407@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
References: <12682767.post@talk.nabble.com> <46EAF230.4030407@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Thanks. 
But what should I do to " look at it while it's mounted,though (IIRC)"?
Only thing I know is that I have to umount xfs_disk to use xfs_db. But at
this time, I can not see files in my xfs_disk.

Actually, I'd like to know where exactly myfile is located in xfs_disk.


Eric Sandeen-3 wrote:
> 
> Hxsrmeng wrote:
>> OpenSUSE10.2. and 2.6.22-rc7-default XFS
>> 1)
>> I'd like to run "xfs_db -f -c "sb 0" -c "p" ./myfile | egrep
>> 'agcount|inopblog|agblklog'" to see the three values.
> 
> if "myfile" is a file on your xfs filesystem, then that's not right.
> xfs_db needs to be pointed at a block device (or filesystem image file)
> containing an xfs filesystem.  You can look at it while it's mounted,
> though (IIRC) the information may not be perfectly in sync with the fs's
> data.
> 
> agcount, inopblog, etc are parameters of an xfs filesystem, not a file
> on that filesystem.
> 
> What are you trying to learn (about your file or filesystem?)
> 
> -Eric
> 
> 
> 
> 

-- 
View this message in context: http://www.nabble.com/Newbie-question-about-xfs_db-with-the-response-message-%22unexpected-XFS-SB-magic-number-0x2e524d46%22-tf4444973.html#a12683711
Sent from the linux-xfs mailing list archive at Nabble.com.
