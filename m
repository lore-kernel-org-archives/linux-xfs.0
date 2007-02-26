Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 26 Feb 2007 10:37:57 -0800 (PST)
Received: from foxengines.net (foxengines.net [69.5.8.162])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1QIbpm7009274
	for <xfs@oss.sgi.com>; Mon, 26 Feb 2007 10:37:53 -0800
Date: Mon, 26 Feb 2007 13:09:48 -0500 (EST)
From: XFS User <sgixfs@foxengines.net>
Reply-To: sgixfs@foxengines.net
Subject: 8.2TB->16.4TB xfs_growfs problem
Message-ID: <Pine.OSX.4.64.0702261301250.1185@powerbook.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

I am experiencing a problem that I'm not sure how to resolve. I do not see
this in the FAQ, nor have I found it in Bugzilla or the mailing lists, 
(they both seemed to be having search problems last week which prevented 
me from using them, I used Google to search into the site so I might've missed 
something).

In summary, I have an 8.2TB filesystem on an 16.4TB LVM2 volume on a
Linux 2.6.18 x86_64 with 4GB RAM.
If I issue the 'xfs_growfs /mounted_volume' command, the command will
complete without printing any errors and the command exits on 0.

I can umount, then mount again, see the new 16TB volume.

If for any reason, I run xfs_repair, all changes will be lost and the
filesystem size will revert to it's original size (e.g it'll shrink
back down to 8.2TB).

On closer inspection I noticed that following the resize, the 0th
superblock is updated with the new dblock size, but no other superblock
seems to get updated. The first superblock (sb 1) second, third, and so 
on all report the original dblock value for the smaller filesystem.

Furthermore, at the conclusion of the resize operation at the time that
the filesystem attributes are printed, there is no line printed such as:
         "data blocks changed from <number> to <bigger number>"
Again, the xfs_growfs command does exit on 0 however.

Can anyone provide any advice that I might try to straighten this out?
I can provide much more detailed information on request.

Thanks,
Rich.
