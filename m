Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p98CTdtN048197 for <xfs@oss.sgi.com>; Sat, 8 Oct 2011 07:29:39 -0500
Received: from mailout.mucip.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A2AD1B8CF2
	for <xfs@oss.sgi.com>; Sat,  8 Oct 2011 05:29:37 -0700 (PDT)
Received: from mailout.mucip.net (mail.svr02.mucip.net [83.170.6.69]) by
	cuda.sgi.com with ESMTP id zFok3DAmARtkVNxt for
	<xfs@oss.sgi.com>; Sat, 08 Oct 2011 05:29:37 -0700 (PDT)
Message-ID: <4E90422E.3060805@birkenwald.de>
Date: Sat, 08 Oct 2011 14:29:34 +0200
From: Bernhard Schmidt <berni@birkenwald.de>
MIME-Version: 1.0
Subject: Re: Premature "No Space left on device" on XFS
References: <4E8E079B.4040103@birkenwald.de> <20111007013711.GW3159@dastard>
	<4E8F0385.7060906@birkenwald.de> <20111007231410.GG3159@dastard>
In-Reply-To: <20111007231410.GG3159@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi,

>> lxmhs45:~ # xfs_info /dev/sdb
>> meta-data=/dev/sdb               isize=256    agcount=4, agsize=655360 blks
>>           =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=2621440, imaxpct=50
>                                                                  ^^^^^^^^^^
>
> And there lies the reason you are getting the filesystem into this
> situation - you're allowing a very large number of inodes to be created
> in the filesystem.

Ah, sorry, I changed that to 50% _after_ the first fuckup due to a 
suggestion on the postfix ml, it used to be the default 25% before.
>
> I'd suggest that for your workload, you need to allow at least 10GB
> of disk space per million inodes. Because of the number of small
> files, XFS is going to need a much larger amount of free space
> available to prevent aging related freespace fragmentation problems.
> The above ratio results in a maximum space usage of about 50%, which
> will avoid such issues. If you need to hold 2 million files, use a
> 20GB filesystem...

I don't need to hold 2 million files, 1 million might be enough, I have 
to make sure I cannot run out of inodes way before I run out of free space.

Generally speaking I have the following problem:

External nodes are submitting data (mails) to this system as fast as 
they can. The mails can be between 800 bytes and several megabytes. 
There are 50 receiver that write those mails as single files flat in a 
single directory.

There are 4 worker threads that process a _random_ file out of this 
directory. To process it they need to be able to create a temporary file 
on the same filesystem. Together they are slower than the 50 receivers 
(they can process maybe 20% of the incoming rate), which means that this 
incoming directory is going to fill. For the sake of the argument lets 
assume that the amount of mails to be sent is unlimited.

The only knob the software knows to prevent this from going over is free 
disk space. When free disk space is lower than 2 Gigabyte, the 
acceptance of new mails is blocked gracefully until there is free space 
again.

It has, however, no way to deal with ENOSPC before that. When it cannot 
create new files due no free inodes (ext4 with default settings) or 
fragmentation in XFS, it breaks quite horribly and cannot recover by itself.

Can I avoid XFS giving ENOSPC due to inode shortage even in worst case 
situations? I would be fine preallocating 1 GB for inode storage if that 
would fix the problem. ext4 with bytes-per-inode = blocksize does this fine.

You mentioned an aging problem with XFS. I guess you mean that an XFS 
filesystem will get slower/more fragmented by time with abuse like this. 
These mail submission above will happen in bursts, during normal times 
it will go down to << 1000 files on the entire filesystem (empty 
incoming directory). Is this enough for XFS to "fix itself"?

BTW, the software can hash the incoming directory in 16 or 16x16 
subdirectories. Would that help XFS in any way with those filesizes? At 
first glance I would have said yes, but due to the random access in 
those directories it would still have the entire spool as workload.

Bernhard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
