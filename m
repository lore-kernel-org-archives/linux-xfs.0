Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5L1pgZP213147 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 20:51:43 -0500
Received: from nospam5.slac.stanford.edu (nospam5.slac.stanford.edu
	[134.79.18.83]) by cuda.sgi.com with ESMTP id 7esio3hZQU72KLLq
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jun 2012 18:51:41 -0700 (PDT)
Received: from mailgate05.slac.stanford.edu (mailgate05.slac.stanford.edu
	[134.79.18.85])
	by nospam5.slac.stanford.edu (8.14.4/8.14.4) with ESMTP id
	q5L1peau028377
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 18:51:40 -0700
	(envelope-from ling@slac.stanford.edu)
Received: from [134.79.72.90] (pcds108.slac.stanford.edu [134.79.72.90])
	by mailgate05.slac.stanford.edu (8.14.4/8.14.4) with ESMTP id
	q5L1pdd2010472
	for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 18:51:39 -0700 (PDT)
	(envelope-from ling@slac.stanford.edu)
Message-ID: <4FE27E2B.2060705@slac.stanford.edu>
Date: Wed, 20 Jun 2012 18:51:39 -0700
From: Ling Ho <ling@slac.stanford.edu>
MIME-Version: 1.0
Subject: Debugging file truncation problem
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

Hello,

I am trying to debug a problem that has bugged us for the last few months.

We have set up a large storage system using GlusterFS, and XFS 
underneath it. We have 5 RHEL6.2 servers (running 
2.6.32-220.7.1.el6.x86_64 when problem last occurred), with LSI 9285-8e 
Raid Controller with Battery Backup Unit. System memory is 48GB.

Over the few months we have it running, we experience two complete power 
outage where everything went down for a long period of time.

After the system came back up, we found some files (between 1-10GB) 
truncated. By truncated I mean the file sizes shrunk, and we lost the 
tail of the files. Since the files were copied from another storage 
system, we have the original to compare. Furthermore we have a cron job 
that collect the file sizes once a day.

However, the troubling thing is, these files were all multiple days old, 
and were not being written to or accessed at the time of the power outage.

Last week, I sensed some problems on the OS on one of the machines, and 
so shut it down cleanly. And right after that, also upgraded the kernels 
and rebooted all other 4 servers. After they all came back up, we 
discovered truncated file again. I am sure the truncation occurred 
within the 24 hours before or after the reboots since the file sizes we 
had collected before the reboot differ from what we collected few hours 
after the reboot. The file truncation occurred on the problematic 
machine, and another one, which I have rebooted cleanly.

I tried to spend more time looking at the truncated files this time. I 
found some of the smaller files actually got truncated to zero length.

I used xfs_bmap to look at the extend allocation, and saw that all of 
them were using a single extent. So, by looking at the original file 
size, and the start location of the truncated file, I tried to extract 
the bits from the raw device, and saved it onto a different directory. 
Something like this:  dd if=/dev/hdc of=/u1/recovered bs=1 
count=1231451239  skip=53242445

To my amaze, after I wrote the file out this way (assuming the complete 
file were also occupying one single extent), the checksum matches the 
original file which resides on the server where I had copied the file from.


These are my questions:

- Under what possible circumstances would the updated inode not written 
to the disk, if the content of the file are already on disk?

- I tried to use block dump to debug while trying to reproduce the 
problem on another test box. I notice xfssyncd and xfsbufd don't cause 
data and inode to be writen to disk. It seems after a file is written, 
data and dirtied inode are written to disk only when flush wakes up. 
Does xfssyncd/xfsbufd only responsible for moving stuff to the system cache?

- Can all the flush processes die, or cease to work on a system and 
still allow the system to function?

I have been trying to reproduce the problem on a test box for the last 
few days but unsuccessful, except I see truncations on file newly 
written, and not yet flushed to disk when I reset the test box. It seems 
XFS is doing everything right. I tried writing through Gluster layer, 
and writing directory to the XFS file system and see no different in 
behavior. I would really like to get some ideas what else to look.


Thanks,
...
ling


















_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
